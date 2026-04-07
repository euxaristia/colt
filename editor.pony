use "term"
use "files"
use "time"

use @write[ISize](fd: I32, buffer: Pointer[U8] tag, size: USize) if posix

primitive ModeNormal
primitive ModeInsert
primitive ModeCommand
primitive ModeSearch

type Mode is (ModeNormal | ModeInsert | ModeCommand | ModeSearch)

class Editor
  let _env: Env
  let _auth: FileAuth
  var _buf: Buffer
  var _cx: USize = 0
  var _cy: USize = 0
  var _rx: USize = 0         // render x (accounts for tabs)
  var _row_off: USize = 0
  var _col_off: USize = 0
  var _rows: USize = 24
  var _cols: USize = 80
  var _mode: Mode = ModeNormal
  var _cmd_buf: String ref = String
  var _search_buf: String ref = String
  var _search_dir: Bool = true  // true = forward
  var _message: String = ""
  var _msg_time: U64 = 0
  var _msg_transient: Bool = false  // true = auto-clear after 5s
  var _yank_lines: Array[String] ref = Array[String]
  var _yank_is_line: Bool = false
  var _count: USize = 0
  var _pending: U8 = 0
  var _quitting: Bool = false
  let _quit_fn: {()} val
  var _tab_stop: USize = 8
  // Undo stack: snapshots of (lines, cx, cy)
  var _undo_stack: Array[(Array[String val], USize, USize)] ref =
    Array[(Array[String val], USize, USize)]

  new create(env: Env, filename: String, quit_fn: {()} val) =>
    _env = env
    _auth = FileAuth(env.root)
    _quit_fn = quit_fn
    _buf = Buffer(filename)
    if filename.size() > 0 then
      _buf.load(_auth)
      let m = String
      m.append("\"")
      m.append(filename)
      m.append("\" ")
      m.append(_buf.line_count().string())
      m.append(" lines")
      _message = m.clone()
      _msg_time = _now_seconds()
      _msg_transient = true
    else
      _message = ""
    end
    _save_undo()

  fun ref set_size(rows: USize, cols: USize) =>
    let r = if rows > 2 then rows else 24 end
    let c = if cols > 0 then cols else 80 end
    _rows = r - 2  // reserve status + cmd line
    _cols = c
    _scroll()
    render()

  // --- Undo ---

  fun ref _save_undo() =>
    let arr = Array[String val](_buf.lines.size())
    for l in _buf.lines.values() do
      let s: String val = l.clone()
      arr.push(s)
    end
    _undo_stack.push((arr, _cx, _cy))
    if _undo_stack.size() > 200 then
      try _undo_stack.shift()? end
    end

  fun ref _undo() =>
    if _undo_stack.size() > 1 then
      try
        _undo_stack.pop()?  // discard current state
        (let snapshot, let cx, let cy) = _undo_stack.pop()?
        _buf.lines.clear()
        for l in snapshot.values() do
          _buf.lines.push(l.clone())
        end
        _cx = cx
        _cy = cy.min(_buf.line_count() - 1)
        _cx = _cx.min(_cur_line_max())
        _buf.dirty = true
        _save_undo()
        _set_message("Undo")
      end
    else
      _set_message("Already at oldest change")
    end

  // --- Scrolling ---

  fun ref _scroll() =>
    _rx = _cx_to_rx(_cy, _cx)
    if _cy < _row_off then
      _row_off = _cy
    end
    if _cy >= (_row_off + _rows) then
      _row_off = (_cy - _rows) + 1
    end
    let tc = _text_cols()
    if _rx < _col_off then
      _col_off = _rx
    end
    if _rx >= (_col_off + tc) then
      _col_off = (_rx - tc) + 1
    end

  fun _cx_to_rx(row: USize, cx: USize): USize =>
    var rx: USize = 0
    try
      let l = _buf.line(row)
      var i: USize = 0
      while i < cx.min(l.size()) do
        if l(i)? == '\t' then
          rx = rx + (_tab_stop - (rx % _tab_stop))
        else
          rx = rx + 1
        end
        i = i + 1
      end
    end
    rx

  // --- Helpers ---

  fun _now_seconds(): U64 =>
    (Time.nanos() / 1_000_000_000).u64()

  fun _gutter_width(): USize =>
    if (_buf.filename.size() == 0) and (_buf.line_count() == 0) then
      0
    else
      let n = if _buf.line_count() > 0 then _buf.line_count() else 1 end
      var w: USize = 1
      var tmp = n
      while tmp >= 10 do
        tmp = tmp / 10
        w = w + 1
      end
      w
    end

  fun _gutter_cols(): USize =>
    let g = _gutter_width()
    if g > 0 then g + 1 else 0 end

  fun _text_cols(): USize =>
    let g = _gutter_cols()
    if _cols > g then _cols - g else 1 end

  fun _cur_line_len(): USize =>
    _buf.line_len(_cy)

  fun _cur_line_max(): USize =>
    let len = _cur_line_len()
    match _mode
    | ModeInsert => len
    else
      if len > 0 then len - 1 else 0 end
    end

  fun ref _clamp_cursor() =>
    if _cy >= _buf.line_count() then
      _cy = _buf.line_count() - 1
    end
    let max_x = _cur_line_max()
    if _cx > max_x then
      _cx = max_x
    end

  fun ref _set_message(msg: String, transient: Bool = false) =>
    _message = msg
    _msg_time = _now_seconds()
    _msg_transient = transient

  // --- Movement ---

  fun ref _move_left(n: USize = 1) =>
    var i: USize = 0
    while i < n do
      if _cx > 0 then _cx = _cx - 1 end
      i = i + 1
    end

  fun ref _move_right(n: USize = 1) =>
    var i: USize = 0
    while i < n do
      let max_x = _cur_line_max()
      if _cx < max_x then _cx = _cx + 1 end
      i = i + 1
    end

  fun ref _move_up(n: USize = 1) =>
    var i: USize = 0
    while i < n do
      if _cy > 0 then _cy = _cy - 1 end
      i = i + 1
    end
    _clamp_cursor()

  fun ref _move_down(n: USize = 1) =>
    var i: USize = 0
    while i < n do
      if _cy < (_buf.line_count() - 1) then _cy = _cy + 1 end
      i = i + 1
    end
    _clamp_cursor()

  fun ref _move_to_line_start() =>
    _cx = 0

  fun ref _move_to_line_end() =>
    _cx = _cur_line_max()

  fun ref _move_to_first_nonblank() =>
    let l = _buf.line(_cy)
    _cx = 0
    while (_cx < l.size()) and
      (((try l(_cx)? else ' ' end) == ' ') or
      ((try l(_cx)? else ' ' end) == '\t'))
    do
      _cx = _cx + 1
    end
    _clamp_cursor()

  fun ref _move_word_forward(n: USize = 1) =>
    var count: USize = 0
    while count < n do
      let l = _buf.line(_cy)
      let len = l.size()
      if _cx >= len then
        if _cy < (_buf.line_count() - 1) then
          _cy = _cy + 1
          _cx = 0
        end
      else
        // Skip current word chars
        while (_cx < len) and _is_word_char(try l(_cx)? else ' ' end) do
          _cx = _cx + 1
        end
        // Skip non-word chars
        while (_cx < len) and (not _is_word_char(try l(_cx)? else ' ' end)) do
          _cx = _cx + 1
        end
        if _cx >= len then
          if _cy < (_buf.line_count() - 1) then
            _cy = _cy + 1
            _cx = 0
            // Skip leading whitespace on new line
            let nl = _buf.line(_cy)
            while (_cx < nl.size()) and
              (((try nl(_cx)? else 'a' end) == ' ') or
              ((try nl(_cx)? else 'a' end) == '\t'))
            do
              _cx = _cx + 1
            end
          end
        end
      end
      count = count + 1
    end
    _clamp_cursor()

  fun ref _move_word_backward(n: USize = 1) =>
    var count: USize = 0
    while count < n do
      if _cx == 0 then
        if _cy > 0 then
          _cy = _cy - 1
          _cx = _cur_line_max()
        end
      else
        let l = _buf.line(_cy)
        _cx = _cx - 1
        // Skip non-word chars backward
        while (_cx > 0) and (not _is_word_char(try l(_cx)? else ' ' end)) do
          _cx = _cx - 1
        end
        // Skip word chars backward
        while (_cx > 0) and _is_word_char(try l(_cx - 1)? else ' ' end) do
          _cx = _cx - 1
        end
      end
      count = count + 1
    end

  fun ref _move_word_end(n: USize = 1) =>
    var count: USize = 0
    while count < n do
      let l = _buf.line(_cy)
      let len = l.size()
      if (len == 0) or (_cx >= (len - 1)) then
        if _cy < (_buf.line_count() - 1) then
          _cy = _cy + 1
          _cx = 0
          let nl = _buf.line(_cy)
          // Skip whitespace
          while (_cx < nl.size()) and
            (((try nl(_cx)? else 'a' end) == ' ') or
            ((try nl(_cx)? else 'a' end) == '\t'))
          do
            _cx = _cx + 1
          end
        end
      else
        _cx = _cx + 1
        // Skip non-word
        while (_cx < len) and (not _is_word_char(try l(_cx)? else ' ' end)) do
          _cx = _cx + 1
        end
        // Go to end of word
        while (_cx < (len - 1)) and _is_word_char(try l(_cx + 1)? else ' ' end) do
          _cx = _cx + 1
        end
      end
      count = count + 1
    end
    _clamp_cursor()

  fun _is_word_char(ch: U8): Bool =>
    ((ch >= 'a') and (ch <= 'z')) or
    ((ch >= 'A') and (ch <= 'Z')) or
    ((ch >= '0') and (ch <= '9')) or
    (ch == '_')

  // --- Editing ---

  fun ref _insert_char(ch: U8) =>
    _buf.insert_char(_cy, _cx, ch)
    _cx = _cx + 1

  fun ref _insert_newline() =>
    _buf.split_line(_cy, _cx)
    _cy = _cy + 1
    _cx = 0

  fun ref _delete_char_at_cursor(): U8 =>
    _buf.delete_char(_cy, _cx)

  fun ref _delete_char_before() =>
    if _cx > 0 then
      _cx = _cx - 1
      _buf.delete_char(_cy, _cx)
    elseif _cy > 0 then
      let prev_len = _buf.line_len(_cy - 1)
      _buf.join_lines(_cy - 1)
      _cy = _cy - 1
      _cx = prev_len
    end

  fun ref _delete_line(): String =>
    _save_undo()
    let content = _buf.delete_line(_cy)
    if _buf.line_count() == 0 then
      _buf.lines.push(String)
    end
    _clamp_cursor()
    content

  fun ref _open_line_below() =>
    _buf.insert_line(_cy + 1, "")
    _cy = _cy + 1
    _cx = 0
    _mode = ModeInsert

  fun ref _open_line_above() =>
    _buf.insert_line(_cy, "")
    _cx = 0
    _mode = ModeInsert

  fun ref _join_line() =>
    if _cy < (_buf.line_count() - 1) then
      _save_undo()
      let cur_len = _buf.line_len(_cy)
      // Add a space if current line is non-empty
      if cur_len > 0 then
        _buf.insert_char(_cy, cur_len, ' ')
      end
      _buf.join_lines(_cy)
      _cx = cur_len
    end

  // --- Search ---

  fun ref _search_next(forward: Bool) =>
    if _search_buf.size() == 0 then
      _set_message("No previous search")
      return
    end
    let start_row = _cy
    let start_col = if forward then _cx + 1 else _cx end
    var row = start_row
    var wrapped = false

    while true do
      let l = _buf.line(row)
      let from_col = if row == start_row then
        if forward then start_col else 0 end
      else
        0
      end

      if forward then
        try
          let idx = l.find(_search_buf where offset = from_col.isize())?
          _cy = row
          _cx = idx.usize()
          _clamp_cursor()
          if wrapped then _set_message("Search wrapped", false) end
          return
        end
        row = row + 1
        if row >= _buf.line_count() then
          row = 0
          wrapped = true
        end
      else
        // Backward search: find last occurrence before start_col
        var found: ISize = -1
        var search_from: ISize = 0
        while true do
          try
            let idx = l.find(_search_buf where offset = search_from)?
            if (row == start_row) and (idx.usize() >= start_col) then
              break
            end
            found = idx
            search_from = idx + 1
          else
            break
          end
        end
        if found >= 0 then
          _cy = row
          _cx = found.usize()
          _clamp_cursor()
          if wrapped then _set_message("Search wrapped", false) end
          return
        end
        if row == 0 then
          row = _buf.line_count() - 1
          wrapped = true
        else
          row = row - 1
        end
      end

      if (row == start_row) and wrapped then
        let nfmsg = String
        nfmsg.append("Pattern not found: ")
        nfmsg.append(_search_buf)
        _set_message(nfmsg.clone())
        return
      end
    end

  // --- Key handling: Normal mode ---

  fun ref normal_key(ch: U8) =>
    let count = if _count > 0 then _count else 1 end

    if (ch >= '0') and (ch <= '9') and not ((_count == 0) and (ch == '0')) then
      _count = (_count * 10) + (ch - '0').usize()
      return
    end

    // Handle pending keys (dd, yy, gg, etc.)
    if _pending == 'd' then
      _pending = 0
      _count = 0
      if ch == 'd' then
        _yank_lines.clear()
        var i: USize = 0
        while i < count do
          if _buf.line_count() > 1 then
            _yank_lines.push(_delete_line())
          elseif _buf.line_len(_cy) > 0 then
            _yank_lines.push(_buf.line(_cy).clone())
            try _buf.lines(_cy)?.clear() end
            _buf.dirty = true
            _cx = 0
          end
          i = i + 1
        end
        _yank_is_line = true
        let dmsg = String
        dmsg.append(count.string())
        dmsg.append(" lines deleted")
        _set_message(dmsg.clone())
        return
      end
      return
    end

    if _pending == 'y' then
      _pending = 0
      _count = 0
      if ch == 'y' then
        _yank_lines.clear()
        var row = _cy
        var i: USize = 0
        while (i < count) and (row < _buf.line_count()) do
          _yank_lines.push(_buf.line(row).clone())
          row = row + 1
          i = i + 1
        end
        _yank_is_line = true
        let ymsg = String
        ymsg.append(count.string())
        ymsg.append(" lines yanked")
        _set_message(ymsg.clone())
        return
      end
      return
    end

    if _pending == 'g' then
      _pending = 0
      _count = 0
      if ch == 'g' then
        _cy = 0
        _cx = 0
        _clamp_cursor()
        return
      end
      return
    end

    if _pending == 'r' then
      _pending = 0
      _count = 0
      if _cur_line_len() > 0 then
        _save_undo()
        try _buf.lines(_cy)?.update(_cx, ch)? end
      end
      return
    end

    if _pending == 'Z' then
      _pending = 0
      _count = 0
      if ch == 'Z' then
        // ZZ: save and quit
        if _buf.filename.size() > 0 then
          _buf.save(_auth)
        end
        _quit()
        return
      elseif ch == 'Q' then
        // ZQ: quit without saving
        _quit()
        return
      end
      return
    end

    _pending = 0
    _count = 0

    match ch
    // Movement
    | 'h' => _move_left(count)
    | 'l' => _move_right(count)
    | 'j' => _move_down(count)
    | 'k' => _move_up(count)
    | '0' => _move_to_line_start()
    | '$' => _move_to_line_end()
    | '^' => _move_to_first_nonblank()
    | 'w' => _move_word_forward(count)
    | 'b' => _move_word_backward(count)
    | 'e' => _move_word_end(count)
    | 'G' =>
      if count > 0 then
        _cy = (_buf.line_count() - 1).min(count - 1)
      else
        _cy = _buf.line_count() - 1
      end
      _clamp_cursor()
    | 'H' =>
      _cy = _row_off
      _clamp_cursor()
    | 'M' =>
      _cy = _row_off + (_rows / 2)
      _clamp_cursor()
    | 'L' =>
      _cy = ((_row_off + _rows) - 1).min(_buf.line_count() - 1)
      _clamp_cursor()
    // Insert mode entry
    | 'i' =>
      _save_undo()
      _mode = ModeInsert
    | 'I' =>
      _save_undo()
      _move_to_first_nonblank()
      _mode = ModeInsert
    | 'a' =>
      _save_undo()
      if _cur_line_len() > 0 then _cx = _cx + 1 end
      _mode = ModeInsert
    | 'A' =>
      _save_undo()
      _cx = _cur_line_len()
      _mode = ModeInsert
    | 'o' =>
      _save_undo()
      _open_line_below()
    | 'O' =>
      _save_undo()
      _open_line_above()
    // Editing
    | 'x' =>
      if _cur_line_len() > 0 then
        _save_undo()
        var i: USize = 0
        while i < count do
          if _cx < _cur_line_len() then
            _delete_char_at_cursor()
          end
          i = i + 1
        end
        _clamp_cursor()
      end
    | 'X' =>
      if _cx > 0 then
        _save_undo()
        var i: USize = 0
        while (i < count) and (_cx > 0) do
          _cx = _cx - 1
          _delete_char_at_cursor()
          i = i + 1
        end
      end
    | 'D' =>
      if _cur_line_len() > 0 then
        _save_undo()
        let l = try _buf.lines(_cy)? else return end
        _yank_lines.clear()
        _yank_lines.push(l.substring(_cx.isize()).clone())
        _yank_is_line = false
        l.truncate(_cx)
        _buf.dirty = true
        _clamp_cursor()
      end
    | 'C' =>
      _save_undo()
      let l = try _buf.lines(_cy)? else return end
      l.truncate(_cx)
      _buf.dirty = true
      _mode = ModeInsert
    | 'J' =>
      _join_line()
    | 'd' =>
      _pending = 'd'
      _count = count
      return
    | 'y' =>
      _pending = 'y'
      _count = count
      return
    | 'g' =>
      _pending = 'g'
      _count = count
      return
    | 'r' =>
      _pending = 'r'
      _count = count
      return
    | 'Z' =>
      _pending = 'Z'
      return
    | 'p' =>
      _save_undo()
      _paste_after()
    | 'P' =>
      _save_undo()
      _paste_before()
    | 'u' =>
      _undo()
    | '~' =>
      if _cur_line_len() > 0 then
        _save_undo()
        try
          let l = _buf.lines(_cy)?
          let ch' = l(_cx)?
          if (ch' >= 'a') and (ch' <= 'z') then
            l.update(_cx, ch' - 32)?
          elseif (ch' >= 'A') and (ch' <= 'Z') then
            l.update(_cx, ch' + 32)?
          end
          _buf.dirty = true
          if _cx < _cur_line_max() then _cx = _cx + 1 end
        end
      end
    // Page movement
    | 0x06 =>  // Ctrl-F
      _move_down(_rows)
    | 0x02 =>  // Ctrl-B
      _move_up(_rows)
    | 0x04 =>  // Ctrl-D
      _move_down(_rows / 2)
    | 0x15 =>  // Ctrl-U
      _move_up(_rows / 2)
    | 0x0C =>  // Ctrl-L (refresh)
      None  // render() is called after every key anyway
    // Command/search mode
    | ':' =>
      _mode = ModeCommand
      _cmd_buf.clear()
    | '/' =>
      _mode = ModeSearch
      _search_buf.clear()
      _search_dir = true
    | '?' =>
      _mode = ModeSearch
      _search_buf.clear()
      _search_dir = false
    | 'n' =>
      _search_next(_search_dir)
    | 'N' =>
      _search_next(not _search_dir)
    end

  // --- Key handling: Insert mode ---

  fun ref insert_key(ch: U8) =>
    match ch
    | 0x1B =>  // Escape
      _mode = ModeNormal
      if _cx > 0 then _cx = _cx - 1 end
      _clamp_cursor()
    | 0x03 =>  // Ctrl-C
      _mode = ModeNormal
      if _cx > 0 then _cx = _cx - 1 end
      _clamp_cursor()
    | 0x0D =>  // Enter
      _insert_newline()
    | 0x7F =>  // Backspace (DEL)
      _delete_char_before()
    | 0x08 =>  // Backspace (BS)
      _delete_char_before()
    | 0x09 =>  // Tab
      _insert_char('\t')
    | if (ch >= 0x20) and (ch < 0x7F) =>
      _insert_char(ch)
    end

  // --- Key handling: Command mode ---

  fun ref command_key(ch: U8) =>
    match ch
    | 0x1B =>  // Escape
      _mode = ModeNormal
      _cmd_buf.clear()
    | 0x03 =>  // Ctrl-C
      _mode = ModeNormal
      _cmd_buf.clear()
    | 0x0D =>  // Enter
      _execute_command()
      _mode = ModeNormal
    | 0x7F =>  // Backspace
      if _cmd_buf.size() > 0 then
        try _cmd_buf.pop()? end
      else
        _mode = ModeNormal
      end
    | 0x08 =>  // Backspace
      if _cmd_buf.size() > 0 then
        try _cmd_buf.pop()? end
      else
        _mode = ModeNormal
      end
    | if (ch >= 0x20) and (ch < 0x7F) =>
      _cmd_buf.push(ch)
    end

  // --- Key handling: Search mode ---

  fun ref search_key(ch: U8) =>
    match ch
    | 0x1B =>  // Escape
      _mode = ModeNormal
      _search_buf.clear()
    | 0x03 =>  // Ctrl-C
      _mode = ModeNormal
      _search_buf.clear()
    | 0x0D =>  // Enter
      _mode = ModeNormal
      if _search_buf.size() > 0 then
        _search_next(_search_dir)
      end
    | 0x7F =>  // Backspace
      if _search_buf.size() > 0 then
        try _search_buf.pop()? end
      else
        _mode = ModeNormal
      end
    | 0x08 =>
      if _search_buf.size() > 0 then
        try _search_buf.pop()? end
      else
        _mode = ModeNormal
      end
    | if (ch >= 0x20) and (ch < 0x7F) =>
      _search_buf.push(ch)
    end

  // --- Commands ---

  fun ref _execute_command() =>
    let cmd: String val = _cmd_buf.clone()
    _cmd_buf.clear()

    if cmd == "q" then
      if _buf.dirty then
        _set_message("No write since last change (add ! to override)")
      else
        _quit()
      end
    elseif cmd == "q!" then
      _quit()
    elseif cmd == "w" then
      _save_file()
    elseif cmd == "wq" then
      if _save_file() then _quit() end
    elseif cmd == "x" then
      if _buf.dirty then
        if _save_file() then _quit() end
      else
        _quit()
      end
    elseif (cmd.size() > 2) and (cmd.substring(0, 2) == "w ") then
      let wfname: String val = cmd.substring(2)
      _buf.filename = wfname.clone()
      _save_file()
    elseif (cmd.size() > 2) and (cmd.substring(0, 2) == "e ") then
      let fname: String val = cmd.substring(2)
      _buf = Buffer(fname.clone())
      _buf.load(_auth)
      _cx = 0
      _cy = 0
      _row_off = 0
      _col_off = 0
      let msg = String
      msg.append("\"")
      msg.append(fname)
      msg.append("\" ")
      msg.append(_buf.line_count().string())
      msg.append(" lines")
      _set_message(msg.clone())
    else
      // Try to parse as line number
      try
        let line_num = cmd.usize()?
        if line_num > 0 then
          _cy = (line_num - 1).min(_buf.line_count() - 1)
          _cx = 0
          _clamp_cursor()
        end
      else
        let errmsg = String
        errmsg.append("Not a command: ")
        errmsg.append(cmd)
        _set_message(errmsg.clone())
      end
    end

  fun ref _save_file(): Bool =>
    if _buf.filename.size() == 0 then
      _set_message("No file name")
      return false
    end
    if _buf.save(_auth) then
      let sm = String
      sm.append("\"")
      sm.append(_buf.filename)
      sm.append("\" ")
      sm.append(_buf.line_count().string())
      sm.append(" lines written")
      _set_message(sm.clone())
      true
    else
      _set_message("Error writing file")
      false
    end

  fun ref _paste_after() =>
    if _yank_lines.size() == 0 then return end
    if _yank_is_line then
      for (i, l) in _yank_lines.pairs() do
        _buf.insert_line(_cy + 1 + i, l.clone())
      end
      _cy = _cy + 1
      _cx = 0
      _move_to_first_nonblank()
    else
      try
        let text = _yank_lines(0)?
        let l = _buf.lines(_cy)?
        var col = _cx + 1
        for ch in text.values() do
          l.insert_byte(col.isize(), ch)
          col = col + 1
        end
        _cx = col - 1
        _buf.dirty = true
      end
    end

  fun ref _paste_before() =>
    if _yank_lines.size() == 0 then return end
    if _yank_is_line then
      for (i, l) in _yank_lines.pairs() do
        _buf.insert_line(_cy + i, l.clone())
      end
      _cx = 0
      _move_to_first_nonblank()
    else
      try
        let text = _yank_lines(0)?
        let l = _buf.lines(_cy)?
        var col = _cx
        for ch in text.values() do
          l.insert_byte(col.isize(), ch)
          col = col + 1
        end
        _cx = col - 1
        _buf.dirty = true
      end
    end

  fun ref _quit() =>
    _quitting = true
    _quit_fn()

  // --- Main key dispatch ---

  fun ref key_press(ch: U8): Bool =>
    """Returns true if quit was triggered."""
    _quitting = false
    match _mode
    | ModeNormal => normal_key(ch)
    | ModeInsert => insert_key(ch)
    | ModeCommand => command_key(ch)
    | ModeSearch => search_key(ch)
    end
    _quitting

  fun ref is_quitting(): Bool => _quitting

  fun ref arrow_up() =>
    match _mode
    | ModeNormal => _move_up(if _count > 0 then _count else 1 end)
    | ModeInsert => _move_up()
    end
    _count = 0

  fun ref arrow_down() =>
    match _mode
    | ModeNormal => _move_down(if _count > 0 then _count else 1 end)
    | ModeInsert => _move_down()
    end
    _count = 0

  fun ref arrow_left() =>
    match _mode
    | ModeNormal => _move_left(if _count > 0 then _count else 1 end)
    | ModeInsert => _move_left()
    end
    _count = 0

  fun ref arrow_right() =>
    match _mode
    | ModeNormal => _move_right(if _count > 0 then _count else 1 end)
    | ModeInsert => _move_right()
    end
    _count = 0

  fun ref home_key() =>
    _cx = 0

  fun ref end_key() =>
    _cx = _cur_line_max()

  fun ref delete_key() =>
    match _mode
    | ModeInsert =>
      if _cx < _cur_line_len() then
        _delete_char_at_cursor()
      end
    | ModeNormal =>
      if _cx < _cur_line_len() then
        _save_undo()
        _delete_char_at_cursor()
        _clamp_cursor()
      end
    end

  fun ref page_up() =>
    _move_up(_rows)

  fun ref page_down() =>
    _move_down(_rows)

  // --- Rendering ---

  fun ref render() =>
    // Clear expired transient messages (5 second timeout)
    if _msg_transient and (_message.size() > 0) then
      if (_now_seconds() - _msg_time) >= 5 then
        _message = ""
        _msg_transient = false
      end
    end

    _scroll()
    let out = String((_rows + 2) * _cols * 2)
    out.append("\x1B[?25l")  // hide cursor
    out.append("\x1B[H")     // move to top-left

    // Draw lines
    let gw = _gutter_width()
    var screen_row: USize = 0
    while screen_row < _rows do
      let file_row = screen_row + _row_off
      if file_row < _buf.line_count() then
        // Draw gutter (line number)
        if gw > 0 then
          _draw_gutter(out, file_row + 1)
        end
        _draw_line(out, file_row)
      else
        out.append(ANSI.grey())
        out.push('~')
        let gc = _gutter_cols()
        var g: USize = 0
        while g < gc do
          out.push(' ')
          g = g + 1
        end
        out.append(ANSI.reset())
      end
      out.append("\x1B[K")  // clear to end of line
      out.append("\r\n")
      screen_row = screen_row + 1
    end

    // Status bar
    _draw_status_bar(out)
    out.append("\r\n")

    // Command / message line
    _draw_command_line(out)
    out.append("\x1B[K")

    // Position cursor
    let cursor_row = (_cy - _row_off) + 1
    let cursor_col = (_rx - _col_off) + _gutter_cols() + 1
    out.append("\x1B[")
    out.append(cursor_row.string())
    out.push(';')
    out.append(cursor_col.string())
    out.push('H')

    out.append("\x1B[?25h")  // show cursor

    ifdef posix then
      @write(1, out.cpointer(), out.size())
    end

  fun _draw_line(out: String ref, file_row: USize) =>
    let l = _buf.line(file_row)
    var col: USize = 0
    var rx: USize = 0
    let tc = _text_cols()
    while col < l.size() do
      let ch = try l(col)? else ' ' end
      if ch == '\t' then
        let spaces = _tab_stop - (rx % _tab_stop)
        var s: USize = 0
        while s < spaces do
          if (rx >= _col_off) and (rx < (_col_off + tc)) then
            out.push(' ')
          end
          rx = rx + 1
          s = s + 1
        end
      else
        if (rx >= _col_off) and (rx < (_col_off + tc)) then
          out.push(ch)
        end
        rx = rx + 1
      end
      col = col + 1
    end

  fun _draw_gutter(out: String ref, line_num: USize) =>
    let gw = _gutter_width()
    let num_str: String val = line_num.string().clone()
    let padding = if gw > num_str.size() then gw - num_str.size() else 0 end
    out.append(ANSI.grey())
    var p: USize = 0
    while p < padding do
      out.push(' ')
      p = p + 1
    end
    out.append(num_str)
    out.push(' ')
    out.append(ANSI.reset())

  fun _draw_status_bar(out: String ref) =>
    out.append("\x1B[7m")  // reverse video

    // Left side: mode + filename
    let mode_str = match _mode
    | ModeNormal => " NORMAL "
    | ModeInsert => " INSERT "
    | ModeCommand => " COMMAND "
    | ModeSearch => " SEARCH "
    end

    let fname: String val = if _buf.filename.size() > 0 then
      _buf.filename.clone()
    else
      "[No Name]".clone()
    end
    let modified: String val = if _buf.dirty then " [+]".clone() else "".clone() end

    let left = String
    left.append(mode_str)
    left.append(fname)
    left.append(modified)

    // Right side: line/col info
    let right = String
    right.append(" ")
    right.append((_cy + 1).string())
    right.append("/")
    right.append(_buf.line_count().string())
    right.append(" Col:")
    right.append((_cx + 1).string())
    right.append(" ")

    let padding = if _cols > (left.size() + right.size()) then
      _cols - left.size() - right.size()
    else
      0
    end

    out.append(left)
    var p: USize = 0
    while p < padding do
      out.push(' ')
      p = p + 1
    end
    out.append(right)
    out.append("\x1B[m")  // reset

  fun _draw_command_line(out: String ref) =>
    match _mode
    | ModeCommand =>
      out.push(':')
      out.append(_cmd_buf.clone())
    | ModeSearch =>
      if _search_dir then out.push('/') else out.push('?') end
      out.append(_search_buf.clone())
    else
      if _message.size() > 0 then
        let msg_len = _message.size().min(_cols)
        let sub: String val = _message.substring(0, msg_len.isize())
        out.append(sub)
      end
    end

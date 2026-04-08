use "term"
use "files"
use "time"

use @write[ISize](fd: I32, buffer: Pointer[U8] tag, size: USize) if posix

primitive ModeNormal
primitive ModeInsert
primitive ModeCommand
primitive ModeSearch
primitive ModeVisual
primitive ModeVisualLine

type Mode is (ModeNormal | ModeInsert | ModeCommand | ModeSearch
  | ModeVisual | ModeVisualLine)

class Editor
  let _env: Env
  let _auth: FileAuth
  var _buf: Buffer
  var _cx: USize = 0
  var _cy: USize = 0
  var _rx: USize = 0
  var _row_off: USize = 0
  var _col_off: USize = 0
  var _rows: USize = 24
  var _cols: USize = 80
  var _mode: Mode = ModeNormal
  var _cmd_buf: String ref = String
  var _search_buf: String ref = String
  var _search_dir: Bool = true
  var _message: String = ""
  var _msg_time: U64 = 0
  var _msg_transient: Bool = false
  var _yank_lines: Array[String] ref = Array[String]
  var _yank_is_line: Bool = false
  // Registers: 0-9 digits, a-z letters, unnamed (0), clipboard
  var _registers: Array[Array[String] ref] ref = Array[Array[String] ref].init(recover iso Array[String] end, 27)
  var _register_is_line: Array[Bool] ref = Array[Bool].init(false, 27)
  // 0=unnamed, 1-26=a-z
  var _current_register: USize = 0
  var _count: USize = 0
  var _pending: U8 = 0
  var _quitting: Bool = false
  let _quit_fn: {()} val
  var _tab_stop: USize = 8
  var _shift_width: USize = 2
  var _relativenum: Bool = false
  var _expandtab: Bool = false
  // Git dirty state
  var _git_dirty: Bool = false
  var _git_branch: String = ""
  // Undo / redo
  var _undo_stack: Array[(Array[String val], USize, USize)] ref =
    Array[(Array[String val], USize, USize)]
  var _redo_stack: Array[(Array[String val], USize, USize)] ref =
    Array[(Array[String val], USize, USize)]
  // Operator pending (d, y, c, >, <)
  var _operator: U8 = 0
  var _op_count: USize = 0
  // f/F/t/T
  var _pending_find: U8 = 0
  var _pending_register: Bool = false
  // Text objects (i/a + w/"'/(/)/{/}/[/]/<)
  var _pending_textobj: U8 = 0
  var _pending_textop: U8 = 0
  var _pending_textcount: USize = 0
  var _last_find_char: U8 = 0
  var _last_find_dir: I8 = 1
  var _last_find_till: Bool = false
  // Marks
  var _marks: Array[(USize, USize)] ref = Array[(USize, USize)].init((0, 0), 26)
  var _mark_set: Array[Bool] ref = Array[Bool].init(false, 26)
  // Visual selection
  var _sel_sx: USize = 0
  var _sel_sy: USize = 0
  // Dot repeat
  var _dot_keys: Array[U8] ref = Array[U8]
  var _dot_recording: Array[U8] ref = Array[U8]
  var _dot_is_recording: Bool = false
  var _dot_replaying: Bool = false
  // Syntax highlighting
  var _lang: SyntaxLang = LangNone
  var _hl_bc_state: Array[Bool] ref = Array[Bool]  // per-row: in block comment?

  new create(env: Env, filename: String, quit_fn: {()} val) =>
    _env = env
    _auth = FileAuth(env.root)
    _quit_fn = quit_fn
    _buf = Buffer(filename)
    if filename.size() > 0 then
      _buf.load(_auth)
      _lang = SyntaxDetect(filename)
      let m = String
      m.append("\"")
      m.append(filename)
      m.append("\" ")
      m.append(_buf.line_count().string())
      if _buf.line_count() == 1 then
        m.append(" line")
      else
        m.append(" lines")
      end
      _message = m.clone()
      _msg_time = _now_seconds()
      _msg_transient = true
    else
      _message = ""
    end
    _save_undo()
    // Check git status
    if filename.size() > 0 then
      _check_git_dirty(filename)
    end

  fun ref set_size(rows: USize, cols: USize) =>
    let r = if rows > 2 then rows else 24 end
    let c = if cols > 0 then cols else 80 end
    _rows = r - 2
    _cols = c
    _scroll()
    render()

  // ── Undo / Redo ──

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
    _redo_stack.clear()

  fun ref _undo() =>
    if _undo_stack.size() > 1 then
      try
        // Save current state to redo before restoring
        let cur = _undo_stack.pop()?
        _redo_stack.push(cur)
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
        // Re-add the redo entry since _save_undo cleared it
        _redo_stack.push(cur)
        _set_message("Undo")
      end
    else
      _set_message("Already at oldest change")
    end

  fun ref _redo() =>
    if _redo_stack.size() > 0 then
      try
        (let snapshot, let cx, let cy) = _redo_stack.pop()?
        _buf.lines.clear()
        for l in snapshot.values() do
          _buf.lines.push(l.clone())
        end
        _cx = cx
        _cy = cy.min(_buf.line_count() - 1)
        _cx = _cx.min(_cur_line_max())
        _buf.dirty = true
        // Push restored state onto undo without clearing redo
        let arr = Array[String val](_buf.lines.size())
        for l in _buf.lines.values() do
          let s: String val = l.clone()
          arr.push(s)
        end
        _undo_stack.push((arr, _cx, _cy))
        if _undo_stack.size() > 200 then
          try _undo_stack.shift()? end
        end
        _set_message("Redo")
      end
    else
      _set_message("Already at newest change")
    end

  // ── Scrolling ──

  fun ref _scroll() =>
    _rx = _cx_to_rx(_cy, _cx)
    let so = _scrolloff()
    if _cy < (_row_off + so) then
      _row_off = if _cy >= so then _cy - so else 0 end
    end
    if (_cy + so) >= (_row_off + _rows) then
      _row_off = ((_cy + so) - _rows) + 1
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

  // ── Helpers ──

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

  fun ref _check_git_dirty(filename: String box) =>
    """
    Track dirty state from buffer. In a full implementation this would
    call git status via Process API, but since that's async in Pony,
    we conservatively use buffer dirty state as the indicator.
    """
    _git_dirty = _buf.dirty
    _git_branch = ""

  // ── Dot repeat ──

  fun ref _dot_start(ch: U8) =>
    if _dot_replaying then return end
    _dot_is_recording = true
    _dot_recording.clear()
    _dot_recording.push(ch)

  fun ref _dot_record(ch: U8) =>
    if _dot_is_recording and (not _dot_replaying) then
      _dot_recording.push(ch)
    end

  fun ref _dot_stop() =>
    if _dot_is_recording and (not _dot_replaying) then
      _dot_is_recording = false
      _dot_keys.clear()
      for k in _dot_recording.values() do
        _dot_keys.push(k)
      end
    end

  fun ref _dot_replay() =>
    if _dot_keys.size() == 0 then return end
    _dot_replaying = true
    // Copy keys to avoid mutation during replay
    let keys = Array[U8](_dot_keys.size())
    for k in _dot_keys.values() do keys.push(k) end
    for k in keys.values() do
      key_press(k)
    end
    _dot_replaying = false

  // ── Movement ──

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
        while (_cx < len) and _is_word_char(try l(_cx)? else ' ' end) do
          _cx = _cx + 1
        end
        while (_cx < len) and (not _is_word_char(try l(_cx)? else ' ' end)) do
          _cx = _cx + 1
        end
        if _cx >= len then
          if _cy < (_buf.line_count() - 1) then
            _cy = _cy + 1
            _cx = 0
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
        while (_cx > 0) and (not _is_word_char(try l(_cx)? else ' ' end)) do
          _cx = _cx - 1
        end
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
          while (_cx < nl.size()) and
            (((try nl(_cx)? else 'a' end) == ' ') or
            ((try nl(_cx)? else 'a' end) == '\t'))
          do
            _cx = _cx + 1
          end
        end
      else
        _cx = _cx + 1
        while (_cx < len) and (not _is_word_char(try l(_cx)? else ' ' end)) do
          _cx = _cx + 1
        end
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

  // ── Text Object Finding ──

  fun _find_text_object(which: U8, ch: U8): (USize, USize, USize, USize) =>
    """
    Find text object range. Returns (sx, sy, ex, ey).
    which: 'i' (inner) or 'a' (around)
    ch: w, ", ', (, ), {, }, B, [, ], <, >
    """
    match ch
    | 'w' => _find_word_object(which)
    | '"' => _find_quote_object(which, '"')
    | '\'' => _find_quote_object(which, '\'')
    | '(' | ')' => _find_bracket_object(which, '(', ')')
    | '{' | '}' | 'B' => _find_bracket_object(which, '{', '}')
    | '[' | ']' => _find_bracket_object(which, '[', ']')
    | '<' | '>' => _find_bracket_object(which, '<', '>')
    else (_cx, _cy, _cx, _cy)
    end

  fun _find_word_object(which: U8): (USize, USize, USize, USize) =>
    let l = _buf.line(_cy)
    let len = l.size()
    if len == 0 then return (_cx, _cy, _cx, _cy) end

    var ws: USize = 0
    var we: USize = 0
    var found = false

    // If cursor is on a word, find its boundaries
    if (_cx < len) and _is_word_char(try l(_cx)? else ' ' end) then
      ws = _cx
      while ws > 0 do
        if not _is_word_char(try l(ws - 1)? else ' ' end) then break end
        ws = ws - 1
      end
      we = _cx
      while (we + 1) < len do
        if not _is_word_char(try l(we + 1)? else ' ' end) then break end
        we = we + 1
      end
      found = true
    else
      // Cursor not on a word, find next word
      ws = _cx
      while (ws < len) and (not _is_word_char(try l(ws)? else ' ' end)) do
        ws = ws + 1
      end
      if ws < len then
        we = ws
        while (we + 1) < len do
          if not _is_word_char(try l(we + 1)? else ' ' end) then break end
          we = we + 1
        end
        found = true
      end
    end

    if not found then return (_cx, _cy, _cx, _cy) end

    if which == 'a' then
      // Include surrounding whitespace
      var asx = ws
      while asx > 0 do
        let prev = try l(asx - 1)? else ' ' end
        if (prev == ' ') or (prev == '\t') then asx = asx - 1 else break end
      end
      var aex = we
      while (aex + 1) < len do
        let next = try l(aex + 1)? else ' ' end
        if (next == ' ') or (next == '\t') then aex = aex + 1 else break end
      end
      ws = asx
      we = aex
    end

    (ws, _cy, we, _cy)

  fun _find_quote_object(which: U8, quote: U8): (USize, USize, USize, USize) =>
    let l = _buf.line(_cy)
    let len = l.size()
    if len == 0 then return (_cx, _cy, _cx, _cy) end

    // Search backward from cursor for opening quote (skip if cursor is on quote)
    var open_pos: USize = 0
    var found_open = false
    var i = if _cx < len then _cx else len - 1 end
    while true do
      let ch = try l(i)? else 0 end
      if ch == quote then
        // Check not escaped
        var escaped = false
        if i > 0 then
          var ei: ISize = i.isize() - 1
          while ei >= 0 do
            if (try l(ei.usize())? else 0 end) != '\\' then break end
            escaped = not escaped
            ei = ei - 1
          end
        end
        if not escaped then
          open_pos = i
          found_open = true
          break
        end
      end
      if i == 0 then break end
      i = i - 1
    end

    if not found_open then return (_cx, _cy, _cx, _cy) end

    // Search forward for closing quote
    var close_pos: USize = 0
    var found_close = false
    var j = open_pos + 1
    while j < len do
      let ch = try l(j)? else 0 end
      if ch == quote then
        var escaped = false
        if j > 0 then
          var ei: ISize = j.isize() - 1
          while ei >= 0 do
            if (try l(ei.usize())? else 0 end) != '\\' then break end
            escaped = not escaped
            ei = ei - 1
          end
        end
        if not escaped then
          close_pos = j
          found_close = true
          break
        end
      end
      j = j + 1
    end

    if not found_close then return (_cx, _cy, _cx, _cy) end

    if which == 'a' then
      (open_pos, _cy, close_pos, _cy)
    else
      // Inner: between quotes
      let cs = open_pos + 1
      let ce = if close_pos > cs then close_pos - 1 else cs end
      (cs, _cy, ce, _cy)
    end

  fun _find_bracket_object(which: U8, open: U8, close: U8): (USize, USize, USize, USize) =>
    // Search backward for opening bracket, tracking nesting
    var open_row: USize = 0
    var open_col: USize = 0
    var found_open = false
    var depth: ISize = 0

    var r = _cy
    while true do
      let l = _buf.line(r)
      let len = l.size()
      var c: USize = len
      if len > 0 then c = len - 1 end
      if (r == _cy) and (_cx < len) then c = _cx end

      while true do
        let ch = try l(c)? else 0 end
        if ch == close then
          depth = depth + 1
        elseif ch == open then
          if depth == 0 then
            open_row = r
            open_col = c
            found_open = true
            break
          end
          depth = depth - 1
        end
        if c == 0 then break end
        c = c - 1
      end
      if found_open then break end
      if r == 0 then break end
      r = r - 1
    end

    if not found_open then return (_cx, _cy, _cx, _cy) end

    // Search forward for matching closing bracket
    var close_row: USize = 0
    var close_col: USize = 0
    var found_close = false
    depth = 0

    var r2 = open_row
    while r2 < _buf.line_count() do
      let l = _buf.line(r2)
      let len = l.size()
      var c2: USize = if r2 == open_row then open_col + 1 else 0 end

      while c2 < len do
        let ch = try l(c2)? else 0 end
        if ch == open then
          depth = depth + 1
        elseif ch == close then
          if depth == 0 then
            close_row = r2
            close_col = c2
            found_close = true
            break
          end
          depth = depth - 1
        end
        c2 = c2 + 1
      end
      if found_close then break end
      r2 = r2 + 1
    end

    if not found_close then return (_cx, _cy, _cx, _cy) end

    if open_row == close_row then
      // Single line
      let l = _buf.line(open_row)
      if which == 'a' then
        (open_col, open_row, close_col, close_row)
      else
        // Inner: skip whitespace
        var sx = open_col + 1
        var ex = if close_col > sx then close_col - 1 else sx end
        while sx <= ex do
          let ch = try l(sx)? else ' ' end
          if (ch == ' ') or (ch == '\t') then sx = sx + 1 else break end
        end
        while ex >= sx do
          let ch = try l(ex)? else ' ' end
          if (ch == ' ') or (ch == '\t') then
            if ex == 0 then break end
            ex = ex - 1
          else break end
        end
        if sx > ex then
          (open_col + 1, open_row, open_col + 1, open_row)
        else
          (sx, open_row, ex, close_row)
        end
      end
    else
      // Multi-line
      if which == 'a' then
        (open_col, open_row, close_col, close_row)
      else
        // Inner: content between brackets
        var sx = open_col + 1
        var sy = open_row
        var ex = close_col
        var ey = close_row

        // Skip leading whitespace on first line
        let first = _buf.line(open_row)
        while sx < first.size() do
          let ch = try first(sx)? else ' ' end
          if (ch == ' ') or (ch == '\t') then sx = sx + 1 else break end
        end
        // If first line is all ws, start at next line
        if (sx >= first.size()) and ((open_row + 1) <= close_row) then
          sy = open_row + 1
          sx = 0
        end

        // Skip trailing whitespace on last line
        let last = _buf.line(close_row)
        while ex > 0 do
          let ch = try last(ex - 1)? else ' ' end
          if (ch == ' ') or (ch == '\t') then ex = ex - 1 else break end
        end
        // If last line is all ws, end at previous line
        if (ex == 0) and (close_row > sy) then
          ey = close_row - 1
          ex = _buf.line_len(ey)
        end

        if sy > ey then
          (open_col + 1, open_row, open_col + 1, open_row)
        else
          (sx, sy, ex, ey)
        end
      end
    end

  // ── f/F/t/T ──

  fun ref _find_char_on_line(ch: U8, dir: I8, till: Bool): Bool =>
    let l = _buf.line(_cy)
    let len = l.size()
    if len == 0 then return false end
    _last_find_char = ch
    _last_find_dir = dir
    _last_find_till = till
    if dir == 1 then
      // Forward
      var i = _cx + 1
      while i < len do
        if (try l(i)? else 0 end) == ch then
          _cx = if till then i - 1 else i end
          return true
        end
        i = i + 1
      end
    else
      // Backward
      if _cx == 0 then return false end
      var i = _cx - 1
      while true do
        if (try l(i)? else 0 end) == ch then
          _cx = if till then i + 1 else i end
          return true
        end
        if i == 0 then break end
        i = i - 1
      end
    end
    false

  fun ref _repeat_find_char(reverse: Bool) =>
    if _last_find_char == 0 then
      _set_message("No previous f/t char")
      return
    end
    let dir: I8 = if reverse then -_last_find_dir else _last_find_dir end
    _find_char_on_line(_last_find_char, dir, _last_find_till)

  // ── Editing ──

  fun ref _insert_char(ch: U8) =>
    _buf.insert_char(_cy, _cx, ch)
    _cx = _cx + 1

  fun ref _insert_newline() =>
    // Auto-indent: copy leading whitespace from current line
    if _mode is ModeInsert then
      let l = _buf.line(_cy)
      var indent_end: USize = 0
      while indent_end < l.size() do
        let ch = try l(indent_end)? else ' ' end
        if (ch != ' ') and (ch != '\t') then break end
        indent_end = indent_end + 1
      end
      if indent_end > 0 then
        let indent = l.substring(0, indent_end.isize()).clone()
        _buf.split_line(_cy, _cx)
        _cy = _cy + 1
        // Insert indent at start of new line
        try
          let nl = _buf.lines(_cy)?
          let i: String val = consume indent
          nl.insert(0, i)
        end
        _cx = indent_end
        _buf.dirty = true
        return
      end
    end
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
      if cur_len > 0 then
        _buf.insert_char(_cy, cur_len, ' ')
      end
      _buf.join_lines(_cy)
      _cx = cur_len
    end

  // ── Yank range ──

  fun ref _yank_range(sx: USize, sy: USize, ex: USize, ey: USize, is_line: Bool) =>
    let reg = try _registers(_current_register)? else return end
    reg.clear()
    try _register_is_line(_current_register)? = is_line end

    if is_line then
      var r = sy
      while r <= ey.min(_buf.line_count() - 1) do
        reg.push(_buf.line(r).clone())
        r = r + 1
      end
    else
      if sy == ey then
        let l = _buf.line(sy)
        let from = sx.min(l.size())
        let to = (ex + 1).min(l.size())
        reg.push(l.substring(from.isize(), to.isize()).clone())
      else
        // First line from sx to end
        let fl = _buf.line(sy)
        reg.push(fl.substring(sx.isize()).clone())
        // Middle lines
        var r = sy + 1
        while r < ey do
          reg.push(_buf.line(r).clone())
          r = r + 1
        end
        // Last line from start to ex
        let ll = _buf.line(ey)
        reg.push(ll.substring(0, (ex + 1).isize()).clone())
      end
    end

    // Also copy to unnamed register (0) if not already using it
    if _current_register != 0 then
      let unreg = try _registers(0)? else return end
      unreg.clear()
      try _register_is_line(0)? = is_line end
      for ln in reg.values() do
        unreg.push(ln.clone())
      end
    end

    // Update legacy _yank_lines for compatibility with _execute_text_object
    _yank_lines.clear()
    for ln in reg.values() do _yank_lines.push(ln.clone()) end
    _yank_is_line = is_line

  // ── Execute motion (returns true if motion was recognized) ──

  fun ref _execute_motion(ch: U8, count: USize): Bool =>
    match ch
    | 'h' => _move_left(count); true
    | 'l' => _move_right(count); true
    | 'j' => _move_down(count); true
    | 'k' => _move_up(count); true
    | 'w' => _move_word_forward(count); true
    | 'b' => _move_word_backward(count); true
    | 'e' => _move_word_end(count); true
    | '0' => _move_to_line_start(); true
    | '$' => _move_to_line_end(); true
    | '^' => _move_to_first_nonblank(); true
    | 'G' =>
      _cy = (_buf.line_count() - 1).min(if count > 1 then count - 1 else _buf.line_count() - 1 end)
      _clamp_cursor()
      true
    | 'H' =>
      _cy = _row_off
      _clamp_cursor()
      true
    | 'M' =>
      _cy = _row_off + (_rows / 2)
      _clamp_cursor()
      true
    | 'L' =>
      _cy = ((_row_off + _rows) - 1).min(_buf.line_count() - 1)
      _clamp_cursor()
      true
    else
      false
    end

  fun _is_linewise_motion(ch: U8): Bool =>
    (ch == 'j') or (ch == 'k') or (ch == 'G')

  // ── Text Object Execution ──

  fun ref _execute_text_object(which: U8, ch: U8, op: U8, count: USize) =>
    """
    Execute operator on text object.
    which: 'i' (inner) or 'a' (around)
    ch: w, ", ', (, ), {, }, B, [, ], <, >
    op: d, y, c, >, <
    """
    (let sx, let sy, let ex, let ey) = _find_text_object(which, ch)
    // If range is degenerate (find failed), cancel
    if (sx == _cx) and (sy == _cy) and (ex == _cx) and (ey == _cy) then
      let l = _buf.line(_cy)
      if l.size() == 0 then return end
      // Check if we're actually at the failed position
      // (cursor wasn't on a text object)
      return
    end

    let is_line = (sy != ey) or (which == 'a')

    match op
    | 'd' =>
      _save_undo()
      _yank_range(sx, sy, ex, ey, is_line)
      if is_line then
        var i = ey
        while i >= sy do
          if _buf.line_count() > 1 then
            _buf.delete_line(i)
          else
            try _buf.lines(i)?.clear() end
            _buf.dirty = true
          end
          if i == 0 then break end
          i = i - 1
        end
        if _buf.line_count() == 0 then _buf.lines.push(String) end
      else
        _buf.delete_range(sy, sx, ey, ex)
      end
      _cy = sy
      _cx = sx
      _clamp_cursor()
      _dot_stop()
    | 'y' =>
      _yank_range(sx, sy, ex, ey, is_line)
      _dot_stop()
      let n_lines = (ey - sy) + 1
      if n_lines > 1 then
        let msg = String
        msg.append(n_lines.string())
        msg.append(" lines yanked")
        _set_message(msg.clone())
      end
    | 'c' =>
      _save_undo()
      _yank_range(sx, sy, ex, ey, is_line)
      if is_line then
        var i = ey
        while i >= sy do
          if _buf.line_count() > 1 then
            _buf.delete_line(i)
          else
            try _buf.lines(i)?.clear() end
            _buf.dirty = true
          end
          if i == 0 then break end
          i = i - 1
        end
        if _buf.line_count() == 0 then _buf.lines.push(String) end
        _buf.insert_line(sy, "")
        _cy = sy
        _cx = 0
      else
        _buf.delete_range(sy, sx, ey, ex)
        _cy = sy
        _cx = sx
      end
      _clamp_cursor()
      _mode = ModeInsert
    | '>' =>
      _save_undo()
      if sy == ey then
        _buf.indent_lines(sy, ey)
      else
        _buf.indent_lines(sy, ey)
      end
      _cy = sy
      _cx = sx
      _clamp_cursor()
      _dot_stop()
    | '<' =>
      _save_undo()
      if sy == ey then
        _buf.outdent_lines(sy, ey)
      else
        _buf.outdent_lines(sy, ey)
      end
      _cy = sy
      _cx = sx
      _clamp_cursor()
      _dot_stop()
    end

  // ── Operator handling ──

  fun ref _handle_operator(op: U8, ch: U8, count: USize) =>
    """Handle operator+motion: compute range, apply operator."""
    // Check for doubled operator (dd, yy, cc, >>, <<)
    if ch == op then
      let sy = _cy
      let ey = ((_cy + count) - 1).min(_buf.line_count() - 1)
      match op
      | 'd' =>
        _save_undo()
        _yank_range(0, sy, _buf.line_len(ey), ey, true)
        var i: USize = 0
        while i < count do
          if _buf.line_count() > 1 then
            _buf.delete_line(_cy)
          elseif _buf.line_len(_cy) > 0 then
            try _buf.lines(_cy)?.clear() end
            _buf.dirty = true
            _cx = 0
          end
          i = i + 1
        end
        if _buf.line_count() == 0 then _buf.lines.push(String) end
        _clamp_cursor()
        _dot_stop()
        let msg = String
        msg.append(count.string())
        msg.append(if count == 1 then " line deleted" else " lines deleted" end)
        _set_message(msg.clone())
      | 'y' =>
        _yank_range(0, sy, _buf.line_len(ey), ey, true)
        _dot_stop()
        let msg = String
        msg.append(count.string())
        msg.append(if count == 1 then " line yanked" else " lines yanked" end)
        _set_message(msg.clone())
      | 'c' =>
        _save_undo()
        _yank_range(0, sy, _buf.line_len(ey), ey, true)
        // Delete lines and replace with empty line
        var i: USize = 0
        let del_count = (ey - sy) + 1
        while i < del_count do
          if _buf.line_count() > 1 then
            _buf.delete_line(sy)
          else
            try _buf.lines(sy)?.clear() end
            _buf.dirty = true
          end
          i = i + 1
        end
        if _buf.line_count() == 0 then _buf.lines.push(String) end
        _buf.insert_line(sy, "")
        _cy = sy
        _cx = 0
        _mode = ModeInsert
      | '>' =>
        _save_undo()
        _buf.indent_lines(sy, ey)
        _dot_stop()
      | '<' =>
        _save_undo()
        _buf.outdent_lines(sy, ey)
        _dot_stop()
      end
      return
    end

    // f/F/t/T as operator motion
    if (ch == 'f') or (ch == 'F') or (ch == 't') or (ch == 'T') then
      // Need next char — set up combined pending state
      _pending_find = ch
      // _operator and _op_count stay set; find handler will trigger operator
      return
    end

    // gg as operator motion
    if ch == 'g' then
      _pending = 'g'
      return
    end

    // Execute the motion to find the destination
    let sx = _cx
    let sy = _cy
    if not _execute_motion(ch, count) then
      // Unknown motion — cancel operator
      _dot_stop()
      return
    end
    let dx = _cx
    let dy = _cy

    let is_line = _is_linewise_motion(ch)

    // Normalize range
    var r_sx: USize = 0
    var r_sy: USize = 0
    var r_ex: USize = 0
    var r_ey: USize = 0
    if (sy < dy) or ((sy == dy) and (sx <= dx)) then
      r_sx = sx; r_sy = sy; r_ex = dx; r_ey = dy
    else
      r_sx = dx; r_sy = dy; r_ex = sx; r_ey = sy
    end

    // For line-wise motions, extend to full lines
    if is_line then
      r_sx = 0
      r_ex = _buf.line_len(r_ey)
    end

    match op
    | 'd' =>
      _save_undo()
      _yank_range(r_sx, r_sy, r_ex, r_ey, is_line)
      if is_line then
        var i = r_ey
        while i >= r_sy do
          if _buf.line_count() > 1 then
            _buf.delete_line(i)
          else
            try _buf.lines(i)?.clear() end
            _buf.dirty = true
          end
          if i == 0 then break end
          i = i - 1
        end
        if _buf.line_count() == 0 then _buf.lines.push(String) end
      else
        _buf.delete_range(r_sy, r_sx, r_ey, r_ex)
      end
      _cy = r_sy
      _cx = r_sx
      _clamp_cursor()
      _dot_stop()
    | 'y' =>
      _yank_range(r_sx, r_sy, r_ex, r_ey, is_line)
      _cy = sy; _cx = sx  // Restore cursor after yank
      _dot_stop()
      let n_lines = (r_ey - r_sy) + 1
      if n_lines > 1 then
        let msg = String
        msg.append(n_lines.string())
        msg.append(" lines yanked")
        _set_message(msg.clone())
      end
    | 'c' =>
      _save_undo()
      _yank_range(r_sx, r_sy, r_ex, r_ey, is_line)
      if is_line then
        var i = r_ey
        while i >= r_sy do
          if _buf.line_count() > 1 then
            _buf.delete_line(i)
          else
            try _buf.lines(i)?.clear() end
            _buf.dirty = true
          end
          if i == 0 then break end
          i = i - 1
        end
        if _buf.line_count() == 0 then _buf.lines.push(String) end
        _buf.insert_line(r_sy, "")
        _cy = r_sy
        _cx = 0
      else
        _buf.delete_range(r_sy, r_sx, r_ey, r_ex)
        _cy = r_sy
        _cx = r_sx
      end
      _mode = ModeInsert
      // Don't dot_stop — recording continues through insert mode
    | '>' =>
      _save_undo()
      _buf.indent_lines(r_sy, r_ey)
      _cy = r_sy
      _move_to_first_nonblank()
      _dot_stop()
    | '<' =>
      _save_undo()
      _buf.outdent_lines(r_sy, r_ey)
      _cy = r_sy
      _move_to_first_nonblank()
      _dot_stop()
    end

  // ── Visual mode helpers ──

  fun _visual_range(): (USize, USize, USize, USize) =>
    """Returns normalized (sx, sy, ex, ey) for the visual selection."""
    match _mode
    | ModeVisualLine =>
      let sy = _sel_sy.min(_cy)
      let ey = _sel_sy.max(_cy)
      (0, sy, _buf.line_len(ey), ey)
    else
      if (_sel_sy < _cy) or ((_sel_sy == _cy) and (_sel_sx <= _cx)) then
        (_sel_sx, _sel_sy, _cx, _cy)
      else
        (_cx, _cy, _sel_sx, _sel_sy)
      end
    end

  fun _in_selection(row: USize, col: USize): Bool =>
    match _mode
    | ModeVisual =>
      (let sx, let sy, let ex, let ey) = _visual_range()
      if (row < sy) or (row > ey) then return false end
      if (row == sy) and (row == ey) then return (col >= sx) and (col <= ex) end
      if row == sy then return col >= sx end
      if row == ey then return col <= ex end
      true
    | ModeVisualLine =>
      let sy = _sel_sy.min(_cy)
      let ey = _sel_sy.max(_cy)
      (row >= sy) and (row <= ey)
    else
      false
    end

  // ── Search ──

  fun ref _search_next(forward: Bool) =>
    if _search_buf.size() == 0 then
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

  // ── Key handling: Normal mode ──

  fun ref normal_key(ch: U8) =>
    let count = if _count > 0 then _count else 1 end

    // Accumulate count prefix
    if (ch >= '0') and (ch <= '9') and not ((_count == 0) and (ch == '0')) then
      _count = (_count * 10) + (ch - '0').usize()
      if _dot_is_recording then _dot_record(ch) end
      return
    end

    // ── Pending find (f/F/t/T waiting for target char) ──
    if _pending_find != 0 then
      let pf = _pending_find
      _pending_find = 0
      let dir: I8 = if (pf == 'f') or (pf == 't') then 1 else -1 end
      let till = (pf == 't') or (pf == 'T')
      // If operator is pending, this is an operator+find motion
      if _operator != 0 then
        let sx = _cx
        let sy = _cy
        if _find_char_on_line(ch, dir, till) then
          let dx = _cx
          let r_sx = sx.min(dx)
          let r_ex = sx.max(dx)
          match _operator
          | 'd' =>
            _save_undo()
            _yank_range(r_sx, _cy, r_ex, _cy, false)
            _buf.delete_range(_cy, r_sx, _cy, r_ex)
            _cx = r_sx
            _clamp_cursor()
            _dot_record(pf)
            _dot_record(ch)
            _dot_stop()
          | 'y' =>
            _yank_range(r_sx, _cy, r_ex, _cy, false)
            _cx = sx
            _dot_record(pf)
            _dot_record(ch)
            _dot_stop()
          | 'c' =>
            _save_undo()
            _yank_range(r_sx, _cy, r_ex, _cy, false)
            _buf.delete_range(_cy, r_sx, _cy, r_ex)
            _cx = r_sx
            _mode = ModeInsert
            _dot_record(pf)
            _dot_record(ch)
          end
        end
        _operator = 0
        _op_count = 0
        _count = 0
        return
      end
      _find_char_on_line(ch, dir, till)
      _count = 0
      return
    end

    // ── Pending keys (gg, r+char, ZZ/ZQ, m+char, '+char) ──
    if _pending == 'g' then
      _pending = 0
      if ch == 'g' then
        if _operator != 0 then
          // Operator + gg: operate from current pos to line 0
          let op = _operator
          let sx = _cx
          let sy = _cy
          _cy = 0; _cx = 0
          let r_sy = _cy.min(sy)
          let r_ey = _cy.max(sy)
          _operator = 0
          match op
          | 'd' =>
            _save_undo()
            _yank_range(0, r_sy, _buf.line_len(r_ey), r_ey, true)
            var i = r_ey
            while i >= r_sy do
              if _buf.line_count() > 1 then _buf.delete_line(i) end
              if i == 0 then break end
              i = i - 1
            end
            if _buf.line_count() == 0 then _buf.lines.push(String) end
            _clamp_cursor()
            _dot_stop()
          | 'y' =>
            _yank_range(0, r_sy, _buf.line_len(r_ey), r_ey, true)
            _cy = sy; _cx = sx
            _dot_stop()
          | 'c' =>
            _save_undo()
            _yank_range(0, r_sy, _buf.line_len(r_ey), r_ey, true)
            var i = r_ey
            while i >= r_sy do
              if _buf.line_count() > 1 then _buf.delete_line(i) end
              if i == 0 then break end
              i = i - 1
            end
            if _buf.line_count() == 0 then _buf.lines.push(String) end
            _buf.insert_line(r_sy, "")
            _cy = r_sy; _cx = 0
            _mode = ModeInsert
          end
        else
          _cy = 0; _cx = 0; _clamp_cursor()
        end
      end
      _count = 0
      return
    end

    if _pending == 'r' then
      _pending = 0
      _count = 0
      if _cur_line_len() > 0 then
        _save_undo()
        _dot_start('r')
        _dot_record(ch)
        _dot_stop()
        try _buf.lines(_cy)?.update(_cx, ch)? end
      end
      return
    end

    if _pending == 'Z' then
      _pending = 0
      _count = 0
      if ch == 'Z' then
        if _buf.filename.size() > 0 then _buf.save(_auth) end
        _quit()
        return
      elseif ch == 'Q' then
        _quit()
        return
      end
      return
    end

    if _pending == 'm' then
      _pending = 0
      _count = 0
      if (ch >= 'a') and (ch <= 'z') then
        let idx = (ch - 'a').usize()
        try _marks.update(idx, (_cy, _cx))? end
        try _mark_set.update(idx, true)? end
        let msg = String
        msg.append("Mark '")
        msg.push(ch)
        msg.append("' set")
        _set_message(msg.clone())
      end
      return
    end

    if _pending == '\'' then
      _pending = 0
      _count = 0
      if (ch >= 'a') and (ch <= 'z') then
        let idx = (ch - 'a').usize()
        if try _mark_set(idx)? else false end then
          try
            (let mr, let mc) = _marks(idx)?
            _cy = mr.min(_buf.line_count() - 1)
            _move_to_first_nonblank()
          end
        else
          let msg = String
          msg.append("Mark '")
          msg.push(ch)
          msg.append("' not set")
          _set_message(msg.clone())
        end
      end
      return
    end

    // ── Register prefix (" waiting for register letter) ──
    if _pending_register then
      _pending_register = false
      if (ch >= 'a') and (ch <= 'z') then
        _current_register = ((ch - 'a') + 1).usize()
      else
        _current_register = 0
      end
      _count = 0
      return
    end

    // Reset register after use (at top of dispatch, before any command)
    // No — we reset it AFTER the command consumes it.
    // Actually, we'll reset it right here after the next key processes.
    // The register is already set, so just let the next key use it.

    // ── Text object pending (i/a waiting for object key) ──
    if _pending_textobj != 0 then
      let which = _pending_textobj
      _pending_textobj = 0
      let op = _pending_textop
      _pending_textop = 0
      let cnt = _pending_textcount
      _pending_textcount = 0
      _dot_record(ch)
      _execute_text_object(which, ch, op, cnt)
      _count = 0
      return
    end

    // ── Operator pending ──
    if _operator != 0 then
      let op = _operator
      _operator = 0
      let oc = _op_count
      _op_count = 0
      // Check for text object prefix
      if (ch == 'i') or (ch == 'a') then
        _pending_textobj = ch
        _pending_textop = op
        _pending_textcount = oc
        _count = 0
        return
      end
      // Use the larger of operator count and motion count
      let mc = if count > 1 then count else oc end
      _dot_record(ch)
      _handle_operator(op, ch, mc)
      _count = 0
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
    // f/F/t/T
    | 'f' => _pending_find = 'f'; _count = count; return
    | 'F' => _pending_find = 'F'; _count = count; return
    | 't' => _pending_find = 't'; _count = count; return
    | 'T' => _pending_find = 'T'; _count = count; return
    | ';' => _repeat_find_char(false)
    | ',' => _repeat_find_char(true)
    // Insert mode entry
    | 'i' =>
      _save_undo()
      _dot_start('i')
      _mode = ModeInsert
    | 'I' =>
      _save_undo()
      _dot_start('I')
      _move_to_first_nonblank()
      _mode = ModeInsert
    | 'a' =>
      _save_undo()
      _dot_start('a')
      if _cur_line_len() > 0 then _cx = _cx + 1 end
      _mode = ModeInsert
    | 'A' =>
      _save_undo()
      _dot_start('A')
      _cx = _cur_line_len()
      _mode = ModeInsert
    | 'o' =>
      _save_undo()
      _dot_start('o')
      _open_line_below()
    | 'O' =>
      _save_undo()
      _dot_start('O')
      _open_line_above()
    // Visual mode
    | 'v' =>
      _mode = ModeVisual
      _sel_sx = _cx
      _sel_sy = _cy
    | 'V' =>
      _mode = ModeVisualLine
      _sel_sx = 0
      _sel_sy = _cy
    // Editing
    | 'x' =>
      if _cur_line_len() > 0 then
        _save_undo()
        _dot_start('x')
        var i: USize = 0
        while i < count do
          if _cx < _cur_line_len() then
            _delete_char_at_cursor()
          end
          i = i + 1
        end
        _clamp_cursor()
        _dot_stop()
      end
    | 'X' =>
      if _cx > 0 then
        _save_undo()
        _dot_start('X')
        var i: USize = 0
        while (i < count) and (_cx > 0) do
          _cx = _cx - 1
          _delete_char_at_cursor()
          i = i + 1
        end
        _dot_stop()
      end
    | 'D' =>
      if _cur_line_len() > 0 then
        _save_undo()
        _dot_start('D')
        let l = try _buf.lines(_cy)? else return end
        _yank_lines.clear()
        _yank_lines.push(l.substring(_cx.isize()).clone())
        _yank_is_line = false
        l.truncate(_cx)
        _buf.dirty = true
        _clamp_cursor()
        _dot_stop()
      end
    | 'C' =>
      _save_undo()
      _dot_start('C')
      let l = try _buf.lines(_cy)? else return end
      l.truncate(_cx)
      _buf.dirty = true
      _mode = ModeInsert
    | 'S' =>
      _save_undo()
      _dot_start('S')
      try _buf.lines(_cy)?.clear() end
      _buf.dirty = true
      _cx = 0
      _mode = ModeInsert
    | 'J' =>
      _dot_start('J')
      _join_line()
      _dot_stop()
    | 'r' =>
      _pending = 'r'
      _count = count
      return
    | 'Z' =>
      _pending = 'Z'
      return
    // Operators
    | '"' =>
      _pending_register = true
      return
    | 'd' =>
      _operator = 'd'
      _op_count = count
      _dot_start('d')
      return
    | 'y' =>
      _operator = 'y'
      _op_count = count
      _dot_start('y')
      return
    | 'c' =>
      _operator = 'c'
      _op_count = count
      _dot_start('c')
      return
    | '>' =>
      _operator = '>'
      _op_count = count
      _dot_start('>')
      return
    | '<' =>
      _operator = '<'
      _op_count = count
      _dot_start('<')
      return
    | 'g' =>
      _pending = 'g'
      _count = count
      return
    | 'm' =>
      _pending = 'm'
      return
    | '\'' =>
      _pending = '\''
      return
    // Paste
    | 'p' =>
      _save_undo()
      _dot_start('p')
      _paste_after()
      _dot_stop()
    | 'P' =>
      _save_undo()
      _dot_start('P')
      _paste_before()
      _dot_stop()
    // Undo / redo
    | 'u' =>
      _undo()
    | 0x12 =>  // Ctrl-R
      _redo()
    | '~' =>
      if _cur_line_len() > 0 then
        _save_undo()
        _dot_start('~')
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
        _dot_stop()
      end
    // Dot repeat
    | '.' =>
      _dot_replay()
    // Page movement
    | 0x06 =>  // Ctrl-F
      _move_down(_rows)
    | 0x02 =>  // Ctrl-B
      _move_up(_rows)
    | 0x04 =>  // Ctrl-D
      _move_down(_rows / 2)
    | 0x15 =>  // Ctrl-U
      _move_up(_rows / 2)
    | 0x0C =>  // Ctrl-L
      None
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

    // Reset register selection after each command
    _current_register = 0

  // ── Key handling: Insert mode ──

  fun ref insert_key(ch: U8) =>
    _dot_record(ch)
    match ch
    | 0x1B =>  // Escape
      _mode = ModeNormal
      if _cx > 0 then _cx = _cx - 1 end
      _clamp_cursor()
      _dot_stop()
    | 0x03 =>  // Ctrl-C
      _mode = ModeNormal
      if _cx > 0 then _cx = _cx - 1 end
      _clamp_cursor()
      _dot_stop()
    | 0x0D | 0x0A =>  // Enter (CR or LF)
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

  // ── Key handling: Visual mode ──

  fun ref visual_key(ch: U8) =>
    // Count prefix in visual mode
    if (ch >= '1') and (ch <= '9') then
      _count = (_count * 10) + (ch - '0').usize()
      return
    end
    if (ch == '0') and (_count > 0) then
      _count = _count * 10
      return
    end

    let count = if _count > 0 then _count else 1 end
    _count = 0

    // Text object pending
    if _pending_textobj != 0 then
      let which = _pending_textobj
      _pending_textobj = 0
      (let sx, let sy, let ex, let ey) = _find_text_object(which, ch)
      _sel_sx = sx; _sel_sy = sy
      _cx = ex; _cy = ey
      _clamp_cursor()
      return
    end

    match ch
    | 0x1B =>  // Escape
      _mode = ModeNormal
      _set_message("")
    | 0x03 =>  // Ctrl-C
      _mode = ModeNormal
    // Movement
    | 'h' => _move_left(count)
    | 'l' => _move_right(count)
    | 'j' => _move_down(count)
    | 'k' => _move_up(count)
    | 'w' => _move_word_forward(count)
    | 'b' => _move_word_backward(count)
    | 'e' => _move_word_end(count)
    | '0' => _move_to_line_start()
    | '$' => _move_to_line_end()
    | '^' => _move_to_first_nonblank()
    | 'G' =>
      _cy = _buf.line_count() - 1
      _clamp_cursor()
    | 'g' =>
      _pending = 'g'
      _count = count
      return
    // Text objects
    | 'i' =>
      _pending_textobj = 'i'
      return
    | 'a' =>
      _pending_textobj = 'a'
      return
    // Toggle visual modes
    | 'v' =>
      match _mode
      | ModeVisual => _mode = ModeNormal
      | ModeVisualLine =>
        _mode = ModeVisual
        _sel_sx = _cx
      end
    | 'V' =>
      match _mode
      | ModeVisualLine => _mode = ModeNormal
      | ModeVisual =>
        _mode = ModeVisualLine
        _sel_sx = 0
      end
    // Operations on selection
    | 'd' | 'x' =>
      (let sx, let sy, let ex, let ey) = _visual_range()
      let is_line = match _mode | ModeVisualLine => true else false end
      _save_undo()
      _yank_range(sx, sy, ex, ey, is_line)
      if is_line then
        var i = ey
        while i >= sy do
          if _buf.line_count() > 1 then _buf.delete_line(i) end
          if i == 0 then break end
          i = i - 1
        end
        if _buf.line_count() == 0 then _buf.lines.push(String) end
      else
        _buf.delete_range(sy, sx, ey, ex)
      end
      _cy = sy; _cx = sx
      _clamp_cursor()
      _mode = ModeNormal
    | 'y' =>
      (let sx, let sy, let ex, let ey) = _visual_range()
      let is_line = match _mode | ModeVisualLine => true else false end
      _yank_range(sx, sy, ex, ey, is_line)
      _cy = sy; _cx = sx
      _mode = ModeNormal
      let n_lines = (ey - sy) + 1
      if n_lines > 1 then
        let msg = String
        msg.append(n_lines.string())
        msg.append(" lines yanked")
        _set_message(msg.clone())
      end
    | 'c' =>
      (let sx, let sy, let ex, let ey) = _visual_range()
      let is_line = match _mode | ModeVisualLine => true else false end
      _save_undo()
      _yank_range(sx, sy, ex, ey, is_line)
      if is_line then
        var i = ey
        while i >= sy do
          if _buf.line_count() > 1 then _buf.delete_line(i) end
          if i == 0 then break end
          i = i - 1
        end
        if _buf.line_count() == 0 then _buf.lines.push(String) end
        _buf.insert_line(sy, "")
        _cy = sy; _cx = 0
      else
        _buf.delete_range(sy, sx, ey, ex)
        _cy = sy; _cx = sx
      end
      _mode = ModeInsert
    | '>' =>
      (let sx, let sy, let ex, let ey) = _visual_range()
      _save_undo()
      _buf.indent_lines(sy, ey)
      _cy = sy
      _move_to_first_nonblank()
      _mode = ModeNormal
    | '<' =>
      (let sx, let sy, let ex, let ey) = _visual_range()
      _save_undo()
      _buf.outdent_lines(sy, ey)
      _cy = sy
      _move_to_first_nonblank()
      _mode = ModeNormal
    | 'J' =>
      (let sx, let sy, let ex, let ey) = _visual_range()
      _save_undo()
      var r = sy
      while r < ey do
        _cy = r
        _join_line()
        r = r + 1
      end
      _mode = ModeNormal
    | '~' =>
      (let sx, let sy, let ex, let ey) = _visual_range()
      _save_undo()
      var r = sy
      while r <= ey do
        let l = try _buf.lines(r)? else r = r + 1; continue end
        let cs = if r == sy then sx else 0 end
        let ce = if r == ey then ex.min(l.size() - 1) else l.size() - 1 end
        var c = cs
        while c <= ce do
          try
            let b = l(c)?
            if (b >= 'a') and (b <= 'z') then l.update(c, b - 32)?
            elseif (b >= 'A') and (b <= 'Z') then l.update(c, b + 32)?
            end
          end
          c = c + 1
        end
        r = r + 1
      end
      _buf.dirty = true
      _mode = ModeNormal
    end

  // ── Key handling: Command mode ──

  fun ref command_key(ch: U8) =>
    match ch
    | 0x1B =>
      _mode = ModeNormal
      _cmd_buf.clear()
    | 0x03 =>
      _mode = ModeNormal
      _cmd_buf.clear()
    | 0x0D | 0x0A =>  // Enter (CR or LF)
      try _execute_command()?
      else
        _set_message("Invalid command")
      end
      _mode = ModeNormal
    | 0x7F =>
      if _cmd_buf.size() > 0 then
        try _cmd_buf.pop()? end
      else
        _mode = ModeNormal
      end
    | 0x08 =>
      if _cmd_buf.size() > 0 then
        try _cmd_buf.pop()? end
      else
        _mode = ModeNormal
      end
    | if (ch >= 0x20) and (ch < 0x7F) =>
      _cmd_buf.push(ch)
    end

  // ── Key handling: Search mode ──

  fun ref search_key(ch: U8) =>
    match ch
    | 0x1B =>
      _mode = ModeNormal
      _search_buf.clear()
    | 0x03 =>
      _mode = ModeNormal
      _search_buf.clear()
    | 0x0D | 0x0A =>  // Enter (CR or LF)
      _mode = ModeNormal
      if _search_buf.size() > 0 then
        _search_next(_search_dir)
      end
    | 0x7F =>
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

  // ── Commands ──

  fun ref _execute_command() ? =>
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
      _lang = SyntaxDetect(fname)
      _hl_bc_state.clear()
      _cx = 0
      _cy = 0
      _row_off = 0
      _col_off = 0
      let msg = String
      msg.append("\"")
      msg.append(fname)
      msg.append("\" ")
      msg.append(_buf.line_count().string())
      if _buf.line_count() == 1 then
        msg.append(" line")
      else
        msg.append(" lines")
      end
      _set_message(msg.clone())
    elseif (cmd.size() > 2) and (cmd(0)? == 's') and (cmd(1)? == '/') then
      // :s/pat/rep/ or :s/pat/rep/g
      _substitute(cmd)?
    elseif (cmd.size() > 3) and _has_substitute(cmd) then
      // :%s/pat/rep/g or :.,$s/pat/rep/g
      _substitute(cmd)?
    elseif cmd == "set" then
      _set_message("Options: relativenumber, norelativenumber, tabstop=N, shiftwidth=N, expandtab, noexpandtab")
    elseif cmd == "set relativenumber" then
      _relativenum = true
      _set_message("relativenumber")
    elseif cmd == "set norelativenumber" then
      _relativenum = false
      _set_message("norelativenumber")
    elseif cmd == "set expandtab" then
      _expandtab = true
      _set_message("expandtab")
    elseif cmd == "set noexpandtab" then
      _expandtab = false
      _set_message("noexpandtab")
    elseif (cmd.size() > 9) and (cmd.substring(0, 9) == "set tabstop") then
      try
        _tab_stop = cmd.substring(9).usize()?
        _set_message("tabstop=" + _tab_stop.string())
      else
        _set_message("Usage: :set tabstop=N")
      end
    elseif (cmd.size() > 12) and (cmd.substring(0, 12) == "set shiftwidth") then
      try
        _shift_width = cmd.substring(12).usize()?
        _set_message("shiftwidth=" + _shift_width.string())
      else
        _set_message("Usage: :set shiftwidth=N")
      end
    elseif cmd == "set nonumber" then
      _set_message("number (gutter always shown)")
    else
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
      if _buf.line_count() == 1 then
        sm.append(" line written")
      else
        sm.append(" lines written")
      end
      _set_message(sm.clone())
      _git_dirty = false
      true
    else
      _set_message("Error writing file")
      false
    end

  fun _has_substitute(cmd: String box): Bool =>
    """Check if command contains 's/' pattern (for :%s, :.,$s, etc.)."""
    var i: USize = 0
    while i < cmd.size() do
      if (try cmd(i)? else 0 end) == 's' then
        if (i + 1) < cmd.size() then
          if (try cmd(i + 1)? else 0 end) == '/' then return true end
        end
      end
      i = i + 1
    end
    false

  fun ref _substitute(cmd: String box) ? =>
    """
    Parse and execute substitute command.
    Supports: :s/pat/rep/, :s/pat/rep/g, :%s/pat/rep/g, :.,$s/pat/rep/g
    Uses literal string matching (no regex).
    """
    // Find the 's/' to get the range prefix
    var s_pos: USize = 0
    while s_pos < cmd.size() do
      if (try cmd(s_pos)? else 0 end) == 's' then break end
      s_pos = s_pos + 1
    end
    if s_pos >= cmd.size() then return end

    // Parse range
    var start_line: USize = _cy
    var end_line: USize = _cy
    var range_set = false

    if s_pos > 0 then
      let prefix_iso = cmd.substring(0, s_pos.isize())
      let prefix: String val = consume prefix_iso
      if prefix == "%" then
        start_line = 0
        end_line = _buf.line_count() - 1
        range_set = true
      else
        // Try to parse as line number or . or .,$
        if prefix == "." then
          start_line = _cy
          end_line = _cy
          range_set = true
        elseif (prefix.size() > 2) and (prefix(0)? == '.') and (prefix(1)? == ',') then
          let rest_iso = prefix.substring(2)
          let rest: String val = consume rest_iso
          start_line = _cy
          if rest == "$" then
            end_line = _buf.line_count() - 1
          else
            try
              end_line = ((rest.usize()?) - 1).min(_buf.line_count() - 1)
            else
              _set_message("Invalid range")
              return
            end
          end
          range_set = true
        else
          try
            let ln = (prefix.usize()?) - 1
            start_line = ln.min(_buf.line_count() - 1)
            end_line = start_line
            range_set = true
          else
            _set_message("Invalid range")
            return
          end
        end
      end
    end

    if not range_set then
      start_line = _cy
      end_line = _cy
    end

    // Parse s/pat/rep/flags
    if (s_pos + 1) >= cmd.size() then return end
    let delim = try cmd(s_pos + 1)? else return end

    // Find pattern end
    var p_start = s_pos + 2
    var p_end = p_start
    while p_end < cmd.size() do
      if (try cmd(p_end)? else 0 end) == delim then break end
      p_end = p_end + 1
    end
    if p_end >= cmd.size() then return end

    let pat_iso = cmd.substring(p_start.isize(), p_end.isize())
    let pat: String val = consume pat_iso

    // Find replacement end
    var r_start = p_end + 1
    var r_end = r_start
    while r_end < cmd.size() do
      if (try cmd(r_end)? else 0 end) == delim then break end
      r_end = r_end + 1
    end

    let rep_iso = cmd.substring(r_start.isize(), r_end.isize())
    let rep: String val = consume rep_iso

    // Parse flags (g for global)
    var global = false
    var f_pos = r_end + 1
    while f_pos < cmd.size() do
      if (try cmd(f_pos)? else 0 end) == 'g' then global = true end
      f_pos = f_pos + 1
    end

    // Execute substitution
    var total_replaced: USize = 0
    var r = start_line
    while r <= end_line.min(_buf.line_count() - 1) do
      let l = try _buf.lines(r)? else r = r + 1; continue end
      if pat.size() == 0 then r = r + 1; continue end

      var offset: USize = 0
      while true do
        try
          let idx = l.find(pat where offset = offset.isize())?
          l.delete(idx, pat.size())
          l.insert(idx, rep)
          total_replaced = total_replaced + 1
          if global then
            offset = idx.usize() + rep.size()
            if offset >= l.size() then break end
          else
            break
          end
        else
          break
        end
      end
      r = r + 1
    end

    let msg = String
    msg.append(total_replaced.string())
    msg.append(if total_replaced == 1 then " substitution" else " substitutions" end)
    _set_message(msg.clone())
    _buf.dirty = true

  fun ref _paste_after() =>
    let reg = try _registers(_current_register)? else return end
    let is_line = try _register_is_line(_current_register)? else false end
    if reg.size() == 0 then return end
    if is_line then
      for (i, l) in reg.pairs() do
        _buf.insert_line(_cy + i, l.clone())
      end
      _cx = 0
      _move_to_first_nonblank()
    else
      try
        let text = reg(0)?
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

  fun ref _paste_before() =>
    let reg = try _registers(_current_register)? else return end
    let is_line = try _register_is_line(_current_register)? else false end
    if reg.size() == 0 then return end
    if is_line then
      for (i, l) in reg.pairs() do
        _buf.insert_line(_cy + i, l.clone())
      end
      _cx = 0
      _move_to_first_nonblank()
    else
      try
        let text = reg(0)?
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

  // ── Main key dispatch ──

  fun ref key_press(ch: U8): Bool =>
    """Returns true if quit was triggered."""
    _quitting = false
    match _mode
    | ModeNormal => normal_key(ch)
    | ModeInsert => insert_key(ch)
    | ModeCommand => command_key(ch)
    | ModeSearch => search_key(ch)
    | ModeVisual => visual_key(ch)
    | ModeVisualLine => visual_key(ch)
    end
    _quitting

  fun ref is_quitting(): Bool => _quitting

  fun ref arrow_up() =>
    match _mode
    | ModeNormal => _move_up(if _count > 0 then _count else 1 end)
    | ModeInsert => _move_up()
    | ModeVisual => _move_up(if _count > 0 then _count else 1 end)
    | ModeVisualLine => _move_up(if _count > 0 then _count else 1 end)
    end
    _count = 0

  fun ref arrow_down() =>
    match _mode
    | ModeNormal => _move_down(if _count > 0 then _count else 1 end)
    | ModeInsert => _move_down()
    | ModeVisual => _move_down(if _count > 0 then _count else 1 end)
    | ModeVisualLine => _move_down(if _count > 0 then _count else 1 end)
    end
    _count = 0

  fun ref arrow_left() =>
    match _mode
    | ModeNormal => _move_left(if _count > 0 then _count else 1 end)
    | ModeInsert => _move_left()
    | ModeVisual => _move_left(if _count > 0 then _count else 1 end)
    | ModeVisualLine => _move_left(if _count > 0 then _count else 1 end)
    end
    _count = 0

  fun ref arrow_right() =>
    match _mode
    | ModeNormal => _move_right(if _count > 0 then _count else 1 end)
    | ModeInsert => _move_right()
    | ModeVisual => _move_right(if _count > 0 then _count else 1 end)
    | ModeVisualLine => _move_right(if _count > 0 then _count else 1 end)
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

  fun _scrolloff(): USize =>
    USize(5).min(_rows / 2)

  fun ref scroll_up() =>
    """Scroll viewport up 3 lines (mouse wheel)."""
    if _row_off >= 3 then
      _row_off = _row_off - 3
    else
      _row_off = 0
    end
    let so = _scrolloff()
    if _cy >= ((_row_off + _rows) - so) then
      _cy = (((_row_off + _rows) - so) - 1).max(_row_off)
      _clamp_cursor()
    end

  fun ref scroll_down() =>
    """Scroll viewport down 3 lines (mouse wheel)."""
    let max_off = if _buf.line_count() > _rows then
      _buf.line_count() - _rows
    else
      0
    end
    _row_off = (_row_off + 3).min(max_off)
    let so = _scrolloff()
    if _cy < (_row_off + so) then
      _cy = (_row_off + so).min(_buf.line_count() - 1)
      _clamp_cursor()
    end

  // ── Rendering ──

  fun ref render() =>
    if _msg_transient and (_message.size() > 0) then
      if (_now_seconds() - _msg_time) >= 5 then
        _message = ""
        _msg_transient = false
      end
    end

    _scroll()
    let out = String((_rows + 2) * _cols * 2)
    out.append("\x1B[?25l")
    out.append("\x1B[H")

    let gw = _gutter_width()
    var screen_row: USize = 0
    while screen_row < _rows do
      let file_row = screen_row + _row_off
      if file_row < _buf.line_count() then
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
      out.append("\x1B[K")
      out.append("\r\n")
      screen_row = screen_row + 1
    end

    _draw_status_bar(out)
    out.append("\r\n")

    _draw_command_line(out)
    out.append("\x1B[K")

    let cursor_row = (_cy - _row_off) + 1
    let cursor_col = (_rx - _col_off) + _gutter_cols() + 1
    out.append("\x1B[")
    out.append(cursor_row.string())
    out.push(';')
    out.append(cursor_col.string())
    out.push('H')

    out.append("\x1B[?25h")

    ifdef posix then
      @write(1, out.cpointer(), out.size())
    end

  fun ref _get_block_comment_state(file_row: USize): Bool =>
    """Get whether this row starts inside a block comment."""
    // Ensure hl_bc_state is big enough
    while _hl_bc_state.size() <= file_row do
      _hl_bc_state.push(false)
    end
    if file_row == 0 then return false end
    try _hl_bc_state(file_row)? else false end

  fun ref _update_hl_state(file_row: USize, in_bc: Bool) =>
    """Store block comment state for the next row."""
    let next = file_row + 1
    while _hl_bc_state.size() <= next do
      _hl_bc_state.push(false)
    end
    try _hl_bc_state.update(next, in_bc)? end

  fun _hl_color(tok: HlToken): String =>
    match tok
    | HlKeyword => "\x1B[1;33m"   // bold yellow
    | HlType    => "\x1B[36m"     // cyan
    | HlString  => "\x1B[32m"     // green
    | HlComment => "\x1B[90m"     // bright black (grey)
    | HlNumber  => "\x1B[35m"     // magenta
    | HlPreproc => "\x1B[33m"     // yellow
    else "" end

  fun ref _draw_line(out: String ref, file_row: USize) =>
    let l = _buf.line(file_row)
    var col: USize = 0
    var rx: USize = 0
    let tc = _text_cols()
    let is_visual = match _mode
    | ModeVisual => true
    | ModeVisualLine => true
    else false end

    // Compute syntax tokens for this line
    let in_bc = _get_block_comment_state(file_row)
    (let tokens, let out_bc) = Syntax.highlight_line(l, _lang, in_bc)
    _update_hl_state(file_row, out_bc)

    var prev_tok: HlToken = HlNormal
    var in_sel: Bool = false

    while col < l.size() do
      let ch = try l(col)? else ' ' end
      let visible = (rx >= _col_off) and (rx < (_col_off + tc))

      // Get token for this position
      let tok: HlToken = try tokens(col)? else HlNormal end

      if visible then
        // Handle visual selection start
        if is_visual then
          let sel = _in_selection(file_row, col)
          if sel and (not in_sel) then
            out.append("\x1B[7m")
            in_sel = true
          elseif (not sel) and in_sel then
            out.append("\x1B[27m")
            in_sel = false
          end
        end

        // Emit color change if token changed
        if (tok isnt prev_tok) then
          if tok is HlNormal then
            out.append("\x1B[39;22m")  // reset fg + bold
          else
            out.append(_hl_color(tok))
          end
          prev_tok = tok
        end
      end

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
        if visible then
          out.push(ch)
        end
        rx = rx + 1
      end

      col = col + 1
    end

    // Reset any lingering attributes
    if (prev_tok isnt HlNormal) or in_sel then
      out.append("\x1B[m")
    end

  fun _draw_gutter(out: String ref, line_num: USize) =>
    let gw = _gutter_width()
    let num_str: String val = if _relativenum then
      if line_num == (_cy + 1) then
        (_cy.string()).clone()
      else
        let diff: USize = if line_num > (_cy + 1) then
          line_num - (_cy + 1)
        else
          (_cy + 1) - line_num
        end
        (diff.string()).clone()
      end
    else
      (line_num.string()).clone()
    end
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
    out.append("\x1B[7m")

    let mode_str = match _mode
    | ModeNormal => " NORMAL "
    | ModeInsert => " INSERT "
    | ModeCommand => " COMMAND "
    | ModeSearch => " SEARCH "
    | ModeVisual => " VISUAL "
    | ModeVisualLine => " V-LINE "
    end

    let fname: String val = if _buf.filename.size() > 0 then
      _buf.filename.clone()
    else
      "[No Name]".clone()
    end
    let modified: String val = if _buf.dirty then " [+]".clone() else "".clone() end
    let git_info: String val = if _git_branch.size() > 0 then
      let s = String
      s.append(" (")
      s.append(_git_branch)
      if _git_dirty then s.append("*") end
      s.append(")")
      s.clone()
    else
      "".clone()
    end

    let left = String
    left.append(mode_str)
    left.append(fname)
    left.append(modified)
    left.append(git_info)

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
    out.append("\x1B[m")

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

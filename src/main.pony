use "term"
use "files"

use @tcgetattr[I32](fd: I32, termios: Pointer[U8] tag) if posix
use @tcsetattr[I32](fd: I32, action: I32, termios: Pointer[U8] tag) if posix
use @cfmakeraw[None](termios: Pointer[U8] tag) if posix
use @exit[None](status: I32) if posix

actor Main
  let _env: Env
  let _term: ANSITerm tag
  embed _orig_termios: Array[U8] = Array[U8].init(0, 256)

  new create(env: Env) =>
    _env = env

    // Enter raw mode
    ifdef posix then
      @tcgetattr(0, _orig_termios.cpointer())
      let raw = Array[U8].init(0, 256)
      @tcgetattr(0, raw.cpointer())
      @cfmakeraw(raw.cpointer())
      @tcsetattr(0, 0, raw.cpointer())
    end

    // Switch to alternate screen buffer (prevents terminal scrollback corruption)
    ifdef posix then
      let alt_screen = "\x1B[?1049h"
      @write(1, alt_screen.cpointer(), alt_screen.size())
    end

    // Enable SGR mouse mode (scroll wheel + click tracking)
    ifdef posix then
      let mouse_on = "\x1B[?1000h\x1B[?1006h"
      @write(1, mouse_on.cpointer(), mouse_on.size())
    end

    // Enable bracketed-paste mode (?2004). The terminal wraps pasted text in
    // \e[200~ ... \e[201~ markers so we can suppress auto-pair on paste.
    ifdef posix then
      let paste_on = "\x1B[?2004h"
      @write(1, paste_on.cpointer(), paste_on.size())
    end

    let filename: String val = try env.args(1)? else "" end

    let main_tag: Main tag = this

    let editor = TimerRender(env, filename, main_tag)
    let term = ANSITerm(
      recover iso EditorNotify(editor) end,
      env.input)
    _term = term

    // Connect stdin — intercept mouse sequences before ANSITerm
    env.input(
      recover iso MouseInputNotify(term, editor) end,
      512)

    // Initial render (TimerRender.create renders immediately)

  be quit() =>
    // Disable bracketed paste and mouse modes
    ifdef posix then
      let paste_off = "\x1B[?2004l"
      @write(1, paste_off.cpointer(), paste_off.size())
    end
    ifdef posix then
      let mouse_off = "\x1B[?1006l\x1B[?1000l"
      @write(1, mouse_off.cpointer(), mouse_off.size())
    end
    ifdef posix then
      @tcsetattr(0, 0, _orig_termios.cpointer())
    end
    ifdef posix then
      // Switch back to main screen buffer and clear
      let restore = "\x1B[?1049l\x1B[2J\x1B[H"
      @write(1, restore.cpointer(), restore.size())
    end
    _term.dispose()
    ifdef posix then
      @exit(0)
    end


actor TimerRender
  let _editor: Editor
  let _main: Main tag
  var _quit: Bool = false

  new create(env: Env, filename: String, main: Main tag) =>
    let self_tag: TimerRender tag = this
    _editor = Editor(env, filename, {() => self_tag.quit() })
    _main = main
    // Initial render
    _editor.render()

  be quit() =>
    _quit = true
    _main.quit()

  be key_press(ch: U8) =>
    if not _editor.key_press(ch) then
      _editor.render()
    end

  be arrow_up() =>
    _editor.arrow_up()
    _editor.render()

  be arrow_down() =>
    _editor.arrow_down()
    _editor.render()

  be arrow_left() =>
    _editor.arrow_left()
    _editor.render()

  be arrow_right() =>
    _editor.arrow_right()
    _editor.render()

  be delete_key() =>
    _editor.delete_key()
    _editor.render()

  be home_key() =>
    _editor.home_key()
    _editor.render()

  be end_key() =>
    _editor.end_key()
    _editor.render()

  be page_up() =>
    _editor.page_up()
    _editor.render()

  be page_down() =>
    _editor.page_down()
    _editor.render()

  be scroll_up() =>
    _editor.scroll_up()
    _editor.render()

  be scroll_down() =>
    _editor.scroll_down()
    _editor.render()

  be set_size(rows: USize, cols: USize) =>
    _editor.set_size(rows, cols)

  be begin_paste() =>
    _editor.begin_paste()

  be end_paste() =>
    _editor.end_paste()
    _editor.render()

  be paste_byte(b: U8) =>
    // Insert without rendering — renders fire on end_paste so a 10kB paste
    // doesn't trigger 10k repaints.
    _editor.key_press(b)


class EditorNotify is ANSINotify
  let _editor: TimerRender tag

  new iso create(editor: TimerRender tag) =>
    _editor = editor

  fun ref apply(term: ANSITerm ref, input: U8) =>
    _editor.key_press(input)

  fun ref up(ctrl: Bool, alt: Bool, shift: Bool) =>
    _editor.arrow_up()

  fun ref down(ctrl: Bool, alt: Bool, shift: Bool) =>
    _editor.arrow_down()

  fun ref left(ctrl: Bool, alt: Bool, shift: Bool) =>
    _editor.arrow_left()

  fun ref right(ctrl: Bool, alt: Bool, shift: Bool) =>
    _editor.arrow_right()

  fun ref delete(ctrl: Bool, alt: Bool, shift: Bool) =>
    _editor.delete_key()

  fun ref home(ctrl: Bool, alt: Bool, shift: Bool) =>
    _editor.home_key()

  fun ref end_key(ctrl: Bool, alt: Bool, shift: Bool) =>
    _editor.end_key()

  fun ref page_up(ctrl: Bool, alt: Bool, shift: Bool) =>
    _editor.page_up()

  fun ref page_down(ctrl: Bool, alt: Bool, shift: Bool) =>
    _editor.page_down()

  fun ref size(rows: U16, cols: U16) =>
    _editor.set_size(rows.usize(), cols.usize())

  fun ref closed() =>
    None

class MouseInputNotify is InputNotify
  """
  Intercepts mouse escape sequences for scroll wheel support and routes
  bracketed-paste markers (\e[200~ / \e[201~) so paste content bypasses
  auto-pair. Non-mouse / non-paste-marker input is forwarded to ANSITerm
  for normal key handling.
  """
  let _t: ANSITerm tag
  let _e: TimerRender tag
  var _in_mouse: Bool = false
  embed _mouse_buf: String ref = String
  let _paste: PasteState ref = PasteState

  new create(t: ANSITerm tag, e: TimerRender tag) =>
    _t = t
    _e = e

  fun ref apply(data: Array[U8] iso) =>
    let non_paste = recover iso Array[U8] end
    var i: USize = 0
    let d: Array[U8] ref = consume ref data

    // Pass 1: strip mouse sequences (their bytes never look like paste markers).
    while i < d.size() do
      if _in_mouse then
        let ch = try d(i)? else i = i + 1; continue end
        _mouse_buf.push(ch)
        if (ch == 'M') or (ch == 'm') then
          _parse_mouse()
          _in_mouse = false
          _mouse_buf.clear()
        end
        i = i + 1
      elseif _check_mouse_start(d, i) then
        _in_mouse = true
        _mouse_buf.clear()
        i = i + 3
      else
        try non_paste.push(d(i)?) end
        i = i + 1
      end
    end

    // Pass 2: feed remaining bytes through the bracketed-paste tracker.
    if non_paste.size() == 0 then return end
    let bytes: Array[U8] val = consume non_paste
    let events = _paste.feed(bytes)
    let key_bytes = recover iso Array[U8] end
    for ev in events.values() do
      match ev.kind
      | PasteEventStart => _e.begin_paste()
      | PasteEventEnd => _e.end_paste()
      | PasteEventKey => key_bytes.push(ev.byte)
      | PasteEventContent => _e.paste_byte(ev.byte)
      end
    end
    if key_bytes.size() > 0 then
      _t(consume key_bytes)
    end

  fun _check_mouse_start(d: Array[U8] ref, i: USize): Bool =>
    if (i + 2) >= d.size() then return false end
    try
      (d(i)? == 0x1B) and (d(i + 1)? == '[') and (d(i + 2)? == '<')
    else
      false
    end

  fun ref _parse_mouse() =>
    if _mouse_buf.size() < 4 then return end
    let params_iso = _mouse_buf.substring(0, (_mouse_buf.size() - 1).isize())
    let params: String val = consume params_iso
    var parts = Array[String val](3)
    var start: USize = 0
    var j: USize = 0
    while j < params.size() do
      if (try params(j)? else 0 end) == ';' then
        let p_iso = params.substring(start.isize(), j.isize())
        let p: String val = consume p_iso
        parts.push(p)
        start = j + 1
      end
      j = j + 1
    end
    let last_iso = params.substring(start.isize())
    let last: String val = consume last_iso
    parts.push(last)

    if parts.size() < 3 then return end
    try
      let button = parts(0)?.usize()?
      if button == 64 then
        _e.scroll_up()
      elseif button == 65 then
        _e.scroll_down()
      end
    end

  fun ref dispose() =>
    _t.dispose()

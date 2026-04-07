use "term"
use "files"
use "time"

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
      // Re-enable output processing so \n works properly as \r\n
      // c_oflag is at offset 4, OPOST = 1
      // Actually, we'll handle \r\n ourselves in rendering
      @tcsetattr(0, 0, raw.cpointer())
    end

    let filename: String val = try env.args(1)? else "" end

    let main_tag: Main tag = this

    let editor = TimerRender(env, filename, main_tag)
    let term = ANSITerm(
      recover iso EditorNotify(editor) end,
      env.input)
    _term = term

    // Connect stdin to ANSITerm
    env.input(
      object iso is InputNotify
        let _t: ANSITerm tag = term

        fun ref apply(data: Array[U8] iso) =>
          _t(consume data)

        fun ref dispose() =>
          _t.dispose()
      end,
      32)

    // Start the periodic timer
    editor.start_timer()

  be quit() =>
    ifdef posix then
      @tcsetattr(0, 0, _orig_termios.cpointer())
    end
    ifdef posix then
      let clear = "\x1B[2J\x1B[H"
      @write(1, clear.cpointer(), clear.size())
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

  be start_timer() =>
    let t: Timer iso = Timer(recover iso RenderTimerNotify(this) end, 1_000_000_000, 1_000_000_000)
    let timers = Timers
    timers(consume t)

  be render_only() =>
    if not _quit and not _editor.is_quitting() then
      _editor.render()
    end

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

  be set_size(rows: USize, cols: USize) =>
    _editor.set_size(rows, cols)


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

class RenderTimerNotify is TimerNotify
  let _actor: TimerRender tag

  new iso create(editor_actor: TimerRender tag) =>
    _actor = editor_actor

  fun ref apply(timer: Timer ref, count: U64): Bool =>
    _actor.render_only()
    true

  fun ref final(timer: Timer ref) =>
    None

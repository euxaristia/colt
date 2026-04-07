use "term"
use "files"

use @tcgetattr[I32](fd: I32, termios: Pointer[U8] tag) if posix
use @tcsetattr[I32](fd: I32, action: I32, termios: Pointer[U8] tag) if posix
use @cfmakeraw[None](termios: Pointer[U8] tag) if posix

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
    let quit_fn: {()} val = {() => main_tag.quit() }

    let term = ANSITerm(
      recover iso EditorNotify(env, filename, quit_fn) end,
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

  be quit() =>
    ifdef posix then
      @tcsetattr(0, 0, _orig_termios.cpointer())
    end
    // Clear screen and move cursor home
    _env.out.write("\x1B[2J\x1B[H")
    _term.dispose()
    _env.exitcode(0)


class EditorNotify is ANSINotify
  let _editor: Editor

  new iso create(env: Env, filename: String, quit_fn: {()} val) =>
    _editor = Editor(env, filename, quit_fn)

  fun ref apply(term: ANSITerm ref, input: U8) =>
    _editor.key_press(input)
    _editor.render()

  fun ref up(ctrl: Bool, alt: Bool, shift: Bool) =>
    _editor.arrow_up()
    _editor.render()

  fun ref down(ctrl: Bool, alt: Bool, shift: Bool) =>
    _editor.arrow_down()
    _editor.render()

  fun ref left(ctrl: Bool, alt: Bool, shift: Bool) =>
    _editor.arrow_left()
    _editor.render()

  fun ref right(ctrl: Bool, alt: Bool, shift: Bool) =>
    _editor.arrow_right()
    _editor.render()

  fun ref delete(ctrl: Bool, alt: Bool, shift: Bool) =>
    _editor.delete_key()
    _editor.render()

  fun ref home(ctrl: Bool, alt: Bool, shift: Bool) =>
    _editor.home_key()
    _editor.render()

  fun ref end_key(ctrl: Bool, alt: Bool, shift: Bool) =>
    _editor.end_key()
    _editor.render()

  fun ref page_up(ctrl: Bool, alt: Bool, shift: Bool) =>
    _editor.page_up()
    _editor.render()

  fun ref page_down(ctrl: Bool, alt: Bool, shift: Bool) =>
    _editor.page_down()
    _editor.render()

  fun ref size(rows: U16, cols: U16) =>
    _editor.set_size(rows.usize(), cols.usize())

  fun ref closed() =>
    None

use "pony_test"

primitive SR
  """Create a String ref for buffer insertion."""
  fun apply(str: String val): String ref =>
    let s: String ref = String
    var i: USize = 0
    while i < str.size() do
      try s.push(str(i)?) end
      i = i + 1
    end
    s

actor Main is TestList
  new create(env: Env) =>
    PonyTest(env, this)

  fun tag tests(test: PonyTest) =>
    test(recover iso TestBufferInsert end)
    test(recover iso TestBufferDeleteLine end)
    test(recover iso TestBufferSplitLine end)
    test(recover iso TestBufferJoinLines end)
    test(recover iso TestBufferDeleteRangeSame end)
    test(recover iso TestBufferDeleteRangeMulti end)
    test(recover iso TestBufferIndent end)
    test(recover iso TestBufferOutdent end)
    test(recover iso TestSyntaxHighlight end)
    test(recover iso TestLangDetect end)
    test(recover iso TestPasteStateRoundtrip end)
    test(recover iso TestPasteStateLoneEscReleases end)
    test(recover iso TestPasteStateNoFalseStart end)
    test(recover iso TestEditorPasteOpenParen end)
    test(recover iso TestEditorPasteParenWithText end)
    test(recover iso TestEditorTypingStillAutoPairs end)


class iso TestBufferInsert is UnitTest
  fun name(): String => "Buffer insert"
  fun apply(h: TestHelper) =>
    let buf = Buffer("")
    buf.lines.clear()
    buf.lines.push(SR("hello"))
    buf.lines.push(SR("world"))
    h.assert_eq[USize](buf.line_count(), 2)
    h.assert_true(buf.line(0) == "hello")
    h.assert_true(buf.line(1) == "world")

    buf.insert_char(0, 5, '!')
    h.assert_true(buf.line(0) == "hello!")
    h.assert_eq[USize](buf.line_len(0), 6)


class iso TestBufferDeleteLine is UnitTest
  fun name(): String => "Buffer delete line"
  fun apply(h: TestHelper) =>
    let buf = Buffer("")
    buf.lines.clear()
    buf.lines.push(SR("first"))
    buf.lines.push(SR("second"))
    buf.lines.push(SR("third"))

    let deleted = buf.delete_line(1)
    h.assert_true(deleted == "second")
    h.assert_eq[USize](buf.line_count(), 2)
    h.assert_true(buf.line(0) == "first")
    h.assert_true(buf.line(1) == "third")


class iso TestBufferSplitLine is UnitTest
  fun name(): String => "Buffer split line"
  fun apply(h: TestHelper) =>
    let buf = Buffer("")
    buf.lines.clear()
    buf.lines.push(SR("hello world"))

    buf.split_line(0, 5)
    h.assert_eq[USize](buf.line_count(), 2)
    h.assert_true(buf.line(0) == "hello")
    h.assert_true(buf.line(1) == " world")


class iso TestBufferJoinLines is UnitTest
  fun name(): String => "Buffer join lines"
  fun apply(h: TestHelper) =>
    let buf = Buffer("")
    buf.lines.clear()
    buf.lines.push(SR("hello"))
    buf.lines.push(SR(" world"))

    buf.join_lines(0)
    h.assert_eq[USize](buf.line_count(), 1)
    h.assert_true(buf.line(0) == "hello world")


class iso TestBufferDeleteRangeSame is UnitTest
  fun name(): String => "Buffer delete range same line"
  fun apply(h: TestHelper) =>
    let buf = Buffer("")
    buf.lines.clear()
    buf.lines.push(SR("hello world"))

    // Inclusive endpoints: cols 0..4 deletes "hello" (5 chars).
    buf.delete_range(0, 0, 0, 4)
    h.assert_true(buf.line(0) == " world")


class iso TestBufferDeleteRangeMulti is UnitTest
  fun name(): String => "Buffer delete range multi line"
  fun apply(h: TestHelper) =>
    let buf = Buffer("")
    buf.lines.clear()
    buf.lines.push(SR("hello"))
    buf.lines.push(SR("middle"))
    buf.lines.push(SR("world"))

    // Inclusive: delete from (0,3) through (2,2) — keeps "hel" + "ld".
    buf.delete_range(0, 3, 2, 2)
    h.assert_eq[USize](buf.line_count(), 1)
    h.assert_true(buf.line(0) == "helld")


class iso TestBufferIndent is UnitTest
  fun name(): String => "Buffer indent"
  fun apply(h: TestHelper) =>
    let buf = Buffer("")
    buf.lines.clear()
    buf.lines.push(SR("hello"))
    buf.lines.push(SR("world"))

    buf.indent_lines(0, 1)
    h.assert_true(buf.line(0) == "  hello")
    h.assert_true(buf.line(1) == "  world")


class iso TestBufferOutdent is UnitTest
  fun name(): String => "Buffer outdent"
  fun apply(h: TestHelper) =>
    let buf = Buffer("")
    buf.lines.clear()
    buf.lines.push(SR("  hello"))
    buf.lines.push(SR("  world"))

    buf.outdent_lines(0, 1)
    h.assert_true(buf.line(0) == "hello")
    h.assert_true(buf.line(1) == "world")


class iso TestSyntaxHighlight is UnitTest
  fun name(): String => "Syntax highlight line"
  fun apply(h: TestHelper) ? =>
    let lang = LangC
    h.assert_eq[String](lang.line_comment(), "//")
    h.assert_eq[String](lang.block_comment_start(), "/*")
    h.assert_eq[String](lang.block_comment_end(), "*/")
    h.assert_true(lang.is_keyword("return"))
    h.assert_false(lang.is_keyword("hello"))
    h.assert_true(lang.is_type("int"))
    h.assert_false(lang.is_type("foo"))

    let line = "int main() {"
    let result = Syntax.highlight_line(line, lang, false)
    let tokens = result._1
    let still_in_bc = result._2
    h.assert_false(still_in_bc)
    h.assert_true((tokens(0)? is HlType) or (tokens(0)? is HlKeyword))


class iso TestLangDetect is UnitTest
  fun name(): String => "Language detection"
  fun apply(h: TestHelper) =>
    h.assert_true((SyntaxDetect("hello.c") is LangC))
    h.assert_true((SyntaxDetect("main.rs") is LangRust))
    h.assert_true((SyntaxDetect("test.py") is LangPython))
    h.assert_true((SyntaxDetect("main.go") is LangGo))
    h.assert_true((SyntaxDetect("app.zig") is LangZig))
    h.assert_true((SyntaxDetect("lib.ha") is LangHare))
    h.assert_true((SyntaxDetect("app.pony") is LangPony))
    h.assert_true((SyntaxDetect("App.java") is LangJava))
    h.assert_true((SyntaxDetect("index.js") is LangJavaScript))
    h.assert_true((SyntaxDetect("app.ts") is LangTypeScript))
    h.assert_true((SyntaxDetect("README.md") is LangMarkdown))
    h.assert_true((SyntaxDetect("data.json") is LangJSON))
    h.assert_true((SyntaxDetect("config.yaml") is LangYAML))
    h.assert_true((SyntaxDetect("Cargo.toml") is LangTOML))
    h.assert_true((SyntaxDetect("script.lua") is LangLua))
    h.assert_true((SyntaxDetect("app.rb") is LangRuby))
    h.assert_true((SyntaxDetect("index.html") is LangHTML))
    h.assert_true((SyntaxDetect("style.css") is LangCSS))
    h.assert_true((SyntaxDetect("Makefile") is LangMakefile))
    h.assert_true((SyntaxDetect("unknown.xyz") is LangNone))


// ── Bracketed-paste regression tests ──
//
// Bug: typing or pasting "(" inserted "()" with the cursor between, so a
// pasted "(" gained a phantom ")". Fix routes paste content through a
// path that bypasses auto-pair while leaving normal typing untouched.

primitive PasteBytes
  """Build an Array[U8] from a string literal — convenience for tests."""
  fun apply(s: String): Array[U8] iso^ =>
    let out = recover iso Array[U8] end
    var i: USize = 0
    while i < s.size() do
      try out.push(s(i)?) end
      i = i + 1
    end
    consume out

class iso TestPasteStateRoundtrip is UnitTest
  fun name(): String => "PasteState classifies keys vs paste content"
  fun apply(h: TestHelper) =>
    let ps: PasteState ref = PasteState
    // "ab" then start-marker, "()", end-marker, then "z"
    let input = recover val
      let a = Array[U8]
      a.push('a'); a.push('b')
      a.push(0x1B); a.push('['); a.push('2'); a.push('0'); a.push('0'); a.push('~')
      a.push('('); a.push(')')
      a.push(0x1B); a.push('['); a.push('2'); a.push('0'); a.push('1'); a.push('~')
      a.push('z')
      a
    end
    let events = ps.feed(input)
    // Expected: 'a','b' as keys, Start, '(',')' as content, End, 'z' as key.
    h.assert_eq[USize](events.size(), 7)
    try
      let e0 = events(0)?; h.assert_true(e0.kind is PasteEventKey); h.assert_eq[U8](e0.byte, 'a')
      let e1 = events(1)?; h.assert_true(e1.kind is PasteEventKey); h.assert_eq[U8](e1.byte, 'b')
      let e2 = events(2)?; h.assert_true(e2.kind is PasteEventStart)
      let e3 = events(3)?; h.assert_true(e3.kind is PasteEventContent); h.assert_eq[U8](e3.byte, '(')
      let e4 = events(4)?; h.assert_true(e4.kind is PasteEventContent); h.assert_eq[U8](e4.byte, ')')
      let e5 = events(5)?; h.assert_true(e5.kind is PasteEventEnd)
      let e6 = events(6)?; h.assert_true(e6.kind is PasteEventKey); h.assert_eq[U8](e6.byte, 'z')
    end
    h.assert_false(ps.in_paste())

class iso TestPasteStateLoneEscReleases is UnitTest
  fun name(): String => "PasteState releases a lone ESC at end of feed"
  fun apply(h: TestHelper) =>
    // A standalone ESC keystroke must be emitted, not swallowed waiting
    // for a paste marker that will never come — otherwise pressing ESC
    // (to leave insert mode) appears to do nothing until the next key.
    let ps: PasteState ref = PasteState
    let input = recover val
      let a = Array[U8]
      a.push(0x1B)
      a
    end
    let events = ps.feed(input)
    h.assert_eq[USize](events.size(), 1)
    try
      let e0 = events(0)?
      h.assert_true(e0.kind is PasteEventKey)
      h.assert_eq[U8](e0.byte, 0x1B)
    end
    h.assert_false(ps.in_paste())

class iso TestPasteStateNoFalseStart is UnitTest
  fun name(): String => "PasteState replays held bytes when match fails"
  fun apply(h: TestHelper) =>
    let ps: PasteState ref = PasteState
    // \e[2 then 'q' — partial paste-start that fails. The held bytes
    // must come out as keystrokes (so e.g. real escape sequences for
    // arrow keys aren't swallowed).
    let input = recover val
      let a = Array[U8]
      a.push(0x1B); a.push('['); a.push('2'); a.push('q')
      a
    end
    let events = ps.feed(input)
    h.assert_eq[USize](events.size(), 4)
    try
      let k0 = events(0)?; h.assert_true(k0.kind is PasteEventKey); h.assert_eq[U8](k0.byte, 0x1B)
      let k1 = events(1)?; h.assert_eq[U8](k1.byte, '[')
      let k2 = events(2)?; h.assert_eq[U8](k2.byte, '2')
      let k3 = events(3)?; h.assert_eq[U8](k3.byte, 'q')
    end

class iso TestEditorPasteOpenParen is UnitTest
  fun name(): String => "Pasted ( does not get an auto-paired )"
  fun apply(h: TestHelper) =>
    let editor = Editor(h.env, "", {() => None})
    editor.key_press('i')  // enter insert mode
    h.assert_true(editor.mode_is_insert())

    editor.begin_paste()
    editor.key_press('(')
    editor.end_paste()

    // Bug: produces "()" with cursor between. Fix: produces "(".
    h.assert_eq[String](editor.current_line().clone(), "(")
    h.assert_eq[USize](editor.cursor_x(), 1)

class iso TestEditorPasteParenWithText is UnitTest
  fun name(): String => "Pasted (foo lands as (foo not (foo)"
  fun apply(h: TestHelper) =>
    let editor = Editor(h.env, "", {() => None})
    editor.key_press('i')

    editor.begin_paste()
    editor.key_press('(')
    editor.key_press('f')
    editor.key_press('o')
    editor.key_press('o')
    editor.end_paste()

    h.assert_eq[String](editor.current_line().clone(), "(foo")
    h.assert_eq[USize](editor.cursor_x(), 4)

class iso TestEditorTypingStillAutoPairs is UnitTest
  fun name(): String => "Typing ( outside paste still auto-pairs"
  fun apply(h: TestHelper) =>
    // Auto-pair is a feature for normal typing — we should only suppress
    // it during paste. Lock the typing behavior in so the fix doesn't
    // accidentally remove auto-pair entirely.
    let editor = Editor(h.env, "", {() => None})
    editor.key_press('i')

    editor.key_press('(')

    h.assert_eq[String]("()", editor.current_line().clone())
    h.assert_eq[USize](1, editor.cursor_x())

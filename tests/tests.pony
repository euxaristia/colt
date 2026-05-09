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
    test(recover iso TestRegexAnchorGlobal end)
    test(recover iso TestRegexAnchorMatchesAtStart end)
    test(recover iso TestRegexClassEscapeDigit end)
    test(recover iso TestRegexClassEscapeWord end)
    test(recover iso TestRegexClassEscapeSpace end)
    test(recover iso TestRegexClassEscapeMixed end)


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


// ── Regex regression tests ──

class iso TestRegexAnchorGlobal is UnitTest
  fun name(): String => "^ anchor matches only at start, not at every pos"
  fun apply(h: TestHelper) ? =>
    // Bug: with global replace, ^a on "aa" matched at pos 0 and again at
    // pos 1, because find() ignored its start argument when _anchored.
    let re = ReCompile("^a")?
    let m1 = re.find("aa", 0)?
    h.assert_eq[USize](0, m1._1)
    h.assert_eq[USize](1, m1._2)
    // Second iteration of :s/^a/b/g — must fail to match.
    h.assert_error({() ? => re.find("aa", 1)? })

class iso TestRegexAnchorMatchesAtStart is UnitTest
  fun name(): String => "^ still matches the literal start of input"
  fun apply(h: TestHelper) ? =>
    let re = ReCompile("^foo")?
    let m = re.find("foobar", 0)?
    h.assert_eq[USize](0, m._1)
    h.assert_eq[USize](3, m._2)

class iso TestRegexClassEscapeDigit is UnitTest
  fun name(): String => "[\\d] inside char class matches digits"
  fun apply(h: TestHelper) ? =>
    let re = ReCompile("[\\d]+")?
    let m = re.find("abc123def", 0)?
    h.assert_eq[USize](3, m._1)
    h.assert_eq[USize](6, m._2)

class iso TestRegexClassEscapeWord is UnitTest
  fun name(): String => "[\\w] inside char class matches word chars"
  fun apply(h: TestHelper) ? =>
    let re = ReCompile("[\\w]+")?
    let m = re.find("  hi_42  ", 0)?
    h.assert_eq[USize](2, m._1)
    h.assert_eq[USize](7, m._2)

class iso TestRegexClassEscapeSpace is UnitTest
  fun name(): String => "[\\s] inside char class matches whitespace"
  fun apply(h: TestHelper) ? =>
    let re = ReCompile("[\\s]+")?
    let m = re.find("ab \tcd", 0)?
    h.assert_eq[USize](2, m._1)
    h.assert_eq[USize](4, m._2)

class iso TestRegexClassEscapeMixed is UnitTest
  fun name(): String => "[\\dA-F] mixes class escape with literal range"
  fun apply(h: TestHelper) ? =>
    // Hex digits: \d for 0-9, plus A-F.
    let re = ReCompile("[\\dA-F]+")?
    let m = re.find("xx2BcAd", 0)?
    h.assert_eq[USize](2, m._1)
    h.assert_eq[USize](4, m._2)  // matches "2B"

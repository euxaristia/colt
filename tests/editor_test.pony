use "pony_test"

class iso TestEditorGGotoBottom is UnitTest
  fun name(): String => "Editor: G goes to bottom of file"
  fun apply(h: TestHelper) =>
    let editor = Editor(h.env, "", {() => None})
    (let sr, let b) = (SR, editor.buf())
    b.lines.push(sr("line 1"))
    b.lines.push(sr("line 2"))
    b.lines.push(sr("line 3"))
    b.lines.push(sr("line 4"))
    b.lines.push(sr("line 5"))
    editor.key_press('G')
    h.assert_eq[USize](editor.cursor_y(), 5, "G should go to last line")

class iso TestEditorGWithCount is UnitTest
  fun name(): String => "Editor: count+G goes to specific line"
  fun apply(h: TestHelper) =>
    let editor = Editor(h.env, "", {() => None})
    (let sr, let b) = (SR, editor.buf())
    b.lines.push(sr("line 1"))
    b.lines.push(sr("line 2"))
    b.lines.push(sr("line 3"))
    b.lines.push(sr("line 4"))
    b.lines.push(sr("line 5"))
    editor.key_press('3')
    editor.key_press('G')
    h.assert_eq[USize](editor.cursor_y(), 2, "3G should go to line 3 (0-indexed 2)")

class iso TestEditorGGGoesToTop is UnitTest
  fun name(): String => "Editor: gg goes to top of file"
  fun apply(h: TestHelper) =>
    let editor = Editor(h.env, "", {() => None})
    (let sr, let b) = (SR, editor.buf())
    b.lines.push(sr("line 1"))
    b.lines.push(sr("line 2"))
    b.lines.push(sr("line 3"))
    b.lines.push(sr("line 4"))
    b.lines.push(sr("line 5"))
    editor.key_press('G')
    h.assert_eq[USize](editor.cursor_y(), 5)
    editor.key_press('g')
    editor.key_press('g')
    h.assert_eq[USize](editor.cursor_y(), 0, "gg should go to first line")
    h.assert_eq[USize](editor.cursor_x(), 0, "gg sets column to 0")

class iso TestEditorJDown is UnitTest
  fun name(): String => "Editor: j moves cursor down"
  fun apply(h: TestHelper) =>
    let editor = Editor(h.env, "", {() => None})
    (let sr, let b) = (SR, editor.buf())
    b.lines.push(sr("line 1"))
    b.lines.push(sr("line 2"))
    b.lines.push(sr("line 3"))
    editor.key_press('j')
    h.assert_eq[USize](editor.cursor_y(), 1, "j should move one line down")

class iso TestEditorKUp is UnitTest
  fun name(): String => "Editor: k moves cursor up"
  fun apply(h: TestHelper) =>
    let editor = Editor(h.env, "", {() => None})
    (let sr, let b) = (SR, editor.buf())
    b.lines.push(sr("line 1"))
    b.lines.push(sr("line 2"))
    b.lines.push(sr("line 3"))
    editor.key_press('j')
    editor.key_press('j')
    h.assert_eq[USize](editor.cursor_y(), 2)
    editor.key_press('k')
    h.assert_eq[USize](editor.cursor_y(), 1, "k should move one line up")

class iso TestEditorGAtBottomStaysBottom is UnitTest
  fun name(): String => "Editor: G when already at bottom stays"
  fun apply(h: TestHelper) =>
    let editor = Editor(h.env, "", {() => None})
    (let sr, let b) = (SR, editor.buf())
    b.lines.push(sr("a"))
    b.lines.push(sr("b"))
    editor.key_press('G')
    h.assert_eq[USize](editor.cursor_y(), 2)
    editor.key_press('G')
    h.assert_eq[USize](editor.cursor_y(), 2, "G at bottom should stay at bottom")

class iso TestEditorCountJ is UnitTest
  fun name(): String => "Editor: count+j moves cursor down multiple lines"
  fun apply(h: TestHelper) =>
    let editor = Editor(h.env, "", {() => None})
    (let sr, let b) = (SR, editor.buf())
    b.lines.push(sr("line 1"))
    b.lines.push(sr("line 2"))
    b.lines.push(sr("line 3"))
    b.lines.push(sr("line 4"))
    b.lines.push(sr("line 5"))
    editor.key_press('3')
    editor.key_press('j')
    h.assert_eq[USize](editor.cursor_y(), 3, "3j should move 3 lines down")

class iso TestEditorCountGClamped is UnitTest
  fun name(): String => "Editor: count+G exceeding lines is clamped"
  fun apply(h: TestHelper) =>
    let editor = Editor(h.env, "", {() => None})
    (let sr, let b) = (SR, editor.buf())
    b.lines.push(sr("one"))
    b.lines.push(sr("two"))
    editor.key_press('9')
    editor.key_press('9')
    editor.key_press('G')
    h.assert_eq[USize](editor.cursor_y(), 2, "99G on 3 lines should clamp to last line")

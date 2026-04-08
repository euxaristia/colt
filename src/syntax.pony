primitive HlNormal
primitive HlKeyword
primitive HlType
primitive HlString
primitive HlComment
primitive HlNumber
primitive HlPreproc

type HlToken is (HlNormal | HlKeyword | HlType | HlString | HlComment
  | HlNumber | HlPreproc)

primitive Syntax
  """
  Hand-rolled syntax highlighter. Produces a per-byte HlToken array for a line,
  given language-specific keyword/type lists and comment markers.
  """

  fun highlight_line(line: String box, lang: SyntaxLang box,
    in_block_comment: Bool): (Array[HlToken] val, Bool)
  =>
    """
    Returns (tokens, still_in_block_comment).
    tokens.size() == line.size(), one HlToken per byte.
    """
    let len = line.size()
    let tokens = recover iso Array[HlToken](len) end
    // Fill with HlNormal
    var i: USize = 0
    while i < len do
      tokens.push(HlNormal)
      i = i + 1
    end

    var pos: USize = 0
    var in_bc = in_block_comment

    while pos < len do
      let ch = try line(pos)? else pos = pos + 1; continue end

      // ── Block comment continuation ──
      if in_bc then
        let bc_end = lang.block_comment_end()
        if (bc_end.size() > 0) and _match_at(line, pos, bc_end) then
          var j: USize = 0
          while j < bc_end.size() do
            try tokens.update(pos + j, HlComment)? end
            j = j + 1
          end
          pos = pos + bc_end.size()
          in_bc = false
        else
          try tokens.update(pos, HlComment)? end
          pos = pos + 1
        end
        continue
      end

      // ── Line comment ──
      let lc = lang.line_comment()
      if (lc.size() > 0) and _match_at(line, pos, lc) then
        while pos < len do
          try tokens.update(pos, HlComment)? end
          pos = pos + 1
        end
        continue
      end

      // ── Block comment start ──
      let bc_start = lang.block_comment_start()
      if (bc_start.size() > 0) and _match_at(line, pos, bc_start) then
        in_bc = true
        var j: USize = 0
        while j < bc_start.size() do
          try tokens.update(pos + j, HlComment)? end
          j = j + 1
        end
        pos = pos + bc_start.size()
        continue
      end

      // ── String literals ──
      if (ch == '"') or (ch == '\'') then
        let quote = ch
        try tokens.update(pos, HlString)? end
        pos = pos + 1
        while pos < len do
          let sc = try line(pos)? else break end
          try tokens.update(pos, HlString)? end
          if (sc == '\\') and ((pos + 1) < len) then
            pos = pos + 1
            try tokens.update(pos, HlString)? end
          elseif sc == quote then
            pos = pos + 1
            break
          end
          pos = pos + 1
        end
        continue
      end

      // ── Preprocessor (#include, #define, etc.) ──
      if (ch == '#') and _is_line_start(line, pos) then
        while pos < len do
          try tokens.update(pos, HlPreproc)? end
          pos = pos + 1
        end
        continue
      end

      // ── Numbers ──
      if _is_digit(ch) and ((pos == 0) or (not _is_word_char(try line(pos - 1)? else ' ' end))) then
        while (pos < len) and (_is_hex_digit(try line(pos)? else ' ' end) or
          ((try line(pos)? else ' ' end) == '.') or
          ((try line(pos)? else ' ' end) == 'x') or
          ((try line(pos)? else ' ' end) == 'X') or
          ((try line(pos)? else ' ' end) == '_'))
        do
          try tokens.update(pos, HlNumber)? end
          pos = pos + 1
        end
        continue
      end

      // ── Keywords / types ──
      if _is_word_start(ch) then
        let word_start = pos
        while (pos < len) and _is_word_char(try line(pos)? else ' ' end) do
          pos = pos + 1
        end
        let word_iso = line.substring(word_start.isize(), pos.isize())
        let word: String val = consume word_iso
        let hl = if lang.is_keyword(word) then
          HlKeyword
        elseif lang.is_type(word) then
          HlType
        else
          HlNormal
        end
        if not (hl is HlNormal) then
          var k = word_start
          while k < pos do
            try tokens.update(k, hl)? end
            k = k + 1
          end
        end
        continue
      end

      pos = pos + 1
    end

    (consume tokens, in_bc)

  fun _match_at(line: String box, pos: USize, pattern: String box): Bool =>
    if (pos + pattern.size()) > line.size() then return false end
    var i: USize = 0
    while i < pattern.size() do
      if (try line(pos + i)? else return false end) != (try pattern(i)? else return false end) then
        return false
      end
      i = i + 1
    end
    true

  fun _is_digit(ch: U8): Bool =>
    (ch >= '0') and (ch <= '9')

  fun _is_hex_digit(ch: U8): Bool =>
    _is_digit(ch) or ((ch >= 'a') and (ch <= 'f')) or ((ch >= 'A') and (ch <= 'F'))

  fun _is_word_start(ch: U8): Bool =>
    ((ch >= 'a') and (ch <= 'z')) or
    ((ch >= 'A') and (ch <= 'Z')) or
    (ch == '_')

  fun _is_word_char(ch: U8): Bool =>
    _is_word_start(ch) or _is_digit(ch)

  fun _is_line_start(line: String box, pos: USize): Bool =>
    """True if everything before pos is whitespace."""
    var i: USize = 0
    while i < pos do
      let c = try line(i)? else return false end
      if (c != ' ') and (c != '\t') then return false end
      i = i + 1
    end
    true


// ── Language definitions ──

interface box SyntaxLang
  fun line_comment(): String
  fun block_comment_start(): String
  fun block_comment_end(): String
  fun is_keyword(word: String box): Bool
  fun is_type(word: String box): Bool

primitive LangNone is SyntaxLang
  fun line_comment(): String => ""
  fun block_comment_start(): String => ""
  fun block_comment_end(): String => ""
  fun is_keyword(word: String box): Bool => false
  fun is_type(word: String box): Bool => false

primitive LangC is SyntaxLang
  fun line_comment(): String => "//"
  fun block_comment_start(): String => "/*"
  fun block_comment_end(): String => "*/"
  fun is_keyword(word: String box): Bool =>
    match word
    | "auto" | "break" | "case" | "const" | "continue" | "default" | "do"
    | "else" | "enum" | "extern" | "for" | "goto" | "if" | "inline"
    | "register" | "restrict" | "return" | "sizeof" | "static" | "struct"
    | "switch" | "typedef" | "union" | "volatile" | "while"
    | "define" | "include" | "ifdef" | "ifndef" | "endif" | "pragma" => true
    else false end
  fun is_type(word: String box): Bool =>
    match word
    | "char" | "double" | "float" | "int" | "long" | "short" | "signed"
    | "unsigned" | "void" | "bool" | "int8_t" | "int16_t" | "int32_t"
    | "int64_t" | "uint8_t" | "uint16_t" | "uint32_t" | "uint64_t"
    | "size_t" | "ssize_t" | "ptrdiff_t" | "NULL" | "true" | "false" => true
    else false end

primitive LangRust is SyntaxLang
  fun line_comment(): String => "//"
  fun block_comment_start(): String => "/*"
  fun block_comment_end(): String => "*/"
  fun is_keyword(word: String box): Bool =>
    match word
    | "as" | "async" | "await" | "break" | "const" | "continue" | "crate"
    | "dyn" | "else" | "enum" | "extern" | "fn" | "for" | "if" | "impl"
    | "in" | "let" | "loop" | "match" | "mod" | "move" | "mut" | "pub"
    | "ref" | "return" | "self" | "Self" | "static" | "struct" | "super"
    | "trait" | "type" | "unsafe" | "use" | "where" | "while" | "yield" => true
    else false end
  fun is_type(word: String box): Bool =>
    match word
    | "bool" | "char" | "f32" | "f64" | "i8" | "i16" | "i32" | "i64"
    | "i128" | "isize" | "str" | "u8" | "u16" | "u32" | "u64" | "u128"
    | "usize" | "String" | "Vec" | "Option" | "Result" | "Box" | "Rc"
    | "Arc" | "HashMap" | "HashSet" | "true" | "false" | "None" | "Some"
    | "Ok" | "Err" => true
    else false end

primitive LangPython is SyntaxLang
  fun line_comment(): String => "#"
  fun block_comment_start(): String => ""
  fun block_comment_end(): String => ""
  fun is_keyword(word: String box): Bool =>
    match word
    | "and" | "as" | "assert" | "async" | "await" | "break" | "class"
    | "continue" | "def" | "del" | "elif" | "else" | "except" | "finally"
    | "for" | "from" | "global" | "if" | "import" | "in" | "is" | "lambda"
    | "nonlocal" | "not" | "or" | "pass" | "raise" | "return" | "try"
    | "while" | "with" | "yield" => true
    else false end
  fun is_type(word: String box): Bool =>
    match word
    | "True" | "False" | "None" | "int" | "float" | "str" | "bool" | "list"
    | "dict" | "set" | "tuple" | "bytes" | "type" | "object" | "self" => true
    else false end

primitive LangGo is SyntaxLang
  fun line_comment(): String => "//"
  fun block_comment_start(): String => "/*"
  fun block_comment_end(): String => "*/"
  fun is_keyword(word: String box): Bool =>
    match word
    | "break" | "case" | "chan" | "const" | "continue" | "default" | "defer"
    | "else" | "fallthrough" | "for" | "func" | "go" | "goto" | "if"
    | "import" | "interface" | "map" | "package" | "range" | "return"
    | "select" | "struct" | "switch" | "type" | "var" => true
    else false end
  fun is_type(word: String box): Bool =>
    match word
    | "bool" | "byte" | "complex64" | "complex128" | "error" | "float32"
    | "float64" | "int" | "int8" | "int16" | "int32" | "int64" | "rune"
    | "string" | "uint" | "uint8" | "uint16" | "uint32" | "uint64"
    | "uintptr" | "true" | "false" | "nil" | "iota" => true
    else false end

primitive LangZig is SyntaxLang
  fun line_comment(): String => "//"
  fun block_comment_start(): String => ""
  fun block_comment_end(): String => ""
  fun is_keyword(word: String box): Bool =>
    match word
    | "align" | "allowzero" | "and" | "asm" | "async" | "await" | "break"
    | "catch" | "comptime" | "const" | "continue" | "defer" | "else"
    | "enum" | "errdefer" | "error" | "export" | "extern" | "fn" | "for"
    | "if" | "inline" | "noalias" | "nosuspend" | "orelse" | "or" | "packed"
    | "pub" | "resume" | "return" | "struct" | "suspend" | "switch" | "test"
    | "try" | "union" | "unreachable" | "var" | "volatile" | "while" => true
    else false end
  fun is_type(word: String box): Bool =>
    match word
    | "bool" | "f16" | "f32" | "f64" | "f80" | "f128" | "i8" | "i16"
    | "i32" | "i64" | "i128" | "isize" | "u8" | "u16" | "u32" | "u64"
    | "u128" | "usize" | "void" | "anytype" | "anyerror" | "anyframe"
    | "true" | "false" | "null" | "undefined" => true
    else false end

primitive LangHare is SyntaxLang
  fun line_comment(): String => "//"
  fun block_comment_start(): String => ""
  fun block_comment_end(): String => ""
  fun is_keyword(word: String box): Bool =>
    match word
    | "as" | "break" | "case" | "const" | "continue" | "def" | "defer"
    | "else" | "export" | "fn" | "for" | "if" | "is" | "let" | "match"
    | "return" | "static" | "struct" | "switch" | "type" | "union" | "use"
    | "yield" => true
    else false end
  fun is_type(word: String box): Bool =>
    match word
    | "bool" | "char" | "f32" | "f64" | "i8" | "i16" | "i32" | "i64"
    | "int" | "rune" | "size" | "str" | "u8" | "u16" | "u32" | "u64"
    | "uint" | "uintptr" | "void" | "valist" | "nullable"
    | "true" | "false" | "null" => true
    else false end

primitive LangPony is SyntaxLang
  fun line_comment(): String => "//"
  fun block_comment_start(): String => "/*"
  fun block_comment_end(): String => "*/"
  fun is_keyword(word: String box): Bool =>
    match word
    | "actor" | "as" | "be" | "break" | "class" | "compile_error"
    | "compile_intrinsic" | "consume" | "continue" | "do" | "else"
    | "elseif" | "embed" | "end" | "error" | "for" | "fun" | "if"
    | "ifdef" | "iftype" | "in" | "interface" | "is" | "isnt" | "let"
    | "match" | "new" | "not" | "object" | "primitive" | "recover"
    | "ref" | "repeat" | "return" | "struct" | "then" | "this" | "trait"
    | "try" | "type" | "until" | "use" | "var" | "where" | "while"
    | "with" => true
    else false end
  fun is_type(word: String box): Bool =>
    match word
    | "Bool" | "U8" | "U16" | "U32" | "U64" | "U128" | "USize" | "ULong"
    | "I8" | "I16" | "I32" | "I64" | "I128" | "ISize" | "ILong"
    | "F32" | "F64" | "String" | "Array" | "None" | "Env" | "Pointer"
    | "MaybePointer" | "true" | "false" | "iso" | "val" | "ref" | "box"
    | "trn" | "tag" => true
    else false end

primitive LangJava is SyntaxLang
  fun line_comment(): String => "//"
  fun block_comment_start(): String => "/*"
  fun block_comment_end(): String => "*/"
  fun is_keyword(word: String box): Bool =>
    match word
    | "abstract" | "assert" | "break" | "case" | "catch" | "class"
    | "const" | "continue" | "default" | "do" | "else" | "enum"
    | "extends" | "final" | "finally" | "for" | "goto" | "if"
    | "implements" | "import" | "instanceof" | "interface" | "native"
    | "new" | "package" | "private" | "protected" | "public" | "return"
    | "static" | "strictfp" | "super" | "switch" | "synchronized" | "this"
    | "throw" | "throws" | "transient" | "try" | "volatile" | "while" => true
    else false end
  fun is_type(word: String box): Bool =>
    match word
    | "boolean" | "byte" | "char" | "double" | "float" | "int" | "long"
    | "short" | "void" | "String" | "Integer" | "Boolean" | "Double"
    | "Float" | "Long" | "Object" | "null" | "true" | "false" => true
    else false end

primitive LangShell is SyntaxLang
  fun line_comment(): String => "#"
  fun block_comment_start(): String => ""
  fun block_comment_end(): String => ""
  fun is_keyword(word: String box): Bool =>
    match word
    | "if" | "then" | "else" | "elif" | "fi" | "for" | "while" | "do"
    | "done" | "case" | "esac" | "in" | "function" | "return" | "local"
    | "export" | "source" | "exit" | "break" | "continue" | "set"
    | "unset" | "shift" | "eval" | "exec" | "readonly" | "declare"
    | "typeset" | "trap" => true
    else false end
  fun is_type(word: String box): Bool => false

primitive LangMakefile is SyntaxLang
  fun line_comment(): String => "#"
  fun block_comment_start(): String => ""
  fun block_comment_end(): String => ""
  fun is_keyword(word: String box): Bool =>
    match word
    | "ifeq" | "ifneq" | "ifdef" | "ifndef" | "else" | "endif" | "define"
    | "endef" | "include" | "override" | "export" | "unexport" | "vpath" => true
    else false end
  fun is_type(word: String box): Bool => false


primitive LangJavaScript is SyntaxLang
  fun line_comment(): String => "//"
  fun block_comment_start(): String => "/*"
  fun block_comment_end(): String => "*/"
  fun is_keyword(word: String box): Bool =>
    match word
    | "async" | "await" | "break" | "case" | "catch" | "class" | "const"
    | "continue" | "debugger" | "default" | "delete" | "do" | "else"
    | "export" | "extends" | "finally" | "for" | "from" | "function" | "if"
    | "import" | "in" | "instanceof" | "let" | "new" | "of" | "return"
    | "static" | "super" | "switch" | "this" | "throw" | "try" | "typeof"
    | "var" | "void" | "while" | "with" | "yield" => true
    else false end
  fun is_type(word: String box): Bool =>
    match word
    | "Array" | "Boolean" | "Date" | "Error" | "Function" | "JSON" | "Map"
    | "Math" | "Number" | "Object" | "Promise" | "Proxy" | "RegExp" | "Set"
    | "String" | "Symbol" | "WeakMap" | "WeakSet" | "console" | "document"
    | "window" | "null" | "undefined" | "true" | "false" | "NaN"
    | "Infinity" => true
    else false end

primitive LangTypeScript is SyntaxLang
  fun line_comment(): String => "//"
  fun block_comment_start(): String => "/*"
  fun block_comment_end(): String => "*/"
  fun is_keyword(word: String box): Bool =>
    match word
    | "abstract" | "as" | "async" | "await" | "break" | "case" | "catch"
    | "class" | "const" | "continue" | "debugger" | "declare" | "default"
    | "delete" | "do" | "else" | "enum" | "export" | "extends" | "finally"
    | "for" | "from" | "function" | "if" | "implements" | "import" | "in"
    | "instanceof" | "interface" | "is" | "keyof" | "let" | "module"
    | "namespace" | "new" | "of" | "override" | "readonly" | "return"
    | "satisfies" | "static" | "super" | "switch" | "this" | "throw" | "try"
    | "type" | "typeof" | "var" | "void" | "while" | "with" | "yield" => true
    else false end
  fun is_type(word: String box): Bool =>
    match word
    | "any" | "boolean" | "never" | "number" | "object" | "string" | "symbol"
    | "unknown" | "void" | "bigint" | "Array" | "Map" | "Set" | "Promise"
    | "Record" | "Partial" | "Required" | "Readonly" | "Pick" | "Omit"
    | "null" | "undefined" | "true" | "false" => true
    else false end

primitive LangMarkdown is SyntaxLang
  fun line_comment(): String => ""
  fun block_comment_start(): String => ""
  fun block_comment_end(): String => ""
  fun is_keyword(word: String box): Bool => false
  fun is_type(word: String box): Bool => false

primitive LangJSON is SyntaxLang
  fun line_comment(): String => ""
  fun block_comment_start(): String => ""
  fun block_comment_end(): String => ""
  fun is_keyword(word: String box): Bool =>
    match word
    | "true" | "false" | "null" => true
    else false end
  fun is_type(word: String box): Bool => false

primitive LangYAML is SyntaxLang
  fun line_comment(): String => "#"
  fun block_comment_start(): String => ""
  fun block_comment_end(): String => ""
  fun is_keyword(word: String box): Bool =>
    match word
    | "true" | "false" | "null" | "yes" | "no" | "on" | "off" => true
    else false end
  fun is_type(word: String box): Bool => false

primitive LangTOML is SyntaxLang
  fun line_comment(): String => "#"
  fun block_comment_start(): String => ""
  fun block_comment_end(): String => ""
  fun is_keyword(word: String box): Bool =>
    match word
    | "true" | "false" => true
    else false end
  fun is_type(word: String box): Bool => false

primitive LangLua is SyntaxLang
  fun line_comment(): String => "--"
  fun block_comment_start(): String => "--[["
  fun block_comment_end(): String => "]]"
  fun is_keyword(word: String box): Bool =>
    match word
    | "and" | "break" | "do" | "else" | "elseif" | "end" | "for"
    | "function" | "goto" | "if" | "in" | "local" | "not" | "or" | "repeat"
    | "return" | "then" | "until" | "while" => true
    else false end
  fun is_type(word: String box): Bool =>
    match word
    | "nil" | "true" | "false" | "self" | "string" | "table" | "math"
    | "io" | "os" | "coroutine" | "debug" | "package" => true
    else false end

primitive LangRuby is SyntaxLang
  fun line_comment(): String => "#"
  fun block_comment_start(): String => "=begin"
  fun block_comment_end(): String => "=end"
  fun is_keyword(word: String box): Bool =>
    match word
    | "alias" | "and" | "begin" | "break" | "case" | "class" | "def"
    | "defined" | "do" | "else" | "elsif" | "end" | "ensure" | "for" | "if"
    | "in" | "module" | "next" | "not" | "or" | "redo" | "rescue" | "retry"
    | "return" | "super" | "then" | "undef" | "unless" | "until" | "when"
    | "while" | "yield" | "require" | "include" | "extend" | "attr_reader"
    | "attr_writer" | "attr_accessor" | "raise" => true
    else false end
  fun is_type(word: String box): Bool =>
    match word
    | "nil" | "true" | "false" | "self" | "Array" | "Hash" | "String"
    | "Integer" | "Float" | "Symbol" | "Proc" | "Lambda" | "IO" | "File"
    | "Dir" | "Regexp" | "Range" | "Struct" | "Class" | "Module"
    | "Kernel" => true
    else false end

primitive LangHTML is SyntaxLang
  fun line_comment(): String => ""
  fun block_comment_start(): String => "<!--"
  fun block_comment_end(): String => "-->"
  fun is_keyword(word: String box): Bool => false
  fun is_type(word: String box): Bool => false

primitive LangCSS is SyntaxLang
  fun line_comment(): String => ""
  fun block_comment_start(): String => "/*"
  fun block_comment_end(): String => "*/"
  fun is_keyword(word: String box): Bool =>
    match word
    | "important" | "inherit" | "initial" | "unset" | "revert" | "auto"
    | "none" | "block" | "inline" | "flex" | "grid" | "absolute" | "relative"
    | "fixed" | "sticky" | "static" | "hidden" | "visible" | "scroll"
    | "solid" | "dashed" | "dotted" | "transparent" => true
    else false end
  fun is_type(word: String box): Bool => false

primitive SyntaxDetect
  """Detect language from filename extension."""
  fun apply(filename: String box): SyntaxLang =>
    // Find the last '.'
    var dot_pos: ISize = -1
    var i: USize = 0
    while i < filename.size() do
      if (try filename(i)? else 0 end) == '.' then
        dot_pos = i.isize()
      end
      i = i + 1
    end

    // Check for special filenames (no extension)
    let base = _basename(filename)
    if (base == "Makefile") or (base == "makefile") or (base == "GNUmakefile") then
      return LangMakefile
    end
    if (base == "Gemfile") or (base == "Rakefile") or (base == "Vagrantfile") then
      return LangRuby
    end
    if (base == ".bashrc") or (base == ".bash_profile") or (base == ".profile")
      or (base == ".zshrc") or (base == ".zshenv")
    then
      return LangShell
    end

    if dot_pos < 0 then return LangNone end

    let ext_iso = filename.substring(dot_pos + 1)
    let ext: String val = consume ext_iso
    match ext
    | "c" | "h" | "cpp" | "cxx" | "cc" | "hpp" | "hxx" => LangC
    | "rs" => LangRust
    | "py" | "pyw" => LangPython
    | "go" => LangGo
    | "zig" => LangZig
    | "ha" => LangHare
    | "pony" => LangPony
    | "java" => LangJava
    | "sh" | "bash" | "zsh" | "fish" => LangShell
    | "mk" => LangMakefile
    | "js" | "jsx" | "mjs" | "cjs" => LangJavaScript
    | "ts" | "tsx" | "mts" | "cts" => LangTypeScript
    | "md" | "markdown" => LangMarkdown
    | "json" | "jsonc" => LangJSON
    | "yml" | "yaml" => LangYAML
    | "toml" => LangTOML
    | "lua" => LangLua
    | "rb" | "rake" | "gemspec" => LangRuby
    | "html" | "htm" | "svg" | "xml" => LangHTML
    | "css" | "scss" | "less" => LangCSS
    else LangNone end

  fun _basename(path: String box): String val =>
    var last_slash: ISize = -1
    var i: USize = 0
    while i < path.size() do
      if (try path(i)? else 0 end) == '/' then
        last_slash = i.isize()
      end
      i = i + 1
    end
    path.substring(last_slash + 1).clone()

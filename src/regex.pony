// Minimal regex engine for Colt's :s/ command.
// Supports: literals, . ^ $ * + ? [abc] [^abc] [a-z]
// Escapes: \d \D \w \W \s \S \n \t \r \\ \. \* \+ \? \[ \] \^ \$
// Greedy quantifiers, no capture groups.

class val _ReAtom
  // kind: 0=literal, 1=any, 2=class, 3=negclass, 5=end-anchor
  let kind: U8
  let byte: U8
  let ranges: Array[(U8, U8)] val
  let qmin: USize
  let qmax: USize

  new val create(k: U8, b: U8, r: Array[(U8, U8)] val,
    qn: USize, qx: USize) =>
    kind = k
    byte = b
    ranges = r
    qmin = qn
    qmax = qx

class val Regex
  let _atoms: Array[_ReAtom] val
  let _anchored: Bool

  new val create(atoms: Array[_ReAtom] val, anchored: Bool) =>
    _atoms = atoms
    _anchored = anchored

  fun find(s: String box, start: USize): (USize, USize) ? =>
    """Find first match at or after start. Returns (match_start, match_end)."""
    var pos = start
    let n = s.size()
    if _anchored then
      // ^ binds to the start of the input only. Calls with start > 0
      // (e.g. successive iterations of :s/^a/b/g) must fail to match,
      // otherwise ^ would silently behave like an unanchored pattern.
      if pos > 0 then error end
      let r = _match_from(0, s, 0)
      if r._1 then return (0, r._2) end
      error
    end
    while pos <= n do
      let r = _match_from(0, s, pos)
      if r._1 then return (pos, r._2) end
      pos = pos + 1
    end
    error

  fun _match_from(ai: USize, s: String box, si: USize): (Bool, USize) =>
    if ai >= _atoms.size() then return (true, si) end
    let atom = try _atoms(ai)? else return (false, 0) end
    if atom.kind == 5 then
      if si == s.size() then return _match_from(ai + 1, s, si) end
      return (false, 0)
    end
    // Greedy consume up to qmax
    var count: USize = 0
    while count < atom.qmax do
      if not _atom_matches(atom, s, si + count) then break end
      count = count + 1
    end
    // If we didn't reach qmin, the atom can't satisfy this position.
    if count < atom.qmin then return (false, 0) end
    // Backtrack down to qmin
    while true do
      let sub = _match_from(ai + 1, s, si + count)
      if sub._1 then return sub end
      if count <= atom.qmin then return (false, 0) end
      count = count - 1
    end
    (false, 0)

  fun _atom_matches(atom: _ReAtom, s: String box, pos: USize): Bool =>
    if pos >= s.size() then return false end
    let c = try s(pos)? else return false end
    match atom.kind
    | 0 => c == atom.byte
    | 1 => c != '\n'
    | 2 => _in_ranges(c, atom.ranges)
    | 3 => not _in_ranges(c, atom.ranges)
    else false
    end

  fun _in_ranges(c: U8, ranges: Array[(U8, U8)] val): Bool =>
    for r in ranges.values() do
      if (c >= r._1) and (c <= r._2) then return true end
    end
    false

primitive ReCompile
  fun _empty_ranges(): Array[(U8, U8)] val =>
    recover val Array[(U8, U8)] end

  fun apply(pattern: String box): Regex ? =>
    let atoms = recover trn Array[_ReAtom](pattern.size()) end
    let n = pattern.size()
    var i: USize = 0
    var anchored = false
    if (n > 0) and (pattern(0)? == '^') then
      anchored = true
      i = 1
    end
    while i < n do
      let c = pattern(i)?

      // End anchor only recognized as the last character
      if (c == '$') and (i == (n - 1)) then
        let empty = _empty_ranges()
        atoms.push(_ReAtom(5, 0, empty, 1, 1))
        i = i + 1
        break
      end

      var kind: U8 = 0
      var b: U8 = 0
      var rs: Array[(U8, U8)] val = _empty_ranges()

      if c == '.' then
        kind = 1
        i = i + 1
      elseif c == '[' then
        i = i + 1
        var neg = false
        if (i < n) and (pattern(i)? == '^') then
          neg = true
          i = i + 1
        end
        let rsb = recover trn Array[(U8, U8)] end
        while (i < n) and (pattern(i)? != ']') do
          var consumed_meta = false
          // \d, \w, \s expand to their positive ranges here so e.g.
          // [\dA-F] matches hex digits. \D / \W / \S aren't supported
          // inside a class — their negation isn't expressible as a
          // simple range list — and fall through to literal-char.
          if (pattern(i)? == '\\') and ((i + 1) < n) then
            let e = pattern(i + 1)?
            if e == 'd' then
              rsb.push(('0', '9'))
              i = i + 2
              consumed_meta = true
            elseif e == 'w' then
              rsb.push(('a', 'z'))
              rsb.push(('A', 'Z'))
              rsb.push(('0', '9'))
              rsb.push(('_', '_'))
              i = i + 2
              consumed_meta = true
            elseif e == 's' then
              rsb.push((' ', ' '))
              rsb.push(('\t', '\t'))
              rsb.push(('\n', '\n'))
              rsb.push(('\r', '\r'))
              i = i + 2
              consumed_meta = true
            end
          end
          if not consumed_meta then
            let lo_pair = _class_char(pattern, i)?
            let lo_b = lo_pair._1
            var hi_b = lo_b
            var j = lo_pair._2
            if (j < n) and (pattern(j)? == '-')
              and ((j + 1) < n) and (pattern(j + 1)? != ']')
            then
              j = j + 1
              let hi_pair = _class_char(pattern, j)?
              hi_b = hi_pair._1
              j = hi_pair._2
            end
            rsb.push((lo_b, hi_b))
            i = j
          end
        end
        if i >= n then error end
        i = i + 1
        rs = consume rsb
        kind = if neg then 3 else 2 end
      elseif c == '\\' then
        if (i + 1) >= n then error end
        let e = pattern(i + 1)?
        if e == 'd' then
          kind = 2
          let a = recover trn Array[(U8, U8)] end
          a.push(('0', '9'))
          rs = consume a
        elseif e == 'D' then
          kind = 3
          let a = recover trn Array[(U8, U8)] end
          a.push(('0', '9'))
          rs = consume a
        elseif e == 'w' then
          kind = 2
          let a = recover trn Array[(U8, U8)] end
          a.push(('a', 'z'))
          a.push(('A', 'Z'))
          a.push(('0', '9'))
          a.push(('_', '_'))
          rs = consume a
        elseif e == 'W' then
          kind = 3
          let a = recover trn Array[(U8, U8)] end
          a.push(('a', 'z'))
          a.push(('A', 'Z'))
          a.push(('0', '9'))
          a.push(('_', '_'))
          rs = consume a
        elseif e == 's' then
          kind = 2
          let a = recover trn Array[(U8, U8)] end
          a.push((' ', ' '))
          a.push(('\t', '\t'))
          a.push(('\n', '\n'))
          a.push(('\r', '\r'))
          rs = consume a
        elseif e == 'S' then
          kind = 3
          let a = recover trn Array[(U8, U8)] end
          a.push((' ', ' '))
          a.push(('\t', '\t'))
          a.push(('\n', '\n'))
          a.push(('\r', '\r'))
          rs = consume a
        elseif e == 'n' then
          kind = 0
          b = '\n'
        elseif e == 't' then
          kind = 0
          b = '\t'
        elseif e == 'r' then
          kind = 0
          b = '\r'
        else
          kind = 0
          b = e
        end
        i = i + 2
      else
        kind = 0
        b = c
        i = i + 1
      end

      // Quantifier
      var qn: USize = 1
      var qx: USize = 1
      if i < n then
        let q = pattern(i)?
        if q == '*' then
          qn = 0
          qx = USize.max_value()
          i = i + 1
        elseif q == '+' then
          qn = 1
          qx = USize.max_value()
          i = i + 1
        elseif q == '?' then
          qn = 0
          qx = 1
          i = i + 1
        end
      end

      atoms.push(_ReAtom(kind, b, rs, qn, qx))
    end
    Regex(consume atoms, anchored)

  fun _class_char(p: String box, i: USize): (U8, USize) ? =>
    let c = p(i)?
    if (c == '\\') and ((i + 1) < p.size()) then
      let e = p(i + 1)?
      var b: U8 = e
      if e == 'n' then b = '\n'
      elseif e == 't' then b = '\t'
      elseif e == 'r' then b = '\r'
      end
      (b, i + 2)
    else
      (c, i + 1)
    end

primitive ReReplace
  fun apply(replacement: String val, matched: String val): String iso^ =>
    """Expand & (whole match) and escape sequences in replacement text."""
    recover iso
      let out = String(replacement.size())
      var i: USize = 0
      let n = replacement.size()
      while i < n do
        let c = try replacement(i)? else i = i + 1; continue end
        if (c == '\\') and ((i + 1) < n) then
          let e = try replacement(i + 1)? else '\\' end
          if e == '&' then out.push('&')
          elseif e == '\\' then out.push('\\')
          elseif e == 'n' then out.push('\n')
          elseif e == 't' then out.push('\t')
          elseif e == 'r' then out.push('\r')
          else out.push(e)
          end
          i = i + 2
        elseif c == '&' then
          out.append(matched)
          i = i + 1
        else
          out.push(c)
          i = i + 1
        end
      end
      out
    end

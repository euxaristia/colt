use "files"

class Buffer
  """
  Text buffer: a mutable array of mutable lines.
  """
  var lines: Array[String ref] ref
  var dirty: Bool = false
  var filename: String = ""

  new create(filename': String = "") =>
    filename = filename'
    lines = Array[String ref]
    lines.push(String)

  fun line_count(): USize =>
    lines.size()

  fun line(row: USize): String box =>
    try lines(row)? else "" end

  fun line_len(row: USize): USize =>
    try lines(row)?.size() else 0 end

  fun ref insert_char(row: USize, col: USize, ch: U8) =>
    try
      let l = lines(row)?
      l.insert_byte(col.isize(), ch)
      dirty = true
    end

  fun ref delete_char(row: USize, col: USize): U8 =>
    try
      let l = lines(row)?
      if col < l.size() then
        let ch = l(col)?
        l.delete(col.isize(), 1)
        dirty = true
        return ch
      end
    end
    0

  fun ref insert_line(row: USize, content: String) =>
    try
      lines.insert(row, content.clone())?
      dirty = true
    end

  fun ref delete_line(row: USize): String =>
    try
      let l = lines.delete(row)?
      dirty = true
      let s = l.clone()
      consume s
    else
      "".clone()
    end

  fun ref split_line(row: USize, col: USize) =>
    try
      let l = lines(row)?
      let rest = String
      if col < l.size() then
        rest.append(l.substring(col.isize()))
        l.truncate(col)
      end
      lines.insert(row + 1, rest)?
      dirty = true
    end

  fun ref join_lines(row: USize) =>
    try
      if (row + 1) < lines.size() then
        let next_line = lines.delete(row + 1)?
        lines(row)?.append(consume next_line)
        dirty = true
      end
    end

  fun ref load(auth: FileAuth) =>
    if filename.size() > 0 then
      let path = FilePath(auth, filename)
      match OpenFile(path)
      | let f: File =>
        lines.clear()
        for file_line in f.lines() do
          lines.push(file_line.string().clone())
        end
        if lines.size() == 0 then
          lines.push(String)
        end
        dirty = false
      end
    end

  fun ref save(auth: FileAuth): Bool =>
    if filename.size() == 0 then
      return false
    end
    let path = FilePath(auth, filename)
    match CreateFile(path)
    | let f: File =>
      // Truncate file first
      f.set_length(0)
      for (i, l) in lines.pairs() do
        f.write(l.clone())
        if i < (lines.size() - 1) then
          f.write("\n")
        end
      end
      f.dispose()
      dirty = false
      true
    else
      false
    end

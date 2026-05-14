primitive PasteEventStart
primitive PasteEventEnd
primitive PasteEventKey
primitive PasteEventContent

type PasteEventKind is (PasteEventStart | PasteEventEnd | PasteEventKey | PasteEventContent)

class PasteEvent
  let kind: PasteEventKind
  let byte: U8

  new create(kind': PasteEventKind, byte': U8 = 0) =>
    kind = kind'
    byte = byte'

class PasteState
  """
  Stream-mode tracker for DEC bracketed paste (xterm "?2004h").
  Feed input bytes via \`feed\`; it returns a list of events in order:
    - PasteEventStart  : the \e[200~ marker was just consumed
    - PasteEventEnd    : the \e[201~ marker was just consumed
    - PasteEventKey    : a regular keystroke byte (forward to terminal parser)
    - PasteEventContent: a paste-body byte (insert literally, bypass auto-pair)
  Partial markers split across \`feed\` calls are held until resolved.
  """
  var _in_paste: Bool = false
  embed _hold: Array[U8] = Array[U8]

  fun in_paste(): Bool => _in_paste

  fun ref feed(data: Array[U8] box): Array[PasteEvent] ref^ =>
    let out = Array[PasteEvent]
    var i: USize = 0
    while i < data.size() do
      let ch = try data(i)? else i = i + 1; continue end
      let expected = _expected_at(_hold.size())
      if (expected != 0) and (ch == expected) then
        _hold.push(ch)
        if _hold.size() == 6 then
          if _in_paste then
            out.push(PasteEvent(PasteEventEnd))
            _in_paste = false
          else
            out.push(PasteEvent(PasteEventStart))
            _in_paste = true
          end
          _hold.clear()
        end
      else
        // Match failed (or no match in progress). Emit any held bytes
        // as content/keys, then process this byte fresh.
        _flush_hold(out)
        if ch == 0x1B then
          _hold.push(ch)
        else
          let k: PasteEventKind =
            if _in_paste then PasteEventContent else PasteEventKey end
          out.push(PasteEvent(k, ch))
        end
      end
      i = i + 1
    end
    // We intentionally do NOT flush _hold here. Partial markers (like \e[)
    // stay in _hold until the next feed() call completes or invalidates them.
    out

  fun ref _flush_hold(out: Array[PasteEvent]) =>
    if _hold.size() == 0 then return end
    let held_kind: PasteEventKind =
      if _in_paste then PasteEventContent else PasteEventKey end
    for h in _hold.values() do
      out.push(PasteEvent(held_kind, h))
    end
    _hold.clear()

  fun _expected_at(idx: USize): U8 =>
    """
    Expected byte at \`idx\` in the marker we're matching.
    """
    let target_5: U8 = if _in_paste then '1' else '0' end
    match idx
    | 0 => 0x1B
    | 1 => '['
    | 2 => '2'
    | 3 => '0'
    | 4 => target_5
    | 5 => '~'
    else 0
    end

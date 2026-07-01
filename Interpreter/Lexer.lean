import Interpreter.Parser

def atEnd (s : String) (pos : s.Pos) : Bool :=
  pos == s.endPos

-- 現在文字を返す
def curr
    (s : String)
    (pos : s.Pos)
    (h : pos ≠ s.endPos)
    : Char :=
  pos.get h

-- 次へ進む
def advance
    (s : String)
    (pos : s.Pos)
    (h : pos ≠ s.endPos)
    : s.Pos :=
  pos.next h

partial def skipSpaces
    (s : String)
    (pos : s.Pos)
    : s.Pos :=
  if h : pos = s.endPos then
    pos
  else
    let c := curr s pos h
    if c.isWhitespace then
      skipSpaces s (advance s pos h)
    else
      pos


-- 実装を簡単にするためここではEOFチェックはしない
def nextToken
    (s : String)
    (pos : s.Pos)
    (h : pos ≠ s.endPos)
    : Except String (Token × s.Pos) :=
  let c := curr s pos h
  match c with
  | '+' =>
    return (.plus, advance s pos h)
  | '-' =>
    return (.minus, advance s pos h)
  | '*' =>
    return (.star, advance s pos h)
  | '/' =>
    return (.slash, advance s pos h)
  | '(' =>
    return (.lparen, advance s pos h)
  | ')' =>
    return (.rparen, advance s pos h)
  | _ =>
    throw s!"unexpected character '{c}'"

partial def lex
    (s : String)
    (pos : s.Pos := s.startPos)
    : Except String (List Token) :=
  let pos := skipSpaces s pos

  if h : pos = s.endPos then
    return []
  else do
    let (tok, pos') ← nextToken s pos h
    let rest ← lex s pos'
    return tok :: rest

def s := "+-*/()"
#eval curr s (s.pos ⟨1⟩ (by decide)) (by decide)
#eval lex s

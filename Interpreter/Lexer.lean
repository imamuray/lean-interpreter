inductive Token where
  | int : Int → Token
  | ident : String → Token
  | plus
  | minus
  | star
  | slash
  | lparen
  | rparen
  | letKw
  | inKw
  | equal
  | trueKw
  | falseKw
  | equalEqual
  | less
deriving Repr, BEq


-- 条件を満たす文字列の終端位置を返す
partial def advanceWhile
    (pred : Char → Bool)
    (s : String)
    (pos : s.Pos)
    : s.Pos :=
  if h : pos = s.endPos then
    pos
  else
    let c := pos.get h
    if pred c then
      advanceWhile pred s (pos.next h)
    else
      pos

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

def skipSpaces
    (s : String)
    (pos : s.Pos)
    : s.Pos :=
  advanceWhile Char.isWhitespace s pos

def readInt
    (s : String)
    (pos : s.Pos)
    : Except String (Int × s.Pos) :=
  let endPos := advanceWhile Char.isDigit s pos
  let digits := s.extract pos endPos
  match digits.toInt? with
  | some n =>
    return (n, endPos)
  | none =>
    throw s!"invalid integer: {digits}"

def isIdentStart (c : Char) : Bool :=
  c.isAlpha || c == '_'

def isIdentChar (c : Char) : Bool :=
  c.isAlpha || c.isDigit || c == '_'

def readIdent
    (s : String)
    (pos : s.Pos)
    : Except String (String × s.Pos) :=
  if h : pos = s.endPos then
    throw "expected identifer"
  else
    let c := pos.get h
    if !isIdentStart c then
      throw s!"invalid identifer start: {c}"
    else
      let endPos := advanceWhile isIdentChar s (pos.next h)
      let name := s.extract pos endPos
      return (name, endPos)

-- 実装を簡単にするためここではEOFチェックはしない
def nextToken
    (s : String)
    (pos : s.Pos)
    (h : pos ≠ s.endPos)
    : Except String (Token × s.Pos) := do
  let c := curr s pos h
  if c.isDigit then
    let (n, pos') ← readInt s pos
    return (.int n, pos')
  else if isIdentStart c then
    let (name, pos') ← readIdent s pos
    match name with
    | "let" =>
      return (.letKw, pos')
    | "in" =>
      return (.inKw, pos')
    | _ =>
      return (.ident name, pos')
  else
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
    | '=' =>
      return (.equal, advance s pos h)
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

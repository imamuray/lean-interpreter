import Interpreter.Expr

inductive Token where
  | int : Int → Token
  | ident : String → Token
  | plus
  | minus
  | star
  | slash
  | lparen
  | rparen
deriving Repr

def lexInt (s : String) : Option Token := do
  let n ← s.toInt?
  return .int n

mutual

partial def parseAtom : List Token → Option (Expr × List Token)
  | .int n :: rest =>
    some (.int n, rest)
  | .ident x :: rest =>
    some (.var x, rest)
  | .lparen :: rest => do
    let (expr, rest') ← parseExpr rest
    match rest' with
    | .rparen :: rest'' =>
      return (expr, rest'')
    | _ =>
      none
  | _ =>
    none

partial def parseMulDiv : List Token → Option (Expr × List Token)
  | tokens => do
    let (left, rest) ← parseAtom tokens
    match rest with
    | .star :: rest' =>
      let (right, rest'') ← parseMulDiv rest'
      return (.mul left right, rest'')
    | .slash :: rest' =>
      let (right, rest'') ← parseMulDiv rest'
      return (.div left right, rest'')
    | _ =>
      return (left, rest)

partial def parseAddSub : List Token → Option (Expr × List Token)
  | tokens => do
    let (left, rest) ← parseMulDiv tokens
    match rest with
    | .plus :: rest' =>
      let (right, rest'') ← parseAddSub rest'
      return (.add left right, rest'')
    | .minus :: rest' =>
      let (right, rest'') ← parseAddSub rest'
      return (.sub left right, rest'')
    | _ =>
      return (left, rest)

partial def parseExpr (tokens : List Token) : Option (Expr × List Token) :=
  parseAddSub tokens

end

def parse (tokens : List Token) : Option Expr := do
  let (expr, rest) ← parseExpr tokens
  match rest with
  | [] => return expr
  | _ => none

-- 動作確認
#eval parse [.int 3, .plus, .int 4, .star, .lparen, .int 5, .minus, .int 2, .rparen]

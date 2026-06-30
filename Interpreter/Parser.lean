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

def parseAtom : List Token → Option (Expr × List Token)
  | .int n :: rest =>
    some (.int n, rest)
  | .ident x :: rest =>
    some (.var x, rest)
  | _ =>
    none

#eval parseAtom [.int 1, .plus, .int 2]
#eval parseAtom [.ident "x", .plus, .int 1]

def parseMulDiv : List Token → Option (Expr × List Token)
  | tokens => do
    let (left, rest) ← parseAtom tokens
    match rest with
    | .star :: rest' =>
      let (right, rest'') ← parseAtom rest'
      return (.mul left right, rest'')
    | .slash :: rest' =>
      let (right, rest'') ← parseAtom rest'
      return (.div left right, rest'')
    | _ =>
      return (left, rest)

#eval parseMulDiv [.int 2, .star, .ident "x"]

def parseExpr : List Token → Option (Expr × List Token)
  | tokens => do
    let (left, rest) ← parseMulDiv tokens
    match rest with
    | .plus :: rest' =>
      let (right, rest'') ← parseMulDiv rest'
      return (.add left right, rest'')
    | .minus :: rest' =>
      let (right, rest'') ← parseMulDiv rest'
      return (.sub left right, rest'')
    | _ =>
      return (left, rest)

#eval parseExpr [.int 1, .plus, .int 2]

import Interpreter.Expr
import Interpreter.Lexer

def parseIdent : List Token → Except String (String × List Token)
  | .ident x :: rest =>
    .ok (x, rest)
  | _ =>
    throw "expected identifier"

def expectedToken
    (expected : Token)
    : List Token → Except String (List Token)
  | t :: rest =>
    if t == expected then
      return rest
    else
      throw "unexpected token"
  | _ =>
    throw "unexpected end"

mutual

partial def parseAtom : List Token → Except String (Expr × List Token)
  | .int n :: rest =>
    .ok (.int n, rest)
  | .ident x :: rest =>
    .ok (.var x, rest)
  | .lparen :: rest => do
    let (expr, rest') ← parseExpr rest
    match rest' with
    | .rparen :: rest'' =>
      return (expr, rest'')
    | _ =>
      throw "expected ')'"
  | .letKw :: rest => do
    let (name, rest1) ← parseIdent rest
    let rest2 ← expectedToken .equal rest1
    let (value, rest3) ← parseExpr rest2
    let rest4 ← expectedToken .inKw rest3
    let (body, rest5) ← parseExpr rest4
    return (.letIn name value body, rest5)
  | _ =>
    throw "expected expression"

partial def parseMulDivLoop
  (left : Expr)
  (tokens : List Token)
  : Except String (Expr × List Token) :=
  match tokens with
  | .star :: rest => do
    let (right, rest') ← parseAtom rest
    parseMulDivLoop (.mul left right) rest'
  | .slash :: rest => do
    let (right, rest') ← parseAtom rest
    parseMulDivLoop (.div left right) rest'
  | _ =>
    return (left, tokens)

partial def parseMulDiv (tokens : List Token) : Except String (Expr × List Token) := do
    let (left, rest) ← parseAtom tokens
    parseMulDivLoop left rest

partial def parseAddSubLoop
  (left : Expr)
  (tokens : List Token)
  : Except String (Expr × List Token) :=
  match tokens with
  | .plus :: rest => do
    let (right, rest') ← parseMulDiv rest
    parseAddSubLoop (.add left right) rest'
  | .minus :: rest => do
    let (right, rest') ← parseMulDiv rest
    parseAddSubLoop (.sub left right) rest'
  | _ =>
    return (left, tokens)

partial def parseAddSub (tokens : List Token) : Except String (Expr × List Token) := do
  let (left, rest) ← parseMulDiv tokens
  parseAddSubLoop left rest

partial def parseExpr (tokens : List Token) : Except String (Expr × List Token) :=
  parseAddSub tokens

end

def parse (tokens : List Token) : Except String Expr := do
  let (expr, rest) ← parseExpr tokens
  match rest with
  | [] =>
    return expr
  | _ =>
    throw "unexpected tokens"

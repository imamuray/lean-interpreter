import Interpreter.Expr
import Interpreter.Lexer
import Interpreter.Parser

def eval : Expr → Env → Except String Value
  | .int n, _ =>
    return .int n

  | .bool b, _ =>
    return .bool b

  | .var x, env =>
    match env x with
    | some v => return v
    | none => throw s!"unknown variable: {x}"

  | .add a b, env => do
    let va ← eval a env
    let vb ← eval b env
    match va, vb with
    | .int x, .int y =>
      return .int (x + y)
    | _, _ =>
      throw "type error in +"

  | .sub a b, env => do
    let va ← eval a env
    let vb ← eval b env
    match va, vb with
    | .int x, .int y =>
      return .int (x - y)
    | _, _ =>
      throw "type error in -"

  | .mul a b, env => do
    let va ← eval a env
    let vb ← eval b env
    match va, vb with
    | .int x, .int y =>
      return .int (x * y)
    | _, _ =>
      throw "type error in *"

  | .div a b, env => do
    let va ← eval a env
    let vb ← eval b env
    match va, vb with
    | .int _, .int 0 =>
      throw "division by zero"
    | .int x, .int y =>
      return .int (x / y)
    | _, _ =>
      throw "type error in /"

  | .eq e1 e2, env => do
    let v1 ← eval e1 env
    let v2 ← eval e2 env
    match v1, v2 with
    | .int x, .int y =>
      return .bool (x == y)
    | .bool x, .bool y =>
      return .bool (x == y)
    | _, _ =>
      throw "type missmatch"

  | .lt e1 e2, env => do
    let v1 ← eval e1 env
    let v2 ← eval e2 env
    match v1, v2 with
    | .int x, .int y =>
      return .bool (x < y)
    | _, _ =>
      throw "'<' expects integers"

  | .letIn name value body, env => do
    let v ← eval value env
    eval body (fun x =>
      if x == name then
        some v
      else
        env x)

def run (s : String) : Except String Value := do
  let tokens ← lex s
  let expr ← parse tokens
  eval expr emptyEnv

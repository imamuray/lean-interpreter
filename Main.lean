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

def runIO (s : String) : IO Unit := do
  match run s with
  | .ok v =>
    IO.println (repr v)
  | .error e =>
    IO.println s!"error: {e}"

partial def repl : IO Unit := do
  let env := emptyEnv
  IO.println "Mini Interpreter REPL"
  IO.println "type 'exit' to quit"

  let rec loop (env : Env) : IO Unit := do
    IO.print "> "
    let stdin ← IO.getStdin
    let input ← stdin.getLine

    -- 空白行ならスキップ
    if input.all Char.isWhitespace then
      loop env

    if input.trimAscii == "exit" then
      return ()

    match run input with
    | .ok v =>
      IO.println (repr v)
      loop env
    | .error e =>
      IO.println s!"error: {e}"
      loop env
  loop env

def main : IO Unit :=
  repl

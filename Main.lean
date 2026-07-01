import Interpreter.Expr
import Interpreter.Lexer
import Interpreter.Parser

def expr : Expr :=
  Expr.mul
    (Expr.add
      (Expr.int 1)
      (Expr.int 2))
    (Expr.int 3)

#check Nat
#eval expr

def eval : Expr → Env → Except String Int
  | .int n, _ =>
    return n
  | .var x, env =>
    match env x with
    | some v => return v
    | none => throw s!"unknown variable: {x}"
  | .add a b, env => do
    let x ← eval a env
    let y ← eval b env
    return x + y
  | .sub a b, env => do
    let x ← eval a env
    let y ← eval b env
    return x - y
  | .mul a b, env => do
    let x ← eval a env
    let y ← eval b env
    return x * y
  | .div a b, env => do
    let x ← eval a env
    let y ← eval b env
    if y == 0 then
      throw "division by zero"
    else
      return x / y
  | .letIn name value body, env => do
    let v ← eval value env
    eval body (fun x =>
      if x == name then
        some v
      else
        env x)

def env : Env :=
  fun x =>
    if x == "x" then some 5 else none

def testEval : Expr :=
  .div
    (.sub (.mul (.int 10) (.int 5)) (.int 8))
    (.int 2)

def okExpr : Expr :=
  .div (.int 10) (.int 2)
def errExpr : Expr :=
  .div (.int 10) (.int 0)

def testExprVar : Expr :=
  .add (.var "x") (.int 3)

def testExprLetIn : Expr :=
  .letIn
    "x"
    (.int 5)
    (.add (.var "x") (.int 3))

#eval eval testEval env -- .ok 21
#eval eval okExpr env -- .ok 5
#eval eval errExpr env -- .error "dad ivision by zero"
#eval eval testExprVar env -- .ok 8
#eval eval testExprLetIn (fun _ => none) -- .ok 8

def run (s : String) : Except String Int := do
  let tokens ← lex s
  let expr ← parse tokens
  eval expr emptyEnv

#eval run "10 +2*  (3-4)+6/2"

def main : IO Unit :=
  IO.println s!"Hello!"

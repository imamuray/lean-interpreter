import Interpreter.Expr

def expr : Expr :=
  Expr.mul
    (Expr.add
      (Expr.int 1)
      (Expr.int 2))
    (Expr.int 3)

#check Nat
#eval expr

def eval : Expr -> Env -> Except String Int
  | .int n, _ =>
    return n
  | .var x, env =>
    match env x with
    | some v => return v
    | none => throw s!"unknown variable: {x}"
  | .add a b, env => do
    let x <- eval a env
    let y <- eval b env
    return x + y
  | .sub a b, env => do
    let x <- eval a env
    let y <- eval b env
    return x - y
  | .mul a b, env => do
    let x <- eval a env
    let y <- eval b env
    return x * y
  | .div a b, env => do
    let x <- eval a env
    let y <- eval b env
    if y == 0 then
      throw "division by zero"
    else
      return x / y

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

#eval eval testEval env
#eval eval okExpr env
#eval eval errExpr env
#eval eval testExprVar env

def main : IO Unit :=
  IO.println s!"Hello!"

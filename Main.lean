import Interpreter.Expr

def expr : Expr :=
  Expr.mul
    (Expr.add
      (Expr.int 1)
      (Expr.int 2))
    (Expr.int 3)

#check Nat
#eval expr

def eval : Expr -> Except String Int
  | .int n => return n
  | .add a b => do
    let x <- eval a
    let y <- eval b
    return x + y
  | .sub a b => do
    let x <- eval a
    let y <- eval b
    return x - y
  | .mul a b => do
    let x <- eval a
    let y <- eval b
    return x * y
  | .div a b => do
    let x <- eval a
    let y <- eval b
    if y == 0 then
      throw "division by zero"
    else
      return x / y

def testEval : Expr :=
  .div
    (.sub (.mul (.int 10) (.int 5)) (.int 8))
    (.int 2)

def okExpr : Expr :=
  .div (.int 10) (.int 2)
def errExpr : Expr :=
  .div (.int 10) (.int 0)

#eval eval testEval
#eval eval okExpr
#eval eval errExpr

def main : IO Unit :=
  IO.println s!"Hello!"

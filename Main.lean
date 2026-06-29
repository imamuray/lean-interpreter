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
  | .int n => .ok n
  | .add a b =>
    match eval a, eval b with
    | .ok x, .ok y => .ok (x + y)
    | .error e, _ => .error e
    | _, .error e => .error e
  | .sub a b =>
    match eval a, eval b with
    | .ok x, .ok y => .ok (x - y)
    | .error e, _ => .error e
    | _, .error e => .error e
  | .mul a b =>
    match eval a, eval b with
    | .ok x, .ok y => .ok (x * y)
    | .error e, _ => .error e
    | _, .error e => .error e
  | .div a b =>
    match eval a, eval b with
      | .ok _, .ok 0 => .error "division by zero"
      | .ok x, .ok y => .ok (x / y)
      | .error e, _ => .error e
      | _, .error e => .error e

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

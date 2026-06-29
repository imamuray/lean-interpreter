import Interpreter.Expr

def expr : Expr :=
  Expr.mul
    (Expr.add
      (Expr.int 1)
      (Expr.int 2))
    (Expr.int 3)

#check Nat
#eval expr

def eval : Expr -> Int
  | .int n => n
  | .add a b => eval a + eval b
  | .sub a b => eval a - eval b
  | .mul a b => eval a * eval b
  | .div a b => eval a / eval b

def testEval : Expr :=
  .div
    (.sub (.mul (.int 10) (.int 5)) (.int 8))
    (.int 2)

#eval eval testEval

def main : IO Unit :=
  IO.println s!"Hello!"

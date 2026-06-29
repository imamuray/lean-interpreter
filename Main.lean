import Interpreter.Expr

def expr : Expr :=
  Expr.mul
    (Expr.add
      (Expr.int 1)
      (Expr.int 2))
    (Expr.int 3)

#check Nat
#eval expr

def main : IO Unit :=
  IO.println s!"Hello!"

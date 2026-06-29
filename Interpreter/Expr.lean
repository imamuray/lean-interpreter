inductive Expr where
  | int : Int -> Expr
  | add : Expr -> Expr -> Expr
  | sub : Expr -> Expr -> Expr
  | mul : Expr -> Expr -> Expr
  | div : Expr -> Expr -> Expr
deriving Repr

inductive Expr where
  | int : Int → Expr
  | var : String → Expr
  | add : Expr → Expr → Expr
  | sub : Expr → Expr → Expr
  | mul : Expr → Expr → Expr
  | div : Expr → Expr → Expr
  | letIn : String → Expr → Expr → Expr
deriving Repr

abbrev Env := String → Option Int

def emptyEnv : Env :=
  fun _ => none

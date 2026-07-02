inductive Expr where
  | int : Int → Expr
  | var : String → Expr
  | add : Expr → Expr → Expr
  | sub : Expr → Expr → Expr
  | mul : Expr → Expr → Expr
  | div : Expr → Expr → Expr
  | letIn : String → Expr → Expr → Expr
deriving Repr

inductive Value where
  | int : Int → Value
  | bool : Bool → Value -- boolはまだ扱わないが、evalの判定用に先に置いておく
deriving Repr

abbrev Env := String → Option Value

def emptyEnv : Env :=
  fun _ => none

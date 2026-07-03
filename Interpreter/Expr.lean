inductive Expr where
  | int : Int → Expr
  | bool : Bool → Expr
  | var : String → Expr
  | add : Expr → Expr → Expr
  | sub : Expr → Expr → Expr
  | mul : Expr → Expr → Expr
  | div : Expr → Expr → Expr
  | eq : Expr → Expr → Expr
  | lt : Expr → Expr → Expr
  | letIn : String → Expr → Expr → Expr
deriving Repr

inductive Value where
  | int : Int → Value
  | bool : Bool → Value -- boolはまだ扱わないが、evalの判定用に先に置いておく

instance : Repr Value where
  reprPrec v _ :=
    match v with
    | .int n => s!"{n}"
    | .bool b => s!"{b}"

abbrev Env := String → Option Value

def emptyEnv : Env :=
  fun _ => none

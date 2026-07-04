import Interpreter

-- Input:
--   [Token.int 42]
-- Expected:
--   Except.ok (Expr.int 42)
#eval parse [Token.int 42]

-- Input:
--   [Token.trueKw]
-- Expected:
--   Except.ok (Expr.bool true)
#eval parse [Token.trueKw]

-- Input:
--   [Token.ident "foo"]
-- Expected:
--   Except.ok (Expr.var "foo")
#eval parse [Token.ident "foo"]

-- Input:
--   [Token.int 1, Token.plus, Token.int 2]
-- Expected:
--   Except.ok (Expr.add (Expr.int 1) (Expr.int 2))
#eval parse [Token.int 1, Token.plus, Token.int 2]

-- Input:
--   [Token.int 1, Token.plus, Token.int 2, Token.star, Token.int 3]
-- Expected:
--   Except.ok
--     (Expr.add
--       (Expr.int 1)
--       (Expr.mul (Expr.int 2) (Expr.int 3)))
#eval parse [Token.int 1, Token.plus, Token.int 2, Token.star, Token.int 3]

-- Input:
--   [Token.letKw, Token.ident "x", Token.equal,
--    Token.int 10, Token.inKw,
--    Token.ident "x", Token.plus, Token.int 2]
-- Expected:
--   Except.ok
--     (Expr.letIn
--       "x"
--       (Expr.int 10)
--       (Expr.add (Expr.var "x") (Expr.int 2)))
#eval parse
  [Token.letKw, Token.ident "x", Token.equal,
   Token.int 10, Token.inKw,
   Token.ident "x", Token.plus, Token.int 2]

-- Input:
--   [Token.ifKw, Token.trueKw, Token.thenKw, Token.int 1, Token.elseKw, Token.int 2]
-- Expected:
--   Except.ok
--     (Expr.ifThenElse
--       (Expr.bool true)
--       (Expr.int 1)
--       (Expr.int 2))
#eval parse
  [Token.ifKw, Token.trueKw, Token.thenKw,
   Token.int 1, Token.elseKw, Token.int 2]

-- Input:
--   [Token.ifKw, Token.int 1, Token.lt, Token.int 2,
--    Token.thenKw, Token.int 10, Token.elseKw, Token.int 20]
-- Expected:
--   Except.ok
--     (Expr.ifThenElse
--       (Expr.lt (Expr.int 1) (Expr.int 2))
--       (Expr.int 10)
--       (Expr.int 20))
#eval parse
  [Token.ifKw,
   Token.int 1, Token.lt, Token.int 2,
   Token.thenKw,
   Token.int 10,
   Token.elseKw,
   Token.int 20]

-- Input:
--   [Token.ifKw, Token.trueKw, Token.thenKw,
--    Token.ifKw, Token.falseKw, Token.thenKw, Token.int 1, Token.elseKw, Token.int 2,
--    Token.elseKw, Token.int 3]
-- Expected:
--   Except.ok
--     (Expr.ifThenElse
--       (Expr.bool true)
--       (Expr.ifThenElse
--         (Expr.bool false)
--         (Expr.int 1)
--         (Expr.int 2))
--       (Expr.int 3))
#eval parse
  [Token.ifKw, Token.trueKw, Token.thenKw,
   Token.ifKw, Token.falseKw, Token.thenKw,
   Token.int 1, Token.elseKw, Token.int 2,
   Token.elseKw, Token.int 3]

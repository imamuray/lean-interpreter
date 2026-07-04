import Interpreter

-- Input: 42
-- Expected: Except.ok [Token.int 42]
#eval lex "42"

-- Input: 1 + 2
-- Expected: Except.ok [Token.int 1, Token.plus, Token.int 2]
#eval lex "1 + 2"

-- Input: (1 + 2) * 3
-- Expected: Except.ok
--   [Token.lParen, Token.int 1, Token.plus, Token.int 2,
--    Token.rParen, Token.star, Token.int 3]
#eval lex "(1 + 2) * 3"

-- Input: let x = 10 in x + 2
-- Expected: Except.ok
--   [Token.letKw, Token.ident "x", Token.equal,
--    Token.int 10, Token.inKw, Token.ident "x",
--    Token.plus, Token.int 2]
#eval lex "let x = 10 in x + 2"

-- Input: true
-- Expected: Except.ok [Token.trueKw]
#eval lex "true"

-- Input: false
-- Expected: Except.ok [Token.falseKw]
#eval lex "false"

-- Input: if true then 1 else 2
-- Expected: Except.ok
--   [Token.ifKw, Token.trueKw, Token.thenKw,
--    Token.int 1, Token.elseKw, Token.int 2]
#eval lex "if true then 1 else 2"

-- Input: 1 == 2
-- Expected: Except.ok [Token.int 1, Token.eqEq, Token.int 2]
#eval lex "1 == 2"

-- Input: 1 < 2
-- Expected: Except.ok [Token.int 1, Token.lt, Token.int 2]
#eval lex "1 < 2"

-- Input: foo
-- Expected: Except.ok [Token.ident "foo"]
#eval lex "foo"

-- Input: foo123
-- Expected: Except.ok [Token.ident "foo123"]
#eval lex "foo123"

-- Input: let
-- Expected: Except.ok [Token.letKw]
#eval lex "let"

-- Input: trueValue
-- Expected: Except.ok [Token.ident "trueValue"]
#eval lex "trueValue"

-- Input: @
-- Expected: Except.error "...unexpected character..."
#eval lex "@"

-- Input: 1 @ 2
-- Expected: Except.error "...unexpected character..."
#eval lex "1 @ 2"

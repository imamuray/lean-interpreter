import Interpreter

-- Input: 42
-- Expected: Except.ok 42
#eval run "42"

-- Input: true
-- Expected: Except.ok true
#eval run "true"

-- Input: false
-- Expected: Except.ok false
#eval run "false"

-- Input: 1 + 2
-- Expected: Except.ok 3
#eval run "1 + 2"

-- Input: 1 + 2 * 3
-- Expected: Except.ok 7
#eval run "1 + 2 * 3"

-- Input: (1 + 2) * 3
-- Expected: Except.ok 9
#eval run "(1 + 2) * 3"

-- Input: 1 == 1
-- Expected: Except.ok true
#eval run "1 == 1"

-- Input: 1 == 2
-- Expected: Except.ok false
#eval run "1 == 2"

-- Input: 1 < 2
-- Expected: Except.ok true
#eval run "1 < 2"

-- Input: 2 < 1
-- Expected: Except.ok false
#eval run "2 < 1"

-- Input: let x = 10 in x + 2
-- Expected: Except.ok 12
#eval run "let x = 10 in x + 2"

-- Input: let x = 1 in let x = 2 in x
-- Expected: Except.ok 2
#eval run "let x = 1 in let x = 2 in x"

-- Input: if true then 1 else 2
-- Expected: Except.ok 1
#eval run "if true then 1 else 2"

-- Input: if false then 1 else 2
-- Expected: Except.ok 2
#eval run "if false then 1 else 2"

-- Input: if 1 < 2 then 10 else 20
-- Expected: Except.ok 10
#eval run "if 1 < 2 then 10 else 20"

-- Input: let x = 5 in if x < 10 then x + 1 else x
-- Expected: Except.ok 6
#eval run "let x = 5 in if x < 10 then x + 1 else x"

-- Input: x
-- Expected: Except.error
#eval run "x"

-- Input: true + 1
-- Expected: Except.error
#eval run "true + 1"

-- Input: if 1 then 2 else 3
-- Expected: Except.error
#eval run "if 1 then 2 else 3"

-- Input: let x = in 1
-- Expected: Except.error
#eval run "let x = in 1"

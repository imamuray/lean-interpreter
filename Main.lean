import Interpreter

partial def repl : IO Unit := do
  let env := emptyEnv
  IO.println "Mini Interpreter REPL"
  IO.println "type 'exit' to quit"

  let rec loop (env : Env) : IO Unit := do
    IO.print "> "
    let stdin ← IO.getStdin
    let input ← stdin.getLine

    -- 空白行ならスキップ
    if input.all Char.isWhitespace then
      loop env

    if input.trimAscii == "exit" then
      return ()

    match run input with
    | .ok v =>
      IO.println (repr v)
      loop env
    | .error e =>
      IO.println s!"error: {e}"
      loop env
  loop env

def main : IO Unit :=
  repl

from std/tables import toTable, contains, `[]`

from errors import Error, newError
from tokens import TokenKind, Token, newToken

type Lexer* = ref object
  index: int
  start: int

  line: int
  column: int

  input: string
  output: seq[Token]
  errors: seq[Error]

proc newLexer*(
  input: string;
): Lexer = Lexer(index: 0, start: 0, line: 1, column: 1, input: input, output: newSeq[Token](), errors: newSeq[Error]())

using lexer: Lexer

const RESERVED_LEXEMES = toTable({
  "": ""
})

proc tokenize*(lexer): void = discard

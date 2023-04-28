from std/tables import toTable, contains, pairs, `[]`
from std/strutils import contains
from std/sequtils import toSeq, filter, map, concat, deduplicate
from std/setutils import toSet
from std/sugar import `=>`

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

proc eos(lexer; l: int = 0): bool = lexer.index + l > high lexer.input
proc reset(lexer): void = lexer.start = lexer.index

proc lexeme(lexer): string = lexer.input[lexer.start..lexer.index-1]

proc get(lexer; l: int = 0): char =
  if lexer.eos(l):
    return '\0'
  else:
    return lexer.input[lexer.index + l]

proc add(lexer; kind: TokenKind): void = lexer.output.add(newToken(kind, lexer.lexeme(), lexer.line, lexer.column))

proc nextColumn(lexer): void =
  lexer.index.inc()
  lexer.column.inc()

proc backColumn(lexer): void =
  lexer.index.dec()
  lexer.column.dec()

proc nextLine(lexer): void =
  lexer.index.inc()
  lexer.line.inc()
  lexer.column = 1

proc error(lexer; msg: string = "Unexpected character '" & $lexer.get() & "'"): void =
  lexer.errors.add(newError("[Lexer]: " & msg, lexer.line, lexer.column))

const RESERVED_LEXEMES = toTable({
  "+":            TK_O_ADD
})

const DIGIT = {'0'..'9'}
const ALPHA = {'a'..'z', 'A'..'Z'}
const IDENT = DIGIT + ALPHA + {'_'}

const CONTROL = {'\x00'..'\x1F'}
const NEW_LINE = {'\n'}
const WHITE_SPACE = {' ', '\t', '\r'}

const COM_DELIM = {'#'}
const STR_DELIM = {'\'', '\"'}

const SYMBOL_CHARACTERS = RESERVED_LEXEMES.pairs()
                                          .toSeq()
                                          .filter(x => not x[0].contains(ALPHA + DIGIT))
                                          .map(x => x[0].toSeq())
                                          .concat()
                                          .deduplicate()
                                          .toSet()
proc tokenize*(lexer): void =
  while not lexer.eos():
    lexer.reset()

    case lexer.get():
    of NEW_LINE:
      lexer.nextLine()
    of WHITE_SPACE:
      lexer.nextColumn()
    of COM_DELIM:
      while lexer.get() notin CONTROL:
        lexer.nextColumn()
    of STR_DELIM:
      lexer.nextColumn()
      while lexer.get() notin CONTROL + STR_DELIM:
        lexer.nextColumn()
      lexer.nextColumn()

      lexer.add(TK_C_TEXT)
    of DIGIT:
      while lexer.get() in DIGIT + {'_', '.'}:
        lexer.nextColumn()

      lexer.add(TK_C_REAL)
    of SYMBOL_CHARACTERS:
      while lexer.get() in SYMBOL_CHARACTERS:
        lexer.nextColumn()

      while lexer.lexeme() notin RESERVED_LEXEMES and lexer.start < lexer.index:
        lexer.backColumn()

      if lexer.lexeme() in RESERVED_LEXEMES:
        lexer.add(RESERVED_LEXEMES[lexer.lexeme()])
      else:
        lexer.error()
        lexer.nextColumn()
    of ALPHA:
      while lexer.get() in IDENT:
        lexer.nextColumn()

      if lexer.lexeme() in RESERVED_LEXEMES:
        lexer.add(RESERVED_LEXEMES[lexer.lexeme()])
      else:
        lexer.add(TK_C_IDENTIFIER)
    else:
      lexer.error()
      lexer.nextColumn()

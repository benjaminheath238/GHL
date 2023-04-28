from ast import NodeKind, Node
from errors import Error,  newError
from tokens import TokenKind, Token

type Parser* = ref object
  index: int

  input: seq[Token]
  output: Node
  errors: seq[Error]

proc newParser*(
  input: seq[Token];
): Parser = Parser(index: 0, input: input, output: ast.newBlockNode(), errors: newSeq[Error]())

using parser: Parser

proc parseExpr(parser; precedence: int = 0, isPrimary: bool = false): Node = discard

proc parseStmt(parser): Node = discard

proc parse*(parser): void = discard

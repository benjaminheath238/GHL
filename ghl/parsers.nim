from std/tables import toTable, contains, pairs, `[]`

from ast import NodeKind, Node
from errors import Error,  newError
from tokens import TokenKind, Token, newToken

type Parser* = ref object
  index: int

  input: seq[Token]
  output: Node
  errors: seq[Error]

proc newParser*(
  input: seq[Token];
): Parser = Parser(index: 0, input: input, output: ast.newBlockNode(), errors: newSeq[Error]())

using parser: Parser

proc eos(parser; l: int = 0): bool = parser.index + l > high parser.input

proc get(parser; l: int = 0): Token =
  if parser.eos():
    return newToken(TK_S_EOS, "EOS", -1, -1)
  else:
    return parser.input[parser.index + l]

proc next(parser): void = parser.index.inc()

proc error(parser; msg: string = "Unexpected token '" & parser.get().lexeme & "'"): void = parser.errors.add(newError("[Parser]: " & msg, parser.get().line, parser.get().column))

proc matches(parser; kinds: set[TokenKind]; l: int = 0): bool = parser.get(l).kind in kinds

proc panik(parser; kinds: set[TokenKind]; msg: string): void =
  parser.error(msg)

  while not parser.eos() and not parser.matches(kinds):
    parser.next()

proc expects(parser; kinds: set[TokenKind], msg: string): void =
  if parser.matches(kinds):
    parser.next()
  else:
    parser.panik(kinds, msg)
    parser.next()

const OPERATOR_PROPERTIES = toTable({
  TK_O_ADD:             (bop: (isRightAssociative: false, precedence: 0), uop: (precedence: 0))
})

const BINARY_OPERATORS = {TK_O_ADD}
const UNARY_OPERATORS = {TK_O_ADD}
const EXPR_FIRSTS = {TK_C_TEXT, TK_C_REAL, TK_C_IDENTIFIER}
const STMT_FIRSTS = {TK_O_ADD}

proc parseExpr(parser; precedence: int = 0, isPrimary: bool = false): Node =
  if isPrimary:
    case parser.get().kind:
    of UNARY_OPERATORS:
      result = ast.newUnaryExprNode(parser.get().line, parser.get().column)

      parser.expects(UNARY_OPERATORS, "Expected an unary operator")

      result.unaryOperator = parser.get(-1).kind

      result.unaryOperand0 = parser.parseExpr(precedence=OPERATOR_PROPERTIES[result.unaryOperator].uop.precedence, isPrimary=true)
    of TK_C_TEXT:
      result = ast.newTextConstExprNode(parser.get().line, parser.get().column)

      parser.expects({TK_C_TEXT}, "Expected a text constant")

      result.textValue = parser.get(-1).lexeme
    of TK_C_REAL:
      result = ast.newRealConstExprNode(parser.get().line, parser.get().column)

      parser.expects({TK_C_REAL}, "Expected a real (number) constant")

      result.realValue = parser.get(-1).lexeme
    else:
      parser.panik(EXPR_FIRSTS, "Expected a text or real literal or a unary expression")

      result = parser.parseExpr()
  else:
    result = parser.parseExpr(isPrimary=true)

    while parser.matches(BINARY_OPERATORS, 1) and OPERATOR_PROPERTIES[parser.get(1).kind].bop.precedence >= precedence:
      result = ast.newBinaryExprNode(parser.get().line, parser.get().column, operand0=result)

      parser.expects(BINARY_OPERATORS, "Expected a binary operator")

      result.binaryOperator = parser.get(-1).kind

      result.binaryOperand1 = parser.parseExpr(precedence=
        if OPERATOR_PROPERTIES[result.binaryOperator].bop.isRightAssociative:
          OPERATOR_PROPERTIES[result.binaryOperator].bop.precedence + 0
        else:
          OPERATOR_PROPERTIES[result.binaryOperator].bop.precedence + 1
      )

proc parseStmt(parser): Node =
  case parser.get().kind:
  else:
    parser.panik(STMT_FIRSTS, "Expected one of ...")

    result = parser.parseStmt()

proc parse*(parser): void =
  while not parser.eos():
    parser.output.blockBody.add(parser.parseStmt())

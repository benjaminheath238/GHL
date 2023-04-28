from tokens import TokenKind

type
  NodeKind* = enum
    NK_BLOCK

    NK_INSTRUCTION

    NK_BINARY_EXPR
    NK_UNARY_EXPR
    
    NK_TEXT_CONST_EXPR
    NK_REAL_CONST_EXPR

  Node* = ref object
    line: int
    column: int
    
    case kind: NodeKind:
    of NK_BLOCK:
      blockBody*: seq[Node]
    of NK_INSTRUCTION:
      instructionKind*: TokenKind
      instructionArgs*: seq[Node]
    of NK_BINARY_EXPR:
      binaryOperand0*: Node
      binaryOperator*: TokenKind
      binaryOperand1*: Node
    of NK_UNARY_EXPR:
      unaryOperator*: TokenKind
      unaryOperand0*: Node
    of NK_TEXT_CONST_EXPR:
      textValue*: string
    of NK_REAL_CONST_EXPR:
      realValue*: string

proc newBlockNode*(
  line: int = 0;
  column: int = 0;

  body: seq[Node] = newSeq[Node]();
): Node = Node(line: line, column: column, kind: NK_BLOCK, blockBody: body)

proc newInstructionNode*(
  line: int = 0;
  column: int = 0;

  kind: TokenKind;
  args: seq[Node] = newSeq[Node]();
): Node = Node(line: line, column: column, kind: NK_INSTRUCTION, instructionKind: kind, instructionArgs: args)

proc newBinaryExprNode*(
  line: int = 0;
  column: int = 0;

  operand0: Node = nil;
  operator: TokenKind = TK_S_EOS;
  operand1: Node = nil;
): Node = Node(line: line, column: column, kind: NK_BINARY_EXPR, binaryOperand0: operand0, binaryOperator: operator, binaryOperand1: operand1)

proc newUnaryExprNode*(
  line: int = 0;
  column: int = 0;

  operator: TokenKind = TK_S_EOS;
  operand0: Node = nil;
): Node = Node(line: line, column: column, kind: NK_UNARY_EXPR, unaryOperator: operator, unaryOperand0: operand0)

proc newTextConstExprNode*(
  line: int = 0;
  column: int = 0;

  value: string = "";
): Node = Node(line: line, column: column, kind: NK_TEXT_CONST_EXPR, textValue: value)

proc newRealConstExprNode*(
  line: int = 0;
  column: int = 0;

  value: string = "";
): Node = Node(line: line, column: column, kind: NK_REAL_CONST_EXPR, realValue: value)

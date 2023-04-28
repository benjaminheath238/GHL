from tokens import TokenKind

type
  NodeKind* = enum
    NK_BLOCK

    NK_INSTRUCTION

  Node* = ref object
    line: int
    column: int
    
    case kind: NodeKind:
    of NK_BLOCK:
      blockBody: seq[Node]
    of NK_INSTRUCTION:
      instructionKind: TokenKind
      instructionArgs: seq[Node]

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

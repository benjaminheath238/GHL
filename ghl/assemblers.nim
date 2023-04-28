from ast import Node
from errors import Error

type Assembler* = ref object
  input: Node
  output: seq[byte]
  errors: seq[Error]

proc newAssembler*(
  input: Node;
): Assembler = Assembler(input: input, output: newSeq[byte](), errors: newSeq[Error]())

using assembler: Assembler

proc assemble*(assembler; node: Node): seq[byte] = discard

proc assemble*(assembler): void = discard

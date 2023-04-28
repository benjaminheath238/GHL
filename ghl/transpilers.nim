from ast import Node
from errors import Error

type Transpiler* = ref object
  input: Node
  output: string
  errors: seq[Error]

proc newTranspiler*(
  input: Node;
): Transpiler = Transpiler(input: input, output: "", errors: newSeq[Error]())

using transpiler: Transpiler

proc transpile*(transpiler; node: Node): string = discard

proc transpile*(transpiler): void = discard

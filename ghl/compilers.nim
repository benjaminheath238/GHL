from ast import Node
from errors import Error

type Compiler* = ref object
  input: Node
  output: Node
  errors: seq[Error]

proc newCompiler*(
  input: Node;
): Compiler = Compiler(input: input, output: ast.newBlockNode(), errors: newSeq[Error]())

using compiler: Compiler

proc compile*(compiler; node: Node): Node = discard

proc compile*(compiler): void = discard

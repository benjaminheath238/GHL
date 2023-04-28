from ast import Node
from errors import Error

type Optimizer* = ref object
  input: Node
  output: Node
  errors: seq[Error]

proc newOptimizer*(
  input: Node;
): Optimizer = Optimizer(input: input, output: ast.newBlockNode(), errors: newSeq[Error]())

using optimizer: Optimizer

proc optimize(optimizer; node: Node): Node = discard

proc optimize*(optimizer): void = discard

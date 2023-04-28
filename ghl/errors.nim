type
  Error* = ref object
    msg: string
    
    line: int
    column: int
    
proc newError*(
  msg: string;
  
  line: int = -1;
  column: int = -1;
): Error = Error(msg: msg, line: line, column: column)

proc `$`*(this: Error): string =
  if this.line == -1 or this.column == -1:
    return this.msg
  else:
    return this.msg & " at " & $this.line & ":" & $this.column

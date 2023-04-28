type
  TokenKind* = enum
    TK_C_IDENTIFIER

  Token* = ref object
    kind*: TokenKind
    
    lexeme*: string

    line*: int
    column*: int
  
proc newToken*(
  kind: TokenKind;
  
  lexeme: string;

  line: int;
  column: int;
): Token = Token(kind: kind, lexeme: lexeme, line: line, column: column)

proc `$`*(this: Token): string =
  return $this.kind & ", " & $this.lexeme & ", " & $this.line & ":" & $this.column

type
  TokenKind* = enum
    TK_C_TEXT
    TK_C_REAL
    TK_C_IDENTIFIER

    TK_O_ADD

    TK_S_EOS

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

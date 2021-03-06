%using ScannerHelper;
%namespace SimpleScanner

%x COMMENT

Alpha	[a-zA-Z_]
Digit	[0-9] 
AlphaDigit	{Alpha}|{Digit}
INTNUM	{Digit}+
REALNUM	{INTNUM}\.{INTNUM}
ID	{Alpha}{AlphaDigit}* 
DotChr	[^\r\n]
ONELINECMNT 	\/\/{DotChr}*
STRING	\'[^']*\'	

// ����� ����� ������ �������� �����, ���������� � ������� - ��� �������� � ����� Scanner
%{
  public int LexValueInt;
  public double LexValueDouble;
  public List<String> Ids = new List<String>();
%}

%%
{INTNUM} { 
  LexValueInt = int.Parse(yytext);
  return (int)Tok.INUM;
}

{REALNUM} { 
  LexValueDouble = double.Parse(yytext);
  return (int)Tok.RNUM;
}

begin { 
  return (int)Tok.BEGIN;
}

end { 
  return (int)Tok.END;
}

cycle { 
  return (int)Tok.CYCLE;
}

{ONELINECMNT} {
  return (int)Tok.ONELINECMNT;
}

{STRING} {
  return (int)Tok.STRING;
}

{ID} { 
  return (int)Tok.ID;
}

<COMMENT>{ID} {
  Ids.Add(yytext);
}

":" { 
  return (int)Tok.COLON;
}

":=" { 
  return (int)Tok.ASSIGN;
}

";" { 
  return (int)Tok.SEMICOLON;
}

"{" { 
  // ������� � ��������� COMMENT
  BEGIN(COMMENT);
}
 
<COMMENT> "}" { 
  // ������� � ��������� INITIAL
  BEGIN(INITIAL);
}

[^ \r\n] {
	LexError();
	return 0; // ����� �������
}

%%

// ����� ����� ������ �������� ���������� � ������� - ��� ���� �������� � ����� Scanner

public void LexError()
{
	Console.WriteLine("({0},{1}): ����������� ������ {2}", yyline, yycol, yytext);
}

public string TokToString(Tok tok)
{
	switch (tok)
	{
		case Tok.ID:
			return tok + " " + yytext;
		case Tok.INUM:
			return tok + " " + LexValueInt;
		case Tok.RNUM:
			return tok + " " + LexValueDouble;
		default:
			return tok + "";
	}
}


UNIT WordCounter;

INTERFACE

USES
  Alphabet,
  Tree;

FUNCTION ReadWord(VAR F: TEXT): Str255;
PROCEDURE CountWord(CONST Word: Str255);
PROCEDURE PrintWordsList(VAR F: TEXT);

IMPLEMENTATION

VAR
  Root: PTreeNode;

FUNCTION ReadWord(VAR F: TEXT): Str255;
VAR
  Ch: CHAR;
  CurrentWord: Str255;
BEGIN
  CurrentWord := '';
  Ch := 'A';
  WHILE NOT EOF(F) AND (Ch <> ' ')
  DO
    BEGIN
      READ(F, Ch);
      Ch := Scrub(Ch);
      IF EOLN(F) AND (Ch = '-') AND NOT EOF(F)
      THEN
        BEGIN
          READLN(F);
          READ(F, Ch);
          Ch := Scrub(Ch)
        END;
      IF Ch <> ' '
      THEN
        CurrentWord := CurrentWord + Ch
    END;
  ReadWord := CurrentWord
END;

PROCEDURE CountWord(CONST Word: Str255);
BEGIN
  IF Word <> ''
  THEN
    InsertNode(Root, Word)
END;

PROCEDURE PrintWordsList(VAR F: TEXT);
BEGIN
  PrintTree(Root, F)
END;

END.

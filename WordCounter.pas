UNIT WordCounter;

INTERFACE

USES
  Alphabet,
  Tree;

PROCEDURE GroupWords(VAR InputFile, OutputFile, TempFile: TEXT);

IMPLEMENTATION

PROCEDURE ReadWord(VAR F: TEXT; VAR Word: Str255);
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
  Word := CurrentWord
END;

FUNCTION IsValidWord(VAR Word: Str255): BOOLEAN;
VAR
  I: INTEGER;
BEGIN
  IsValidWord := TRUE;
  IF (LENGTH(Word) > 2) AND ((Word[1] = '-') OR (Word[LENGTH(Word)] = '-')) OR (Word = '')
  THEN
    IsValidWord := FALSE;
END;

PROCEDURE CountWord(VAR Word: Str255);
BEGIN
  IF IsValidWord(Word)
  THEN
    InsertWord(Word)
END;

PROCEDURE GroupWords(VAR InputFile, OutputFile, TempFile: TEXT);
VAR
  Unique, All: INTEGER;
  Word: Str255;
BEGIN
  RESET(InputFile);
  WHILE NOT EOF(InputFile)
  DO
    BEGIN
      ReadWord(InputFile, Word);
      CountWord(Word);
      WordCount(Unique, All);
      IF Unique = 10000
      THEN
        SaveToFile(TempFile)
    END;
  RESET(TempFile);
  LoadFromFile(TempFile);
  REWRITE(OutputFile);
  WordCount(Unique, All);
  WRITELN(OutputFile, 'Unique words ', Unique);
  WRITELN(OutputFile, 'Total words ', All);
  SaveToFile(OutputFile)
END;

END.

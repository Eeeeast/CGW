UNIT WordCounter;

INTERFACE

USES
  Alphabet,
  Tree;

PROCEDURE GroupWords(VAR InputFile, OutputFile: TEXT);

IMPLEMENTATION

PROCEDURE ReadWord(VAR F: TEXT; VAR Word: STRING);
VAR
  Ch: CHAR;
  CurrentWord: STRING[255];
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
          Ch := Scrub(Ch);
          IF Ch = ' '
          THEN
            CurrentWord := CurrentWord + '-'
        END;
      IF Ch <> ' '
      THEN
        CurrentWord := CurrentWord + Ch
    END;
  Word := CurrentWord
END;

FUNCTION IsValidWord(VAR Word: STRING): BOOLEAN;
VAR
  I: INTEGER;
BEGIN
  IsValidWord := TRUE;
  IF (LENGTH(Word) >= 2) AND ((Word[1] = '-') OR (Word[LENGTH(Word)] = '-')) OR (Word = '-') OR (Word = '')
  THEN
    IsValidWord := FALSE
END;

PROCEDURE CountWord(VAR Word: STRING);
BEGIN
  IF IsValidWord(Word)
  THEN
    InsertWord(Word)
END;

PROCEDURE GroupWords(VAR InputFile, OutputFile: TEXT);
VAR
  Unique, All: INTEGER;
  Word: STRING[255];
BEGIN
  RESET(InputFile);
  WHILE NOT EOF(InputFile)
  DO
    BEGIN
      ReadWord(InputFile, Word);
      CountWord(Word);
      WordCount(Unique, All)
    END;
  REWRITE(OutputFile);
  WordCount(Unique, All);
  WRITELN(OutputFile, 'Unique words ', Unique);
  WRITELN(OutputFile, 'Total words ', All);
  SaveToFileAndClear(OutputFile)
END;

END.

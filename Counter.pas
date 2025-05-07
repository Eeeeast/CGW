UNIT Counter;

INTERFACE

USES
  Tree,
  Scraper;

PROCEDURE CountWords(CONST FileName: Str255);

IMPLEMENTATION

FUNCTION CompareStr(S1, S2: STRING): INTEGER;
VAR
  I: INTEGER;
BEGIN
  I := 1;
  WHILE (I < LENGTH(S1)) AND (I < LENGTH(S2)) AND (I <> -1)
  DO
    BEGIN
      IF FindPosition(S1[I]) < FindPosition(S2[I])
      THEN
        BEGIN
          CompareStr := -1;
          I := -1
        END
      ELSE
        IF FindPosition(S1[I]) > FindPosition(S2[I])
        THEN
          BEGIN
            CompareStr := 1;
            I := -1
          END
        ELSE
          I := I + 1
    END;
  IF I <> -1
  THEN
    IF LENGTH(S1) > LENGTH(S2)
    THEN
      CompareStr := -1
    ELSE
      IF LENGTH(S1) < LENGTH(S2)
      THEN
        CompareStr := 1
      ELSE
        CompareStr := 0
END;

PROCEDURE InsertWord(VAR Root: PTreeNode; CONST Word: Str255);
VAR
  Comparison: INTEGER;
BEGIN
  IF Root = NIL
  THEN
    Root := CreateNode(Word)
  ELSE
    BEGIN
      Comparison := CompareStr(Word, Root^.Word);
      IF Comparison < 0
      THEN
        InsertWord(Root^.Left, Word)
      ELSE
        IF Comparison > 0
        THEN
          InsertWord(Root^.Right, Word)
        ELSE
          Root^.Count := Root^.Count + 1
    END
END;

PROCEDURE CountWords(CONST FileName: Str255);
VAR
  F: TEXT;
  Ch: CHAR;
  CurrentWord: Str255;
BEGIN
  Root := NIL;
  ASSIGN(F, FileName);
  RESET(F);
  CurrentWord := '';
  WHILE NOT EOF(F)
  DO
    BEGIN
      READ(F, Ch);
      Ch := Scrub(Ch);
      IF Ch <> ' '
      THEN
        CurrentWord := CurrentWord + Ch
      ELSE
        IF CurrentWord <> ''
        THEN
          BEGIN
            InsertWord(Root, CurrentWord);
            CurrentWord := ''
          END
    END;
  IF CurrentWord <> ''
  THEN
    InsertWord(Root, CurrentWord);
  CLOSE(F);
END;

END.

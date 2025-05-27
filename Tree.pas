UNIT Tree;

INTERFACE

USES
  Alphabet;

PROCEDURE SaveToFileAndClear(VAR F: TEXT);
PROCEDURE InsertWord(CONST Word: STRING);
PROCEDURE WordCount(VAR Unique, All: INTEGER);

IMPLEMENTATION

CONST
  MAX_UNIQUE_WORDS = 10000;
  MainTempFileName = 'temp.txt';
  TempFileName1 = 'temp1.txt';
  TempFileName2 = 'temp2.txt';

TYPE
  PTreeNode = ^TTreeNode;
  TTreeNode = RECORD
                Word: STRING[255];
                Count: INTEGER;
                Left, Right: PTreeNode
              END;

VAR
  Root: PTreeNode;
  UniqueWords, AllWords: INTEGER;

PROCEDURE PrintTree(Root: PTreeNode; VAR F: TEXT);
BEGIN
  IF Root <> NIL
  THEN
    BEGIN
      PrintTree(Root^.Left, F);
      WRITELN(F, Root^.Word, ' ', Root^.Count);
      PrintTree(Root^.Right, F)
    END
END;

PROCEDURE DestroyTree(VAR Root: PTreeNode);
BEGIN
  IF Root <> NIL
  THEN
    BEGIN
      DestroyTree(Root^.Left);
      DestroyTree(Root^.Right);
      DISPOSE(Root);
      Root := NIL
    END
END;

PROCEDURE Clear;
BEGIN
  DestroyTree(Root);
  UniqueWords := 0;
  AllWords := 0
END;

PROCEDURE MergeStatistics;
VAR
  MainFile, TempFile1, TempFile2: TEXT;
  Word1, Word2: STRING[255];
  Count1, Count2: INTEGER;
  Ch: CHAR;
  HasWord1, HasWord2: BOOLEAN;
BEGIN
  ASSIGN(MainFile, MainTempFileName);
  ASSIGN(TempFile1, TempFileName1);
  ASSIGN(TempFile2, TempFileName2);

  RESET(MainFile);
  REWRITE(TempFile1);
  WHILE NOT EOF(MainFile)
  DO
    BEGIN
      READ(MainFile, Ch);
      WRITE(TempFile1, Ch)
    END;

  REWRITE(TempFile2);
  SaveToFileAndClear(TempFile2);

  RESET(TempFile1);
  RESET(TempFile2);
  REWRITE(MainFile);

  HasWord1 := FALSE;
  HasWord2 := FALSE;

  IF NOT EOF(TempFile1)
  THEN
    BEGIN
      Word1 := '';
      READ(TempFile1, Ch);
      WHILE (Ch <> ' ') AND NOT EOLN(TempFile1)
      DO
        BEGIN
          Word1 := Word1 + Ch;
          READ(TempFile1, Ch)
        END;
      READLN(TempFile1, Count1);
      HasWord1 := TRUE
    END;

  IF NOT EOF(TempFile2)
  THEN
    BEGIN
      Word2 := '';
      READ(TempFile2, Ch);
      WHILE (Ch <> ' ') AND NOT EOLN(TempFile2)
      DO
        BEGIN
          Word2 := Word2 + Ch;
          READ(TempFile2, Ch)
        END;
      READLN(TempFile2, Count2);
      HasWord2 := TRUE
    END;

  WHILE HasWord1 OR HasWord2
  DO
    BEGIN
      IF HasWord1 AND (NOT HasWord2 OR (CompareStrings(Word1, Word2) <= crEqual))
      THEN
        BEGIN
          IF HasWord2 AND (CompareStrings(Word1, Word2) = crEqual)
          THEN
            BEGIN
              WRITELN(MainFile, Word1, ' ', Count1 + Count2);
              HasWord2 := FALSE;
              IF NOT EOF(TempFile2)
              THEN
                BEGIN
                  Word2 := '';
                  READ(TempFile2, Ch);
                  WHILE (Ch <> ' ') AND NOT EOLN(TempFile2)
                  DO
                    BEGIN
                      Word2 := Word2 + Ch;
                      READ(TempFile2, Ch)
                    END;
                  READLN(TempFile2, Count2);
                  HasWord2 := TRUE
                END
            END
          ELSE
            WRITELN(MainFile, Word1, ' ', Count1);
          HasWord1 := FALSE;
          IF NOT EOF(TempFile1)
          THEN
            BEGIN
              Word1 := '';
              READ(TempFile1, Ch);
              WHILE (Ch <> ' ') AND NOT EOLN(TempFile1)
              DO
                BEGIN
                  Word1 := Word1 + Ch;
                  READ(TempFile1, Ch)
                END;
              READLN(TempFile1, Count1);
              HasWord1 := TRUE
            END
        END
      ELSE
        IF HasWord2
        THEN
          BEGIN
            WRITELN(MainFile, Word2, ' ', Count2);
            HasWord2 := FALSE;
            IF NOT EOF(TempFile2)
            THEN
              BEGIN
                Word2 := '';
                READ(TempFile2, Ch);
                WHILE (Ch <> ' ') AND NOT EOLN(TempFile2)
                DO
                  BEGIN
                    Word2 := Word2 + Ch;
                    READ(TempFile2, Ch)
                  END;
                READLN(TempFile2, Count2);
                HasWord2 := TRUE
              END
          END
    END;

  CLOSE(TempFile1);
  CLOSE(TempFile2);
  CLOSE(MainFile)
END;

FUNCTION CreateNode(CONST Word: STRING; Count: INTEGER): PTreeNode;
VAR
  Node: PTreeNode;
BEGIN
  NEW(Node);
  Node^.Word := Word;
  Node^.Count := Count;
  Node^.Left := NIL;
  Node^.Right := NIL;
  UniqueWords := UniqueWords + 1;
  AllWords := AllWords + Count;
  CreateNode := Node
END;

PROCEDURE InsertNode(VAR Root: PTreeNode; CONST Word: STRING; Count: INTEGER);
BEGIN
  IF Root = NIL
  THEN
    Root := CreateNode(Word, Count)
  ELSE
    CASE CompareStrings(Word, Root^.Word)
    OF
      crLower: InsertNode(Root^.Left, Word, Count);
      crEqual: BEGIN
               Root^.Count := Root^.Count + Count;
               AllWords := AllWords + Count
             END;
      crHigher: InsertNode(Root^.Right, Word, Count)
    END;
  IF UniqueWords >= MAX_UNIQUE_WORDS
  THEN
    BEGIN
      MergeStatistics;
      Clear
    END
END;

PROCEDURE InsertWord(CONST Word: STRING);
BEGIN
  InsertNode(Root, Word, 1)
END;

PROCEDURE SaveToFileAndClear(VAR F: TEXT);
BEGIN
  PrintTree(Root, F);
  Clear
END;

PROCEDURE LoadFromFile(VAR F: TEXT);
VAR
  Ch: CHAR;
  Word: STRING[255];
  Count: INTEGER;
BEGIN
  WHILE NOT EOF(F)
  DO
    BEGIN
      Word := '';
      Count := 1;
      Ch := 'A';
      WHILE NOT EOLN(F) AND (Ch <> ' ')
      DO
        BEGIN
          READ(F, Ch);
          Ch := Scrub(Ch);
          IF Ch <> ' '
          THEN
            Word := Word + Ch
        END;
      IF NOT EOLN(F)
      THEN
        READ(F, Count);
      READLN(F);
      InsertNode(Root, Word, Count)
    END
END;

PROCEDURE WordCount(VAR Unique, All: INTEGER);
BEGIN
  Unique := UniqueWords;
  All := AllWords
END;

BEGIN
  Root := NIL;
  UniqueWords := 0;
  AllWords := 0
END.

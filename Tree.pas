UNIT Tree;

INTERFACE

USES
  Alphabet;

TYPE
  Str255 = STRING[255];

PROCEDURE SaveToFile(VAR F: TEXT);
PROCEDURE LoadFromFile(VAR F: TEXT);
PROCEDURE InsertWord(CONST Word: Str255);
PROCEDURE WordCount(VAR Unique, All: INTEGER);

IMPLEMENTATION

TYPE
  PTreeNode = ^TTreeNode;
  TTreeNode = RECORD
                Word: Str255;
                Count: INTEGER;
                Left, Right: PTreeNode
              END;

VAR
  Root: PTreeNode;

FUNCTION CreateNode(CONST Word: Str255; Count: INTEGER): PTreeNode;
VAR
  Root: PTreeNode;
BEGIN
  NEW(Root);
  Root^.Word := Word;
  Root^.Count := Count;
  Root^.Left := NIL;
  Root^.Right := NIL;
  CreateNode := Root
END;

PROCEDURE InsertNode(VAR Root: PTreeNode; CONST Word: Str255; Count: INTEGER);
BEGIN
  IF Root = NIL
  THEN
    Root := CreateNode(Word, Count)
  ELSE
    CASE CompareStr(Word, Root^.Word)
    OF
      Lower: InsertNode(Root^.Left, Word, Count);
      Equal: Root^.Count := Root^.Count + Count;
      Higher: InsertNode(Root^.Right, Word, Count)
    END
END;

PROCEDURE InsertWord(CONST Word: Str255);
BEGIN
  InsertNode(Root, Word, 1)
END;

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

PROCEDURE SaveToFile(VAR F: TEXT);
BEGIN
  PrintTree(Root, F)
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

PROCEDURE LoadFromFile(VAR F: TEXT);
VAR
  Ch: CHAR;
  Word: Str255;
  Count: INTEGER;
BEGIN
  DestroyTree(Root);
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

PROCEDURE TreeWordCount(VAR Root: PTreeNode; VAR Unique, All: INTEGER);
BEGIN
  IF Root <> NIL
  THEN
    BEGIN
      Unique := Unique + 1;
      All := All + Root^.Count;
      TreeWordCount(Root^.Left, Unique, All);
      TreeWordCount(Root^.Right, Unique, All)
    END
END;

PROCEDURE WordCount(VAR Unique, All: INTEGER);
BEGIN
  Unique := 0;
  All := 0;
  TreeWordCount(Root, Unique, All)
END;

BEGIN
  Root := NIL
END.

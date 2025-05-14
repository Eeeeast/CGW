UNIT Tree;

INTERFACE

USES
  Alphabet;

TYPE
  Str255 = STRING[255];

PROCEDURE SaveToFile(VAR F: TEXT);
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

FUNCTION CreateNode(CONST Word: Str255): PTreeNode;
VAR
  Root: PTreeNode;
BEGIN
  NEW(Root);
  Root^.Word := Word;
  Root^.Count := 1;
  Root^.Left := NIL;
  Root^.Right := NIL;
  CreateNode := Root
END;

PROCEDURE InsertNode(VAR Root: PTreeNode; CONST Word: Str255);
BEGIN
  IF Root = NIL
  THEN
    Root := CreateNode(Word)
  ELSE
    CASE CompareStr(Word, Root^.Word)
    OF
      Lower: InsertNode(Root^.Left, Word);
      Equal: Root^.Count := Root^.Count + 1;
      Higher: InsertNode(Root^.Right, Word)
    END
END;

PROCEDURE InsertWord(CONST Word: Str255);
BEGIN
  InsertNode(Root, Word)
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

PROCEDURE TreeWordCount(VAR Root: PTreeNode; VAR Unique, All: INTEGER);
BEGIN
  IF Root <> NIL
  THEN
    BEGIN
      Unique := Unique + 1;
      All := All + Root^.Count;
      TreeWordCount(Root^.Left, Unique, All);
      TreeWordCount(Root^.Right, Unique, All);
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

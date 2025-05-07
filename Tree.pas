UNIT Tree;

INTERFACE

TYPE
  Str255 = STRING[255];
  PTreeNode = ^TTreeNode;
  TTreeNode = RECORD
                Word: Str255;
                Count: integer;
                Left, Right: PTreeNode
              END;

VAR
  Root: PTreeNode;

PROCEDURE PrintTree(FileName: STRING);
FUNCTION CreateNode(CONST Word: Str255): PTreeNode;

IMPLEMENTATION

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

PROCEDURE PrintTreeReverse(Root: PTreeNode; VAR F: TEXT);
BEGIN
  IF Root <> NIL
  THEN
    BEGIN
      PrintTreeReverse(Root^.Left, F);
      WRITELN(F, Root^.Word, ' ', Root^.Count);
      PrintTreeReverse(Root^.Right, F)
    END
END;

PROCEDURE PrintTree(FileName: STRING);
VAR
  F: TEXT;
BEGIN
  ASSIGN(F, FileName);
  REWRITE(F);
  IF Root <> NIL
  THEN
    BEGIN
      PrintTreeReverse(Root^.Left, F);
      WRITELN(F, Root^.Word, ' ', Root^.Count);
      PrintTreeReverse(Root^.Right, F)
    END;
  CLOSE(F)
END;

END.

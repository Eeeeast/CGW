UNIT WordTree;

INTERFACE

TYPE
  PWordNode = ^TWordNode;
  TWordNode = RECORD
    Word: TEXT;
    Count: INTEGER;
    Left, Right: PWordNode
  END;

PROCEDURE InitTree(VAR Root: PWordNode);
PROCEDURE AddWordToTree(VAR Node: PWordNode; VAR Word: TEXT);
PROCEDURE TraverseAndPrint(Node: PWordNode; VAR OutFile: TEXT);

IMPLEMENTATION

USES TextUtils;

PROCEDURE InitTree(VAR Root: PWordNode);
BEGIN
  Root := NIL
END;

PROCEDURE AddWordToTree(VAR Node: PWordNode; VAR Word: TEXT);
VAR
  Cmp: INTEGER;
BEGIN
  RESET(Word);
  IF NOT EOF(Word)
  THEN
    IF Node = NIL
    THEN
      BEGIN
        NEW(Node);
        Node^.Count := 1;
        CopyText(Node^.Word, Word);
        Node^.Left := NIL;
        Node^.Right := NIL
      END
    ELSE
      BEGIN
        Cmp := CompareText(Word, Node^.Word);
        CASE Cmp OF
          -1: AddWordToTree(Node^.Left, Word);
          0: Node^.Count := Node^.Count + 1;
          1: AddWordToTree(Node^.Right, Word)
        END
      END
END;

PROCEDURE TraverseAndPrint(Node: PWordNode; VAR OutFile: TEXT);
VAR
  Ch: CHAR;
BEGIN
  IF Node <> NIL
  THEN
    BEGIN
      TraverseAndPrint(Node^.Left, OutFile);
      RESET(Node^.Word);
      WHILE NOT EOF(Node^.Word)
      DO
        BEGIN
          READ(Node^.Word, Ch);
          WRITE(OutFile, Ch)
        END;
      WRITELN(OutFile, ' ', Node^.Count);
      TraverseAndPrint(Node^.Right, OutFile)
    END
END;

END.

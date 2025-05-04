UNIT TextUtils;

INTERFACE

FUNCTION CompareText(VAR S1, S2: TEXT): INTEGER;
PROCEDURE CopyText(VAR Dest, Source: TEXT);

IMPLEMENTATION

USES
  AlphabetUtils,
  WordTree;

FUNCTION CompareText(VAR S1, S2: TEXT): INTEGER;
VAR
  Ch1, Ch2: CHAR;
  IsExit: BOOLEAN;
BEGIN
  RESET(S1);
  RESET(S2);
  IsExit := FALSE;
  WHILE NOT EOF(S1) AND NOT EOF(S2) AND NOT IsExit
  DO
    BEGIN
      READ(S1, Ch1);
      READ(S2, Ch2);
      IF Ch1 < Ch2
      THEN
        BEGIN
          CompareText := -1;
          IsExit := TRUE
        END
      ELSE
        IF Ch1 > Ch2
        THEN
          BEGIN
            CompareText := 1;
            IsExit := TRUE
          END
    END;
  IF NOT IsExit
  THEN
    IF EOF(S1) AND NOT EOF(S2)
    THEN
      CompareText := -1
    ELSE
      IF NOT EOF(S1) AND EOF(S2)
      THEN
        CompareText := 1
      ELSE
        CompareText := 0
END;

PROCEDURE CopyText(VAR Dest, Source: TEXT);
VAR
  Ch: CHAR;
BEGIN
  REWRITE(Dest);
  RESET(Source);
  WHILE NOT EOF(Source)
  DO
    BEGIN
      READ(Source, Ch);
      WRITE(Dest, Ch)
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
      WHILE NOT EOLN(Node^.Word)
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

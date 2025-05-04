UNIT TextProcessor;

INTERFACE

USES
  WordTree,
  TextUtils,
  AlphabetUtils;

PROCEDURE ProcessText(VAR FileHandle: TEXT; VAR TreeRoot: PWordNode);

IMPLEMENTATION

PROCEDURE ProcessText(VAR FileHandle: TEXT; VAR TreeRoot: PWordNode);
VAR
  Ch: CHAR;
  CurrentWord: TEXT;
BEGIN
  REWRITE(CurrentWord);
  WHILE NOT EOF(FileHandle)
  DO
    BEGIN
      WHILE NOT EOLN(FileHandle) AND NOT EOF(FileHandle)
      DO
        BEGIN
          READ(FileHandle, Ch);
          IF IsLetterOrDigit(Ch)
          THEN
            WRITE(CurrentWord, Ch)
          ELSE
            BEGIN
              AddWordToTree(TreeRoot, CurrentWord);
              REWRITE(CurrentWord)
            END
        END;
      AddWordToTree(TreeRoot, CurrentWord);
      REWRITE(CurrentWord);
      IF NOT EOF(FileHandle)
      THEN
        READLN(FileHandle)
    END
END;

END.

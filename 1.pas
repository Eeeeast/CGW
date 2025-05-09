PROGRAM WordCounter(INPUT, OUTPUT);

USES
  WordCounter;

VAR
  F: TEXT;

BEGIN
  ASSIGN(F, 'input.txt');
  RESET(F);
  WHILE NOT EOF(F)
  DO
    CountWord(ReadWord(F));
  CLOSE(F);
  ASSIGN(F, 'output.txt');
  REWRITE(F);
  PrintWordsList(F);
  CLOSE(F)
END.

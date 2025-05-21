PROGRAM WordCounter(INPUT, OUTPUT);

USES
  WordCounter;

VAR
  InputFile, OutputFile, TempFile: TEXT;

BEGIN
  ASSIGN(InputFile, 'book-war-and-peace-big.txt');
  ASSIGN(OutputFile, 'output.txt');
  ASSIGN(TempFile, 'temp.txt');
  RESET(InputFile);
  REWRITE(OutputFile);
  REWRITE(TempFile);
  GroupWords(InputFile, OutputFile, TempFile);
  CLOSE(InputFile);
  CLOSE(OutputFile);
  CLOSE(TempFile)
END.

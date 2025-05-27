PROGRAM WordCounter(INPUT, OUTPUT);

USES
  WordCounter;

VAR
  InputFile, OutputFile: TEXT;

BEGIN
  ASSIGN(InputFile, 'book-war-and-peace.txt');
  ASSIGN(OutputFile, 'output.txt');
  RESET(InputFile);
  REWRITE(OutputFile);
  GroupWords(InputFile, OutputFile);
  CLOSE(InputFile);
  CLOSE(OutputFile)
END.

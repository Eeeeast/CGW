PROGRAM WordCounter;

USES
  AlphabetUtils,
  WordTree,
  TextProcessor;

VAR
  Root: PWordNode;
  InFile, OutFile, TempFile: TEXT;

BEGIN
  InitTree(Root);

  ASSIGN(InFile, 'book-war-and-peace.txt');
  ASSIGN(OutFile, 'output.txt');

  RESET(InFile);
  REWRITE(OutFile);
  REWRITE(TempFile);
  Scrub(InFile, TempFile);
  CLOSE(InFile);

  RESET(TempFile);
  ProcessText(TempFile, Root);

  TraverseAndPrint(Root, OutFile);
  CLOSE(OutFile);

  WRITELN('Processing complete.')
END.

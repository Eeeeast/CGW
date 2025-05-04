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

  ASSIGN(InFile, 'input.txt');
  ASSIGN(OutFile, 'output.txt');

  RESET(InFile);
  REWRITE(TempFile);
  Scrub(InFile, TempFile);
  CLOSE(InFile);

  RESET(TempFile);
  ProcessText(TempFile, Root);

  REWRITE(OutFile);
  TraverseAndPrint(Root, OutFile);
  CLOSE(OutFile);

  WRITELN('Processing complete.')
END.

PROGRAM WordCounter(INPUT, OUTPUT);

USES
  Counter,
  Tree;

BEGIN
  CountWords('input.txt');
  PrintTree('output.txt')
END.

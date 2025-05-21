UNIT Alphabet;

INTERFACE

TYPE
  TComparisonResult = (Lower, Equal, Higher);

FUNCTION Scrub(Ch: CHAR): CHAR;
FUNCTION CompareStr(S1, S2: STRING): TComparisonResult;

IMPLEMENTATION

VAR
  CharMap: ARRAY[CHAR] OF CHAR;
  CharOrder: ARRAY[CHAR] OF BYTE;

FUNCTION Scrub(Ch: CHAR): CHAR;
BEGIN
  Scrub := CharMap[Ch]
END;

FUNCTION FindPosition(Ch: CHAR): INTEGER;
BEGIN
  FindPosition := CharOrder[Ch]
END;

FUNCTION CompareStr(S1, S2: STRING): TComparisonResult;
VAR
  Compare, I: INTEGER;
BEGIN
  Compare := 0;
  I := 1;
  WHILE (I <= LENGTH(S1)) AND (I <= LENGTH(S2)) AND (Compare = 0)
  DO
    BEGIN
      Compare := FindPosition(S1[I]) - FindPosition(S2[I]);
      I := I + 1
    END;
  IF Compare = 0
  THEN
    Compare := LENGTH(S1) - LENGTH(S2);
  IF Compare < 0
  THEN
    CompareStr := Lower
  ELSE
    IF Compare = 0
    THEN
      CompareStr := Equal
    ELSE
      CompareStr := Higher
END;

PROCEDURE InitializeTables;
CONST
  InvalidPos = 0;
  AlphabetUpper: ARRAY[0..25] OF CHAR = (
    'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M',
    'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z'
  );
  AlphabetLower: ARRAY[0..25] OF CHAR = (
    'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm',
    'n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'v', 'w', 'x', 'y', 'z'
  );
  CyrillicUpper: ARRAY[0..32] OF CHAR = (
    CHR(192), CHR(193), CHR(194), CHR(195), CHR(196), CHR(197), CHR(168),
	CHR(198), CHR(199), CHR(200), CHR(201), CHR(202), CHR(203), CHR(204),
	CHR(205), CHR(206), CHR(207), CHR(208), CHR(209), CHR(210), CHR(211),
	CHR(212), CHR(213), CHR(214), CHR(215), CHR(216), CHR(217), CHR(218),
	CHR(219), CHR(220), CHR(221), CHR(222), CHR(223)
  );
  CyrillicLower: ARRAY[0..32] OF CHAR = (
    CHR(224), CHR(225), CHR(226), CHR(227), CHR(228), CHR(229), CHR(184),
	CHR(230), CHR(231), CHR(232), CHR(233), CHR(234), CHR(235), CHR(236),
	CHR(237), CHR(238), CHR(239), CHR(240), CHR(241), CHR(242), CHR(243),
	CHR(244), CHR(245), CHR(246), CHR(247), CHR(248), CHR(249), CHR(250),
	CHR(251), CHR(252), CHR(253), CHR(254), CHR(255)
  );
  SpecialSymbol: CHAR = '-';
VAR
  Pos, I: Integer;
  Ch: CHAR;
BEGIN
  FOR Ch := LOW(CHAR) TO HIGH(CHAR)
  DO
    BEGIN
      CharMap[Ch] := ' ';
      CharOrder[Ch] := InvalidPos
    END;
  Pos := 1;
  FOR I := 0 TO HIGH(AlphabetUpper)
  DO
    BEGIN
      CharMap[AlphabetUpper[I]] := AlphabetUpper[I];
      CharOrder[AlphabetUpper[I]] := Pos;
      CharMap[AlphabetLower[I]] := AlphabetUpper[I];
      CharOrder[AlphabetLower[I]] := Pos;
      Pos := Pos + 1
    END;
  FOR I := 0 TO HIGH(CyrillicUpper)
  DO
    BEGIN
      CharMap[CyrillicUpper[I]] := CyrillicUpper[I];
      CharOrder[CyrillicUpper[I]] := Pos;
      CharMap[CyrillicLower[I]] := CyrillicUpper[I];
      CharOrder[CyrillicLower[I]] := Pos;
      Pos := Pos + 1
    END;
  CharMap[SpecialSymbol] := SpecialSymbol;
  CharOrder[SpecialSymbol] := Pos
END;

BEGIN
  InitializeTables
END.

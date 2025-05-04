UNIT AlphabetUtils;

INTERFACE

CONST
  InvalidPos = -1;
  AlphabetUpper: ARRAY[0..25] OF CHAR = (
    'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M',
    'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z'
  );
  AlphabetLower: ARRAY[0..25] OF CHAR = (
    'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n', 'o', 'p', 'q', 'r', 's',
    't', 'u', 'v', 'w', 'x', 'y', 'z'
  );
  CyrillicUpper: ARRAY[0..32] OF CHAR = (
    CHR(192), CHR(193), CHR(194), CHR(195), CHR(196), CHR(197), CHR(168), CHR(198), CHR(199), CHR(200), CHR(201), CHR(202), CHR(203),
    CHR(204), CHR(205), CHR(206), CHR(207), CHR(208), CHR(209), CHR(210), CHR(211), CHR(212), CHR(213), CHR(214), CHR(215), CHR(216),
    CHR(217), CHR(218), CHR(219), CHR(220), CHR(221), CHR(222), CHR(223)
  );
  CyrillicLower: ARRAY[0..32] OF CHAR = (
    CHR(224), CHR(225), CHR(226), CHR(227), CHR(228), CHR(229), CHR(184), CHR(230), CHR(231), CHR(232), CHR(233), CHR(234), CHR(235),
    CHR(236), CHR(237), CHR(238), CHR(239), CHR(240), CHR(241), CHR(242), CHR(243), CHR(244), CHR(245), CHR(246), CHR(247), CHR(248),
    CHR(249), CHR(250), CHR(251), CHR(252), CHR(253), CHR(254), CHR(255)
  );
  Numeric: ARRAY[0..9] OF CHAR = (
    '0', '1', '2', '3', '4', '5', '6', '7', '8', '9'
  );
  SpecialSymbol: ARRAY[0..0] OF CHAR = (
    '-'
  );

FUNCTION IsLetterOrDigit(Ch: CHAR): BOOLEAN;

PROCEDURE Scrub(VAR InFile, OutFile: TEXT);

IMPLEMENTATION

FUNCTION IsIn(Ch: CHAR; Arr: ARRAY OF CHAR; VAR Pos: INTEGER): BOOLEAN;
VAR
  I: INTEGER;
BEGIN
  Pos := InvalidPos;
  IsIn := FALSE;
  I := 0;
  WHILE I < LENGTH(Arr)
  DO
    BEGIN
      IF Arr[I] = Ch
      THEN
        BEGIN
          Pos := I;
          IsIn := TRUE;
          I := LENGTH(Arr) + 1
        END;
      I := I + 1
    END
END;

FUNCTION ToUpperCase(Ch: CHAR): CHAR;
VAR
  Pos: INTEGER;
BEGIN
  IF IsIn(Ch, AlphabetLower, Pos)
  THEN
    ToUpperCase := AlphabetUpper[Pos]
  ELSE
    IF IsIn(Ch, CyrillicLower, Pos)
    THEN
      ToUpperCase := CyrillicUpper[Pos]
    ELSE
      ToUpperCase := Ch
END;

FUNCTION FindPosition(Ch: CHAR): INTEGER;
VAR
  Pos: INTEGER;
BEGIN
  Ch := ToUpperCase(Ch);
  IF IsIn(Ch, AlphabetUpper, Pos)
  THEN
    FindPosition := Pos { A-Z → 0..25 }
  ELSE
    IF IsIn(Ch, CyrillicUpper, Pos)
    THEN
      FindPosition := 26 + Pos { А-Я → 26..58 }
    ELSE
      IF IsIn(Ch, Numeric, Pos)
      THEN
        FindPosition := 59 + Pos { 0-9 → 59..68 }
      ELSE
        IF IsIn(Ch, SpecialSymbol, Pos)
        THEN
          FindPosition := 69 + Pos { - → 69 }
        ELSE
          FindPosition := InvalidPos
END;

FUNCTION IsLetterOrDigit(Ch: CHAR): BOOLEAN;
VAR
  Pos: INTEGER;
BEGIN
  IsLetterOrDigit := FindPosition(CH) <> InvalidPos
END;

PROCEDURE Scrub(VAR InFile, OutFile: TEXT);
VAR
  Ch, UpCh: CHAR;
  Pos: INTEGER;
BEGIN
  WHILE NOT EOF(InFile)
  DO
    BEGIN
      WHILE NOT EOLN(InFile)
      DO
        BEGIN
          READ(InFile, Ch);
          UpCh := ToUpperCase(Ch);
          IF FindPosition(UpCh) <> InvalidPos
          THEN
            WRITE(OutFile, UpCh)
          ELSE
            WRITE(OutFile, ' ')
        END;
      READLN(InFile)
    END
END;

END.

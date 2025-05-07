UNIT Scraper;

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
    'À', 'Á', 'Â', 'Ã', 'Ä', 'Å', '¨', 'Æ', 'Ç', 'È', 'É', 'Ê', 'Ë', 'Ì', 'Í', 'Î', 'Ï', 'Ð', 'Ñ', 'Ò', 'Ó', 'Ô', 'Õ', 'Ö', '×', 'Ø', 'Ù', 'Ú', 'Û', 'Ü', 'Ý', 'Þ', 'ß'
  );
  CyrillicLower: ARRAY[0..32] OF CHAR = (
    'à', 'á', 'â', 'ã', 'ä', 'å', '¸', 'æ', 'ç', 'è', 'é', 'ê', 'ë', 'ì', 'í', 'î', 'ï', 'ð', 'ñ', 'ò', 'ó', 'ô', 'õ', 'ö', '÷', 'ø', 'ù', 'ú', 'û', 'ü', 'ý', 'þ', 'ÿ'
  );
  Numeric: ARRAY[0..9] OF CHAR = (
    '0', '1', '2', '3', '4', '5', '6', '7', '8', '9'
  );
  SpecialSymbol: ARRAY[0..0] OF CHAR = (
    '-'
  );

FUNCTION Scrub(Ch: CHAR): CHAR;
FUNCTION FindPosition(Ch: CHAR): INTEGER;

IMPLEMENTATION

FUNCTION IsIn(Ch: CHAR; Arr: ARRAY OF CHAR; VAR Pos: INTEGER): BOOLEAN;
VAR
  I: INTEGER;
BEGIN
  Pos := InvalidPos;
  IsIn := FALSE;
  I := 0;
  WHILE I <= LENGTH(Arr) - 1
  DO
    BEGIN
      IF Arr[I] = Ch
      THEN
        BEGIN
          Pos := I;
          IsIn := TRUE
        END;
      I := I + 1
    END
END;

FUNCTION Scrub(Ch: CHAR): CHAR;
VAR
  Pos: INTEGER;
BEGIN
  IF IsIn(Ch, AlphabetLower, Pos)
  THEN
    Scrub := AlphabetUpper[Pos]
  ELSE
    IF IsIn(Ch, CyrillicLower, Pos)
    THEN
      Scrub := CyrillicUpper[Pos]
    ELSE
      IF IsIn(Ch, AlphabetUpper, Pos) OR IsIn(Ch, CyrillicUpper, Pos) OR IsIn(Ch, SpecialSymbol, Pos)
      THEN
        Scrub := Ch
      ELSE
        Scrub := ' '
END;

FUNCTION FindPosition(Ch: CHAR): INTEGER;
VAR
  Pos: INTEGER;
BEGIN
  Ch := Scrub(Ch);
  IF IsIn(Ch, AlphabetUpper, Pos)
  THEN
    FindPosition := Pos { A-Z â†’ 0..25 }
  ELSE
    IF IsIn(Ch, CyrillicUpper, Pos)
    THEN
      FindPosition := 26 + Pos { Ð-Ð¯ â†’ 26..58 }
    ELSE
      IF IsIn(Ch, SpecialSymbol, Pos)
      THEN
        FindPosition := 69 + Pos { - â†’ 69 }
      ELSE
        FindPosition := InvalidPos
END;

END.

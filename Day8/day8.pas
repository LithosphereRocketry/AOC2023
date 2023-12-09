program Day8;
function encode(line: string; ind: integer): integer;
begin
    encode := (ord(line[ind]) - ord('A'))*26*26
            + (ord(line[ind+1]) - ord('A'))*26
            + (ord(line[ind+2]) - ord('A')) + 1;
end;
var
    input: array of boolean;
    c: char;
    infile: text;
    line: string;
    tok: integer;
    mapl, mapr: array[1 .. 26*26*26] of integer;
    inp_ind: integer;
    count: longint;
    loc: integer;
begin
    setLength(input, 0);
    assign(infile, 'input.txt');
    reset(infile);
    while c <> chr(10) do begin
        setLength(input, length(input)+1);
        input[length(input)-1] := (c = 'R');
        read(infile, c);
    end;
    read(infile, c);
    inp_ind := 1;
    while not eof(infile) do begin
        readln(infile, line);
        tok := encode(line, 1);
        mapl[tok] := encode(line, 8);
        mapr[tok] := encode(line, 13);
    end;

    loc := 1;
    count := 0;
    while loc <> 26*26*26 do begin
        if input[inp_ind] then loc := mapr[loc]
        else loc := mapl[loc];
        count := count + 1;
        inp_ind := (inp_ind mod (length(input) - 1)) + 1;
    end;
    writeln(count);
end.
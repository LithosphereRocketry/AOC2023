program Day8;
function encode(line: string; ind: integer): integer;
begin
    encode := (ord(line[ind]) - ord('A'))*26*26
            + (ord(line[ind+1]) - ord('A'))*26
            + (ord(line[ind+2]) - ord('A')) + 1;
end;
function greatestCommonDivisor(a, b: Int64): Int64;
var
  temp: Int64;
begin
  while b <> 0 do
  begin
    temp := b;
    b := a mod b;
    a := temp
  end;
  result := a
end;
function leastCommonMultiple(a, b: Int64): Int64;
begin
  result := b * (a div greatestCommonDivisor(a, b));
end;
var
    input: array of boolean;
    c: char;
    infile: text;
    line: string;
    tok: integer;
    mapl, mapr: array[1 .. 26*26*26] of integer;
    hit: array[1 .. 26*26*26] of longint;
    inp_ind: integer;
    loc: integer;
    starts: array of integer;
    offset: array of longint;
    period: array of longint;
    hits: array of boolean;
    fullperiod: longint;
    i, j: integer;
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
    setLength(starts, 0);
    while not eof(infile) do begin
        readln(infile, line);
        tok := encode(line, 1);
        if (tok mod 26) = 1 then begin
            writeln('hi');
            setLength(starts, length(starts)+1);
            starts[length(starts)-1] := tok;
        end;
        mapl[tok] := encode(line, 8);
        mapr[tok] := encode(line, 13);
    end;

    setLength(offset, length(starts));
    setLength(period, length(starts));
    for i := 1 to length(starts)-1 do begin
        
        for j := 1 to 26*26*26 do hit[j] := -1;
        loc := 1;
        offset[i] := 0;
        inp_ind := starts[i];
        while loc <> 26*26*26 do begin
            if input[inp_ind] then loc := mapr[loc] else loc := mapl[loc];
            offset[i] := offset[i] + 1;
            inp_ind := (inp_ind mod (length(input) - 1)) + 1;
        end;

        period[i] := 0;
        repeat
            if input[inp_ind] then loc := mapr[loc] else loc := mapl[loc];
            period[i] := period[i] + 1;
            inp_ind := (inp_ind mod (length(input) - 1)) + 1;
        until loc = 26*26*26;
        write(period[i]);
        write('*n + ');
        writeln(offset[i]);
    end;
    fullperiod := 1;
    for i := 1 to length(period)-1 do
        fullperiod := lcm(fullperiod, period[i]);
    for i := 1 to length(hits)-1 do begin
        setLength(hits[i], fullperiod);
        loc := starts[i];
        for j := 1 to fullperiod-1 do begin
            if loc mod 26 = 0 then
                hits[i][(j + offset[i]) mod fullperiod] := true;
        end;
    end;
    for i := 1 to fullperiod-1 do begin
    
end.
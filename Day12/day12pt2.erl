-module(day12pt2).
-export([run/1]).

run(Fname) ->
    Parses = [parse(L) || L <- lines(Fname)],
    lists:sum([solvememo(M, S, G) || {M, S, G} <- Parses]).

lines(Fname) ->
    {ok, File} = file:read_file(Fname),
    Text = unicode:characters_to_list(File),
    string:split(Text, "\n", all).

stoi(Str) ->
    {Int, _} = string:to_integer(Str),
    Int.

parse(Line) ->
    StrSpl = string:split(Line, " "),
    Grp = string:split(hd(tl(StrSpl)), ",", all),
    {closed, lists:append([hd(StrSpl)|lists:duplicate(4, [$?|hd(StrSpl)])]),
             lists:append(lists:duplicate(5, [stoi(N) || N <- Grp]))}.

solvememo(Mode, Str, Search) ->
    case erlang:get({'solvememo', {Mode, Str, Search}}) of
        Val when is_integer(Val) ->
            Val;
        'undefined' -> 
            Sol = solve(Mode, Str, Search),
            erlang:put({'solvememo', {Mode, Str, Search}}, Sol),
            Sol
    end.

solve(closed, [], []) -> 1;
solve(open, [], [0]) -> 1;
solve(_, [], _) -> 0;
solve(closed, [$.|Str], G) -> solvememo(closed, Str, G);
solve(open, [$.|Str], [0|GT]) -> solvememo(closed, Str, GT);
solve(open, [$.|_], _) -> 0;
solve(closed, [$#|_], []) -> 0;
solve(open, [$#|_], [0|_]) -> 0;
solve(_, [$#|Str], [GH|GT]) -> solvememo(open, Str, [GH-1|GT]);
solve(Mode, [$?|Str], G) ->
    solvememo(Mode, [$.|Str], G) + solvememo(Mode, [$#|Str], G).
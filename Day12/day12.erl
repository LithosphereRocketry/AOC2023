-module(day12).
-export([run/1]).

run(Fname) ->
    Parses = [parse(L) || L <- lines(Fname)],
    lists:sum([solve(M, S, G) || {M, S, G} <- Parses]).

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
    {closed, hd(StrSpl), [stoi(N) || N <- Grp]}.

solve(closed, [], []) -> 1;
solve(open, [], [0]) -> 1;
solve(_, [], _) -> 0;
solve(closed, [$.|Str], G) -> solve(closed, Str, G);
solve(open, [$.|Str], [0|GT]) -> solve(closed, Str, GT);
solve(open, [$.|_], _) -> 0;
solve(closed, [$#|_], []) -> 0;
solve(open, [$#|_], [0|_]) -> 0;
solve(_, [$#|Str], [GH|GT]) -> solve(open, Str, [GH-1|GT]);
solve(Mode, [$?|Str], G) ->
    solve(Mode, [$.|Str], G) + solve(Mode, [$#|Str], G).
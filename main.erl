-module(main).
-team("Wyatt Smith, Longiy Tsin").
-export([start/0]).

serv1(PID) -> recieve
    {add, X, Y} ->
        io:format("(serv1) Adding ~p and ~p for ~p~n", [X, Y, X+Y]),
        serv1()
    {sub, X, Y} ->
        io:format("(serv1) Subracting ~p and ~p for ~p~n", [X, Y, X-Y]),
        serv1()
    {mult, X, Y} ->
        io:format("(serv1) Multiplying ~p and ~p for ~p~n", [X, Y, X*Y]),
        serv1()
    {div, X, Y} ->
        io:format("(serv1) Dividing ~p and ~p for ~p~n", [X, Y, X/Y]),
        serv1()
    {neg, X} ->
        io:format("(serv1) Negating ~p for ~p~n", [X, -X]),
        serv1()
    {sqrt, X} ->
        io:format("(serv1) Squaring ~p for ~p~n", [X, sqrt(x)]),
        serv1()
    MM ->
        PID ! MM
    end.

serv2(PID) -> recieve
    MM ->
        PID ! MM
    end.

serv3() -> recieve

make_request(PID) -> 
    {ok, Num} = io:read("Enter a message: "),
    PID ! Num
    make_request(PID).

start() -> 
    serv3 = spawn(?MODULE, serv3, []),
    serv2 = spawn(?MODULE, serv2, [serv3]),
    serv1 = spawn(?MODULE, serv1, [serv2]),
    make_request(serv1),
    okay.
-module(main).
-team("Longiy Tsin, Wyatt Smith").
-export([start/0, serv1/1, serv2/1, serv3/1]).

%% ---- serv1: handles arithmetic tuples ----
serv1(PID) ->
    receive
        halt ->
            PID ! halt,
            io:format("(serv1) Halting.~n");
        {add, X, Y} ->
            io:format("(serv1) Adding ~p and ~p = ~p~n", [X, Y, X+Y]),
            serv1(PID);
        {sub, X, Y} ->
            io:format("(serv1) Subtracting ~p and ~p = ~p~n", [X, Y, X-Y]),
            serv1(PID);
        {mult, X, Y} ->
            io:format("(serv1) Multiplying ~p and ~p = ~p~n", [X, Y, X*Y]),
            serv1(PID);
        {'div', X, Y} ->
            io:format("(serv1) Dividing ~p and ~p = ~p~n", [X, Y, X/Y]),
            serv1(PID);
        {neg, X} ->
            io:format("(serv1) Negating ~p = ~p~n", [X, -X]),
            serv1(PID);
        {sqrt, X} ->
            io:format("(serv1) Square root of ~p = ~p~n", [X, math:sqrt(X)]),
            serv1(PID);
        MM ->
            PID ! MM,
            serv1(PID)
    end.

%% ---- serv2 helpers ----
sum_numbers([]) -> 0;
sum_numbers([H|T]) when is_number(H) -> H + sum_numbers(T);
sum_numbers([_|T]) -> sum_numbers(T).

product_numbers([]) -> 1;
product_numbers([H|T]) when is_number(H) -> H * product_numbers(T);
product_numbers([_|T]) -> product_numbers(T).

%% ---- serv2: handles lists ----
serv2(PID) ->
    receive
        halt ->
            PID ! halt,
            io:format("(serv2) Halting.~n");
        [H|T] when is_integer(H) ->
            Sum = sum_numbers([H|T]),
            io:format("(serv2) Sum of integer-headed list ~p = ~p~n", [[H|T], Sum]),
            serv2(PID);
        [H|T] when is_float(H) ->
            Product = product_numbers([H|T]),
            io:format("(serv2) Product of float-headed list ~p = ~p~n", [[H|T], Product]),
            serv2(PID);
        MM ->
            PID ! MM,
            serv2(PID)
    end.

%% ---- serv3: catches everything else ----
serv3(Count) ->
    receive
        halt ->
            io:format("(serv3) Unprocessed message count: ~p~n", [Count]),
            io:format("(serv3) Halting.~n");
        {error, Msg} ->
            io:format("(serv3) Error: ~p~n", [Msg]),
            serv3(Count);
        MM ->
            io:format("(serv3) Not handled: ~p~n", [MM]),
            serv3(Count + 1)
    end.

%% ---- main loop ----
make_request(PID) ->
    {ok, Input} = io:read("Enter a message: "),
    case Input of
        all_done ->
            PID ! halt,
            io:format("(main) Shutting down.~n");
        _ ->
            PID ! Input,
            make_request(PID)
    end.

start() ->
    Serv3 = spawn(?MODULE, serv3, [0]),
    Serv2 = spawn(?MODULE, serv2, [Serv3]),
    Serv1 = spawn(?MODULE, serv1, [Serv2]),
    make_request(Serv1).
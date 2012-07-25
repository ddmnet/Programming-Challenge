#!/usr/bin/env escript

read() ->
	case io:get_line(standard_io, '') of
		eof -> ok;
		Line -> parse_numeral(Line)
	end.

parse_numeral(Line) ->
	try to_number([], string:strip(Line, right, $\n)) of
		Res -> io:format("~p\n", [Res])
	catch
		error:bad_input -> io:format(standard_error, "Invalid Numeral\n", [])
	end,
	read().

%% I
to_val(Val) when Val =:= 73 ->
	{ok, 1};
%% V
to_val(Val) when Val =:= 86 ->
	{ok, 5};
%% X
to_val(Val) when Val =:= 88 ->
	{ok, 10};
%% L
to_val(Val) when Val =:= 76 ->
	{ok, 50};
%% C
to_val(Val) when Val =:= 67 ->
	{ok, 100};
%% D
to_val(Val) when Val =:= 68 ->
	{ok, 500};
%% M
to_val(Val) when Val =:= 77 ->
	{ok, 1000};
to_val(_) ->
	err.

to_number(_, []) ->
	0;
to_number(PreviousValue, [Head|Tail]) ->
	F = fun
		(N) when N > PreviousValue -> (N - (PreviousValue * 2)) + to_number(N, Tail);
		(N) -> N + to_number(N, Tail)
	end,
	case to_val(Head) of
		{ok, Int} -> F(Int);
		err -> erlang:error(bad_input)
	end.

main(_) ->
	read().
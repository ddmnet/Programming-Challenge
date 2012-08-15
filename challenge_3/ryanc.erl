%% To run, escript ryanc.erl <filename>
%% To run compiled version, escript ryanc.beam <filename>

-module(ryanc).

-export([main/1]).

parse_piece(Space) ->
	if
		Space =:= $R -> 
			Result = {white, rook};
		Space =:= $r -> 
			Result = {black, rook};
		Space =:= $N -> 
			Result = {white, knight};
		Space =:= $n -> 
			Result = {black, knight};
		Space =:= $B ->
			Result = {white, bishop};
		Space =:= $b ->
			Result = {black, bishop};
		Space =:= $Q ->
			Result = {white, queen};
		Space =:= $q ->
			Result = {black, queen};
		Space =:= $K ->
			Result = {white, king};
		Space =:= $k ->
			Result = {black, king};
		Space =:= $P ->
			Result = {white, pawn};
		Space =:= $p ->
			Result = {black, pawn};
		true -> 
			Result = {empty, empty}
	end,
	Result.

load_pieces([], _) ->
	[];
load_pieces(Pieces, N) ->
	[Row | Leftovers] = Pieces,
	lists:zip(
		[{X, N} || X <- lists:seq(1,8)],
		[parse_piece(Space) || Space <- Row]) ++ load_pieces(Leftovers, N-1).

find_kings(Board) ->
	List = dict:to_list(Board),
	lists:foldl(fun(Space, List0) -> 
		case Space of
			{{_, _}, {_, king}} ->
				List1 = List0 ++ [Space];
			_ -> 
				List1 = List0 ++ []
		end,
		List1
	end, [], List).

check_left_horizontal(_, X, _, _) when X =:= 0 ->
	safe;

check_left_horizontal(GoodColor, X, Y, Board) ->
	case dict:fetch({X, Y}, Board) of
		{empty, empty} ->
			check_left_horizontal(GoodColor, X-1, Y, Board);
		{GoodColor, _} ->
			safe;
		{_, rook} ->
			check;
		{_, queen} ->
			check;
		{_, _} ->
			safe
	end.

check_right_horizontal(_, X, _, _) when X =:= 9 ->
	safe;

check_right_horizontal(GoodColor, X, Y, Board) ->
	case dict:fetch({X, Y}, Board) of
		{empty, empty} ->
			check_right_horizontal(GoodColor, X+1, Y, Board);
		{GoodColor, _} ->
			safe;
		{_, rook} ->
			check;
		{_, queen} ->
			check;
		{_, _} ->
			safe
	end.

check_top_vertical(_, _, Y, _) when Y =:= 9 ->
	safe;

check_top_vertical(GoodColor, X, Y, Board) ->
	case dict:fetch({X, Y}, Board) of
		{empty, empty} ->
			check_top_vertical(GoodColor, X, Y+1, Board);
		{GoodColor, _} ->
			safe;
		{_, rook} ->
			check;
		{_, queen} ->
			check;
		{_, _} ->
			safe
	end.

check_bottom_vertical(_, _, Y, _) when Y =:= 0 ->
	safe;

check_bottom_vertical(GoodColor, X, Y, Board) ->
	case dict:fetch({X, Y}, Board) of
		{empty, empty} ->
			check_bottom_vertical(GoodColor, X, Y-1, Board);
		{GoodColor, _} ->
			safe;
		{_, rook} ->
			check;
		{_, queen} ->
			check;
		{_, _} ->
			safe
	end.

check_knight_positions(GoodColor, X, Y, Board) ->
	PossiblePositions = [
		{-2, 1}, {-2, -1}, {2,1}, {2,-1},
		{-1, 2}, {-1, -2}, {1,2}, {1, -2}],
	GenPositions = [{X2 + X, Y2 + Y} || {X2, Y2} <- PossiblePositions],
	Checks = [check_knight_position(GoodColor, KnightX, KnightY, Board) || {KnightX, KnightY} <- GenPositions],
	case lists:any(fun(El) -> El =:= check end, Checks) of
		true -> check;
		_ -> safe
	end.

check_knight_position(GoodColor, X, Y, Board) ->
	case dict:is_key({X, Y}, Board) of
		true ->
			case dict:fetch({X, Y}, Board) of
				{GoodColor, _} -> safe;
				{_, knight} -> check;
				_ -> safe
			end;
		_ -> safe
	end.

check_diagonals(GoodColor, X, Y, Board) ->
	Movements = [{-1, 1}, {-1, 1}, {1, -1}, {1, 1}],
	Checks = [check_diagonal(GoodColor, X, Y, Board, Movement) || Movement <- Movements],
	case lists:any(fun(El) -> El =:= check end, Checks) of
		true -> check;
		_ -> safe
	end.
check_diagonal(GoodColor, X1, Y1, Board, {X2, Y2}) ->
	case dict:is_key({X1 + X2, Y1 + Y2}, Board) of 
		true ->
			case dict:fetch({X1 + X2, Y1 + Y2}, Board) of
				{empty, empty} -> 
					check_diagonal(GoodColor, X1 + X2, Y1 + Y2, Board, {X2, Y2});
				{GoodColor, _} -> safe;
				{_, bishop} -> check;
				{_, queen} -> check;
				_ -> safe
			end;
		_ -> safe
	end.

check_pawns(Color, X, Y, Board) ->
	case Color of
		black -> Movements = [{-1, -1}, {1, -1}];
		_ -> Movements = [{-1, 1}, {1, 1}]
	end,
	Checks = [check_pawn(Color, X, Y, Board, Movement) || Movement <- Movements],
	case lists:any(fun(El) -> El =:= check end, Checks) of
		true -> check;
		_ -> safe
	end.
check_pawn(GoodColor, X1, Y1, Board, {X2, Y2}) ->
	case dict:is_key({X1 + X2, Y1 + Y2}, Board) of 
		true ->
			case dict:fetch({X1 + X2, Y1 + Y2}, Board) of
				{GoodColor, _} -> 
					safe;
				{_, pawn} -> check;
				_ -> safe
			end;
		_ -> safe
	end.

run_the_board(Board, King) ->
	{{X, Y}, {GoodColor, _}} = King,
	Result = [check_left_horizontal(GoodColor, X-1, Y, Board), 
		check_right_horizontal(GoodColor, X+1, Y, Board),
		check_top_vertical(GoodColor, X, Y+1, Board), 
		check_bottom_vertical(GoodColor, X, Y-1, Board),
		check_knight_positions(GoodColor, X, Y, Board), 
		check_diagonals(GoodColor, X, Y, Board), 
		check_pawns(GoodColor, X, Y, Board)],
	case lists:any(fun(El) -> El =:= check end, Result) of
		true -> check;
		_ -> safe
	end.

parse_board(FullBoard) ->
	[Header | Pieces] = FullBoard,
	Board = dict:from_list(load_pieces(Pieces, 8)),
	case find_kings(Board) of
		[] -> io:format("~s No kings found!~n", [Header]);
		[_] -> io:format("~s Only one king found!~n", [Header]);
		[King1, King2] -> 
			R1 = run_the_board(Board, King1),
			R2 = run_the_board(Board, King2),
			display_results(Header, [{King1, R1}, {King2, R2}]);
		_ -> io:format("~sUmmmm what?~n", [Header])
	end,
	ok.

display_results(Header, List) ->
	case List of
		[{_, safe}, {_, safe}] ->
			io:format("~s No Kings in Check~n", [Header]);
		[{_, check}, {_, check}] ->
			io:format("~s Both Kings in Check!?!?~n", [Header]);
		_ -> ok
	end,
	lists:map(fun(L) ->  
		case L of
			{{_, {black, king}}, safe} -> ok;
			{{_, {black, king}}, check} -> 
				io:format("~s Black King in Check~n", [Header]);
			{{_, {white, king}}, safe} -> ok;
			{{_, {white, king}}, check} -> 
				io:format("~s White King in Check~n", [Header]);
			_ -> ok
		end
	end, List),
	ok.

read(File, Accum) ->
	case file:read_line(File) of
		eof -> 
			parse_board(Accum),
			ok;
		{ok, Line} -> 
			if 
				length(Accum) =:= 9 ->
					parse_board(Accum),
					Accum2 = [];
				true ->
					Stripped = string:strip(Line, right, $\n),
					Accum2 = Accum ++ [Stripped]
			end,
			read(File, Accum2)
	end.
read_boards_file(File) ->
	io:format("Getting file: ~s~n", [File]),
	{ok, Stream} = file:open(File, [read]),
	read(Stream, []),
	ok.

main([File]) ->
	read_boards_file(File),
	ok;
main([]) ->
	io:format("No file found~n", []),
	ok.

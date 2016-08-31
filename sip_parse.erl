-module(sip_parse10).

-export([parse_sip_message/1]).
-include("sip.hrl").

parse_sip_message(Message) ->
	[Header|Msg] = split_into_headers_and_data(Message),
	#sip_message{type = Header,
				 data = parse_important_data(Msg)}.

parse_important_data(Msg) ->
	[Host,Port,Name] = [proplists:get_value(X, Msg) || X <- [host,port,name]],
	[From,To,Data] = [proplists:get_value(X, Msg) || X <- [from,to,data]],
	[{host,Host},
	 {port,Port},
	 {name,Name},
	 {from,From},
	 {to,To},
	 {data,Data}].


split_into_headers_and_data([$R,$E,$Q,$U,$E,$S,$T|_]=SIP) ->
	{Header,R1} = split_on_new_line(SIP),
	{From,R2} = split_on_new_line(R1),	
	{To, Data} = split_on_new_line(R2),
	[Header,{from,get_from(From)},{to,get_to(To)},{data,Data}];
split_into_headers_and_data([$R,$E,$G,$I,$S,$T,$E,$R|_]=SIP) ->
	{Header,X1} = split_on_space(SIP),
	{Host,X2} = split_on_space(X1),
	{Port,Name} = split_on_space(X2),
	[Header,{host,Host},{port,Port},{name,Name}];
split_into_headers_and_data([$R,$E,$P,$L,$Y|_]) ->
	["REPLY"].


split_on_new_line(String) ->
	{A,[$\n|R]} = lists:splitwith(fun(X) -> X /= $\n end, String),
	{A,R}.
split_on_space(String) ->
	{A,[$ |R]} = lists:splitwith(fun(X) -> X /= $  end, String),
	{A,R}.


get_from([$F,$r,$o,$m,$:,$ |From]) -> From.
get_to([$T,$o,$:,$ |To]) -> To.

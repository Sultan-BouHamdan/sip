-module(sip_message).
-include("sip.hrl").
-export([get_name/1,
		 get_data/1,
		 get_to/1]).

get_name(Msg) ->
	proplists:get_value(name, Msg#sip_message.data).

get_data(Msg) ->
	Msg#sip_message.data.

get_to(Msg) ->
	proplists:get_value(to, Msg#sip_message.data).
-module(sip_contact).
-include("sip.hrl").

-export([register/1,
		 get_host/1,
		 get_port/1,
		 get_name/1]).

register(Msg) ->
	Name = get_name(Msg),
	ets:insert(register, {Name, get_host(Msg), get_port(Msg)}),
	sip_log:log_db(ets:lookup(register,Name)).

get_name(Contact) ->
	proplists:get_value(name, Contact).

get_host(Contact) ->
	proplists:get_value(host, Contact).

get_port(Contact) ->
	proplists:get_value(port, Contact).
	
	
	



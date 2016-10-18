-module(sip_contact_tests).
-include_lib("eunit/include/eunit.hrl").
-include("sip.hrl").

register_test() ->
	Msg = [{name,"Adam"},{host,"Host"},{port,"Port"}],
	Name = sip_contact:get_name(Msg),
	Host = sip_contact:get_host(Msg),
	Port = sip_contact:get_port(Msg),
	?assertEqual(ets:insert(register, {Name, Host, Port}),
				 true),
	Res = ets:lookup(register,Name),
	?assertEqual([{"Adam","Host","Port"}], Res).

get_host_test() ->
	Host = sip_contact:get_host([{name,"Robert"},
								 {host,"10.10.10.2"},
								 {port,"8080"}]),
	?assertEqual(Host,"10.10.10.2").


get_port_test() ->
	Port = sip_contact:get_port([{name,"Robert"},
								 {host,"10.10.10.2"},
								 {port,"8080"}]),
	?assertEqual(Port,"8080").

get_name_test() ->
	Name = sip_contact:get_name([{name,"Robert"},
								 {host,"10.10.10.2"},
								 {port,"8080"}]),
	?assertEqual("Robert", Name).

get_missing_name_test() ->
	Name = sip_contact:get_name([{name,""},
								 {host,"10.10.10.2"},
								 {port,"8080"}]),
	?assertEqual("", Name).
	
	



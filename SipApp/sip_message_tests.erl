-module(sip_message_tests).
-include_lib("eunit/include/eunit.hrl").
-include("sip.hrl").



get_register_data_test() ->
	Msg = #sip_message{type = "REGISTER", 
					   data = [{name,"Adam"},
							   {host,"10.10.10.1"},
							   {port,"9090"}]},
	Res = sip_message:get_data(Msg),
	?assertEqual([{name,"Adam"},
				  {host,"10.10.10.1"},
				  {port,"9090"}], 
				 Res).

get_request_data_test() ->
	Msg = #sip_message{type = "REQUEST", 
					   data = [{from,"Adam"},
							   {to,"Robert"},
							   {data,"DATA"}]},
	Res = sip_message:get_data(Msg),
	?assertEqual([{from,"Adam"},
				  {to,"Robert"},
				  {data,"DATA"}], 
				 Res).


get_malicious_data_test() ->
	Msg = #sip_message{type = "REGISTER", 
					   data = [{name,"Adam"},
							   {host,"100.10.10.1"},
							   {port,"9090"}]},
	Res = sip_message:get_data(Msg),
	?assertEqual([{name,"Adam"},
				  {host,"10.10.10.1"},
				  {port,"9090"}], 
				 Res).

get_to_test() ->
	Msg = #sip_message{type = "REQUEST", 
					   data = [{from,"Adam"},
							   {to,"Ewe"},
							   {data,"DATA"}]},
	Res = sip_message:get_to(Msg),
	?assertEqual("Ewe", Res).
	
get_missing_to_test() ->
	Msg = #sip_message{type = "REQUEST", 
					   data = [{from,"Adam"},
							   {to,""},
							   {data,"DATA"}]},
	Res = sip_message:get_to(Msg),
	?assertEqual("", Res).
	
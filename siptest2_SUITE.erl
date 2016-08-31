-module(siptest2_SUITE).
-include_library("common_test/include/ct.hrl").
-include("sip.hrl").
-compile(export_all).

all() ->
    [client_receive_ok,
     client_registered_in_db].

init_per_testcase(_, _) ->
    sip_server10:start_server().

end_per_testcase(_, _) ->
    sip_server10:stop_server().

clientA_receive_ok() ->
    Client = "Client-A",
    sip_client9:sip_register("10.10.10.1", "8080", Client),
    {Client, ok} = sip_log:log_register(Client).

clientB_receive_ok() ->
    Client = "Client-B",
    sip_client9:sip_register("10.10.10.2", "8080", Client),
    {Client, ok} = sip_log:log_register(Client).

message_send_test() ->
	sip_client9:sip_communicate("REQUEST", "From:Client-A\n", "To:Client-B\n", "Hello!"),
	{ok, "REQUEST From:Client-A\nTo:Client-B\nHello!"} = sip_server:start_listen_accept_socket().

server_extract_to() ->
	Msg = #sip_message{type = "REQUEST", 
					   data = [{from,"Client-A"},
							   {to,"Client-B"},
							   {data,"Hello!"}]},
	"Client-B" = sip_message:get_to(Msg).

server_finds_host() ->
	Contact = [{name,"Client-B"},{host,"10.10.10.2"},{port,"8080"}],
	"10.10.10.2" = sip_contact:get_host(Contact).

server_finds_port() ->
	Contact = [{name,"Client-B"},{host,"10.10.10.2"},{port,"8080"}],
	"8080" = sip_contact:get_port(Contact).

message_receive_test() ->
	{ok,"Reply"} = sip_client9:sip_communicate("REPLY", 
											   "From:Client-A\n", 
											   "To:Client-B\n", 
											   "Hello!").
	


	


	
	


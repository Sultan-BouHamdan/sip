-module(sip_server10).
-include("sip.hrl").
-export([start_server/0,
	 	 start_listen_socket/0]).

start_server() ->
	Server_Pid = spawn_link(fun start_listen_socket/0),
	{ok, Server_Pid}.


start_listen_socket()->
	{ok, LSocket} = gen_tcp:listen(50600,[list,{active,false},{packet,4}]),
	ets:new(register, [set, named_table]),
	accept_socket(LSocket).

accept_socket(LSocket) ->
	{ok, ASocket} = gen_tcp:accept(LSocket),
	sip_handler(ASocket),
	accept_socket(LSocket).

sip_handler(ASocket) ->
	{ok, Bin} = gen_tcp:recv(ASocket, 0),
	Msg = sip_parse10:parse_sip_message(Bin),
	Reply = case Msg#sip_message.type of
				"REGISTER" ->
					ets:insert(register,{name,host,port}),
					sip_contact:register(sip_message:get_data(Msg)),
					"OK";
				"REQUEST" ->
					To = sip_message:get_to(Msg),
					Contact = get_contact(To),
					Request = sip_message:get_data(Msg),
					ok = send_to(Contact, Request),
					"Reply";
				"REPLY" ->
					"Ack"
			end,
	gen_tcp:send(ASocket, Reply).
	

get_contact(User) ->
	ets:lookup(register, User).

send_to(Contact, Request) ->
	Host = sip_contact:get_host(Contact),
	Port = sip_contact:get_port(Contact),
	{ok, Socket} = gen_tcp:connect(Host, Port, []),
	gen_tcp:send(Socket, Request).








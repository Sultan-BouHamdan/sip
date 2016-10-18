-module(sip_client).

-export([sip_register/3,
		 sip_communicate/4]).

sip_register(Host, Port, Name) ->
	{ok,Socket} = gen_tcp:connect({127,0,0,1}, 50600, [binary,{active,false},{packet,4}]),
	Reg = [Host, Port, Name],
	Message = lists:flatten(io_lib:format("REGISTER ~s ~s ~s", Reg)),
	gen_tcp:send(Socket, Message),
	case gen_tcp:recv(Socket,0) of
		{ok, "OK"} ->
			gen_tcp:close(Socket);
		_ -> 
			io:format("Registration Failed")
	end.

sip_communicate(Type,From,To,Data) ->
	case gen_tcp:connect({127,0,0,1},50600,[list,{active,false},{packet,4}]) of
		{ok, Socket} -> 
			SIP = io_lib:format("~s\n~s\n~s\n~s", [Type,From,To,Data]), 
			gen_tcp:send(Socket,SIP),
			case gen_tcp:recv(Socket, 0) of
				{ok,"Reply"} ->
					gen_tcp:send(Socket,"Ack");
				_ ->
					gen_tcp:close(Socket)
			end;
		{error, _} = Error -> Error
	end.





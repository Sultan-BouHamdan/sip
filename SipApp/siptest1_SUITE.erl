-module(siptest1_SUITE).
-include_library("common_test/include/ct.hrl").
-compile(export_all).

all() ->
    [client_receive_ok].

init_per_testcase(_, _) ->
    sip_server:start_server().

end_per_testcase(_, _) ->
    sip_server:stop_server().

client_receive_ok() ->
	{ok,Socket} = gen_tcp:connect({127,0,0,1}, 50600, [binary,{active,false},{packet,4}]),
	gen_tcp:send(Socket, "REGISTER HOST PORT NAME"),
	{ok, <<"ok">>} = gen_tcp:recv(Socket).





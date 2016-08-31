-module(siptest1_SUITE).
-include_library("common_test/include/ct.hrl").
-compile(export_all).

all() ->
    [client_receive_ok,
     client_registered_in_db].

init_per_testcase(_, _) ->
    sip_server10:start_server().

end_per_testcase(_, _) ->
    sip_server10:stop_server().

client_receive_ok() ->
    Client = "Client-A",
    sip_client9:sip_register("10.10.10.1", "8080", Client),
    {Client, ok} = sip_log:log_register(Client).

client_registered_in_db() ->    
    Client = "Client-B",
    sip_client9:sip_register("10.10.10.1", "8080", Client),
    {Client, ok} = sip_log:log_register(Client),
    ["10.10.10.1", "8080", Client] = sip_log:log_db(Client).

-module(sip_log).
-export([log_db/1]).


log_db(User) ->
	{ok, User} = file:open("priv/logs/db_log.txt", [write]).
	
	


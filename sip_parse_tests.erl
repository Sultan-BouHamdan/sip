-module(sip_parse10_tests).
-include_lib("eunit/include/eunit.hrl").
-include("sip.hrl").

get_from_test() ->
    Text = "From: Adam",
    Res = sip_parse10:get_from(Text),
    ?assertEqual("Adam", Res).

get_missing_from_test() ->
    Text = "From: ",
    Res = sip_parse10:get_from(Text),
    ?assertEqual("", Res).

get_to_test() ->
    Text = "To: Robert",
    Res = sip_parse10:get_to(Text),
    ?assertEqual("Robert", Res).
    
split_on_newline_test() ->
    Text = "A\nB",
    Res = sip_parse10:split_on_new_line(Text),
    ?assertEqual({"A","B"}, Res).

split_on_missing_newline_test() ->
    Text = "A B",
    Res = sip_parse10:split_on_new_line(Text),
    ?assertEqual({"A B",""}, Res).

split_on_space_test() ->
    Text = "C D",
    Res = sip_parse10:split_on_space(Text),
    ?assertEqual({"C","D"}, Res).

split_on_missing_space_test() ->
    Text = "C\nD",
    Res = sip_parse10:split_on_space(Text),
    ?assertEqual({"C\nD",""}, Res).

split_request_into_headers_and_data_test() ->    
    Text = "REQUEST\nFrom: Adam\nTo: Robert\nDATA",
    Res = sip_parse10:split_into_headers_and_data(Text),
    ?assertEqual(["REQUEST", 
                  {from,"Adam"},
                  {to,"Robert"},
                  {data,"DATA"}],
                 Res).

split_malformed_request_into_headers_and_data_test() ->   
    Text = "REQUEST\nFrom: Adam\nTo: Robert DATA",
    Res = sip_parse10:split_into_headers_and_data(Text),
    ?assertEqual([Text], Res).

split_register_into_headers_and_data_test() ->
    Text = "REGISTER HOST PORT NAME",
    Res = sip_parse10:split_into_headers_and_data(Text),
    ?assertEqual(["REGISTER", 
                  {host,"HOST"},
                  {port,"PORT"},
                  {name,"NAME"}],
                 Res).

split_malformed_register_into_headers_and_data_test() ->
    Text = "REGISTER HOST PORT\nNAME",
    Res = sip_parse10:split_into_headers_and_data(Text),
    ?assertEqual([Text], Res).
    

split_reply_into_headers_and_data_test() ->
    Text = "REPLY",
    Res = sip_parse10:split_into_headers_and_data(Text),
    ?assertEqual(["REPLY"], Res).

parse_sip_message_test() ->
    Text = "REQUEST\nFrom: Calvin\nTo: Hobbes\nTHIS_TEXT RIGHT HERE",
    Res = sip_parse10:parse_sip_message(Text),
    ?assertEqual(#sip_message{type = "REQUEST",
                              data = [{from,"Adam"},
                                      {to,"Robert"},
                                      {data,"DATA"}]},
                 Res).

%% Feel free to use, reuse and abuse the code in this file.

-module(http_errors).
-behaviour(cowboy_http_handler).
-export([init/3, handle/2, terminate/3]).

init({_Transport, http}, Req, _Opts) ->
	#{'case' := Case} = cowboy_req:match_qs(Req, ['case']),
    case_init(Case, Req).

case_init(<<"init_before_reply">> = Case, _Req) ->
	cowboy_error_h:ignore(?MODULE, case_init, 2),
    error(Case);
case_init(<<"init_after_reply">> = Case, Req) ->
	cowboy_error_h:ignore(?MODULE, case_init, 2),
    _ = cowboy_req:reply(200, [], "http_handler_crashes", Req),
    error(Case);
case_init(<<"init_reply_handle_error">> = Case, Req) ->
    Req1 = cowboy_req:reply(200, [], "http_handler_crashes", Req),
    {ok, Req1, Case};
case_init(<<"handle_before_reply">> = Case, Req) ->
    {ok, Req, Case};
case_init(<<"handle_after_reply">> = Case, Req) ->
    {ok, Req, Case}.

handle(_Req, <<"init_reply_handle_error">> = Case) ->
	cowboy_error_h:ignore(?MODULE, handle, 2),
    error(Case);
handle(_Req, <<"handle_before_reply">> = Case) ->
	cowboy_error_h:ignore(?MODULE, handle, 2),
    error(Case);
handle(Req, <<"handle_after_reply">> = Case) ->
	cowboy_error_h:ignore(?MODULE, handle, 2),
    _ = cowboy_req:reply(200, [], "http_handler_crashes", Req),
    error(Case).

terminate(_, _, _) ->
	ok.

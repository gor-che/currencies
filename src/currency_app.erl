-module(currency_app).
-behaviour(application).

-export([start/2]).
-export([stop/1]).

start(_Type, _Args) ->
    ets:new(pb,[set,named_table,public]),
    
    Dispatch = cowboy_router:compile([
        {'_', [{"/", currency_handler, []}]}
    ]),
    {ok, _} = cowboy:start_http(http, 100,
        [{port, 8088}],
        [{env, [{dispatch, Dispatch}]}]
    ),
	currency_sup:start_link().

stop(_State) ->
	ok.

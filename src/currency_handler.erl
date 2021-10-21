-module(currency_handler).
-behaviour(cowboy_http_handler).

-export([init/3]).
-export([handle/2]).
-export([terminate/3]).
-export([get_new_currency/0]).

init(_, Req, _Opts) ->
	{ok, Req, undefined}.

handle(Req0, State) ->
    case ets:lookup(pb, currency) of
        [] -> get_new_currency();
        [{currency,DateTime,_}] -> 
            {Date,TimeNow} = calendar:local_time(),
            {Days,Time} = calendar:time_difference(DateTime,{Date,TimeNow}),
            if Time > {0,1,0} -> get_new_currency();
                Days > 0 -> get_new_currency();
                true -> nothing end
    end,

    XML = case ets:lookup(pb,currency) of
        [{currency,_,Xml}] -> Xml;
        _ -> io:format("ETS is empty, check storage"),
            "ETS is empty"
    end,

    {ok, Req} = cowboy_req:reply(200,
        [{<<"content-type">>, <<"text/xml">>}],
        XML,Req0),
	{ok, Req, State}.


get_new_currency() ->
    Url = "https://api.privatbank.ua/p24api/pubinfo?json&exchange&coursid=5",

    case httpc:request(Url) of
        {ok,{_,_,Body}} ->
            PL = jsx:decode(list_to_binary(Body),[{labels,atom},{return_maps,false}]),
            Data = make_xml(PL),
            toETS(lists:flatten(Data));
        Else -> io:format("Problem with request to pb: ~p~n",[Else])
    end.

fields_to_xml(Fields) ->
    [  {row, [], [ {exchangerate, Props,[]}  ]}  || Props <- Fields].

make_xml(Fields) ->
    xmerl:export_simple([{exchangerates,fields_to_xml(Fields)}], xmerl_xml).

toETS(Xml)->
   ets:insert(pb,{currency,calendar:local_time(),Xml}).

terminate(_Reason, _Req, _State) ->
	ok.

%%%-------------------------------------------------------------------
%%% Created : 13. Juni 2011
%%%-------------------------------------------------------------------
-module(main).



-export([go/0
        ]).





%%====================================================================
%% External functions
%%====================================================================
%%

go() ->
    start(normal,{}).
%%--------------------------------------------------------------------
%% Func: start/2
%% Returns: {ok, Pid}        |
%%          {ok, Pid, State} |
%%          {error, Reason}   
%%--------------------------------------------------------------------
start(normal,_) ->
    log:log(info,"Boot up ~p,~p",[calendar:now_to_local_time(erlang:now()),self()]),
    random:uniform(),
    stdin:start(),
    stdout:start(),
    radar:start(),
    cannon:start(),
    mover:start(),
    messagehub:start().


    
    








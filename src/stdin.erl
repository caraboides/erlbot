%% Author: Christian Hennig (christian.hennig@freiheit.com)
%% Created: 13.06.2011
%% Description: TODO: Add description to stdin
-module(stdin).

%%
%% Include files
%%

%%
%% Include files
%%
-behavior(gen_component).

%%
%% Exported Functions
%%
-export([start/0,init/1,on/2]).

%%
%% API Functions
%%
start() ->
gen_component:start_link(?MODULE,{},[]).

init({}) ->
    register(?MODULE,self()),
    [].

on({get,Pid},S) ->
     self() ! next,
    [Pid|S];

on(next,S) ->
   case io:get_line('') of
                eof ->
                    log:log(error,"IN: ~p  --------------- Shutdown~n",[eof]),
                    init:stop();
                Text ->
                    Parsed = string:tokens(Text, " "),
                    WithoutLast = lists:reverse(tl(lists:reverse(Parsed))),
                    send_to_all(S,WithoutLast)
    end,
    self() ! next,
    S;

on(_,S) ->
 self() ! next,
 S.
    


%%
%% Local Functions
%%


send_to_all(Pids,Mesg) ->
    [ Pid ! Mesg || Pid <- Pids ]. 
    
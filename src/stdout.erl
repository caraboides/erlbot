%% Author: Christian Hennig (christian.hennig@freiheit.com)
%% Created: 13.06.2011
%% Description: TODO: Add description to output
-module(stdout).


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
    ok.

on({sTOP},_) ->
    off;
on({oN},_) ->
    ok;
    
on(M,ok) ->
    Out = lists:concat([M,"\n"]),
    io:put_chars(standard_io, Out),
    ok;

on(_,S) ->
    S.



%%
%% Local Functions
%%


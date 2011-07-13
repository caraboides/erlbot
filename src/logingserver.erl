%% Author: Christian Hennig (christian.hennig@freiheit.com)
%% Created: 21.06.2011
%% Description: TODO: Add description to logingserver
-module(logingserver).

%%
%% Include files
%%

%%
%% Exported Functions
%%
-export([go/0]).

%%
%% API Functions
%%
go() ->
    spawn(fun() ->  register(logger,self()),loop() end).
loop()->
    receive
        M ->
            io:format(M)
    end,
    loop().
        
    


%%
%% Local Functions
%%


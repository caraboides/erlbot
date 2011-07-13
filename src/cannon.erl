-module(cannon).

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


on({shootAtAngle,Angel,Target},ok) ->
    stdout ! rotateTo(Angel),
   {Target,Angel};

on({shootAtAngle,NAngel,Target},{Target,AngelOld}) ->
    Angel =NAngel +  NAngel - AngelOld,
    stdout ! rotateTo(Angel),
    {Target,0};

on({rotationReached},{Target,_Angel}) ->
    stdout ! shooooooooot(Target),
    stdout ! rotateTo(0),
    ok;


on({rotate,M},ok) ->
    stdout ! M,
    ok;





on({rotationReached},S) ->
    S;

on(_,S) ->
    S.


rotateTo(Angel) ->
    String = io_lib:format("RotateTo 2 ~p ~p",[1.5708,Angel]),
    String.

shooooooooot(rob) ->
    io_lib:format("Shoot ~p",[12]);

shooooooooot(mine) ->
    io_lib:format("Shoot ~p",[0.1]).
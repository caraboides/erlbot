%%  Author: Christian Hennig (christian.hennig@freiheit.com)
%% Created: 13.06.2011
%% Description: TODO: Add description to echo
-module(messagehub).
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
    stdin ! {get,self()},
    gb_trees:empty().


on(["Initialize","1"],S) ->
  timer:sleep(30),
  stdout ! io_lib:format("Name ~p Team: FCH",[node()]),
  timer:sleep(30),
  stdout ! "Colour 005DA8",
    mover ! {go},
  radar ! {go},
  S;

on(["GameOption",KeyS,Value],S) ->
  
  S;

on(["GameStarts"],S) ->
  stdout ! "Print I kill u! \n",
  S;

on(["Initialize",_Number],S) ->
  stdout ! "Print I kill u again! \n",
  mover ! {go},
  radar ! {go},
  S;

on(["Radar", EntfernungS,TypS,Radar_WinkelS],S) ->
    {Entfernung,_}=string:to_float(EntfernungS),
    {Typ,_}=string:to_integer(TypS),
    {Radar_Winkel,_}=string:to_float(Radar_WinkelS),
    radar ! {Typ,Entfernung,Radar_Winkel},
    S;

on(["Info", ZeitS,GeschwindigkeitS,Kanonen_WinkelS],S) ->
    S;

on(["Coordinates",XS,YS,AngleS],S) ->
    S;

on(["RobotInfo",Energie_LevelS,"0"],S) ->
    radar ! {prepareShoot},
    S;


on( ["RobotInfo",Energie_LevelS],S) ->
    radar ! {prepareShoot},
    S;

on(["RotationReached","1"],S) ->
    mover ! {rotationReached},
    S;

on(["RotationReached","2"],S) ->
    cannon ! {rotationReached},
    S;
on(["RotationReached","3"],S) ->
    cannon ! {rotationReached},
    S;
on(["RotationReached","4"],S) ->
   radar ! {rotationReached},
    S;


on(["RotationReached",Whar],S) ->

    S;

on(["Energy",EnergiS],S) ->
    %log:log(info,"Engergi: ~p",[EnergiS]),

    S;

on(["RobotsLeft",WhoS],S) ->
    S;

on(["Collision",WhatS,WhoS],S) ->
    {Typ,_}=string:to_integer(WhatS),
    {Radar_Winkel,_}=string:to_float(WhoS),
    radar ! {Typ,0,Radar_Winkel},
    S;

on(["Warning",Typ,Message],S) ->
    log:log(warn,"RTB: ~p ~p",[Typ,Message]),
    S;

on(["Dead"],S) ->
  
    S;

on(["GameFinishes"]=M,S) ->
   log:log(error,"IN: ~p  --------------- ~n",[M]),

   S;

on(["ExitRobot"]=M,S) ->
   log:log(error,"IN: ~p  --------------- Shutdown~n",[M]),

   init:stop(),
   S;

on(M,S) ->
   log:log(error,"IN: ~p  --------------- ~n",[M]),

   S.




                     
                  









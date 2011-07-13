-module(mover).

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
    {1,0,0}.


on({acc},{Radar_Winkel,Koef,Token}=S) ->
    Acc=     -0.7 + (1 -Koef)*1.3,
    stdout ! io_lib:format("Accelerate ~p \n",[Acc]),
    comm:send_local_after(300,self(), {acc}),
    {Radar_Winkel,Koef*0.7,Token};


on({rotate},{Radar_Winkel,Koef,Token}=S) when  Radar_Winkel == 0 ->
     comm:send_local_after(100,self(),{rotate}),
     {0,Koef,0};

on({rotate},{Radar_Winkel,Koef,0}=S) ->

            stdout ! io_lib:format("RotateAmount 1 0.785398 ~p \n",[Radar_Winkel]),
            NextTurn = max(abs(trunc((0.785398 * Radar_Winkel))),1)*1000,
            comm:send_local_after(NextTurn,self(),{rotate}),
            {0,Koef,0};

on({rotationReached},{Radar_Winkel,Koef,1}) ->
    self() ! {rotate},
    {0,Koef,0};

on({niceThing,Radar_Winkel,Entfernung},{_Radar_Winkel,Koef,_Token}=S) ->
    Acc=     -0.7 + (1 -Koef)*2,
    stdout ! io_lib:format("RotateAmount 1 0.785398 ~p \n",[Radar_Winkel*Acc]),
    {0,0,1};

on({wallwillHit,Radar_Winkel,Dist},{_Radar_Winkel,_Koef,Token}=S) ->
    Koef= 1 -(Dist/7),
    Angel = Koef*(math:pi()),
    {Angel,Koef,0};

on({go},S) ->
    %stdout ! io_lib:format("Accelerate ~p \n",[1]),
    comm:send_local_after(1000,self(), {acc}),
    comm:send_local_after(1000,self(), {rotate}),
    {1,0,0};

on(M,S) ->
    log:log(info,"Nocatch Mover: ~p in ~p",[M,S]),
    S.




-module(radar).

%%
%% Include files
%%
-behavior(gen_component).

%%
%% Exported Functions
%%
-export([start/0,init/1,on/2,norm/1]).

%%
%% API Functions
%%

-define(MAXRAND,1.2).
-define(MINRAND,-1.2).
-define(RADSPEED,2.0944).


start() ->
gen_component:start_link(?MODULE,{},[]).

init({}) ->
    register(?MODULE,self()),
    gb_trees:enter({richtung},1,gb_trees:empty()).


on({_Typ,_Entfernung,error},S) ->
   S;

on({2,Entfernung,Radar_Winkel_Bla},S) ->
    Radar_Winkel = norm( Radar_Winkel_Bla),
    case ((abs(Radar_Winkel)<?MAXRAND) and (Entfernung < 10)) of
        true ->
            mover ! {wallwillHit,Radar_Winkel,Entfernung};
        false ->
            ok
    end,
    updateRadarPos(S,Radar_Winkel);
   
on({3,Entfernung,Radar_Winkel_Bla},S) ->
    Radar_Winkel = norm( Radar_Winkel_Bla),
    mover ! {niceThing,Radar_Winkel,Entfernung},
    updateRadarPos(S,Radar_Winkel);

on({4,Entfernung,Radar_Winkel_Bla},S) ->
    Radar_Winkel = norm( Radar_Winkel_Bla),
    mover ! {wallwillHit,Radar_Winkel,Entfernung},
    updateRadarPos(S,Radar_Winkel);

on({Type,_Entfernung,Radar_Winkel_Bla},S) ->
    Radar_Winkel = norm( Radar_Winkel_Bla),
    updateRadarPos(S,Radar_Winkel);

on({go},S) ->
     simpleRotate(S);

on({prepareShoot},S) ->
    Angel = getAngel(S),
    cannon ! {shootAtAngle,Angel*0.76,rob},
    mover ! {niceThing,Angel*1.2,10},
    self() ! {robfound},
    S;


on({robfound},S) ->
    backRotate(S);
    



on({rotationReached},S) ->
   S;

on({check_radar},S) ->
   simpleRotate(S);


on(M,S) ->
        log:log(info,"Nocatch RADAR: ~p in ~p",[M,S]),
    S.

getAngel(S) ->
    {_,Se,Mi} = now(),
    AcSec = Se +  (Mi / 1000000),
    OldSec = gb_trees:get({timeLastUp},S),
    Elebs = AcSec - OldSec,
    OldPos = gb_trees:get({radar},S),
    Direction = gb_trees:get({richtung},S),
    NewPos = OldPos + (Direction*Elebs*2.0944),
    NewPos.



updateRadarPos(S,Newpos) ->

     S1 = gb_trees:enter({radar},Newpos , S),
     {_Ma,Se,Mi} = now(),
     AcSec = Se +  (Mi / 1000000),
     S2 = gb_trees:enter({timeLastUp},AcSec , S1),
     S2.


simpleRotate(S) ->
    Dnew = -1*gb_trees:get({richtung},S),
    case Dnew of
        -1 ->
            String = io_lib:format("RotateTo 4 ~p ~p",[?RADSPEED,?MINRAND]);
        _ ->
            String = io_lib:format("RotateTo 4 ~p ~p",[?RADSPEED,?MAXRAND])
    end,
    stdout ! String,
    Time = trunc((?MAXRAND*2 / ?RADSPEED ) * 1000),
    comm:send_local_after(Time, self(), {check_radar}),
    gb_trees:enter({richtung}, Dnew, S).

backRotate(S) ->
    Dnew = -1*gb_trees:get({richtung},S),
    case Dnew of
        -1 ->
            String = io_lib:format("RotateTo 4 ~p ~p",[?RADSPEED,?MINRAND]);
        _ ->
            String = io_lib:format("RotateTo 4 ~p ~p",[?RADSPEED,?MAXRAND])
    end,
    comm:send_local_after(200, stdout, String),
    gb_trees:enter({richtung}, Dnew, S).


norm(W) ->
    case (abs(W) > math:pi()) of
        true ->
            do_norm(W);
        false ->
            W
    end.

do_norm(W) ->
    NewW = case W > 0 of
        true ->
            W - math:pi()*2;
        false ->
                W+ math:pi()*2
    end,
    norm(NewW).
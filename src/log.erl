%   Licensed under the Apache License, Version 2.0 (the "License");
%   you may not use this file except in compliance with the License.
%   You may obtain a copy of the License at
%
%       http://www.apache.org/licenses/LICENSE-2.0
%
%   Unless required by applicable law or agreed to in writing, software
%   distributed under the License is distributed on an "AS IS" BASIS,
%   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
%   See the License for the specific language governing permissions and
%   limitations under the License.

%% @doc log service
-module(log).



-export([log/2, log/3]).

-ifdef(with_export_type_support).
-export_type([log_level/0]).
-endif.

%-type log_level() :: debug | info | warn | error | fatal.


-define(DEBUG,true).
-define(INFO,true).
-define(WARN,true).
-define(ERROR,true).
-define(FATAL,true).




log(Level, Log) ->
    case Level of
        info ->
            case ?INFO of
                true -> 
                    out(Level, Log);
                false ->
                    ok
            end;
        debug ->
            case ?DEBUG of
                true -> 
                    out(Level, Log);
                false ->
                    ok
            end;
  warn ->
            case ?WARN of
                true -> 
                    out(Level, Log);
                false ->
                    ok
            end;
  error ->
            case ?ERROR of
                true -> 
                    out(Level, Log);
                false ->
                    ok
            end;
 fatal ->
            case ?FATAL of
                true -> 
                    out(Level, Log);
                false ->
                    ok
            end
end.



log(Level, Log, Data) ->
       case Level of
        info ->
            case ?INFO of
                true -> 
                   out(Level, Log, Data);
                false ->
                    ok
            end;
        debug ->
            case ?DEBUG of
                true -> 
                   out(Level, Log, Data);
                false ->
                    ok
            end;
  warn ->
            case ?WARN of
                true -> 
                   out(Level, Log, Data);
                false ->
                    ok
            end;
  error ->
            case ?ERROR of
                true -> 
                   out(Level, Log, Data);
                false ->
                    ok
            end;
 fatal ->
            case ?FATAL of
                true -> 
                   out(Level, Log, Data);
                false ->
                    ok
            end
end .
   

out(Level, Log) ->
    out(Level,Log,[]).

%% out(Level, Log, Data) ->
%%     io:format("[~p]",[Level]),
%%     io:format( Log, Data),
%%     io:format("~n").

out(Level, Log, Data) ->
    Pid = {logger,loging@anilin} , 
    Pid ! io_lib:format("[~p]",[Level]),
    Pid ! io_lib:format(Log, Data),
    Pid ! io_lib:format("~n",[]).





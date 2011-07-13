-module(comm).

-export([send/2, send_local/2, send_local_after/3]).

send(Pid, Message) ->
    send_local(Pid, Message).

send_local(Pid, Message) ->
    Pid ! Message,
    ok.

send_local_after(Delay, Pid, Message) ->
    erlang:send_after(Delay, Pid, Message).
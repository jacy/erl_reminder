%% @author jacy
%% @doc @todo Add description to client.


-module(client).
-compile(export_all).
-define(SERVER,?MODULE).
%% ====================================================================
%% API functions
%% ====================================================================

subscribe(Pid) ->
    Ref = erlang:monitor(process, whereis(?SERVER)),
    ?SERVER ! {self(), Ref, {subscribe, Pid}},
    receive
        {Ref, ok} ->
            {ok, Ref};
        {'DOWN', Ref, process, _Pid, Reason} ->
            {error, Reason}
    after 5000 ->
        {error, timeout}
end.

add_event(Name, Description, TimeOut) ->
    Ref = make_ref(),
  	?SERVER ! {self(), Ref, {add, Name, Description, TimeOut}},
    receive
        {Ref, Msg} -> Msg
    after 5000 ->
        {error, timeout}
    end.

%% ====================================================================
%% Internal functions
%% ====================================================================



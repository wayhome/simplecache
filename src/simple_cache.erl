-module(simple_cache).
-export([insert/2, lookup/1, delete/1]).

insert(Key, Value) ->
    case simplecache_store:lookup(Key) of
        {ok, Pid} ->
            simplecache_element:replace(Pid, Value),
            simplecache_event:replace(Key, Value);
        {error, _} ->
            {ok, Pid} = simplecache_element:create(Value),
            simplecache_store:insert(Key, Pid),
            simplecache_event:create(Key, Value)
    end.

lookup(Key) ->
    try
        {ok, Pid} = simplecache_store:lookup(Key), 
        {ok, Value} = simplecache_element:fetch(Pid),
        simplecache_event:lookup(Key),
        {ok, Value}
    catch
        _Class:_Exception ->
            {error, not_found}
    end.

delete(Key) ->
    case simplecache_store:lookup(Key) of
        {ok, Pid} ->
            simplecache_element:delete(Pid),
            simplecache_event:delete(Key);
        {error, _Reason} ->
            ok
   end.

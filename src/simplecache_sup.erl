-module(simplecache_sup).

-behaviour(supervisor).

%% API
-export([start_link/0]).

%% Supervisor callbacks.
-export([init/1]).

-define(SERVER, ?MODULE).

start_link() ->
    supervisor:start_link({local, ?SERVER}, ?MODULE, []).

init([]) ->
    ElementSup = {simplecache_element_sup, {simplecache_element_sup, start_link, []},
                 permanent, 2000, supervisor, [simplecache_element]},

    EventManager = {simplecache_event, {simplecache_event, start_link, []},
                 permanent, 2000, worker, [simplecache_event]},

    Children = [ElementSup, EventManager],
    RestartStrategy = {one_for_one, 4, 3600},
    {ok, {RestartStrategy, Children}}.


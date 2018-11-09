-module(resource_instance).
-behaviour(gen_server).

-export([create/2, start_link/0]).
-export([list_connectors/1, list_locations/1]).
-export([get_type/1, get_ops/1]).
-export([init/1, handle_call/3, handle_cast/2]).

%%% More to follow later. 

start_link() ->
    gen_server:start_link({local, resource_instance_server},?MODULE, [], []).

init([]) ->
%De State is momenteel niks
%die is initieel leeg
    {ok, []}.
		

	
list_connectors(ResInst_Pid) ->
	gen_server:call(resource_instance_server,{get_connectors,ResInst_Pid}).

list_locations(ResInst_Pid) ->
	gen_server:call(resource_instance_server,{get_locations,ResInst_Pid}).
	
get_type(ResInst_Pid) ->
	gen_server:call(resource_instance_server,{get_type,ResInst_Pid}).

get_ops(ResInst_Pid) ->
	gen_server:call(resource_instance_server,{get_ops,ResInst_Pid}).


create(Selector, Environment) -> 
	apply(Selector, create, Environment).
	% returns {ok, ResInst_Pid}
	
handle_call({get_connectors, ResInst_Pid},_From,State) ->
	Connectors = msg:get(ResInst_Pid, get_connectors),
	{reply,Connectors,State};
	
handle_call({get_locations, ResInst_Pid},_From,State) ->
	Connectors = msg:get(ResInst_Pid, get_locations),
	{reply,Connectors,State};

handle_call({get_type, ResInst_Pid},_From,State) ->
	Connectors = msg:get(ResInst_Pid, get_type),
	{reply,Connectors,State};
	
handle_call({get_ops, ResInst_Pid},_From,State) ->
	Connectors = msg:get(ResInst_Pid, get_ops),
	{reply,Connectors,State}.
	
handle_cast({_Msg}, State) ->
	{noreply, State}.
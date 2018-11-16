-module(pipeInst).
-behaviour(gen_server).
-export([create/2, init/1]).
-export([handle_call/3, handle_cast/2]). 

create(Host, ResTyp_Pid) -> 
	gen_server:start_link(?MODULE,[Host, ResTyp_Pid],[]).
	%{ok, spawn(?MODULE, init, [Host, ResTyp_Pid])}.

init([Host, ResTyp_Pid]) -> 
	io:format("Init pipe instance~n"),
	State = resource_type:get_initial_state(ResTyp_Pid, self(), []),
	survivor:entry({ pipeInst_created, State }),
	{ok, {Host, State, ResTyp_Pid}}.

handle_call({get_connectors,_Ref},_From,{Host, State, ResTyp_Pid})->
	C_List = resource_type:get_connections_list(ResTyp_Pid, State), 
	{reply,{ok,C_List},{Host, State, ResTyp_Pid}};
	
handle_call({get_locations,_Ref},_From,{Host, State, ResTyp_Pid})->
	List = resource_type:get_locations_list(ResTyp_Pid, State),
	{reply,{ok,List},{Host, State, ResTyp_Pid}};

handle_call({get_type,_Ref},_From,{Host, State, ResTyp_Pid})->
	{reply,ResTyp_Pid,{Host, State, ResTyp_Pid}};

handle_call({get_ops,_Ref},_From,{Host, State, ResTyp_Pid})->
	{reply,[],{Host, State, ResTyp_Pid}}.

handle_cast(something,State) ->
	{noreply,State}.
	
%loop(Host, State, ResTyp_Pid) -> 
%	receive
%		{get_connectors, ReplyFn} ->
%			{ok,C_List} = resource_type:get_connections_list(ResTyp_Pid, State), 
%			ReplyFn(C_List),
%			loop(Host, State, ResTyp_Pid);
%		{get_locations, ReplyFn} ->
%			{ok, List} = resource_type:get_locations_list(ResTyp_Pid, State),
%			ReplyFn(List),
%			loop(Host, State, ResTyp_Pid);
%		{get_type, ReplyFn} -> 
%			ReplyFn(ResTyp_Pid),
%			loop(Host, State, ResTyp_Pid);
%		{get_ops, ReplyFn} ->
%			ReplyFn([]),
%			loop(Host, State, ResTyp_Pid)
%	end.
	
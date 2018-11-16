-module(resource_type).
%-behaviour(gen_server).
-export([create/2]).
-export([get_initial_state/3, get_connections_list/2, get_locations_list/2]).

%start_link() ->

%init() ->



create(Selector, ParameterList) -> 
	% e.g. called as follows: 
	%
	% 	resource_type:create(pipeTyp, []). 
	%
	% resource type creation must select a specific type
	% creation of an abstract (partially defined) type is
	% not possible. Returns {ok, ResTyp_Pid}. 
	io:format("Creating "),
	io:format(Selector),
	io:format(" in resource_type~n"),
	apply(Selector, create, ParameterList).
	
get_initial_state(ResTyp_Pid, ResInst_Pid, TypeOptions) -> 
	io:format("Resource Type: Get initial state~n"),
	State = msg:get(ResTyp_Pid, initial_state, [ResInst_Pid, TypeOptions]),
	io:format("Resource Type: Received initial state~n"),
	State.
%	{ok, State} = resource_type:get_initial_state(ResTyp_Pid, self(), []),
	
get_connections_list(ResTyp_Pid, State) -> 
	msg:get(ResTyp_Pid, connections_list, State).

get_locations_list(ResTyp_Pid, State) -> 
	msg:get(ResTyp_Pid, locations_list, State). 
	
%%% More functions to follow later. 

-module(systemSupervisor).
-behaviour(supervisor).

-export([start_link/0]).
-export([init/1]).
-export([addNewPipe/0, getPipeTypSpec/0, getPipeTypSpec/1]).
-export([crashPipeTyp/0]).

start_link() ->
	supervisor:start_link({local,?MODULE}, ?MODULE, []).


init([]) ->	
	SupFlags = #{strategy => one_for_one, intensity => 1, period => 5},
    ChildResInstance = #{id => res_instance,
                    start => {resource_instance, start_link, []},
                    restart => permanent,
                    shutdown => brutal_kill,
                    type => worker,
                    modules => [resource_instance]},
	ChildPipeTyp = #{id => pipetype,
                    start => {pipeTyp, start_link, []},
                    restart => permanent,
                    shutdown => brutal_kill,
                    type => worker,
                    modules => [pipeTyp]},
	ChildPipesSupervisor = #{id => pipesupervisor,
							start => {pipeSupervisor, start_link, [3]},
							restart => permanent,
							shutdown => brutal_kill,
							type => worker,
							modules => [pipeSupervisor]},
	
	ChildSpecs = [ChildResInstance,ChildPipeTyp,ChildPipesSupervisor],
    {ok, {SupFlags, ChildSpecs}}.

% addNewPipe() ->
	% Ref = make_ref(),
	% %{ok, Child} = getPipeTypSpec(),
	
	% ChildSpec = #{id => Ref,
				% start => {pipeInst, create, [self(), getPipeTypSpec()]},
				% restart => permanent,
				% shutdown => brutal_kill,
				% type => worker,
				% modules => [pipeInst]},
	% supervisor:start_child(?MODULE, ChildSpec),
	% {ok,Ref}.

% getPipeTypSpec() ->	
	% AllChildren = supervisor:which_children(?MODULE),
	% {ok, Child} = getPipeTypSpec(AllChildren),
	% Child.

% getPipeTypSpec([{pipetype,Child,_Type,_Modules}|_Other]) ->
	% {ok,Child};
	
% getPipeTypSpec([]) ->
	% {error, no_pipetype_present};
	
% getPipeTypSpec([_First|Other]) ->
	% getPipeTypSpec(Other).
	
crashPipeTyp() ->
	msg:get(getPipeTypSpec(), stop).

	

	
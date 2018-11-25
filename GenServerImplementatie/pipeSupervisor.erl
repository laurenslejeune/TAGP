-module(pipeSupervisor).
-behaviour(supervisor).

-export([start_link/1]).
-export([init/1]).

start_link(N) ->
	supervisor:start_link({local,?MODULE}, ?MODULE, [N]).

	
init([N]) ->
	%%N is the number of pipes to be created
	
	%%If all the children crash, and then another one crashes again, something is very wrong
	%%In that case, terminate the supervisor and leave it up its supervisor to fix things
	SupFlags = #{strategy => one_for_one, intensity => N+1, period => 5},
	
	%%Generate the required N pipes
	{_Refs,Pipes} = generateNPipes(N),
	
	survivor:entry(pipeSupervisor_created),
	{ok, {SupFlags, Pipes}}.	
	
generateNPipes(1) ->
	Ref = make_ref(),
	PipeChild = #{id => Ref,
				start => {pipeInst, create, [self(), pipeTyp_server]},
				restart => permanent,
				shutdown => brutal_kill,
				type => worker,
				modules => [pipeInst]},
	{[Ref],[PipeChild]};
	
generateNPipes(N) -> 
	
	Ref = make_ref(),
	Pipe  = #{id => Ref,
			start => {pipeInst, create, [self(), pipeTyp_server]},
			restart => permanent,
			shutdown => brutal_kill,
			type => worker,
			modules => [pipeInst]},
	{OtherRefs, OtherPipes} = generateNPipes(N-1),
	{OtherRefs++[Ref],OtherPipes++[Pipe]}.
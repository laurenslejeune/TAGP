-module(pipeTyp).
-behaviour(gen_server).
-export([start_link/0]). % More to be added later. 
-export([init/1, handle_call/3, handle_cast/2]).

start_link() ->
	%survivor:entry(pipeTyp_created),
	io:format("pipeTyp created ~n"),
	%PipeTyp_server = spawn(?MODULE, init, []),
	{ok, PipeTyp_server} = gen_server:start_link({local, pipeTyp_server},?MODULE, [], []),
	{ok, PipeTyp_server}.

init([]) -> 
	survivor:entry(pipeTyp_created),
	{ok,[]}.
	%loop().

handle_call(test, _From, _State) ->
	io:format("Dit is een test~n"),
	{reply,reply,[]};
	
handle_call({initial_state, [ResInst_Pid, TypeOptions], _Ref},_From,_State) ->
	io:format("Geraak ik tot ier ?~n"),
	{ok, Location} = location:create(ResInst_Pid, emptySpace), %-> Deze moet nog geïmplementeerd worden
	{ok, In} = connector:create(ResInst_Pid, simplePipe),
	{ok, Out} = connector:create(ResInst_Pid, simplePipe),

	Reply = #{resInst => ResInst_Pid, chambers => [Location], 
			cList => [In, Out], typeOptions => TypeOptions},
	{reply,Reply,[]};

handle_call({connections_list, State, _Ref},_From,_State) ->
	#{cList := C_List} = State, 
	{reply,C_List, []};
	
handle_call({locations_list, State, _Ref}, _From,_State) ->
	#{chambers := L_List} = State,
	{reply, L_List, []}.
	
handle_cast(something,_State) ->
	{noreply,[]}.
	
%loop() -> 
%	receive
%		{initial_state, [ResInst_Pid, TypeOptions], ReplyFn} ->
%			Location = location:create(ResInst_Pid, emptySpace),
%			In = connector:create(ResInst_Pid, simplePipe),
%			Out = connector:create(ResInst_Pid, simplePipe),
%			ReplyFn(#{resInst => ResInst_Pid, chambers => [Location], 
%					cList => [In, Out], typeOptions => TypeOptions}), 
%			loop();
%		{connections_list, State , ReplyFn} -> 
%			#{cList := C_List} = State, ReplyFn(C_List), 
%			loop();
%		{locations_list, State, ReplyFn} -> 
%			#{chambers := L_List} = State, ReplyFn(L_List),
%			loop()
%	end. 

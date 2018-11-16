-module(connector).
-behaviour(gen_server).

-export([create/2]).
-export([connect/2, disconnect/1, discard/1]).
-export([get_connected/1, get_ResInst/1, get_type/1]).
-export([init/1, handle_call/3, handle_cast/2]).

%start_link(ResInst_Pid, ConnectTyp_Pid) ->
%    gen_server:start_link({local, make_ref()},?MODULE, [{ResInst_Pid, ConnectTyp_Pid}], []).

create(ResInst_Pid, ConnectTyp_Pid) -> 
	gen_server:start_link(?MODULE, [ResInst_Pid, ConnectTyp_Pid], []).
	
	%Probleem met deze code:
	%	Als de hele tijd dezelfde ref -> crasht
	%	Wilt echter ook niet werken met make_ref
	%gen_server:start_link({local, make_ref()},?MODULE, [ResInst_Pid, ConnectTyp_Pid], []).
	

init([ResInst_Pid, ConnectTyp_Pid]) -> 
	survivor:entry(connector_created), 
	State = {ResInst_Pid, disconnected, ConnectTyp_Pid},
	{ok,State}.
%	loop(State).

connect(Connector_Pid, C_Pid) ->
	gen_server:cast(Connector_Pid,{connect,C_Pid}).

disconnect(Connector_Pid) ->
	gen_server:cast(Connector_Pid,disconnect).
 
get_connected(Connector_Pid) ->
	msg:get(Connector_Pid, get_connected).

get_ResInst(Connector_Pid) ->
	msg:get(Connector_Pid, get_ResInst).
	
get_type(Connector_Pid) ->
	msg:get(Connector_Pid, get_type ).

		
discard(Connector_Pid) -> 
	gen_server:cast(Connector_Pid,disconnect).
	
% Connectors do not survive their ResInst, nor do they 
% move/change from one ResInst to another. 


%loop(ResInst_Pid, Connected_Pid, ConnectTyp_Pid) -> 
%	receive
%		{connect, C_Pid} -> 
%			survivor:entry({connection_made, self(), C_Pid, for , ResInst_Pid}),
%			loop(ResInst_Pid, C_Pid, ConnectTyp_Pid); 
%		disconnect -> 
%			loop(ResInst_Pid, disconnected, ConnectTyp_Pid);
%		{get_connected, ReplyFn} -> 
%			ReplyFn(Connected_Pid),
%			loop(ResInst_Pid, Connected_Pid, ConnectTyp_Pid);
%		{get_ResInst, ReplyFn} -> 
%			ReplyFn(ResInst_Pid),
%			loop(ResInst_Pid, Connected_Pid, ConnectTyp_Pid);
%		{get_type, ReplyFn} -> 
%			ReplyFn(ConnectTyp_Pid),
%			loop(ResInst_Pid, Connected_Pid, ConnectTyp_Pid);	
%		discard -> 
%			survivor:entry(connector_discarded),
%			stopped
%	end. 

handle_cast({connect, C_Pid}, {ResInst_Pid, _Connected_Pid, ConnectTyp_Pid}) -> % {...} = State
    survivor:entry({connection_made, self(), C_Pid, for , ResInst_Pid}),
	{noreply, {ResInst_Pid, C_Pid, ConnectTyp_Pid}};
	
handle_cast(disconnect, {ResInst_Pid, _Connected_Pid, ConnectTyp_Pid}) -> % {...} = State
	{noreply, {ResInst_Pid, disconnected, ConnectTyp_Pid}};
	
handle_cast(discard, {_ResInst_Pid, _Connected_Pid, _ConnectTyp_Pid}) -> % {...} = State
	survivor:entry(connector_discarded),
	ServerRef = self(),
	gen_server:stop(ServerRef),
	{noreply,stopped}.
	
handle_call(get_connected, _From,{ResInst_Pid, Connected_Pid, ConnectTyp_Pid}) -> % {...} = State
	{reply,Connected_Pid, {ResInst_Pid, Connected_Pid, ConnectTyp_Pid}};

handle_call(get_ResInst, _From, {ResInst_Pid, Connected_Pid, ConnectTyp_Pid}) -> % {...} = State
	{reply, ResInst_Pid, {ResInst_Pid, Connected_Pid, ConnectTyp_Pid}};

handle_call(get_type, _From, {ResInst_Pid, Connected_Pid, ConnectTyp_Pid}) -> % {...} = State
	{reply, ConnectTyp_Pid, {ResInst_Pid, Connected_Pid, ConnectTyp_Pid}}.	


%The terminate callback is optional, a default version is provided
%terminate(Reason, {ResInst_Pid, Connected_Pid, ConnectTyp_Pid}) ->
%.
	
%test() -> 
%	C1_Pid = create(self(), dummy1_pid),
%	C2_Pid = create(self(), dummy2_pid),
%	connect(C1_Pid, C2_Pid),
%	{C1_Pid, C2_Pid}.

	
		
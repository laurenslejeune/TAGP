-module(location).
-behaviour(gen_server).
-export([create/2, get_ResInst/1, get_Visitor/1, get_Type/1, arrival/2, departure/1, dispose/1]).
-export([init/1,handle_call/3, handle_cast/2]). 

create(ResInst_Pid, LocationTyp_Pid) ->
	gen_server:start_link(?MODULE,[ResInst_Pid, LocationTyp_Pid],[]).
	%spawn(?MODULE, init, [ResInst_Pid, LocationTyp_Pid]).
	
init([ResInst_Pid, LocationTyp_Pid]) ->
	io:format("hoe ver kom ik?~n"),
	{ok,{ResInst_Pid, LocationTyp_Pid, vacant}}.
	
get_ResInst(Location_Pid) -> 
	msg:get(Location_Pid, get_ResInst).

get_Visitor(Location_Pid) ->
	msg:get(Location_Pid, get_Visitor).
	
get_Type(Location_Pid) ->
	msg:get(Location_Pid, get_Type).
	
arrival(Location_Pid, Visitor_Pid) ->
	gen_server:cast(Location_Pid,{arrived,Visitor_Pid}).

departure(Location_Pid) ->
	gen_server:cast(Location_Pid,departed).

dispose(Location_Pid) ->
	gen_server:cast(Location_Pid,remove).

handle_call(get_ResInst,_From,{ResInst_Pid, LocationTyp_Pid, Visitor_Pid}) ->
	{reply,ResInst_Pid,{ResInst_Pid, LocationTyp_Pid, Visitor_Pid}};
	
handle_call(get_Visitor,_From,{ResInst_Pid, LocationTyp_Pid, Visitor_Pid}) ->
	{reply,Visitor_Pid,{ResInst_Pid, LocationTyp_Pid, Visitor_Pid}};

handle_call(get_Type, _From, {ResInst_Pid, LocationTyp_Pid, Visitor_Pid}) ->
	{reply,LocationTyp_Pid,{ResInst_Pid, LocationTyp_Pid, Visitor_Pid}}.

handle_cast({arrived,V_Pid},{ResInst_Pid, LocationTyp_Pid, _Visitor_Pid}) ->
		{noreply,{ResInst_Pid, LocationTyp_Pid, V_Pid}};

handle_cast(departed,{ResInst_Pid, LocationTyp_Pid, _Visitor_Pid}) ->
		{noreply,{ResInst_Pid, LocationTyp_Pid, vacant}};

handle_cast(remove,State) ->
		ServerRef = self(),
		gen_server:stop(ServerRef),
		{noreply,State}.

		%loop(ResInst_Pid, LocationTyp_Pid, Visitor_Pid) -> 
%	receive
%		{get_ResInst, ReplyFn} -> 
%			ReplyFn(ResInst_Pid),
%			loop(ResInst_Pid, LocationTyp_Pid, Visitor_Pid);
%		{get_Visitor, ReplyFn} -> 
%			ReplyFn(Visitor_Pid),
%			loop(ResInst_Pid, LocationTyp_Pid, Visitor_Pid);
%		{get_Type, ReplyFn} -> 
%			ReplyFn({LocationTyp_Pid}),
%			loop(ResInst_Pid, LocationTyp_Pid, Visitor_Pid);
%		{arrived, V_Pid} ->
%			loop(ResInst_Pid, LocationTyp_Pid, V_Pid);
%		departed -> 
%			loop(ResInst_Pid, LocationTyp_Pid, vacant);
%		remove -> 
%			stopped
%	end. 
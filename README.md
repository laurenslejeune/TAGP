# TAGP
Hoe gaan we dit doen:
0) Start survivor en observer
1) {ok, typePID} = resource_type:create(pipeTyp,[]).
	Dit roept de create functie van de pipeTyp op, zonder parameters (zoals vereist)
2) {ok,ResPID}=resource_instance:create(pipeInst,[self(),TypePID]).
	Dit roept de create functie van de pipe instance op, parameters zijn bijhorende TypPID en PID vd host
	
Course material

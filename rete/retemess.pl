% Copyright (c) Gruppo IA, 2017
% Gestione dei messaggi e degli errori

message(N) :- message(N,'').

message(N,Args) :-
	mess(N,break,Text),
	write(break),tab(1),write(N),write(': '),write(Text),write(Args),nl.
%	break.
message(N,Args) :-
	mess(N,error,Text),
	write(error),tab(1),write(N),write(': '),write(Text),write(Args),nl,
	!, fail.
message(N,Args) :-
	mess(N,Type,Text),
	mess_types(TT),
	member(Type,TT),
	write(Type),tab(1),write(N),write(': '),write(Text),write(Args),nl,
	!.
message(_,_).

mess_types([info,trace,warning,debug]).

set_messtypes :-
	message(001,[info,warn,trace,error,debug]),
	mess_types(X),
	message(002,X),
	read(MT),
	retract( mess_types(_) ),
	asserta( mess_types(MT) ).

mess(001,info, 'Legal Message Types: ').		%  set_message
mess(002,info, 'Current Message Types: ').		%  set_message

mess(101,info, 'Initializing').				%  initialize
mess(102,info, 'Initialization Complete').		%  initialize
mess(103,error, 'Initialization Error').		%  initialize

mess(104,trace, 'Rule Firing: ').				%  go
mess(105,trace, 'Conflict Set Delete: ').		%  del_confli...
mess(106,trace, 'Failed to CS Delete: ').		%  del_confli...
mess(107,trace, 'Conflict Set Add: ').			%  add_confli...
mess(108,error, 'Premature end to run: ').		%  go
mess(109,trace, 'Asserting: ').				%  add_ws
mess(110,trace, 'Failing Action Part: ').		%  process
mess(111,trace, 'Rule Fired: ').				%  process
mess(112,debugx, 'Conflict Set').				%  select_rule

mess(201,info, 'Rule Rete Network Complete').	%  rete_compil
mess(202,info, 'Rule: ').					%  rete_comp
mess(203,error, 'Rule Failed to Compile: ').		%  rete_comp

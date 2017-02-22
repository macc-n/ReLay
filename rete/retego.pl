% Copyright (c) Gruppo IA, 2017

:- reconsult('retemess.pl').

:- dynamic (gfactid/1).
	
%Comando Relay 13
%Start GIE with RETE pattern matching
% inizializzazione dell'ambiente
initialize :-
	message(101),
	abolish(memory,2),
	abolish(inst,3),
	setchron(1),
	abolish(conflict_set,1),
	assert(conflict_set([])),
	assert(mea(no)),
	forall(fact(X,Y,Z),assert_fact_memory(fact(X,Y,Z))),
	message(102), !.
initialize :-
	message(103).
	
setchron(N) :-
	retract( chron(_) ),
	asserta( chron(N) ),!.
setchron(N) :-
	asserta( chron(N) ).

assert_fact_memory(fact(X,Y,Z)) :-
	retract(gfactid(N)),
	greater(N,X,ID),
	assert(gfactid(ID)),
	assert_ws(fact(X,Y,Z)).

greater(X,Y,Z) :-
	(X>Y -> Z=X; Z=Y).

	
	
	
%Comando Relay 13
%Start GIE with RETE pattern matching
% inizia il ragionamento forward
go :-
	conflict_set(CS),
	select_rule(CS,inst(ID,LHS,RHS)),
	message(104,ID),
	(process(ID,RHS,LHS); true),
	del_conflict_set(ID,LHS,RHS),
	!,go.
go :-
	conflict_set([]),
	write('Conflict set is empty'),nl,
	!.
go :-
	message(108).

% seleziona la regola da attivare
select_rule(CS,R) :-
	message(112,CS),
	mea_filter(0,CS,[],CSR),
	lex_sort(CSR,R).
	
% gestione dell'ordinamento delle regole nel conflict set
mea_filter(_,X,_,X) :- not mea(yes), !.
mea_filter(_,[],X,X).
mea_filter(Max,[inst(N,[A/T|Z],C)|X],Temp,ML) :-
	T < Max,
	!, mea_filter(Max,X,Temp,ML).
mea_filter(Max,[inst(N,[A/T|Z],C)|X],Temp,ML) :-
	T = Max,
	!, mea_filter(Max,X,[inst(N,[A/T|Z],C)|Temp],ML).
mea_filter(Max,[inst(N,[A/T|Z],C)|X],Temp,ML) :-
	T > Max,
	!, mea_filter(T,X,[inst(N,[A/T|Z],C)],ML).
lex_sort(L,R) :-
	build_keys(L,LK),
	sort(LK,X),
	reverse(X,[K-R|_]).
	
build_keys([],[]).
build_keys([inst(N,TokenList,C)|T],[Key-inst(N,TokenList,C)|TR]) :-
	build_chlist(TokenList,ChL),
	sort(ChL,X),
	reverse(X,Key),
	build_keys(T,TR).

build_chlist([],[]).
build_chlist([_/Chron|T],[Chron|TC]) :-
	build_chlist(T,TC).


% esegue ricorsivamente ogni azione nella parte destra della regola
process(N,[],_) :- message(111,N), !.
process(N,[Action|Rest],LHS) :-
	take(Action,LHS),
	!,process(N,Rest,LHS).
process(N,[Action|Rest],LHS) :-
	message(110,N), !, fail.
	
test(not(X)) :- !.
test(X#Y) :- X=Y,!.
test(X>Y) :- X>Y,!.
test(X>=Y) :- X>=Y,!.
test(X<Y) :- X<Y,!.
test(X=<Y) :- X=<Y,!.
test(X \= Y) :- not X=Y, !.
test(X = Y) :- X=Y, !.
test(X = Y) :- X is Y,!.
test(is_on(X,Y)) :- is_on(X,Y),!.
test(call(X)) :- call(X).

% esegue l'azione richiesta
take(A,_) :-take(A),!.
take(retract(X)) :- retract_ws(X), !.
take(X) :-
	X=..[Name|List],
	gen_fact_id(G),
	assert(fact(G,X,1)),
	assert_ws(fact(G,X,1)),
	!.
take(X # Y) :- X=Y,!.
take(X = Y) :- X is Y,!.
take(write(X)) :- write(X),!.
take(write_line(X)) :- write_line(X),!.
take(nl) :- nl,!.
take(read(X)) :- read(X),!.
take(prompt(X,Y)) :- nl,write(X),read(Y),!.
take(cls) :- cls, !.
take(is_on(X,Y)) :- is_on(X,Y), !.
take(list(X)) :- lst(X), !.
take(call(X)) :- call(X).	
	
% elabora il fatto all'interno della struttura
assert_ws(fact(X,Y,Z)) :-
	message(109,Y),
	addrete(Y,TimeStamp).

% aggiunge una regola al conflict set
add_conflict_set(N,TokenList,Action) :-
	message(107,N),
	retract( conflict_set(CS) ),
	asserta( conflict_set([inst(N,TokenList,Action)|CS]) ).	

% rimuove una regola dal conflict set
del_conflict_set(N,TokenList,Action) :-
	conflict_set(CS),
	remove(inst(N,TokenList,Action),CS,CS2),
	message(105,N),
	retract( conflict_set(_) ),
	asserta( conflict_set(CS2) ).
del_conflict_set(N,TokenList,Action) :-
	message(106,N).

% ciclo repeat-fail per trovare le corrispondenze tra i nodi radice e le clausole
% crea un token di tipo add e lo invia nella struttura
addrete(Fact,TimeStamp) :-
	root(ID,Fact,NextList),
	send(tok(add,[Fact/TimeStamp]), NextList),
	fail.
addrete(_,_).

% passa il token ricevuto ad ogni nodo nella lista
send(_,[]).
send(Tokens, [Node|Rest]) :-
	sen(Node, Tokens),
	send(Tokens, Rest).

% add or delete the new token from the appropriate memory, build new
% tokens from left or right and send them to successor nodes.

% invia il token ad una regola, in questo caso la regola è aggiunta o rimossa dal conflict set
sen(rule-N,tok(AD,TokenList)) :-
	rul(N,TokenList,Actions),
	(AD = add, add_conflict_set(N,TokenList,Actions);
	 AD = del, del_conflict_set(N,TokenList,Actions)),
	!.

% il token è inviato al lato sinistro di un nodo a due input. In questo caso, il token è
% aggiunto o rimosso dalla memoria sinistra del nodo
sen(Node-l,tok(AD,TokenList)) :-
	bi(Node,TokenList,Right,NextList),
	(AD = add, asserta( memory(Node-l,TokenList) );
	 AD = del, retract( memory(Node-l,TokenList) )),
	!,matchRight(Node,AD,TokenList,Right,NextList).

% il token è inviato al lato destro di un nodo a due input. In questo caso, il token è
% aggiunto o rimosso dalla memoria destra del nodo
sen(Node-r,tok(AD,TokenList)) :-
	bi(Node,Left,TokenList,NextList),
	(AD = add, asserta( memory(Node-r,TokenList) );
	 AD = del, retract( memory(Node-r,TokenList) )),
	!,matchLeft(Node,AD,TokenList,Left,NextList).

% usato per i test
sen(test-N,tok(AD,TokenList)) :-
	tes(N,TokenList,[Test/0],NextList),
	test(Test),
	append(TokenList,[Test/0],NewToks),
	!,send(tok(AD,NewToks),NextList).

% confronta la memoria destra del nodo con Right. Se l'unificazione ha successo,
% viene creato un nuovo token aggiungendo al token originale la parte destra della memoria.
% Il nuovo token viene inviato nella struttura con send
matchRight(Node,AD,TokenList,Right,NextList) :-
	memory(Node-r,Right),
	append(TokenList,Right,NewToks),
	send(tok(AD,NewToks),NextList),
	fail.
matchRight(_,_,_,_,_).

% confronta la memoria sinistra del nodo con Left. Se l'unificazione ha successo,
% viene creato un nuovo token aggiungendo al token originale la parte sinistra della memoria.
% Il nuovo token viene inviato nella struttura con send
matchLeft(Node,AD,TokenList,Left,NextList) :-
	memory(Node-l,Left),
	append(Left,TokenList,NewToks),
	send(tok(AD,NewToks),NextList),
	fail.
matchLeft(_,_,_,_,_).

% predicato per eliminare un fatto dalla struttura
retract_ws(Prem/T) :- retract_ws(Prem).
retract_ws(Prem) :-
	delrete(Prem,TimeStamp),
	retract(fact(X,Prem,Y)).	

% ciclo repeat-fail per trovare le corrispondenze tra i nodi radice e le clausole
delrete(Fact,TimeStamp) :-
	root(ID,P,NextList),
	delr(Fact,TimeStamp),
	fail.
delrete(_,_).

% crea un token di tipo del e lo invia nella struttura
delr(Fact,TimeStamp) :-
	!, send(tok(del,[Fact/TimeStamp]), NextList).
delr(Fact,TimeStamp).	
	
	
%generatori degli indici dei fatti
gen_fact_id(G) :-
	retract(gfactid(N)),
	G is N + 1,
	asserta(gfactid(G)).

gfactid(0).

gid(100).


% Strumenti

remove(X,[X|Y],Y) :- !.
remove(X,[Y|Z],[Y|W]) :- remove(X,Z,W).

is_on(X,[X|Y]).
is_on(X,[Y|Z]) :- is_on(X,Z).

write_line([]) :- nl.
write_line([H|T]) :-
	write(H),tab(1),
	write_line(T).




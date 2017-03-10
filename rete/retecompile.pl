% Copyright (c) Gruppo IA, 2017

:- reconsult('retemess.pl').

:- dynamic (rule/5).


%Lista funzioni usate per il punto 12
%Comando Relay 12
%Create RETE structure



insertAtEnd(X,[ ],[X]).
insertAtEnd(X,[H|T],[H|Z]) :- insertAtEnd(X,T,Z). 

compile :-
	rete_pre_compiler,
	rete_compile.

	
% eliminatore degli or nelle regole e generatore di regole equivalenti
rete_pre_compiler :-
	forall(rule(N,RHS,and(LHS),K,P),rule_pre_compiler(N,RHS,LHS,K,P)).
	
rule_pre_compiler(N,RHS,LHS,K,P):-
	retract(rule(N,RHS,and(LHS),K,P)),
	or_deleter(N,RHS,LHS,K,P, NewLHS).
	
or_deleter(N,RHS,[H|T],K,P, NewLHS) :-
	H=..[Name|List],
	(Name = 'or' -> or_adder(N,RHS,T,K,P,NewLHS,List) ; add_continue(N,RHS,T,K,P,NewLHS,H)).

or_deleter(N,RHS,[], K, P, NewLHS) :-
	assert(rule(N,RHS,and(NewLHS),K,P)).
	
	
add_continue(N,RHS,T,K,P,LHS,H) :-	
	insertAtEnd(H,LHS, NewLHS),
	or_deleter(N, RHS, T, K, P, NewLHS).

or_adder(N,RHS,T,K,P,LHS,[H | Rest_or]) :-
	insertAtEnd(H,LHS,NewLHS),
	or_deleter(N,RHS,T,K,P,NewLHS),
	or_adder(N,RHS,T,K,P,LHS,Rest_or).

or_adder(N,RHS,T,K,P,LHS,[]) :-
	!.
	

% predicato per inizializzare l'algoritmo di creazione della struttura
rete_compile :-
	abolish(root,3),
	abolish(bi,4),
	abolish(tes,4),
	abolish(rul,3),
	abolish(varg,1),
	abolish(nid,1),
	asserta(nid(0)),
	rete_compil.

% legge ogni regola e la compila nella struttura del Rete
rete_compil :-
	rule(N,RHS,and(LHS),K,P),
	rete_comp(N,LHS,RHS),
	fail.

% predicato per segnalare il completamento della costruzione della struttura
rete_compil :-
	message(201).

% controlla la prima clausola della condizione della regola e determina se costruire un nuovo
% nodo radice oppure se ne esiste già il corrispondente. Passa successivamente il nodo radice e
% il rimanente della parte sinistra della regola a retcom. Infine, stampa un messaggio di conferma
rete_comp(N,[H|T],RHS) :-
	check_root(RN,H,HList),
	retcom(root(RN),[H/_],HList,T,N,[RHS]),
	message(202,N), !.

% messaggio di errore per segnalare il fallimento della compilazione della regola N
rete_comp(N,_,_) :-
	message(203,N).

% predicato che viene richiamto quando tutte le clausole di una regola sono state compilate nella struttura
% e serve per collegare la regola completa alla struttura
retcom(PNID,OutTok,PrevList,[],N,RHS) :-
	build_rule(OutTok,PrevList,N,RHS),
	update_node(PNID,PrevList,rule-N),
	!.

% predicato per controllare se le clausole combaciano con un nodo radice o un nodo a due input già esistente, 
% in caso contrario ne crea uno nuovo

retcom(PNID,PrevNode,PrevList,[H|T],N,RHS) :-
	check_root(RN,H,HList),
	check_node(PrevNode,PrevList,[H/_],HList,NID,OutTok,NList),
	update_node(PNID,PrevList,NID-l),
	update_root(RN,HList,NID-r),
	!,
	retcom(NID,OutTok,NList,T,N,RHS).

% usato per i test
retcom(PNID,PrevNode,PrevList,[H|T],N,RHS) :-	
	check_tnode(PrevNode,PrevList,[H/0],HList,NID,OutTok,NList),
	update_node(PNID,PrevList,test-NID),
	!,
	retcom(test-NID,OutTok,NList,T,N,RHS).

% crea un nodo radice in quanto non c'è corrispondeza tra Term e i nodi radice già esistenti
check_root(NID,Term,[]) :-
	not(root(_,Term,_)),
	gen_nid(NID),
	assertz( root(NID,Term,[]) ), !.

% verifica che il nodo radice relativo a Term esiste già nella struttura
check_root(N,Term,List) :-
	asserta(temp(Term)),
	retract(temp(T1)),
	root(N,Term,List),
	root(N,T2,_),
	comp_devar(T1,T2), !.

% non esiste una corrispondeza precisa e viene creato un nuovo nodo radice
check_root(NID,Term,[]) :-
	gen_nid(NID),
	assertz( root(NID,Term,[]) ).

% il nuovo nodo è nella lista dei collegamenti del vecchio nodo, quindi non viene eseguita nessuna azione
update_root(RN,HList,NID) :-
	member(NID,HList), !.

% il nuovo nodo non è nella lista dei collegamenti del vecchio nodo, quindi viene aggiunto un collegamento
% inserendo l'id del nuovo nodo nella lista
update_root(RN,HList,NID) :-
	retract( root(RN,H,HList) ),
	asserta( root(RN,H,[NID|HList]) ).

% richiama il predicato update_root nel caso in cui il nodo sia un nodo radice
update_node(root(RN),HList,NID) :-
	update_root(RN,HList,NID), !.

% il nuovo nodo è nella lista dei collegamenti del vecchio nodo, quindi non viene eseguita nessuna azione
update_node(X,PrevList,NID) :-
	member(NID,PrevList), !.

% il nuovo nodo non è nella lista dei collegamenti del vecchio nodo, quindi viene aggiunto un collegamento
% inserendo l'id del nuovo nodo nella lista
update_node(PNID,PrevList,NID) :-
	retract( bi(PNID,L,R,_) ),
	asserta( bi(PNID,L,R,[NID|PrevList]) ).

% utilizzato per i test
update_node(test-N,PrevList,NID) :-
	retract( tes(N,L,T,_) ),
	asserta( tes(N,L,T,[NID|PrevList]) ), !.

% crea un nodo a due input in quanto non c'è corrispondeza tra H e i nodi a due input già esistenti
check_node(PNode,PList,H,HList,NID,OutTok,[]) :-
	not (bi(_,PNode,H,_)),
	append(PNode,H,OutTok),
	gen_nid(NID),
	assertz( bi(NID,PNode,H,[]) ),
	!.

% verifica che il nodo a due input relativo a H esiste già nella struttura
check_node(PNode,PList,H,HList,NID,OutTok,NList) :-
	append(PNode,H,OutTok),
	asserta(temp(OutTok)),
	retract(temp(Tot1)),
	bi(NID,PNode,H,NList),
	bi(NID,T2,T3,_),
	append(T2,T3,Tot2),
	comp_devar(Tot1,Tot2),
	!.

% non esiste una corrispondeza precisa e viene creato un nuovo nodo a due input 
check_node(PNode,PList,H,HList,NID,OutTok,[]) :-
	append(PNode,H,OutTok),
	gen_nid(NID),
	assertz( bi(NID,PNode,H,[]) ).
	
% usato per i test
check_tnode(PNode,PList,H,HList,NID,OutTok,[]) :-
	not (tes(_,PNode,H,_)),
	append(PNode,H,OutTok),
	gen_nid(NID),
	assertz( tes(NID,PNode,H,[]) ),
	!.
check_tnode(PNode,PList,H,HList,NID,OutTok,NList) :-
	append(PNode,H,OutTok),
	asserta(temp(OutTok)),
	retract(temp(Tot1)),
	tes(NID,PNode,H,NList),
	tes(NID,T2,T3,_),
	append(T2,T3,Tot2),
	comp_devar(Tot1,Tot2),
	!.
check_tnode(PNode,PList,H,HList,NID,OutTok,[]) :-
	append(PNode,H,OutTok),
	gen_nid(NID),
	assertz( tes(NID,PNode,H,[]) ).

% predicato usato per asserire la regola
build_rule(OutTok,PrevList,N,RHS) :-
	assertz( rul(N,OutTok,RHS) ).

%Genera gli indici
gen_nid(NID) :-
	retract( nid(N) ),
	NID is N+1,
	asserta( nid(NID) ).

% confronta i termini T1 e T2
comp_devar(T1,T2) :-
	de_vari(T1),
	de_vari(T2),
	T1=T2.

% predicati utilizzati nel caso in cui i termini siano liste
% caso in cui la lista sia vuota
de_vari([]).

% caso in cui la lista contenga almeno un elemento
de_vari([H|T]) :-
	de_var(H),
	de_vari(T).

% caso in cui il termine non sia una lista
de_vari(X) :- de_var(X).

% rimuove il timestamp 
de_var(X/_) :- de_var(X).

% sostituisce le variabili
de_var(X) :-
	init_vargen,
	term_variables(X,XList),
	de_vl(XList).

de_vl([]).
de_vl([H|T]) :-
	de_v(H),
	de_vl(T).

de_v(X) :-
	d_v(X).

d_v(V) :-
	var(V),
	var_gen(V), !.
d_v(_).

init_vargen :-
	abolish(varg,1),
	asserta(varg(1)).

var_gen(V) :-
	retract(varg(N)),
	NN is N+1,
	asserta(varg(NN)),
	string_integer(NS,N),
	string_list(NS,NL),
	append("#VAR_",NL,X),
	name(V,X).





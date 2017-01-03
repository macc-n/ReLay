:- use_module(library(charsio)).
:- dynamic fact_not_found/1.

fact_not_found(0). %è 1 se il fatto non è stato trovato


esplora(Obiettivo):-
	esplora(Obiettivo, Traccia1, Traccia).
	
risposta_utente(Obiettivo):-
	risposta_utente(Obiettivo, Traccia1, Traccia).


append([],L,L).
append([H|T],L2,[H|L3]):-
	append(T,L2,L3). 

	
%**********************************************************************************************************
% esplora
%**********************************************************************************************************	
	
	
%caso in cui la coda delle clausole è vuota
verificaEsplora([], Traccia1, Traccia1).
%caso in cui obiettivo è un fatto
verificaEsplora(X, Traccia1, Traccia):-
	fact(_, X, 0),
	fact_not_found(Val),
	retract(fact_not_found(Val)),
	assert(fact_not_found(0)),
	!,
	fail.
verificaEsplora(X, Traccia1, Traccia):-
	fact(_, X, 1),
	fact_not_found(Val),
	retract(fact_not_found(Val)),
	assert(fact_not_found(0)),
	append(Traccia1, [true], Traccia).
%caso in cui obiettivo è la testa di una regola
verificaEsplora(X, Traccia1, Traccia):-
	rule(_, X, C, _,_),
	append(Traccia1, [C], Traccia2),
	verificaEsplora(C, Traccia2, Traccia).

verificaEsplora([H|T], Traccia1, Traccia):-
	append(Traccia1, [H], Traccia2),
	verificaEsplora(H, Traccia2, Traccia3),
	verificaEsplora(T, Traccia3, Traccia).
%Caso AND
verificaEsplora(and([H|T]), Traccia1, Traccia):-
	append(Traccia1, [H], Traccia2),
	verificaEsplora(H, Traccia2, Traccia3),
	verificaEsplora(T, Traccia3, Traccia).
%Caso OR
verificaEsplora(or([H|T]), Traccia1, Traccia):-
	append(Traccia1, [H], Traccia2),
	verificaEsplora(H, Traccia2, Traccia).
verificaEsplora(or([H|T]), Traccia1, Traccia):-
	verificaEsploraOR(T, Traccia1, Traccia).
verificaEsploraOR([H|T], Traccia1, Traccia):-
	append(Traccia1, [H], Traccia2),
	verificaEsplora(H, Traccia2, Traccia).
verificaEsploraOR([H|T], Traccia1, Traccia):-
	verificaEsploraOR(T, Traccia1, Traccia).
%Caso No
verificaEsplora(no(X), Traccia1, Traccia):-
	fact_not_found(Val),
	retract(fact_not_found(Val)),
	assert(fact_not_found(1)),
	verificaEsploraNegazione(X, Traccia1, Traccia),
	fact_not_found(0).

verificaEsploraNegazione(X, Traccia1, Traccia):-             %se X è vero
	verificaEsplora(X, Traccia1, Traccia),
	!,
	fail.
verificaEsploraNegazione(X, Traccia1, Traccia):-             %se X è falso
	!,
	append(Traccia1, [true], Traccia).

esplora(Obiettivo, Traccia1, Traccia):-
	Traccia1=[Obiettivo],
	verificaEsplora(Obiettivo, Traccia1, Traccia),
	scriviTraccia(Traccia, 'traccia.txt').
	
	
%**********************************************************************************************************
% risposta_utente
%**********************************************************************************************************
%caso in cui la coda delle clausole è vuota
verificaRispUt([], Traccia1, Traccia1).
%caso in cui obiettivo è un fatto
verificaRispUt(X, Traccia1, Traccia):-
	fact(_, X, 0),
	fact_not_found(Val),
	retract(fact_not_found(Val)),
	assert(fact_not_found(0)),
	!,
	fail.
verificaRispUt(X, Traccia1, Traccia):-
	fact(_, X, 1),
	fact_not_found(Val),
	retract(fact_not_found(Val)),
	assert(fact_not_found(0)),
	!,
	append(Traccia1, [true], Traccia).

verificaRispUt(X, Traccia1, Traccia):-
	askable(X, Domanda),
	!,
	chiedi(X, Traccia1, Traccia),
	fact_not_found(Val),
	retract(fact_not_found(Val)),
	assert(fact_not_found(0)).
	
%caso in cui obiettivo è la testa di una regola
verificaRispUt(X, Traccia1, Traccia):-
	rule(_, X, C, _,_),
	append(Traccia1, [C], Traccia2),
	verificaRispUt(C, Traccia2, Traccia).

verificaRispUt([H|T], Traccia1, Traccia):-
	append(Traccia1, [H], Traccia2),
	verificaRispUt(H, Traccia2, Traccia3),
	verificaRispUt(T, Traccia3, Traccia).

%Caso AND
verificaRispUt(and([H|T]), Traccia1, Traccia):-
	append(Traccia1, [H], Traccia2),
	verificaRispUt(H, Traccia2, Traccia3),
	verificaRispUt(T, Traccia3, Traccia),
	!.
%Caso OR
verificaRispUt(or([H|T]), Traccia1, Traccia):-
	append(Traccia1, [H], Traccia2),
	verificaRispUt(H, Traccia2, Traccia),
	!.
verificaRispUt(or([H|T]), Traccia1, Traccia):-
	verificaORRispUt(T, Traccia1, Traccia),
	!.
verificaORRispUt([H|T], Traccia1, Traccia):-
	append(Traccia1, [H], Traccia2),
	verificaRispUt(H, Traccia2, Traccia).
verificaORRispUt([H|T], Traccia1, Traccia):-
	verificaORRispUt(T, Traccia1, Traccia).
%Caso No
verificaRispUt(no(X), Traccia1, Traccia):-
	fact_not_found(Val),
	retract(fact_not_found(Val)),
	assert(fact_not_found(1)),
	verificaNegazioneRispUt(X, Traccia1, Traccia),
	fact_not_found(0).
verificaNegazioneRispUt(X, Traccia1, Traccia):-             %se X è vero
	verificaRispUt(X, Traccia1, Traccia),
	!,
	fail.
verificaNegazioneRispUt(X, Traccia1, Traccia):-             %se X è falso
	!,
	append(Traccia1, [true], Traccia).

risposta_utente(Obiettivo, Traccia1, Traccia):-
	Traccia1=[Obiettivo],
	verificaRispUt(Obiettivo, Traccia1, Traccia).												
	
chiedi(Obiettivo, Traccia, Traccia):-
    	term_to_atom(Obiettivo, Domanda),
	atom_concat([Domanda, '.txt'], Path),
    	scriviTraccia(Traccia, Path),
    	!,
    	javaMessage('api.Backward',risposta_utente(string(Domanda))).
	
scriviTraccia([], Path).
scriviTraccia([H|T], Path):-
	open(Path,append,Stream),
	write(Stream,H), nl(Stream),
	close(Stream),
	scriviTraccia(T, Path).


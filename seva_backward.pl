:- dynamic yet_found/1.
:- dynamic fact_not_found/1.

fact_not_found(0). %è 1 se il fatto non è stato trovato
yet_found(1).	   %è 1 se è la soluzione è stata già trovata
	
backward(Obiettivo):-
	write('Esplora avviato'),
	nl,
	esplora(Obiettivo, Traccia1, Traccia),
	write(Obiettivo),
	write('. Vuoi sapere come? [y, n] ' ),
	read(RisCome),
	rispostaCome(RisCome, Traccia),
	nl,
	write('Altre soluzioni? [y, n] '),
	read(Ris),
	altreRisposte(Ris).
	
backward(Obiettivo):-
	write('Risposta utente avviato'),
	nl,
	curr_kb(KB),
	open(KB,append,Stream), 
    write(Stream,'%Asked facts'),  nl(Stream), 
    close(Stream), 
	yet_found(Val),
	retract(yet_found(Val)),
	assert(yet_found(1)),
	!,
	risposta_utente(Obiettivo, Traccia1, Traccia),
	write(Obiettivo),
	write('. Vuoi sapere come? [y, n] ' ),
	read(RisCome),
	rispostaCome(RisCome, Traccia),
	nl,
	write('Altre soluzioni? [y, n] '),
	read(Ris),
	altreRisposteRisUtente(Ris).
	
rispostaCome(y, Traccia):-
	nl,
	presentaTraccia(Traccia),
	!.																		
rispostaCome(n, Traccia):-
	!.																		
rispostaCome(_, Traccia):-
	write('Risposta non valida. Riprovare'),
	nl,
	write('Vuoi sapere come? [y, n] '),
	read(Ris),
	rispostaCome(Ris, Traccia),
	!.																		
	
altreRisposte(y):-
	!,
	fail.
	
altreRisposte(n).
altreRisposte(_):-
	write('Risposta non valida. Riprovare'),
	nl,
	write('Altre soluzioni? [y, n] '),
	read(Ris),
	altreRisposte(Ris).
	
altreRisposteRisUtente(y):-
	yet_found(Val),
	retract(yet_found(Val)),
	assert(yet_found(1)),
	!,
	fail.
	
altreRisposteRisUtente(n).
altreRisposteRisUtente(_):-
	write('Risposta non valida. Riprovare'),
	nl,
	write('Altre soluzioni? [y, n] '),
	read(Ris),
	altreRisposteRisUtente(Ris).
	
%**********************************************************************************************************
% esplora
%**********************************************************************************************************	
	
	
%caso in cui la coda delle clausole è vuota
verificaEsplora([], Traccia1, Traccia1).
%caso in cui l' obiettivo è un fatto
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
%caso in cui l' obiettivo è la testa di una regola
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
	verificaEsplora(Obiettivo, Traccia1, Traccia).
	
	
%**********************************************************************************************************
% risposta_utente
%**********************************************************************************************************
%caso in cui la coda delle clausole è vuota
verificaRispUt([], Traccia1, Traccia1).
%caso in cui l' obiettivo è un fatto
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
	chiedi(X, Traccia1, Traccia),
	fact_not_found(Val),
	retract(fact_not_found(Val)),
	assert(fact_not_found(0)),
	yet_found(Val),
	retract(yet_found(Val)),
	assert(yet_found(0)).
	
%caso in cui l' obiettivo è la testa di una regola
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
	verificaRispUt(T, Traccia3, Traccia).
%Caso OR
verificaRispUt(or([H|T]), Traccia1, Traccia):-
	append(Traccia1, [H], Traccia2),
	verificaRispUt(H, Traccia2, Traccia).
verificaRispUt(or([H|T]), Traccia1, Traccia):-
	verificaORRispUt(T, Traccia1, Traccia).
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
	yet_found(Val),
	retract(yet_found(Val)),
	assert(yet_found(1)),
	Traccia1=[Obiettivo],
	verificaRispUt(Obiettivo, Traccia1, Traccia),
	%controllo che non sia una soluzione già trovata con esplora
	yet_found(0).												

risposta(y, Obiettivo, Traccia1, Traccia):-
	max_id(Max),
	NewIdFact is Max+1,
	retract(max_id(Max)),
	assert(max_id(NewIdFact)), % si aggiorna il valore massimo.
	assertz((fact(NewIdFact, Obiettivo, 1))),
	curr_kb(KB),
	open(KB,append,Stream), 
    write(Stream,fact(NewIdFact, Obiettivo, 1)),  nl(Stream), 
    close(Stream), 
	append(Traccia1, ['risposta = y'], Traccia).
	
risposta(n, Obiettivo, Traccia1, Traccia):-
	max_id(Max),
	NewIdFact is Max+1,
	retract(max_id(Max)),
	assert(max_id(NewIdFact)),
	assertz((fact(NewIdFact, Obiettivo, 0))),
	curr_kb(KB),
	open(KB,append,Stream), 
    write(Stream,fact(NewIdFact, Obiettivo, 0)),  nl(Stream), 
    close(Stream), 
	append(Traccia1, ['risposta = n'], Traccia),
	!,
	fail.
	
risposta(w, Obiettivo, Traccia1, Traccia):-
	nl,
	presentaTraccia(Traccia1),
	nl,
	!,															
	chiedi(Obiettivo, Traccia1, Traccia).
	
risposta(_, Obiettivo, Traccia1, Traccia):-
	!,
	rispostaNonValida(Obiettivo, Traccia1, Traccia).
	
chiedi(Obiettivo, Traccia1, Traccia):-
	askable(Obiettivo, Domanda),
	write(Domanda),
	write('? [y,n,w] '),
	read(Ris),
	risposta(Ris, Obiettivo, Traccia1, Traccia),
	!.															
	
rispostaNonValida(Obiettivo, Traccia1, Traccia):-
	write('Risposta non valida. Riprovare'),
	nl,
	chiedi(Obiettivo, Traccia1, Traccia).
	
presentaTraccia([]).
presentaTraccia([H|T]):-
	write('\t'),
	write(H),
	nl,
	presentaTraccia(T).
	
	
	
	

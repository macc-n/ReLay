/*************************************************************************
        Nome: gie_cond.pl
        
	Realizzazione: Settembre, 2013
        	Descrizione: Meccanismo di Gestione delle Condizioni
        	Autore: Nicola Milella

	Descrizione: dati
		condizione -> and([c1,c2,..,cn]),
		fatto -> F, 
		certezza -> Crt,
			Si aggiornerà -> and(Nc)
			Si restituiranno:
				condizione aggiornata -> C
				valore boolean -> B (verifica o meno di C)
	Utilizzo: gie_forward_confl//checkfact

	Revisione: Febbraio, 2014
	Autore: Francesco Solare	
		
	Obiettivo: Snellimento e Pulizia del Codice
	
    Revisioni: Ottobre, 2014
       Autore: Morisco M. - Petrera M.
       Inserimento delle modifiche apportate di Fabio Fiorella e Davide Giannico  
       per i predicati updatecond/6 per i 4 operatori matematici
    
	Revisione: Ottobre, 2016
	Autori: Iovine A. - Lovascio C.
		Obiettivo: Aggiunta dell'operatore not_exists. Metodi:
			-not_exists
			-Modifiche negli operatori and, or, no
			-Modifiche in get_val, get_cond
			-Modifiche in updatecond

*************************************************************************/

%------------------------------------ Sostituzione dei valori di certezza nelle condizioni -----------------------------------------
/*************************************************************************
        Condizione AND
*************************************************************************/
updatecond(and([]),_,_,and(Nc),C) :-
	C=and(Nc).
	
updatecond(and([F|T]),F,Crt,and(Nc),C) :-
	append(Nc,[Crt],Ln1),
	append(Ln1,T,Ln),
	updatecond(and([]),F,Crt,and(Ln),C). %sostituzione effettutata
	
updatecond(and([X|T]),F,Crt,and(Nc),C) :-
	number(X),
	append(Nc,[X],Ln),
	updatecond(and(T),F,Crt,and(Ln),C).

updatecond(and([X|T]),F,Crt,and(Nc),C) :-
	updatecond(X,F,Crt,_,Cn),
	append(Nc,[Cn],Ln),
	updatecond(and(T),F,Crt,and(Ln),C).

updatecond(and([X|T]),F,Crt,and(Nc),C) :-
	append(Nc,[X],Ln),
	updatecond(and(T),F,Crt,and(Ln),C).

/*************************************************************************
        Condizione OR
*************************************************************************/
updatecond(or([]),_,_,or(Nc),C) :-
	C=or(Nc).

updatecond(or([F|T]),F,Crt,or(Nc),C) :-
	append(Nc,[Crt],Ln1),
	append(Ln1,T,Ln),
	updatecond(or([]),F,Crt,or(Ln),C).

updatecond(or([X|T]),F,Crt,or(Nc),C) :-
	number(X),
	append(Nc,[X],Ln),
	updatecond(or(T),F,Crt,or(Ln),C).

updatecond(or([X|T]),F,Crt,or(Nc),C) :-
	updatecond(X,F,Crt,_,Cn),
	append(Nc,[Cn],Ln),
	updatecond(or(T),F,Crt,or(Ln),C).

updatecond(or([X|T]),F,Crt,or(Nc),C) :-
	append(Nc,[X],Ln),
	updatecond(or(T),F,Crt,or(Ln),C).
	
/*************************************************************************
        Condizione NOT
	Definita no/1 per evitare ridondanza col predicato predefinito
	not/1 dell'interprete
*************************************************************************/
updatecond(no(F),F,Crt,no(_),C) :-

	C=no(Crt),
	!.
updatecond(no(X),_,_,no(_),C) :-
	number(X),
	C=no(X),
	!.

updatecond(no(X),F,Crt,no(_),C) :-
	updatecond(X,F,Crt,_,_,Cn),
	C=no(Cn),
	!.

updatecond(no(X),_,_,no(_),C) :-
	C=no(X),
	!.

/*
updatecond(no(X),_,Crt,no(_),C) :-

	C=no(1),
	verify(C,B),


	!.
*/

/*************************************************************************
        Condizione NOT_EXISTS
*************************************************************************/
updatecond(not_exists(F),F,Crt,not_exists(_),C) :-
	
	C=not_exists(Crt),
	!.
updatecond(not_exists(X),_,_,not_exists(_),C) :-
	number(X),
	C=not_exists(X),
	!.

updatecond(not_exists(X),F,Crt,not_exists(_),C) :-
	updatecond(X,F,Crt,_,Cn),
	C=not_exists(Cn),
	!.

updatecond(not_exists(X),_,_,not_exists(_),C) :-
	C=not_exists(X),
	!.
	
/*************************************************************************
        Condizione add
*************************************************************************/


updatecond(add([]),_,_,add(Nc),B,C) :-
	C=add(Nc),
	verify(add(Nc),B).

updatecond(add([F|T]),F,Crt,add(Nc),B,C) :- 
	fact(_,F, _),	
	arg(1,F, Num),
	append(Nc,[Num],Ln),
	updatecond(add(T),F,Crt,add(Ln),B,C).
								
updatecond(add([X|T]),F,Crt,add(Nc),B,C) :- 
	number(X),
	append(Nc,[X],Ln),
	updatecond(add(T),F,Crt,add(Ln),B,C).
								
updatecond(add([X|T]),F,Crt,add(Nc),B,C) :- 
	updatecond(X,F,Crt,_,_,Cn),
	append(Nc,[Cn],Ln),
	updatecond(add(T),F,Crt,add(Ln),B,C).
							
updatecond(add([X|T]),F,Crt,add(Nc),B,C) :- 
	append(Nc,[X],Ln),
	updatecond(add(T),F,Crt,add(Ln),B,C).
	
	
/*************************************************************************
        Condizione MUL
*************************************************************************/
updatecond(mul([]),_,_,mul(Nc),B,C) :-
	C=mul(Nc),
	verify(mul(Nc),B).

updatecond(mul([F|T]),F,Crt,mul(Nc),B,C) :- 
	fact(_,F, _),	
	arg(1,F, Num),
	append(Nc,[Num],Ln),
	updatecond(mul(T),F,Crt,mul(Ln),B,C).
	
								
updatecond(mul([X|T]),F,Crt,mul(Nc),B,C) :- 
	number(X),
	append(Nc,[X],Ln),
	updatecond(mul(T),F,Crt,mul(Ln),B,C).
								
updatecond(mul([X|T]),F,Crt,mul(Nc),B,C) :- 
	updatecond(X,F,Crt,_,_,Cn),
	append(Nc,[Cn],Ln),
	updatecond(mul(T),F,Crt,mul(Ln),B,C).
							
updatecond(mul([X|T]),F,Crt,mul(Nc),B,C) :- 
	append(Nc,[X],Ln),
	updatecond(mul(T),F,Crt,mul(Ln),B,C).
	
/*************************************************************************
        Condizione DIV
*************************************************************************/
updatecond(div([]),_,_,div(Nc),B,C) :-
	C=div(Nc),
	verify(div(Nc),B).

updatecond(div([F|T]),F,Crt,div(Nc),B,C) :- 
	fact(_,F, _),	
	arg(1,F, Num),
	append(Nc,[Num],Ln),
	updatecond(div(T),F,Crt,div(Ln),B,C).
								
updatecond(div([X|T]),F,Crt,div(Nc),B,C) :- 
	number(X),
	append(Nc,[X],Ln),
	updatecond(div(T),F,Crt,div(Ln),B,C).
								
updatecond(div([X|T]),F,Crt,div(Nc),B,C) :- 
	updatecond(X,F,Crt,_,_,Cn),
	append(Nc,[Cn],Ln),
	updatecond(div(T),F,Crt,div(Ln),B,C).
							
updatecond(div([X|T]),F,Crt,div(Nc),B,C) :- 
	append(Nc,[X],Ln),
	updatecond(div(T),F,Crt,div(Ln),B,C).
/*************************************************************************
        Condizione MIN
*************************************************************************/
updatecond(minus([]),_,_,minus(Nc),B,C) :-
	C=minus(Nc),
	verify(minus(Nc),B).

updatecond(minus([F|T]),F,Crt,minus(Nc),B,C) :- 
	fact(_,F, _),	
	arg(1,F, Num),
	append(Nc,[Num],Ln),
	updatecond(minus(T),F,Crt,minus(Ln),B,C).
								
updatecond(minus([X|T]),F,Crt,minus(Nc),B,C) :- 
	number(X),
	append(Nc,[X],Ln),
	updatecond(minus(T),F,Crt,minus(Ln),B,C).
								
updatecond(minus([X|T]),F,Crt,minus(Nc),B,C) :- 
	updatecond(X,F,Crt,_,_,Cn),
	append(Nc,[Cn],Ln),
	updatecond(minus(T),F,Crt,minus(Ln),B,C).
							
updatecond(minus([X|T]),F,Crt,minus(Nc),B,C) :- 
	append(Nc,[X],Ln),
	updatecond(minus(T),F,Crt,minus(Ln),B,C).
	
	


/*************************************************************************
        Verifica della Condizione
*************************************************************************/
%Versione vero falso
verify(C) :-
	call(C),!.
%Versione con numero di ritorno: vero=1, falso=0
%Input C -> condizione
%OutputV -> 1 vero, 0 falso
verify(C,V) :- 
	call(C),
	!,
	V=1.
verify(_,V) :- 
	V=0.

%Data la condizione, verifica se è vera o falsa
and([]).

/* Modifica Iovine-Lovascio
 * È stata eliminata la condizione X>0 affinchè gli operatori siano in grado di gestire
 * il valore -1. Questa situazione si presenta soltanto nel caso in cui l'and si trova
 * all'interno di un operatore not_exists.
*/
and([X|T]) :-
	%verifica se X è un numero	
	number(X),
	X=\=0,	
	X=<1,
	!,
	and(T).

and([X|T]) :-
	%verifica se X è una sotto condizione di tipo OR	
	functor(X,or,_),
	call(X),
	!,
	and(T).

and([X|T]) :- 
	%verifica se X è una sotto condizione di tipo AND
	functor(X,and,_),
	call(X),
	!,
	and(T).

and([X|T]) :- 
	%verifica se X è una sotto condizione di tipo NO
	functor(X,no,_),
	call(X),
	!,
	and(T).
	
and([X|T]) :- 
	%verifica se X è una sotto condizione di tipo DIV
	functor(X,div,_),
	call(X),
	!,
	and(T).
	
and([X|T]) :- 
	%verifica se X è una sotto condizione di tipo NOT_EXISTS
	functor(X,not_exists,_),
	call(X),
	!,
	and(T).

and([_]) :-
	fail.

%Come per and/1. Termina l'esecuzione non appena un elemento è verificato.
%Se si arriva ad esaminare tutti gli elementi della lista,
%vuol dire che nessuno si è verificato e quindi si porta ad un fallimento
or([]) :- 
	fail.
or([X|_]) :- 
	number(X),
	X>0,
	X=<1,
	!.
or([X|_]) :- 
	functor(X,or,_),
	call(X).
or([X|_]) :- 
	functor(X,and,_),
	call(X).
or([X|_]) :- 
	functor(X,no,_),
	call(X).
or([X|_]) :- 
	functor(X,not_exists,_),
	call(X).
or([_|T]) :- 
	or(T).
	
/******************* PRVova *************/	

add([]).
add([X|T]) :-
	%verifica se X è un numero	
	number(X),
	
	!,
	add(T).

add([X|T]) :-
	%verifica se X è una sotto condizione di tipo OR	
	functor(X,or,_),
	call(X),
	!,
	add(T).

add([X|T]) :- 
	%verifica se X è una sotto condizione di tipo AND
	functor(X,and,_),
	call(X),
	!,
	add(T).

add([X|T]) :- 
	%verifica se X è una sotto condizione di tipo NO
	functor(X,no,_),
	call(X),
	!,
	add(T).

add([_]) :-
	fail.
	
mul([]).
mul([X|T]) :-
	%verifica se X è un numero	
	number(X),	
	!,
	mul(T).

mul([X|T]) :-
	%verifica se X è una sotto condizione di tipo OR	
	functor(X,or,_),
	call(X),
	!,
	mul(T).

mul([X|T]) :- 
	%verifica se X è una sotto condizione di tipo AND
	functor(X,and,_),
	call(X),
	!,
	mul(T).

mul([X|T]) :- 
	%verifica se X è una sotto condizione di tipo NO
	functor(X,no,_),
	call(X),
	!,
	mul(T).

mul([_]) :-
	fail.

	
div([]).
div([X|T]) :-
	%verifica se X è un numero	
	number(X),

	!,
	div(T).

div([X|T]) :-
	%verifica se X è una sotto condizione di tipo OR	
	functor(X,or,_),
	call(X),
	!,
	div(T).

div([X|T]) :- 
	%verifica se X è una sotto condizione di tipo AND
	functor(X,and,_),
	call(X),
	!,
	div(T).

div([X|T]) :- 
	%verifica se X è una sotto condizione di tipo NO
	functor(X,no,_),
	call(X),
	!,
	div(T).

div([_]) :-
	fail.


minus([]).
minus([X|T]) :-
	%verifica se X è un numero	
	number(X),
	
	!,
	minus(T).

minus([X|T]) :-
	%verifica se X è una sotto condizione di tipo OR	
	functor(X,or,_),
	call(X),
	!,
	minus(T).

minus([X|T]) :- 
	%verifica se X è una sotto condizione di tipo AND
	functor(X,and,_),
	call(X),
	!,
	minus(T).

minus([X|T]) :- 
	%verifica se X è una sotto condizione di tipo NO
	functor(X,no,_),
	call(X),
	!,
	minus(T).

minus([_]) :-
		fail.	
	
	

	
	
/*************** FINE *******/
	
/* 
*	La condizione not_exists è verificata se l'elemento contenuto al suo interno
*	è stato sostituito con -1. Se all'interno del predicato not_exists c'è un solo
*	elemento, allora questo non deve esistere, se c'è una condizione di tipo AND
*	è sufficiente che un elemento al suo interno restituisca -1, se c'è una condizione
*	di tipo OR tutti gli elementi al suo interno devono restituire -1.
****/	
not_exists(X) :-
	number(X),
	X >= 0,
	!,
	fail.
	
not_exists(X) :-
	number(X),
	X =:= -1,
	!.
	
not_exists(X) :-
	functor(X,and,_),
	get_val(X, Val, _),
	Val =:= -1,
	!.
not_exists(X) :-
	functor(X,or,_),
	get_val(X, Val, _),
	Val =:= -1,
	!.
not_exists(X) :-
	functor(X,no,_),
	get_val(X, Val, _),
	Val =:= -1,
	!.
	
%Come per and/1. L'elemento da verificare è uno, se si verifica vuol dire che la condizione è falsa 
%e quindi si porta ad un fallimento altrimenti se l'elemento non è verificato vuol dire che la condizione è vera
no(X) :-
	number(X),
	X>=0, %MODIFICAMINAFRA
	X<1,
	!. 
	%fail. %MODIFICAMINAFRA
no(X) :- 
	functor(X,or,_),
	call(X),
	!,
	fail.
no(X):-

	functor(X,and,_),
	call(X),
	!,
	fail.
no(X) :- 

	functor(X,no,_),
	call(X),
	!,
	fail.
no(_) :- fail. %MODIFICAMINAFRA


get_val(add(C),Val,_) :- 
	get_add(C,Val),!.		 
get_val(mul(C),Val,_) :- 
	get_mul(C,Val),!.
get_val(div(C),Val,_) :- 
	get_div(C,Val),!.
get_val(minus(C),Val,_) :- 
	get_minus(C,Val),!.
	
	
%Recupera il valore massimo in una condizione di tipo OR
get_val(or(C),Val,_) :- 
	get_max(C,Val),!.		  
%Recupera il valore minimo in una condizione di tipo AND
get_val(and(C),Val,_) :- 

	get_min(C,Val),!.			  
	
%Se la condizione è verificata restituisce 1, se non è verificata restituisce (1 - certezza)

get_val(no(C),Val,0) :-
	number(C),
	!, %MODIFICAMINAFRA aggiunto CUT
	Val is 1-C.
get_val(no(_),1,1). %MODIFICAMINAFRA spostato questo caso generale "get_val(no(_),1,1)." , sotto il caso specifico "get_val(no(C),Val,0)"

get_val(not_exists(C), C, 0) :-
	number(C),
	!.
get_val(not_exists(_),1,1).

%Restituisce la lista di elementi della condizione
get_cond(or(L),L).
get_cond(and(L),L).
get_cond(no(L),L).

get_cond(not_exists(L), L).


/*************************************************************************
        Nome: gie_indexing.pl
        
	Realizzazione: Settembre, 2013
        	Descrizione: Meccanismo di Indicizzazione delle Regole
        	Autore: Nicola Milella

	Revisione: Febbraio, 2014
	Autore: Francesco Solare		
		
		Obiettivo: Snellimento e Pulizia del Codice

		Procedura: initindexrules/0 (ex initindexing/0)
		Obiettivo: Renaming per evitare ambiguità

*************************************************************************/
:- dynamic (irule/3).
%------------------------- Indicizzazione Regole -------------------------

%Indicizzazione regole iniziali:
%asserisce irule(Id regola, testa, lista condizioni) per ogni regola inizialmente nella kb
initindexrules :-
	rule(Idr,R,_,_,_),
	not(irule(Idr,R,_)),
	assert(irule(Idr,R,[])),
	index(Idr,R),
	fail.
initindexrules.

%Per ogni regola avvia l'indicizzazione
indexing :-
	rule(Idr,Rt,_,_,_),
	irule(Idr,Rt,_),
	index(Idr,Rt),
	fail.
indexing.
		 
%Data una regola con id "Idr" e testa "R":
%avvia la verifica della presenza nelle condizioni di altre regole
index(Idr,R) :-  
	rule(Idrn,_,C,_,_),
	Idr\==Idrn,
	ver(Idr,Idrn,R,C),
	fail.
index(_,_).

%Verifica della presenza nelle condizioni di altre regole:
%Idrn e C sono l'id e la condizione della regola da verificare
ver(Idr,Idrn,R,C) :-  
	memb(R,C),!,
	add(Idr,Idrn,R).
			  		  
%Verifica appartenenza. Simile al member della libreria lists, 
%adattato a ricercare nelle condizioni complesse		  
memb(R,and([R|_])).
memb(R,and([X|_])) :-
	memb(R,X),!.
memb(R,and([_|T])) :-
	memb(R,and(T)).
memb(R,or([R|_])).
memb(R,or([X|_])) :-
	memb(R,X),!.
memb(R,or([_|T])) :-
	memb(R,or(T)).
memb(R,no(R)).

%Aggiunge l'id della regola Idrn nella lista della regola Idr
add(Idr,Idrn,R) :-
	irule(Idr,R,Lc),!,
	not(member(Idrn,Lc)),
	append([Idrn],Lc,Lcn),
	retract(irule(Idr,R,Lc)),
	assert(irule(Idr,R,Lcn)).
add(_,_,_).

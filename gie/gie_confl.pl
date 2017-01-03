/*************************************************************************
        Nome: gie_confl.pl
        
	Realizzazione: Settembre, 2013
        	Descrizione: Realizzazione del 
			     Meccanismo di Risoluzione
        		     dei conflitti del GIE
        	Autore: Nicola Milella
         
      	Revisioni: Febbraio, 2014
	Autore: Francesco Solare

  		Procedura: ass_rule/1
  		Obiettivo: Assegnazione del valore di certezza del fatto dedotto
       		
       		Procedura: sweep_fact/4
  		Obiettivo: Rielaborazione della procedura per taglio della
			   regola dei tre punti e modifiche al tracking della
			   risoluzione forward con passaggio ad una procedura
			   a 5 variabili
		
		Obiettivo: Pulizia del Codice
		
	 Revisioni: Ottobre, 2014
     Autore: Morisco M. - Petrera M.
     Procedura: ass_rule_do
     Obiettivo: Adeguamento del codice alle modifiche effettuate da Giannico e Fiorella, tramite l'inserimento 
     dell'argomento F al predicato asserting_head per la gestione dei calcoli matematici
	       	 
*************************************************************************/
:- dynamic confl/1.
:- dynamic verified/2.
:- dynamic fireset/1.
:- dynamic irule/3.
:- dynamic frule/5.
:- dynamic fact/3.
:- dynamic tracker/2.
%-------------------------------------- Risoluzione dei Conflitti ----------------------

/*************************************************************************
        Gestore principale della componente che avvia 
	in ordine tutte le varie operazioni	       	 
*************************************************************************/
fire :- 
	assert(confl([])),
	firerule,
	asserting,
	indexing,
	retractall(verified(_,_)),
	!.

%Per ogni regola avvia la ricerca di tutte le altre che vanno in conflitto
firerule :-
	write('     firerule '),nl,
	frule(Idr,R,_,P,_),
	firerule_do(Idr,R,P),
	asserta(confl([])),
	fail.
firerule :-
	retract(confl([])).

%Date tutte le informazioni della regola: si raggruppano le regole in conflitto 
%con lo stesso predicato di testa in confl([[idr1,priorità],...,[idrN,priorità]])
firerule_do(Idr,R,P) :- 
	fireset(T),
	confl(L),
	%se una regola non fa parte del fireset vuol dire che è stata già esaminata
	member(Idr,T),
	append([[Idr,P]],L,Ln),
	retract(confl(L)),
	asserta(confl(Ln)),
	delete(T,Idr,Tn),
	retract(fireset(T)),
	assert(fireset(Tn)),
	conflicts(Idr,R),
	!.
%Considera le regole pronte a scattare con lo stesso predicato di testa
conflicts(Idr,R) :- 
	frule(Idrn,Rn,_,Pn,_),
	Idr\==Idrn,
	functor(Rn,N,_),
	functor(R,N,_),
	conflicts_do(Idrn,Pn),
	fail.
conflicts(_,_).		

%Raggruppa tutte le regole con lo stesso predicato di testa 
%memorizzando Id e Priorità in confl([[Idr,P],...,[Idrn,Pn]])		
conflicts_do(Idrn,Pn) :- 
	confl(L),!,
	fireset(T),
	append([[Idrn,Pn]],L,Ln),
	retract(confl(L)),
	asserta(confl(Ln)),
	delete(T,Idrn,Tn),
	retract(fireset(T)),
	assert(fireset(Tn)).

% Aggiorna il fireset rimuovendo la regola in esame				
asserting :- 
	write('     asserting '),nl,
	confl(L),
	sort_list(L,_),
	ass_rule(L),
	retract(confl(L)),
	fail.
asserting.

/*************************************************************************
        Gestisce il caso in cui la testa della regola è già un fact:
	se il fatto già presente nella WM ha certezza inferiore 
	a quello che si sta asserendo, viene sostituito dal nuovo, 
	con certezza superiore, evitando duplicati.

	VARIANTE: Se si commenta ass_rule(T) si blocca il ciclo 
		  permettendo l'asserzione della regola a priorità maggiore 
		  invece che di tutte.	

	REVISIONE su ass_rule/1: Sostituzione della regola del Prodotto 
		   		 con quella del valore Minimo.
*************************************************************************/
ass_rule([]). %MODIFICAMINAFRA aggiunto il passo base in cui la lista � vuota

ass_rule([[Idr,P]|T]) :- 

	frule(Idr,R,C,P,Crt),
	fact(Idf,R,Crtf),
	get_val(C,V,_),	
	%Crtn is V*Crt,
	get_min([V,Crt],Crtn),
	%revisionata completamente
	sweep_fact(Idr,Idf,R,Crtf,Crtn),
	retract(frule(Idr,R,C,P,Crt)),
	%retract(irule(Idr,R,_)), %MODIFICAMINAFRA commentato per non eliminare regole intermedie
	%si inserisce tra quelle usate
	assert(used_rule(Idr,R,C,P,Crt)), 
	%permette di considerare tutte le regole in conflitto, invece che solo la prima
	ass_rule(T). 

						
%Gestisce il caso in cui la testa della regola è un used_fact, ignorandola 

ass_rule([[Idr,P]|T]) :- 

	frule(Idr,R,C,P,Crt),
	used_fact(_,R,_),
	retract(frule(Idr,R,C,P,Crt)),
	%retract(irule(Idr,R,_)), %MODIFICAMINAFRA commentato per non eliminare regole intermedie
	%si inserisce tra quelle usate 
	assert(used_rule(Idr,R,C,P,Crt)),
	ass_rule(T).

%Caso base in cui bisogna asserire la testa della regola come fatto						
ass_rule([[Idr,P]|T]) :- 

	frule(Idr,R,C,P,Crt),
	
	get_val(C,V,_),	
	ass_rule_do(Idr,R,C,P,Crt,V),
	ass_rule(T).
	
ass_rule([_|T]) :- 
	ass_rule(T). %vincenzo: passo base in cui frule non c'è piu quando rimossa dallo stop

%Esegue l'asserzione della testa della regola, rimuove la regola e la riscrive come used_rule
ass_rule_do(Idr,R,C,P,Crt,V) :-
functor(C,F,_),
	%+ Idr	
	asserting_head(Idr,R,Crt,V,F), 
	retract(frule(Idr,R,C,P,Crt)),
	assert(used_rule(Idr,R,C,P,Crt)),
	!.

/**************************************************************************************************************************
	Descrizione: Confronta i valori di certezza del vecchio e nuovo fatto in modo da mantenere in memoria 
		     sempre quello con certezza maggiore	

	Revisione: Eliminazione della regola dei tre punti. 
	Revisione: Taglio del punto di scelta visto che non asseriva la certezza maggiore. 
	Revisione: Passaggio alla procedura sweep_fact/5 per gestire anche il tracking della risoluzione
			sweep_fact(IdFRule,IdFact,Rule_head,CertaintyFact,CertaintyNew_fact)
**************************************************************************************************************************/
sweep_fact(_,_,_,Crtf,Crtn) :- 
	Crtn =< Crtf,
	%continuava a non asserire la certezza maggiore
	!.
sweep_fact(Idr,Idf,R,Crtf,Crtn) :- 
	%C is Crtn-Crtf,
	% scarto minimo tra le certezze di 2 fatti
	%C >= 0.3,
	retract(fact(Idf,R,Crtf)),
	assert(fact(Idf,R,Crtn)),
	%riassegno il puntatore alla traccia corrente
	retract(tracker(_,Idf)),
	assert(tracker(Idr,Idf)).
%sweep_fact(_,_,_,_).

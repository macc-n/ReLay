/*************************************************************************
*************************************************************************
        Nome: gie_forward_rete.pl

	Realizzazione: Settembre, 2013
        	Descrizione: Realizzazione del Ragionamento forward del GIE
        	Autore: Nicola Milella
    Revisione : Giugno,2014
	Autore: Fabio Fiorella & Davide Giannico


	Descrizione:
		FATTO -> fact(Idf,F,Cf)
			Idf -> id fatto
			F -> fatto es. p(a)
			Cf -> certezza fatto ]0,1]
		REGOLA -> rule(Idr,R,C,P,Crt)
			Idr -> id regola
			R -> testa regola p(A,B)
			C -> condizione es. or([p(A),..,and([q(A)..]),..,no(g(A))])
			P -> priorit� regola
			Crt -> certezza regola
		VALORE BOOLEANO -> B {0,1}
		VALORE DI CERTEZZA DI UNA CONDIZIONE -> Val

      	Revisioni: Febbraio, 2014
       	Autore: Francesco Solare

  		Procedura: asserting/6
  		Obiettivo: Assegnazione del valore di certezza del fatto dedotto
			   e passaggio ad una procedura a 7 variabili che permetta
			   la gestione del tracking della risoluzione forward

		Procedura: unfireset/0
		Obiettivo: Snellimento e Puliza del Codice
		Autore: Francesco Solare

  		Modulo: gie_expl.pl
  		Obiettivo: Disabilitazione del modulo
       		Autore: Francesco Solare


       Revisioni: Ottobre, 2014
       Autore: Morisco M. - Petrera M.
       Obiettivo:
       -Inserimento delle modifiche apportate da Luigi Tedone per il predicato time diff (vedi in seguito)
       -Inserimento delle modifiche apportate da Fabio Fiorella e Davide Giannico per il predicato asserting_head(vedi in seguito)
       e adeguamento del codice.

	   Revisione: Ottobre, 2016
	   Autore: Iovine A. - Lovascio C.
	   Obiettivo:
			-Aggiunta della possibilità di ritrattare un fatto
			-Aggiunta dell'operatore not_exists
				-Modifiche nel metodo checkfact
			-Modifica del metodo checkrule/2
			-Gestione del caricamento e scaricamento dei moduli
				-Modifiche nel metodo mainloop
				-Metodi clean_before_loading e manage_delayed_modules
				-Modifiche in asserting_head
				
		Revisione: Novembre, 2016
		Autore: Bruno S. - Morelli N. - Pinto A.
		Obiettivo:
			- Modifica del metodo check_unique per rimozione forzata
*************************************************************************
*************************************************************************/

:- dynamic (fact/3).
:- dynamic (used_fact/3).
:- dynamic (rule/5).
:- dynamic (exp_rule/3).
:- dynamic (fireset/1).
:- dynamic (irule/3).
:- dynamic (frule/5).
:- dynamic (verified/2).
:- dynamic (min_threshold/1).
:- dynamic (tracker/2).
:- dynamic (unique/1).
:- dynamic (call_p/2).
:- dynamic (frame_data/2).
:- dynamic (frame_fact/2).
:- dynamic (used_frame_fact/3).

%-------------------------------------------------------------- Motore Forward: BEGIN -----------------------------------------------------
%caricamento dei file contenenti le varie funzionalit�
:-reconsult('gie_cond.pl').
:-reconsult('gie_utility.pl').
:-reconsult('gie_indexing.pl').
:-reconsult('gie_confl.pl').
:-reconsult('gie_textgui.pl').
%:-reconsult('gie/gie_expl.pl').
:-reconsult('tree_utility.pl').
:-reconsult('gie_operation.pl').

/*************************************************************************
        Ciclo Principale

		Modifica apportata da Luigi Tedone
		Descrizione: aggiunto il predicato timediff che consente di calcolare la durata
					 del processo inferenziale.
*************************************************************************/
mainloop :-
	fact(_,_,_),
	forward,
	gui_mainloop(forward_finished),
	fireset,
	fire,
	gui_mainloop(fire_finished),
	mainloop,
	!.

mainloop :-
    not(fact(_,_,_)),
    forwardframe,
    mainloop.

mainloop :-
	%set_threshold,
	%checkrest,
	fact(_,_,_),
	mainloop.
	
/*
	Modifica Iovine-Lovascio per la gestione del caricamento
	e scaricamento differito dei moduli
*/
mainloop :-
	not(fact(_,_,_)),
	module_to_be_loaded(ModPath),
	!,
	write('     finished module. Loading new modules '),nl,
	clean_before_loading,
	manage_delayed_modules,
	mainloop,
	!.
	
/*
	Pulizia degli alberi di unificazione.
	Operazione necessaria per evitare che lo stesso fatto venga sostituito più volte
	nella stessa regola.
*/
clean_before_loading :-
	retractall(t_rule(_, _)),			
	clean_dirtyrules.	
	
manage_delayed_modules :-
	module_to_be_loaded(ModPath),
	load(ModPath),
	retractall(module_to_be_loaded(ModPath)),
	manage_delayed_modules.
	
manage_delayed_modules :-
	module_to_be_unloaded(ModName),
	unload(ModName),
	retractall(module_to_be_unloaded(ModName)),
	manage_delayed_modules.
	
manage_delayed_modules.

	
mainloop :-
gui_mainloop(fact_finished),
	clean_dirtyrules, %MODIFICAMINAFRA
	clean_frame_fact,
	timediff. %Modifica apportata da Luigi Tedone

/*************************************************************************
        Implementazione del Motore Forward
*************************************************************************/
%verifica che non ci sono pi� fatti da analizzare
forward :-
	not(fact(_,_,_)),
	write('     stop forward '),nl,
	!.
%verifica ogni fatto in ciascuna regola, sfruttando l'indicizzazione, dopo di che lo riscrive come used_fact

forward :-
	fact(Idf,F,Cf),
	gui_forward(Idf,F),
	calculate_k,
	doall(checkrule(F,Cf)),
	retract(fact(Idf,F,Cf)),
	assert(used_fact(Idf,F,Cf)),
	forward,!.

forwardframe :-
	calculate_k,
    rule(_,_,C,_,_),
    (C=and(X) ; C=or(X)),
    checkframe(X),
    forwardframe,
    !.

%verifica che il framedata unifica con la condizione della regola
checkframe([A|T]) :-
        nonvar(A),
        A \== call_p,
        not(number(A)),
        A =.. [Slot, Frame, Value],
        (nonvar(Frame) ; nonvar(Value)),
        Slot_Frame =.. [Slot, _, _],
        frame_data(Slot_Frame,_),
		value_frame(Frame, Slot, Value, CrtFrame),
        A_new =.. [Slot, Frame, Value],
        verify_bound([Slot, Frame, Value]),
        not(used_fact(_,A_new,CrtFrame)),
        not(fact(_,A_new,CrtFrame)),
        %maxidf(Idf),
    	%Idfact is Idf + 1,
        %idflist_upd(Idfact),
    	assert(fact(frame,A_new,CrtFrame)),
    	assert(used_frame_fact(frame,A_new,CrtFrame)),
    	%Ccostruisco l'explainer a runtime
    	atom_concat('Frame: ',Frame,SpiegaFrame),
    	atom_concat(', Slot: ',Slot,SpiegaFrame1),
    	atom_concat(', Value: ',Value,SpiegaFrame2),
    	atom_concat(SpiegaFrame,SpiegaFrame1,SpiegaFrame3),
    	atom_concat(SpiegaFrame3,SpiegaFrame2,SpiegaFrame4),
    	atom_concat(SpiegaFrame4,' ',SpiegaFrame5),
    	%asserisco explain
	%retract(explainer(A_new,_,B,_,_)),
        assert(explainer(A_new,0,SpiegaFrame5,[])),
    	%retract(frame_data(F,Cf)),
    	checkframe(T),
        !.

checkframe([_|T]):-
        checkframe(T),
	!.

checkframe([],_,_,_):-
    fail.

%seleziona le regole in cui il fatto � presente nelle condizioni
checkrule(_,_,[]).
checkrule(F,Cf,[Idr|T]) :-
	t_rule(Idr ,Tree),
	checkfact(F,Cf,Idr,Tree),
	checkrule(F,Cf,T).

%Verifica se il fatto deriva da una regola indicizzata
checkrule(F,Cf) :-
	irule(_,F,L),
	%!,	% Modifica Iovine-Lovascio, cut rimosso in quanto salta alcune unificazioni
	checkrule(F,Cf,L).

% il fallimento di checkrule attiverà il checkrule successivo e le regole saranno attivate 2 volte?!

checkrule(F,Cf) :-
	t_rule(Idr ,Tree),
	checkfact(F,Cf,Idr,Tree).%fallimento considererà altra regola


/********************************************************************************************************************
	Modifica apportata da Luigi Tedone
	Descrizione: rimozione dei thread che peggiorano le performance del 15% invece di migliorarle

	Modifica apportata da Domenico V.
	Descrizione: Utilizzo dei thread, garantisce un miglioramento del 30%

	Verifica se il fatto in considerazione � presente o meno nella regola in considerazione.
	Aggiorna(cancella e riasserisce) le regole non verificate, a meno di quelle iniziali

	Procedura updating_rule/6 (ex asserting/6, con valore B <> 2)
	Revisione: Separazione della procedura di aggiornamento della condizione di una regola
		   da quella di asserzione della testa di una regola
	Revisione: Estensione alla gestione del tracking del processo di deduzione

	Revisione Minafra: commentata la procedura di eliminazione (retract) delle regole intermedie
	
	Revisione Iovine-Lovascio: Rimossa la condizione Tree\=NTree in modo da permettere
	   la verifica di teste in cui non è stato unificato nulla (necessario per il caso
	   del not_exists)
********************************************************************************************************************/

/*checkfact(F,Cf,Idr,R,C,P,Crt) :-	%MODIFICAMINAFRA  MODIFICA FAF TOLTO IL COMMENTO PER LA POLARITA'
	maxinitialidr(MIdr),
	Idr > MIdr,
	retract(rule(Idr,_,_,_,_)),
	getfunct(C,Funct),
	updatecond(C,F,Cf,Funct,B,Nc),
	!,
	%+ Idr
	updating_rule(Idr,R,Nc,P,Crt,B). */

    checkfact(F,Cf,Idr,Tree) :-	%con alberi
	%gtrace,
		elabora_tree(Tree,F,Cf,Ntree), %ciclo di unificazione sull’albero
		!, 
		% Tree\=Ntree, %appena elaborato l'albero, se è identico a quello iniziale è inutile proseguire
		rule(Idr,R,C,P,Crt),
		assert_verified_rule(Ntree,Idr,R,C,P,Crt,NTree2), %gestione asserzioni di regole verificate,
		!,
		% Tree\=NTree2, %dopo l'asserzione delle regole verificate se l'albero finale è identico a quello iniziale non serve ritrattare e riasserirlo(sperco di risorse)
		retract(t_rule(Idr,_)),
		assert(t_rule(Idr,NTree2)).


/********************************************************************************************************************
	Asserisce la testa di una regola se � stata dedotta dal processo inferenziale

	Procedura asserting_head/4 (ex asserting/6, con valore B == 2)
	Revisione: Separazione della procedura di asserzione della testa di una regola
		   da quella di aggiornamento della condizione di una regola
	Revisione: Estensione alla gestione del tracking del processo di deduzione
	Revisione: Sostituzione della regola del Prodotto con quella del valore Minimo
	Revisione: aggiunta dell' argomento  F per le operazioni aritmetiche.
	Revisione: aggiunta del caso relativo alla retract di un fatto
********************************************************************************************************************/
%MODIFICAFAF  TESTA MULTIPLA OK
asserting_head(_Idr,[],_Crt,_Val, _F):-!.

asserting_head(Idr,[T|L],Crt,Val, F):-
	asserting_head(Idr,T,Crt,Val,F),
	asserting_head(Idr,L,Crt,Val,F).
%FINE MODIFICAFAF

% Modifica Iovine-Lovascio: Caso in cui la testa contiene la retract di un fatto
asserting_head(Idr, retract(R), Crt, Val, F) :-
	retractall(fact(_, R, _)),
	retractall(used_fact(_, R, _)).
	
% Modifica Iovine-Lovascio: Gestione asserzione caricamento e scaricamento moduli
asserting_head(Idr, load_module(ModPath), Crt, Val, F) :-
	write('Caricamento del modulo '),write(ModPath),nl,
	load(ModPath).

asserting_head(Idr, unload_module(ModName), Crt, Val, F) :-
	write('Scaricamento del modulo '), write(ModName), nl,
	unload(ModName).

asserting_head(Idr, load_module_delayed(ModPath), Crt, Val, F) :-
	write('Caricamento differito del modulo '),write(ModPath),nl,
	assert(module_to_be_loaded(ModPath)).
	
asserting_head(Idr, unload_module_delayed(ModName), Crt, Val, F) :-
	write('Scaricamento differito del modulo '),write(ModName),nl,
	assert(module_to_be_unloaded(ModName)).	

asserting_head(Idr,R,Crt,Val, F) :-  % Revisione di Morisco-Petrera (aggiunta delle modifiche di Giannico e Fiorella)
	not(F = and),
	not(F = or),
	not(F = no),
	maxidf(M),
	IdfNew is M+1,
	idflist_upd(IdfNew),
	!,
	%Crtn is Val*Crt,
	get_min([Val,Crt],_Crtn),
	arg(1,R, Val),
	check_unique(IdfNew,R,Crt),!,
	%tracker Idr -> IdfNew ...
	assert(tracker(Idr,IdfNew)).

asserting_head(Idr,R,Crt,Val,_F) :-
	maxidf(M),
	IdfNew is M+1,
	idflist_upd(IdfNew),
	!,
	%Crtn is Val*Crt,
	get_min([Val,Crt],Crtn),
	check_unique(IdfNew,R,Crtn),!,
	%tracker Idr -> IdfNew ...
	assert(tracker(Idr,IdfNew)).

% MODIFICAMINAFRA commentato per far SCRIVERE i fatti dedotti con certezza 0 per permettere la verifica di no(0)
%check_certainty(_,_,0) :-
	%!, %MODIFICAMINAFRA senza cut, asserisce il fatto nel successivo check_certainty
	%gui_check_certainty(0).
/*check_certainty(IdfNew,R,Crt) :-
	Crt > 1,
	!, %MODIFICAMINAFRA senza cut, asserisce il fatto nel successivo check_certainty
	gui_check_certainty(IdfNew,R,Crt).

check_certainty(IdfNew,R,Crt) :-
	Crt < 0,
	!, %MODIFICAMINAFRA senza cut, asserisce il fatto nel successivo check_certainty
	gui_check_certainty(IdfNew,R,Crt).

check_certainty(IdfNew,R,_) :-
	 check_operation(R,IdfNew),
	 !. %MODIFICAMINAFRA senza cut, asserisce il fatto nel successivo check_certainty

*/


%%%%%%%% MODIFICAFAF se � gi� stato asserito un certo fatto non asserirne altri
/*
check_unique(IdfNew,R,Crt) :-
 	functor(R,Testa, _),
	to_update(Testa),	write('TROVATO uno'),nl,
	fact(_,P,Crt),
	functor(P,Testa,_),  !,
	write('ecco P'), write(P), nl.
 */

%%%%%%%% MODIFICAFAF se � gi� stato asserito un certo fatto ritrattalo e asserisci il nuovo fatto
 %MODIFICA FUNZIONANTE
/*check_certainty(IdfNew,R,Crt) :-
 	functor(R,Testa, _),
	last_value(Testa),
	fact(_,P,_),
	write(P), nl,
	functor(P,Testa,_),
	retract(fact(_,P,_)),
	assert(fact(IdfNew,R,Crt)),	 !,
	write('LAST SCRITTO uno'), nl.

	*/

%Aggiunto da Bruno S. - Morelli N. - Pinto A. per rimozione forzata
check_unique(_,X,_) :-
	del_fact(X),
	frule(_,X,_,_,_),
	retractall(frule(_,X,_,_,_)).


%%%%%%%% MODIFICAFAF se � gi� stato asserito un certo fatto ritrattalo e asserisci il nuovo fatto
check_unique(IdfNew,R,Crt) :-

 	functor(R,Head,_),
 	unique(Pattern),
 	not(Pattern == null),
 	functor(Pattern,Head,_),
 	findall(P,(fact(_,P,_),functor(P,Head,_)), Set_fact),
 	clean_fact(Pattern,Set_fact),
  	assert(fact(IdfNew,R,Crt)),!.

	%%%%% CERCO un fatto di tipo struttura, ossia di tipo fact(ID,fatto(LISTA),crt) e piuttosto che creare un nuovo fatto aggiorno il contenuto della lista.
check_unique(IdfNew,R,Crt) :-
 	functor(R,Head,_),
 	structure(Pattern),
 	not(Pattern == null),
 	functor(Pattern,Head,_),
		%gtrace,
 	%findall(P,(fact(_,P,_),functor(P,Head,_)), Set_fact),
	fact(_,P,_),
	functor(P,Head,_),
	R=..[Head,L], %assumo che la struttura abbia solo una lista come argomento
	P=..[Head,L1],
	append(L,L1,Ldup),
	remove_dups(Ldup,Lfinal),
	Str=..[Head,Lfinal],
	%not(used_fact(_,Str,_)), %verifico che sia stato aggiunto qualcosa
	retract(fact(_,P,_)),
	assert(fact(IdfNew,Str,Crt)),!.
	/*
check_unique(IdfNew,R,Crt) :- %variante in cui sto asserendo una struttura già costruita e quindi non devo fare nulla
 	functor(R,Head,_),
 	structure(Pattern),
 	not(Pattern == null),
 	functor(Pattern,Head,_),
		%gtrace,
 	%findall(P,(fact(_,P,_),functor(P,Head,_)), Set_fact),
	fact(_,P,_),
	functor(P,Head,_),
	R=..[Head,L], %assumo che la struttura abbia solo una lista come argomento
	P=..[Head,L1],
	append(L,L1,Ldup),
	remove_dups(Ldup,Lfinal),
	Str=..[Head,Lfinal],
	used_fact(_,Str,_), !.%verifico che sia stato aggiunto qualcosa
	*/
/*
check_unique(IdfNew,R,Crt) :-
 	functor(R,HeadNew,Ariety),
 	unique(NewFact, FactToRetract),
 	functor(NewFact,HeadNew,Ariety),
 	functor(FactToRetract,Head,Ariety),
 	findall(P,(fact(_,P,_),functor(P,Head,Arity)), Set_fact),
 	clean_fact(FactToRetract,Set_fact),
  	assert(fact(IdfNew,R,Crt)),
    !.
  */
  
  check_unique(_,stop(X),_) :-
	retractall(frule(_,X,_,_,_)).%elimino le regole che stanno per scattare che sono state attivate dal fatto X -->solo se priorità minore della regola che attiva il deep retract
	
check_unique(IdfNew,R,Crt) :-
	assert(fact(IdfNew,R,Crt)).
	
clean_fact(X,[X]):- retract(fact(_,X,_)).

clean_fact(X,[_Y|Resto]):-
 	clean_fact(X,Resto).

clean_fact(_X,[]).



	

	
retract_trees(X):-
	t_rule(_Id,Tree),
	clean_tree(Tree,X,_NTree),
	fail.
retract_tree(_).





%-------------------------------------------------------------- Procedure per i calcoli matematici --------------------------------------
 %MODIFICAMINAFRA permette la verifica di check_operation anche in cicli successivi del sistema, quando esiste gi� un risultato dichiarato come fatto per quell'operazione


 check_operation(R,IdfNew) :-
 							 op(I,X,Y,add)=R,
							not(fact( _ , r(_, I), 1)),
                            T is X+Y,
                            assert(fact(IdfNew,r(T,I),1)).

check_operation(R,IdfNew) :- op(I,X,Y,sub)=R,
							not(fact( _ , r(_, I), 1)),
                            T is X-Y,
                            assert(fact(IdfNew,r(T,I),1)).

check_operation(R,IdfNew) :- op(I,X,Y,mul)=R,
							not(fact( _ , r(_, I), 1)),
                            T is X * Y,
                            assert(fact(IdfNew,r(T,I),1)).

check_operation(R,IdfNew) :-op(I,X,Y,div) = R,
							not(fact( _ , r(_, I), 1)),
                            T is X / Y,
                            assert(fact(IdfNew,r(T,I),1)).

check_operation(R,IdfNew) :-op(I,X,Y,max) = R,
							not(fact( _ , r(_, I), 1)),
                            X >= Y,
                            assert(fact(IdfNew,r(1,I),1)).

check_operation(R,IdfNew) :-op(I,X,Y,min) = R,
							not(fact( _ , r(_, I), 1)),
                            X < Y,
                            assert(fact(IdfNew,r(0,I),1)).
/*
% check_operation che tiene conto anche del tempo (survey). Utilizzata per decisioni inerenti il cane.
check_operation(R,IdfNew) :-op(I,X,Y,max, S) = R,
                            X > Y,
                            assert(fact(IdfNew,r(1,I, X),1)).
check_operation(R,IdfNew) :-op(I,X,Y,min, S) = R,
                            X < Y,
                            assert(fact(IdfNew,r(1,I, X),1)).
*/

/***********************************Procedura minore e maggiore
AUTORE: Danilo Minafra

DESCRIZIONE: come per le operazioni, inserendo "lesser", "lesser_eq", "greater", "greater_eq"
	sar� effettuato il confronto tra i due parametri passati.

OUTPUT: sar� asserito un predicato r(Ris, Id) dove in "Ris" sar� contenuto il risultato del confronto (true/false)
	ed Id � l'identificativo dell'operazione iniziale.
********************/

 check_operation(R,IdfNew) :- op(I,X,Y,lesser)=R,
                            X<Y,
							not(fact( _ , r(_, I), 1)),
                            assert(fact(IdfNew,r(t,I),1)).

 check_operation(R,IdfNew) :- op(I,X,Y,lesser)=R,
                            X>=Y,
							not(fact( _ , r(_, I), 1)),
                            assert(fact(IdfNew,r(f,I),1)).


 check_operation(R,IdfNew) :- op(I,X,Y,lesser_eq)=R,
                            X=<Y,
							not(fact( _ , r(_, I), 1)),
                            assert(fact(IdfNew,r(t,I),1)).

 check_operation(R,IdfNew) :- op(I,X,Y,lesser_eq)=R,
                            X>Y,
							not(fact( _ , r(_, I), 1)),
                            assert(fact(IdfNew,r(f,I),1)).


 check_operation(R,IdfNew) :- op(I,X,Y,greater)=R,
                            X>Y,
							not(fact( _ , r(_, I), 1)),
                            assert(fact(IdfNew,r(t,I),1)).

 check_operation(R,IdfNew) :- op(I,X,Y,greater)=R,
                            X=<Y,
							not(fact( _ , r(_, I), 1)),
                            assert(fact(IdfNew,r(f,I),1)).


 check_operation(R,IdfNew) :- op(I,X,Y,greater_eq)=R,
                            X>=Y,
							not(fact( _ , r(_, I), 1)),
                            assert(fact(IdfNew,r(t,I),1)).

 check_operation(R,IdfNew) :- op(I,X,Y,greater_eq)=R,
                            X<Y,
							not(fact( _ , r(_, I), 1)),
                            assert(fact(IdfNew,r(f,I),1)).


 check_operation(R,IdfNew) :- op(I,X,[Y,Z], between)=R,
                            X>Y,
                            X<Z,
							not(fact( _ , r(_, I), 1)),
                            assert(fact(IdfNew,r(t,I),1)).

 check_operation(R,IdfNew) :- op(I,X,[Y,_Z], between)=R,
                            X=<Y,
							not(fact( _ , r(_, I), 1)),
                            assert(fact(IdfNew,r(f,I),1)).

 check_operation(R,IdfNew) :- op(I,X,[_Y,Z], between)=R,
                            X>=Z,
							not(fact( _ , r(_, I), 1)),
                            assert(fact(IdfNew,r(f,I),1)).


 check_operation(R,IdfNew) :- op(I,X,[Y,Z], between_eq)=R,
                            X>=Y,
                            X=<Z,
							not(fact( _ , r(_, I), 1)),
                            assert(fact(IdfNew,r(t,I),1)).

 check_operation(R,IdfNew) :- op(I,X,[Y,_Z], between_eq)=R,
                            X<Y,
							not(fact( _ , r(_, I), 1)),
                            assert(fact(IdfNew,r(f,I),1)).

 check_operation(R,IdfNew) :- op(I,X,[_Y,Z], between_eq)=R,
                            X>Z,
							not(fact( _ , r(_, I), 1)),
                            assert(fact(IdfNew,r(f,I),1)).


check_operation(R,_) :-
							op(I,_,_,_)=R,
 							fact( _ , r(_, I), 1),
 							!.

%Verifica che sono state provate tutte le regole
doall(P) :-
	not(allchecked(P)).

%Sfrutta il backtracking per provare tutte le regole
allchecked(P) :-
	call(P),fail.

%--------------------------------------------------------------FINE Procedure per i calcoli matematici --------------------------------------
%-------------------------------------------------------------- Motore Forward: END ---------------------------------------------------------

%--------------------------------------------------------------Procedura per calcolare k ----------------------------------------------------

	calculate_k   :- fact(Id, k(X), Y) ,
					 final_k(ID ,K, C),
					 C1 is C + Y,
					 K1 is K * X,
				  	 retract(final_k(ID, K, C)),
					 assert(final_k(Id, K1, C1)),
					 gui_calculateK(Id,K1,C1),
					 retract(fact(Id, k(X), Y)),nl,
					 calculate_k.

	calculate_k :-  not(fact(_, k(_), _)),
					final_k(Id, K, C),
					Id > 0,
					K1 is K / C,
					assert(fact(Id, k(K1), 1) ),
					retract(final_k(Id, K, C)).

	calculate_k :- true.
%------------------------------------------------------------- Fine Procedura per il calcolo di k ----------------------------------------------------

/*************************************************************************
	Preparazione delle regole da passare alla componente
	di conflict resolution
*************************************************************************/
%Divide le regole pronte a scattare da quelle non pronte
%fireset([]).
fireset :-
	write('     fireset '),nl,
	verified(Idr,1),
	rule(Idr,R,C,P,Crt),
	fireset_do(Idr,R,C,P,Crt),
	retract(rule(Idr,R,C,P,Crt)),
	fail.
fireset.

% vincenzo: gestione regole con testa multipla,
% senza lo split delle regole non si potranno sfruttare gran parte della gestione di regole implementata in gie_confl
fireset_do(_,[],_,_,_).
fireset_do(Idr,[R|L],C,P,Crt) :-
	maxidr(M),
	IdrNew is M+1,
	idrlist_upd(IdrNew),
	exp_rule(Idr,_,AC),
	assert(exp_rule(IdrNew,R,AC)),
	assert(tracker(Idr,IdrNew)),
	fireset_do(IdrNew,R,C,P,Crt),
	fireset_do(Idr,L,C,P,Crt),
	!.
	
	%Date tutte le informazioni di una regola pronta a scattare:
%aggiorna il fireset, e la riasserisce come frule
fireset_do(Idr,R,C,P,Crt) :-
	%retract(rule(Idr,R,C,P,Crt)), %testa regola senza lista
	assert(frule(Idr,R,C,P,Crt)),
	fireset(L),
	append([Idr],L,Ln),
	retract(fireset(L)),
	assert(fireset(Ln)),
	!.
	

/***********************************************************************
unfireset :-
	write('     unfireset '),nl,
	rule(Idr,R,C,P,Crt),
	verified(Idr,1),
	unfireset_do(Idr,R,C,P,Crt),
	fail.
unfireset.

%date tutte le informazioni di una regola non pronta a scattare:
%Controlla se � gi� indicizzata
unfireset_do(Idr,R,_,_,_) :-
	irule(Idr,R,_),
	write('     '),write(Idr),write(' already present'),nl,
	!.
%date tutte le informazioni di una regola non pronta a scattare e non indicizzata:
%Asserisce il predicato irule(Id,testa,lista regole in cui � presente) utile per l'indicizzazione successiva
unfireset_do(Idr,R,_,_,_) :-
	assert(irule(Idr,R,[])),!.
unfireset_do(_,_,_,_,_).

%-------------------------------------- Post Forward: trovare fatti chiedibili all'utente -------------------------------------------------

%Controlla le regole non scattate in cerca di nuovi fatti chiedibili all'utente
checkrest :-
	rule(Idr,R,C,_,_),
	initrules(I),
	%salta le regole caricate inizialmente
	not(member(Idr,I)),
	count_cond(C,Ris),
	min_threshold(Trs),
 	%soglia minima di completamento di una condizione
	Ris >= Trs,
	checkrest_do(R,C),
	fail.
checkrest.

checkrest_do(R,C) :-
	check_demandable(R,C),
	!.

set_threshold :-
	min_threshold(Trs),
	nl,write('     The default threshold for considering the conditions is: '),write(Trs),
	nl,write('     Would you change it? (yes/no/why)'),
	nl,read(Answ),
	set_threshold(Answ).
set_threshold(yes) :-
	nl,write('     Type new threshold value(0,0.1,..,0.9,1): '),
	nl,read(Trs),
	retractall(min_threshold(_)),
	assert(min_threshold(Trs)),
	nl,write('     Threshold updated!'),nl.
set_threshold(why) :-
	nl,write('     Increasing the threshold, you set a stricter constraint.'),
	nl,write('     The system will consider less rules than normal, having the conditions more chances to be satisfied'),nl,
	nl,write('     Decreasing the thresold, you set a weaker constraint.'),
	nl,write('     The system will consider more rules than normal, having the conditions less chances to be satisfied'),nl,
	set_threshold.
set_threshold(_).
*************************************************************************/

/*********************************** Procedura clean_dirtyrules
AUTORE: Danilo Minafra

DESCRIZIONE: elimina tutte le regole intermedie asserite durante il processo inferenziale
***********************************/

clean_dirtyrules:-
	nl,write('     Cleaning dirty rules'),nl,
	%all_cleaned,
	retractall(irule(_,_,_)),
	retractall(frule(_,_,_,_,_)),
	nl,write('     Cleaning finished'),nl.

all_cleaned:-
	rule(IDr,_,_,_,_),
	not(not_to_clean(IDr)),
	retract(rule(IDr,_,_,_,_)),
	fail.
all_cleaned.

not_to_clean(IDIRule):-
	rule(IDIRule,DedFact,_,_,_),
	explainer(DedFact,_,_,_).

	%PROCEDURA clean_frame_fact
%se esistono, elimina i fatti asseriti dai frame per far scattare le regole alla fine del forward
%LISO-PROSCIA

clean_frame_fact:-
	retractall(used_fact(frame,_,_)).


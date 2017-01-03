/**********************************************
        Nome: seva_start.pl

	Realizzazione: Febbraio, 2014
  		Obiettivo: MAIN del SEVA
       		Autore: Francesco Solare

	Revisione : Giugno,2014
	Autore: Fabio Fiorella & Davide Giannico
	
	Revisione : Novembre, 2016
	Autore: Iovine A. - Lovascio C.
	Obiettivo:
		-Gestione dei moduli
			-Modifiche in loader e loaderfacts
			-Incluso il file seva_modules
			
	Revisione : Novembre, 2016
	Autori: Bruno S. - Morelli N. - Pinto A.
	Obiettivo:
		- Rimozione forzata
			- Aggiunta del predicato delete_fact
		- Filtri
			- Incluso il file seva_filter
			
**********************************************/
:- use_module(library(lists)).
:- use_module(library(system)).      % aggiunto da Anzivino Giuseppe, Novembre 2016


/***********************************************
      	PREDICATI DI SETTING DELL'AMBIENTE
***********************************************/
:- multifile (rule/5).
%rappresentazione dei fatti della kb
:- dynamic fact/3.
%rappresentazione dei fatti grezzi della kb
:- dynamic rfact/4.
%rappresentazione delle regole della kb
:- dynamic rule/5.
%id dei fatti
:- dynamic idf/1.
%id delle regole
:- dynamic idr/1.
%lista dei fatti originali
:- dynamic initfacts/1.
%lista delle regole originali
:- dynamic initrules/1.
%rappresentazione dei fatti usati nel processo inferenziale
:- dynamic used_fact/3.
%regole usate nel processo inferenziale
:- dynamic used_rule/5.
%indicizzazione delle regole
:- dynamic irule/3.
%tracking del percorso di risoluzione forward
:- dynamic tracker/2.
%regole utilizzate per inferire la nuova conoscenza durante il processo deduttivo
:- dynamic inferedrule/2.
%predicato che contiene il path del file contenente le regole
:- dynamic curr_rules/1.

/***********************************************
      	PREDICATI DI SETTING DEL GIE
***********************************************/
%lista delle regole in conflitto con quella considerata durante il processo inferenziale
:- dynamic confl/1.
%lista dei fatti già considerati durante il processo inferenziale
:- dynamic fireset/1.
%rappresenta una regola che è stata verificata
:- dynamic verified/2.
%regole già considerate durante il processo inferenziale
:- dynamic frule/5.

/***********************************************
      	PREDICATI DI I/0
***********************************************/
%kb corrente
:- dynamic curr_kb/1.
%kb grezza corrente
:- dynamic curr_rudekb/1.
%validazione dell'utilizzo del modulo di fuzzyness
:- dynamic fuzzycheck/1.
%id del file .log
:- dynamic curr_flog/1.
%scelta da menu corrente
:- dynamic curr_task/1.
%rappresentazione delle membership di input
:- dynamic ufunctinput/4.
%rappresentazione delle membership di output
:- dynamic ufunctoutput/4.
%rappresentazione del valore di regolazione da applicare al setting ambientale
:- dynamic final_adjustment/2.
%rappresentazione dei frame definiti in gie/ FRAME
:- dynamic(frame/2).

:- dynamic fact_presence/1.
:- dynamic max_id/1.
:- dynamic explained_fact/1.
:- dynamic explained_condition_rule/2.
:- dynamic final_k/3.

%inizializzazione dell'ambiente SEVA
:- reconsult('seva_textgui.pl').
%:- reconsult('seva_setting.pl').
:- reconsult('seva_explain.pl').
:- reconsult('seva_utility.pl').
:- reconsult('seva_backward.pl').
%Pasquadibisceglie V. Zaza G.:separazione del modulo di seva_setting 
:- reconsult('seva_genera_setting.pl').
:- reconsult('seva_setting_unfunction.pl').
:- reconsult('seva_setting_explainer.pl').
% Modifica Iovine-Lovascio: Gestione moduli
:- reconsult('seva_modules.pl').
% Modifica Bruno S. - Morelli N. - Pinto A. : Filtri
:- reconsult('seva_filter.pl').

/********************************************
      	Setting iniziale dell'ambiente
********************************************/
curr_task(0).
curr_kb(unknow).
curr_flog(unknow).
path_frame('gie/FRAME/').
idf([]).
idr([]).
initfacts([]).
initrules([]).
fireset([]).
fact_presence(0). % si inizializza una variabile che indica se ci sono o meno semplici fact.
max_id(0).  % si inizializza il valore di max_id, che terrà traccia del massimo ID tra i fatti inizialmnete presenti nella KB
explained_fact( 0 ).
explained_condition_rule(0 , 0).
final_k(0 , 1, 0).

/*************************************************************************
        Realizzazione: Gestione del modulo di fuzzificazione
*************************************************************************/
/** edited By Fabio F. & Davide G.**/
/** modifica successiva di Domenico V. , aggiunta check_max***/


check_max :- not(fact(Id, X , Y )),
	              fuzzyness_module.

check_max :- find_max,
	              fuzzyness_module.


fuzzyfier(Kb) :-
	call(rfact(_,_,_,_)),
	!,
	retractall(fuzzycheck(_)),
	assert(fuzzycheck(1)),
	retractall(curr_kb(_)),
	retractall(curr_rudekb(_)),
	assert(curr_rudekb(Kb)),
	reconsult('seva_fuzzyness.pl'),
	check_max.
	%find_max,          % si ricerca il valore di ID massimo
	%fuzzyness_module.
 %   reassert_fact. % si riasseriscono i fatti valutati da find_max



fuzzyfier(Kb) :-
	call(fact(_,_,_)),
	!,
	retractall(curr_rudekb(_)),
	retractall(curr_kb(_)),
	assert(curr_kb(Kb)),
	retractall(fuzzycheck(_)),
	assert(fuzzycheck(0)),
	%elimino le funzioni di membership per l'input, mantendo quelle per l'output
	retractall(ufunctinput(_,_,_,_)),
	gui_popup(info0).

% --------- modifica apportata da Anzivino Giuseppe, Pasquadibisceglie Vincenzo, Zaza Gianluca, Novembre 2016
% modificato il predicato loader, e aggiunto il predicato loaderfacts

loaderfacts:-
	gui_factsmodule(loaderfacts),
	read(Facts),
	%reconsult(Facts),
	load_first(Facts),	
	%inizializzo il file .log
	create_filelog(Facts),
	fuzzyfier(Facts).      % predicato richiamato in loaderfacts invece che in loader (Pasquadibisceglie Vincenzo, Zaza Gianluca)


loader :-
	gui_fuzzymodule(loader),
	read(Kb),
	%reconsult(Kb).
	load_first(Kb),					% Modifica Iovine-Lovascio: Caricamento del modulo iniziale
	retractall(curr_rules(_)),
	assert(curr_rules(Kb)).	   
	%inizializzo il file .log
	%create_filelog(Kb),
	%fuzzyfier(Kb).

%-----------------------

/*************************************************************************
        Realizzazione: Rimozione forzata
*************************************************************************/
delete_fact(X) :-
	del_fact(X),
	fact(_, X, _),
	retract(del_fact(X)),
	retract(fact(_, X, _)).

delete_fact(X) :-
	del_fact(X),
	not(fact(_, X, _)).
	
delete_fact(X) :-
	not(del_fact(X)).		
	
/*************************************************************************
        Realizzazione: Gestione del modulo di defuzzificazione
*************************************************************************/
defuzzyfier :-
	reconsult('seva_defuzzyness.pl'),
	defuzzyness_module.

/****************************************************************************
        Realizzazione: Gestione del modulo di reinizializzazione del SEVA
****************************************************************************/
initializer :-
	%recupera lista fatti iniziali
	initfacts(InitFacts),
	%ripristina i fatti e le regole allo stato iniziale, reinizializzando l'ambiente
	initializefacts(InitFacts),
	initializerules,
	%svuoto l'albero di risoluzione del precedente processo inferenziale
	retractall(fireset(_)),
	assert(fireset([])),
	retractall(final_adj(_DedFact,_Regulation)),
	retractall(fact_ded(_Idf,_F,_Cf)),
	retractall(t_rule(_,_)).

/****************************************************************************
        Realizzazione: Gestione del modulo di pulizia della Working Memory
****************************************************************************/
%Modifica apportata da Domenico V.
%elimino le membership di output
cleaner :-
	retractall(ufunctoutput(_,_,_,_)), fail.
cleaner :-
	retractall(ufunctoutputok(_,_,_,_)), fail.
cleaner :-
	%richiamo il cleaner e inizializzo il SEVA
	reconsult('seva_refresh.pl'),
	%reconsult('seva_setting.pl').
	%aggiunto Pasquadibisceglie V. - Zaza G.
	reconsult('seva_setting_explainer.pl'), 
    reconsult('seva_setting_unfunction.pl').

%-------------------------------------- CICLO MAIN ----------------------------------------------
start :-
	gui_seva(heading),
	gui_seva(menu),
	read(Chc),
	do(Chc).
	
	
	
% -------- modifica apportata da Anzivino Giuseppe, Novembre 2016
% Questa modifica separa il caricamento dei fatti rispetto alle regole (base di conoscenza)

%--------- modifca apportata da Pasquadibisceglie Vincenzo, Zaza Gianluca, Novembre 2016
% Questa modifica permette di gestire oltre alla separazione dei fatti rispetto alle regole (base di conoscenza), gli rfact


do(1) :-
	curr_task(0),
	retractall(curr_task(_)),
	assert(curr_task(1)),
	loader,
	gui_seva(menu),
	read(Chc),
	do(Chc),
	!.
do(1) :-
    curr_task(1),
	gui_popup(info1),
	gui_seva(menu),
	read(Chc),
	do(Chc),
	!.
do(2) :-
	curr_task(1),
	retractall(curr_task(_)),
	assert(curr_task(2)),
	loaderfacts,
	gui_seva(menu),
	read(Chc),
	do(Chc),
	!.
do(2) :-
    curr_task(2),
	gui_popup(info6),
	gui_seva(menu),
	read(Chc),
	do(Chc),
	!.
do(2) :-
    curr_task(0),
	gui_popup(wrong6),
	gui_seva(menu),
	read(Chc),
	do(Chc),
	!.
% ---------------------------------------

do(3) :-
	curr_task(1),
	gui_popup(wrong2),
	gui_seva(menu),
	read(Chc),
	do(Chc),
	!.
do(3) :-
	curr_task(2),
	start_count,	%Modifica apportata da Luigi Tedone, fa partire il timer che misura la durata del processo inferenziale
	retractall(curr_task(_)),
	assert(curr_task(3)),
	reconsult('./gie/gie_forward.pl'),
	gui_gie(heading),
	%creo i predicati irule per ciascuna regola utili all'indicizzazione
	initindexrules,
	%creo le liste (iniziali e di servizio) con le regole presenti nella wm
	initialrules,
	%creo le liste (iniziali e di servizio) con i fatti presenti nella wm
	initialfacts,
	%con le regole presenti nella wm creo i nuovi alberi aventi la la radice con le condizioni di ogni regola
	init_trees, 
	%richiamo il ricercatore di frame e lo cerco
	reconsult('./gie/gie_frame.pl'),
	findframe, %se non è stato definito use_frame(FRAME) i frame non saranno utilizzati
	%richiamo il gestore principale
	mainloop,
	gui_gie(closing),
	gui_seva(menu),
	read(Chc),
	do(Chc),
	!.
do(3) :-
	gui_popup(wrong2),
	gui_seva(menu),
	read(Chc),
	do(Chc),
	!.
do(4) :-
	curr_task(XChs),
	XChs > 3,
	gui_popup(info3),
	gui_seva(menu),
	read(Chc),
	do(Chc),
	!.
do(4) :-
	curr_task(3),
	retractall(curr_task(_)),
	assert(curr_task(4)),
	save_dedfact,
	defuzzyfier,
	gui_popup(saving),
	gui_seva(menu),
	read(Chc),
	do(Chc),
	!.
do(4) :-
	gui_popup(wrong1),
	gui_seva(menu),
	read(Chc),
	do(Chc),
	!.
do(5) :-
	curr_task(XChs),
	XChs < 4,
	gui_popup(wrong4),
	gui_seva(menu),
	read(Chc),
	do(Chc),
	!.
do(5) :-
	gui_expmodule(heading),
	%estraggo le regole usate per inferire nuovi fatti
	retrievaling_usedrules,
	
	%retrievaling_usedrules_2,                                                     % sbloccare nel caso si voglia utilizzare 
	%open('rulefact.pl', write, SS),                                               % l'altro modulo di spiegazione 
    %write(SS,'''.''.'),                                                           % (Anzivino Giuseppe, Novembre 2016), 
	%nl(SS),                                                                       % e commentare 
	%close(SS),                                                                    % retrievaling_usedrules
	
	%costruisco le spiegazioni
	building_explain,
	
	%building_explain_2,                                                           % sbloccare nel caso si voglia utilizzare 
	%rules,                                                                        % l'altro modulo di spiegazione 
	%stamp_rule_fact,                                                              % (Anzivino Giuseppe, Novembre 2016), 
	%delete_file('explain.pl'),                                                    % e commentare building_explain
	
	gui_expmodule(closing),
	gui_seva(menu),
	read(Chc),
	do(Chc),
	!.
do(6) :-
	curr_task(XChs),
	XChs < 4,
	gui_popup(wrong5),
	gui_seva(menu),
	read(Chc),
	do(Chc),
	!.
do(6) :-
	gui_backmodule(heading),
	gui_popup(info4),
	read(Goal),
	gui_backmodule(beginning),
	backward(Goal),
	gui_backmodule(closing),
	gui_seva(menu),
	read(Chc),
	do(Chc),
	!.
do(6) :-
	gui_popup(info5),
	gui_backmodule(closing),
	gui_seva(menu),
	read(Chc),
	do(Chc),
	!.
do(7) :-
	curr_task(0),
	gui_popup(wrong2),
	gui_seva(menu),
	read(Chc),
	do(Chc),
	!.
do(7) :-
	curr_task(1),
	gui_popup(wrong3),
	gui_seva(menu),
	read(Chc),
	do(Chc),
	!.
do(7) :-
	retractall(curr_task(_)),
	assert(curr_task(1)),
	initializer,
	gui_popup(info0),
	gui_seva(menu),
	read(Chc),
	do(Chc),
	!.
do(8) :-
	cleaner,
	gui_popup(info0),
	gui_seva(menu),
	read(Chc),
	do(Chc),
	!.
%aggiunto da Pasquadibisceglie V. - Zaza G. : inserimento della funzionalità della modifica delle membership.
do(9) :-
curr_task(XChs),
	XChs > 1,
	gui_popup(wrong7),
	gui_seva(menu),
	read(Chc),
	do(Chc),
	!.
do(9) :-
	inizio,
	!.
%Aggiunto da Bruno S. - Morelli N. - Pinto A. : Aggiunta di del_fact per la rimozione forzata.
do(10) :-
	curr_task(2),
	gui_popup(info7),
	read(DelFact),
	assert(del_fact(DelFact)),
	delete_fact(DelFact),
	gui_seva(menu),
	read(Chc),
	do(Chc),
	!.
do(10) :-
    curr_task(0),
	gui_popup(wrong2),
	gui_seva(menu),
	read(Chc),
	do(Chc),
	!.
%Aggiunto da Bruno S. - Morelli N. - Pinto A. : Aggiunta di un modulo per i filtri.
do(11) :-
	curr_task(XChs),
	XChs < 4,
	gui_popup(wrong1),
	gui_seva(menu),
	read(Chc),
	do(Chc),
	!.
do(11) :-
	filter_menu,
	gui_seva(menu),
	read(Chc),
	do(Chc),
	!.	

% Modifica nostra
do(12) :-
	curr_task(1),
	gui_popup(wrong2),
	gui_seva(menu),
	read(Chc),
	do(Chc),
	!.
do(12) :-
	curr_task(2),
	start_count,	%Modifica apportata da Luigi Tedone, fa partire il timer che misura la durata del processo inferenziale
	retractall(curr_task(_)),
	assert(curr_task(3)),	
	reconsult('./gie/gie_forward_rete.pl'),
	gui_gie(heading),
	%creo i predicati irule per ciascuna regola utili all'indicizzazione
	initindexrules,
	%creo le liste (iniziali e di servizio) con le regole presenti nella wm
	initialrules,
	%creo le liste (iniziali e di servizio) con i fatti presenti nella wm
	initialfacts,
	%con le regole presenti nella wm creo i nuovi alberi aventi la la radice con le condizioni di ogni regola
	init_trees, 
	%richiamo il ricercatore di frame e lo cerco
	reconsult('./gie/gie_frame.pl'),
	findframe, %se non è stato definito use_frame(FRAME) i frame non saranno utilizzati
	%richiamo il gestore principale
	mainloop,
	gui_gie(closing),
	gui_seva(menu),
	read(Chc),
	do(Chc),
	!.
do(12) :-
	gui_popup(wrong2),
	gui_seva(menu),
	read(Chc),
	do(Chc),
	!.

do(0) :-
	gui_seva(closing),
	!.
do(_) :-
	gui_popup(wrong0),
	gui_seva(menu),
	read(Chc),
	do(Chc),
	!.


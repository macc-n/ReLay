/**********************************************
        Nome: seva_java.pl
        
	Realizzazione: Febbraio, 2014, seva_start
  		Obiettivo: MAIN del SEVA
       		Autore: Francesco Solare
       	 
	Revisione : Luglio,2014
	Autore: Visaggio Domenico
	
	Revisione : Novembre, 2016
	Autore: Iovine A. - Lovascio C.
	Obiettivo:
		-Gestione dei moduli
			-Modifiche in loader
			-Incluso il file seva_modules
**********************************************/
:- use_module(library(lists)).



/***********************************************
      	PREDICATI DI SETTING DELL'AMBIENTE
***********************************************/
:- multifile (rule/5).
%rappresentazione dei fatti della kb
:- dynamic (fact/3).
%rappresentazione dei fatti grezzi della kb
:- dynamic (rfact/5).
%rappresentazione delle regole della kb
:- dynamic (rule/5).
%id dei fatti
:- dynamic (idf/1).
%id delle regole
:- dynamic (idr/1).
%lista dei fatti originali
:- dynamic (initfacts/1).
%lista delle regole originali
:- dynamic (initrules/1).
%rappresentazione dei fatti usati nel processo inferenziale
:- dynamic (used_fact/3).
%regole usate nel processo inferenziale
:- dynamic (used_rule/5).
%indicizzazione delle regole
:- dynamic (irule/3).
%tracking del percorso di risoluzione forward
:- dynamic (tracker/2).
%regole utilizzate per inferire la nuova conoscenza durante il processo deduttivo
:- dynamic (inferedrule/2).


/*****
MODIFICA AGGIUNTA DA Visaggio Domenico
Per interporlog
*********/
:-prolog_flag(unknown,_,fail).  


/***********************************************
      	PREDICATI DI SETTING DEL GIE
***********************************************/
%lista delle regole in conflitto con quella considerata durante il processo inferenziale
:- dynamic (confl/1).
%lista dei fatti già considerati durante il processo inferenziale
:- dynamic (fireset/1).
%rappresenta una regola che è stata verificata
:- dynamic (verified/2).
%regole già considerate durante il processo inferenziale
:- dynamic (frule/5).

/***********************************************
      	PREDICATI DI I/0 
***********************************************/
%kb corrente
:- dynamic (curr_kb/1).
%kb grezza corrente
:- dynamic (curr_rudekb/1).
%validazione dell'utilizzo del modulo di fuzzyness
:- dynamic (fuzzycheck/1).
%id del file .log
:- dynamic (curr_flog/1).
%scelta da menu corrente
:- dynamic (curr_task/1).
%rappresentazione delle membership di input
%:- dynamic (ufunctinput/4).% Morisco-Petrera
%rappresentazione delle membership di output
%:- dynamic (ufunctoutput/4). %Morisco-Petrera
%rappresentazione del valore di regolazione da applicare al setting ambientale
:- dynamic (final_adjustment/2).
%rappresentazione dei frame definiti in gie/ FRAME
:- dynamic(frame/2).

:- dynamic (fact_presence/1).
:- dynamic (max_id/1).
:- dynamic (explained_fact/1).
:- dynamic (explained_condition_rule/2).
:- dynamic (final_k/3).
:- dynamic (use_frame/1).

%inizializzazione dell'ambiente SEVA
:- reconsult('seva_textgui.pl').
:- reconsult('seva_setting.pl').
:- reconsult('seva_explain.pl').
:- reconsult('seva_utility.pl').
% Modifica Iovine-Lovascio: Gestione moduli
:- reconsult('seva_modules.pl').

/***
PER INTERPROLOG
***/

/********************************************
      	Setting iniziale dell'ambiente
********************************************/
curr_task(0).
curr_kb(unknow).
curr_flog(unknow).
path_frame('WebContent/ES/IE/gie/FRAME/').
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


check_max :- not(fact(_Id, _X , _Y )),
	              fuzzyness_module.
				  
check_max :- find_max,
	              fuzzyness_module.		
				  
				  
fuzzyfier(Kb) :-
	call(rfact(_,_,_,_,_)),
	!,
	retractall(fuzzycheck(_)),
	assert(fuzzycheck(1)),	
	retractall(curr_kb(_)),
	retractall(curr_rudekb(_)),	
	assert(curr_rudekb(Kb)),
	%reconsult('WebContent/ES/IE/seva_fuzzyness.pl'),
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
	retractall(fuzzycheck(_)),
	assert(fuzzycheck(0)),
	assert(curr_kb(Kb)),
	%elimino le funzioni di membership per l'input, mantendo quelle per l'output
	retractall(ufunctinput(_,_,_,_)),
	gui_popup(info0).
	

loader(Kb) :-
	gui_fuzzymodule(loader),
	%reconsult(Kb),
	load_first(Kb),
	%valuto l'ultimo timestamp 
	%reconsult('WebContent/ES/IE/gie/gie_forward.pl'),
	reconsult('./gie/gie_forward.pl'),
	open(Kb,append,Stream),
	valute_timestamp(Stream),
	close(Stream),
	%inizializzo il file .log
	create_filelog(Kb),
	fuzzyfier(Kb).

	

/*************************************************************************
        Realizzazione: Gestione del modulo di defuzzificazione
*************************************************************************/
defuzzyfier :-
	%reconsult('WebContent/ES/IE/seva_defuzzyness.pl'),
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
	%reconsult('WebContent/ES/IE/seva_refresh.pl'),			
	%reconsult('WebContent/ES/IE/seva_setting.pl').
	reconsult('seva_refresh.pl'),			
	reconsult('seva_setting.pl').		
	
%-------------------------------------- CICLO MAIN ----------------------------------------------
	
startMiFuzzi(Kb) :-
	%reconsult('WebContent/ES/IE/seva_setting.pl'),	
    reconsult('seva_setting.pl'),	
	loader(Kb),
	!.
	

startGie:-
	start_count,	%Modifica apportata da Luigi Tedone, fa partire il timer che misura la durata del processo inferenziale
	%reconsult('WebContent/ES/IE/gie/gie_forward.pl'),
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
	%richiamo il ricercatore di frame e lo cerco nella kb
	reconsult('WebContent/ES/IE/gie/gie_frame.pl'),
	reconsult('./gie/gie_frame.pl'),
	%consult('WebContent/ES/KB/new_fact'),
	findframe,
	%richiamo il gestore principale
	mainloop, 
	gui_gie(closing),
	!.
	
	
startDefuzziandSave :-
	save_dedfact,
	defuzzyfier,
	gui_popup(saving),
	!.


startExplainer :-
	gui_expmodule(heading),
	%estraggo le regole usate per inferire nuovi fatti
	retrievaling_usedrules,
	%costruisco le spiegazioni
	building_explain,
	gui_expmodule(closing),
	!.

	
startReinizialize :-
	initializer,
	gui_popup(info0),
	!.
	
startRefresh :- 
	cleaner,
	gui_popup(info0),
	!.

	
startTranslateToInthelexClassify(Head):-
	%reconsult('WebContent/ES/IE/seva_int.pl'),
	reconsult('seva_int.pl'),
	translateToInthelexClassify(Head),
	gui_popup(info0).

startTranslateToInthelexTune(Head):-
	%reconsult('WebContent/ES/IE/seva_int.pl'),
	reconsult('seva_int.pl'),
	translateToInthelexTune(Head),
	gui_popup(info0).
	
startTranslateToInthelexBody(Body):-
	%reconsult('WebContent/ES/IE/seva_int.pl'),
	reconsult('seva_int.pl'),
	translateToInthelexBody(Body),
	gui_popup(info0).

	
/***startTranslateToInthelex(Path):-	
	reconsult('WebContent/ES/IE/seva_int2.pl'),
	translateToInthelex('apprendimento/pattern2.pl').***/
	
/*******
AGGIUNTO DA VISAGGIO DOMENICO PER INTERPROLOG
******/
nonDeterministicGoal(InterestingVarsTerm,G,ListTM) :-
  findall(InterestingVarsTerm,G,L), buildTermModel(L,ListTM).
	
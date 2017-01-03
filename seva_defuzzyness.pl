/************************************************************************************************
        Nome: seva_defuzzyness.pl
         
      	Realizzazione: Febbraio, 2014
  		Descrizione: Modulo di defuzzificazione dell'output
       		Autore: Francesco Solare
       	 
        	Rappresentazione: Fatto dedotto
		fact(Idf,Fact,Certainty).
        		Idf -> id fatto dedotto
        		F -> fatto del tipo "variable(Survey,LangLabel)"
			Variable -> variabile di output (tipo di regolazione)
			Survey -> id della rilevazione
			LangLabel -> etichetta della variabile linguistica (livello di regolazione)
			Certainty -> valore di certezza ]0,1] (del livello applicato a quel tipo di regolazione)

		Rappresentazione: Valore di Regolazione della Configurazione ambientale corrente
		Per ogni Variable, con N Label, la regolazione viene calcolata col
			Metodo della Media Pesata
			
			[(PickLangLabel1*CertLangLabel1)+...+(PickLangLabel1*CertLangLabel1)]
			_____________________________________________________________________

					[CertLangLabel1+...+CertLangLabelN]

		Rappresentazione: Valore booleano
			B -> {0,1}

***********************************************************************************************/
%definizione dell'associazione fatto dedotto - etichetta linguistica - valore di certezza
:- dynamic (initialdedfact/4).
%definizione dell'associazione membership di output - etichetta linguistica - valore di certezza
:- dynamic (initialufunctout/3).
%inizializzazione del calcolo della media pesata di Sugeno
:- dynamic (countforfact/4).
%rappresentazione del valore di regolazione da applicare al setting ambientale
:- dynamic (final_adjustment/3).
%lista contenete gli ufunctout
:- dynamic (ufunctoutlist/1).
%lista contenete i final_adjlist
:- dynamic (final_adjlist/1).
ufunctoutlist([]).
%-------------------------------------- INIZIO PROCEDURA PREPROCESSING_DEDFACT/0 -------------------------------------------------
/**************************************************************************************************************************
     Modifica apportata da Domenico V, per verificare se c'è ufunctoutput corrispondente
	 
	 Descrizione: 
		Procedura composta che permette di inizializzare il modulo di defuzzyness con le informazioni necessarie		
	Output: 
		un predicato dinamico initialdedfact/3 - Recupero delle info sui fatti dedotti dal processo inferenziale
		un predicato dinamico initialufunctout/3 - Recupero delle info sulle membership di output da considerare
	Esempio:
	input
		used_fact(1,natural_brightness_middle(survey1),0.35).
		used_fact(2,internal_brightness_middle_high(survey1),0.36666666666666664).
		used_fact(3,natural_brightness_high(survey1),0.65).
		used_fact(4,internal_brightness_very_high(survey1),0.6333333333333333).
		used_fact(5,box_occupied(survey1),1.0).
		used_fact(6,lux_dimming_level(survey1,l1),0.35).
		used_fact(7,lux_dimming_level(survey1,l2),0.36666666666666664).
		initfacts([5,4,3,2,1]).
		ufunctoutput(1,lux_dimming_level,[stop,l1,l2,l3,max],[0,25,50,100,200]).
	output
		initialdedfact(lux_dimming_level,l1,0.35).
		initialdedfact(lux_dimming_level,l2,0.36666666666666664).
		initialufunctout(lux_dimming_level,l1,25).
		initialufunctout(lux_dimming_level,l2,50).
**************************************************************************************************************************/
%Estrazione ed asserzione della corrispondenza membership/regolazione
extracting_initiufunctout(_,_,[],[]) :-
	!.
extracting_initufunctout(LVar,RLevel,[RLevel|_],[LValue|_]) :-
	!,
	assert(initialufunctout(LVar,RLevel,LValue)).
extracting_initufunctout(LVar,RLevel,[_|TailLLabel],[_|TailLValue]) :-
	extracting_initufunctout(LVar,RLevel,TailLLabel,TailLValue).

%Inizializzazione delle funzioni di membership di output
initializing_ufunctout(LangVariable,RegLevel) :-
	ufunctoutputok(_,LangVariable,LangLabelList,LangValueList), %modificato da ufunctoutput in ufunctoutputok
	extracting_initufunctout(LangVariable,RegLevel,LangLabelList,LangValueList).

%Ciclo principale
preprocessing_dedfact :-
	used_fact(IdDFact,DedFact,CertDFact),
	initfacts(InitialFact),	
	not(member(IdDFact,InitialFact)),
	%estrazione del livello di regolazione
	assert(DedFact),
	functor(DedFact,FunctDFact,_),
	ufunctoutlist(L),       %aggiunto da Domenico V
	member(FunctDFact,L), %aggiunto da Domenico V
	arg(3,DedFact,RegulationLevel), %modificato per aggiunta istanza
	arg(2,DedFact,Istance), %modificato per aggiunta istanza
	retract(DedFact),
	%asserzione della nuova conoscenza
	assert(initialdedfact(FunctDFact,RegulationLevel,CertDFact,Istance)),
	%inizializzazione della membership di riferimento
	initializing_ufunctout(FunctDFact,RegulationLevel),
	sleep(0.1),
	nl,write('     retrieved deduction'),
	fail.
%passo base.
preprocessing_dedfact.
%-------------------------------------- FINE PROCEDURA PREPROCESSING_DEDFACT/0 -------------------------------------------------

/**************************************************************************************************************************
        Descrizione: 
		Estensione della procedura di inizializzazione del processo di defuzzyness dell'output		
	Output: 
		un predicato dinamico countforfact/4 - Inizializza il calcolo di defuzzyness
	Esempio:
	input
		initialdedfact(lux_dimming_level,l1,0.35,bagno1).
		initialdedfact(lux_dimming_level,l2,0.36666666666666664,bagno1).
		initialufunctout(lux_dimming_level,l1,25,bagno1).
		initialufunctout(lux_dimming_level,l2,50,bagno1).
	output
		countforfact(lux_dimming_level,0,0,bagno1).
**************************************************************************************************************************/
checking_dedfact :-
	initialdedfact(DedFact,_,_,Istance),
	not(countforfact(DedFact,0,0,Istance)),	
	assert(countforfact(DedFact,0,0,Istance)),
	fail.
checking_dedfact.

/**************************************************************************************************************************
  Modifica apportata da Domenico V. assert(final_adj(DedFact,Regulation))
 Asserisce le regolazioni finali per poi essere visualizzate dall'interfaccia java
 
        Descrizione: 
		Procedura composta che permette di defuzzificare l'output dell'inferenza (per eccesso)		
	Output: 
		un predicato dinamico final_adjustment/3 - Valore crisp (%) della regolazione
	Esempio:
	input
		initialdedfact(lux_dimming_level,l1,0.35).
		initialdedfact(lux_dimming_level,l2,0.36666666666666664).
		initialufunctout(lux_dimming_level,l1,25).
		initialufunctout(lux_dimming_level,l2,50).
	output
		final_adjustment(bagno1,lux_dimming_level,38).
**************************************************************************************************************************/
processing_dedfact :-
	initialdedfact(DedFact,RegLevel,CertDFact,Istance),
	initialufunctout(DedFact,RegLevel,MaxPick),	
	retract(countforfact(DedFact,ActualNum,ActualDenom,Istance)),
	NewNum is ActualNum+(MaxPick*CertDFact),
	NewDenom is ActualDenom+CertDFact,
	assert(countforfact(DedFact,NewNum,NewDenom,Istance)),
	retract(initialdedfact(DedFact,RegLevel,CertDFact,Istance)),
	retract(initialufunctout(DedFact,RegLevel,MaxPick)),
	fail.
	
processing_dedfact :-
	countforfact(DedFact,FinalNum,FinalDenom,Istance),
	%approssimazione per eccesso
	FinalDenom > 0, %Aggiunto da D. Visaggio
	Regulation is ceiling(FinalNum/FinalDenom),
	%Regulation is FinalNum/FinalDenom,
	assert(final_adjustment(Istance,DedFact,Regulation)),
	assert(final_adj(Istance,DedFact,Regulation)),
	sleep(0.1),
	nl,write('     defuzzyness'),
	retract(countforfact(DedFact,FinalNum,FinalDenom,Istance)),
	fail.

processing_dedfact.

/*********************************
Aggiunto da Domenico V.

Descrizione:Permette di realizzare la lista contente gli ufunctoutput, utile se non ci sono ufunctoutput corrispondenti

****************************************/
getufunctoutlist:-ufunctoutput(Id,LangVariable,LangLabelList,LangValueList),
                  assert(ufunctoutputok(Id,LangVariable,LangLabelList,LangValueList)),
				  retract(ufunctoutput(Id,LangVariable,LangLabelList,LangValueList)),
				  ufunctoutlist(L),	
	             append([LangVariable],L,Ln),
				 retract(ufunctoutlist(L)),
				 assert(ufunctoutlist(Ln)),
				 getufunctoutlist.
				 
getufunctoutlist.
%-------------------------------------- CICLO MAIN -------------------------------------------------------
defuzzyness_module :-
	gui_fuzzymodule(heading_defuzzyness),
	curr_kb(Kb),
	curr_flog(FileLog),
	open(FileLog,append,Str1),
	write(Str1,'%*********** TRACKING DEFUZZYNESS ON '),write(Str1,Kb),write(Str1,' ***********'),
	close(Str1),
	getufunctoutlist, %aggiunto da Domenico V.
	%ciclo main - begin
	preprocessing_dedfact,
	tracking_defuzzyness,
	gui_fuzzymodule(beginning),
	checking_dedfact,
	processing_dedfact,
	tracking_defuzzyness,
	%ciclo main - end
	open(FileLog,append,Str2),
	nl(Str2),nl(Str2),write(Str2,'%***************** END ******************'),
	nl(Str2),nl(Str2),
	close(Str2),
	gui_fuzzymodule(closing).

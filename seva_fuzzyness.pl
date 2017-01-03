/****************************************************************************
        Nome: seva_fuzzyness.pl
         
      	Realizzazione: Febbraio, 2014
  		Descrizione: Modulo di fuzzificazione dell'input
       		Autore: Francesco Solare
	  	Revisione : Giugno,2014
	    Autore: Fabio Fiorella & Davide Giannico
       
	   Rappresentazione: Fatto grezzo
        	rfact(Idrf,Survey,Variable,Value).
        		Idrf -> id fatto grezzo
        		Survey -> id della rilevazione
			Variable -> nome della variabile linguistica
			Value -> valore rilevato dal sistema di sensori
			
	Rappresentazione: Fatto fuzzificato
		fact(Idf,Fact,Certainty).
        		Idf -> id fatto fuzzificato
        		F -> fatto del tipo "variable_LangLabel(Survey)"
			LangLabel -> etichetta della variabile linguistica
			Certainty -> valore di certezza ]0,1]
				     metodo della distanza dal picco della
				     membership
			Per ogni Variable, il valore di certezza della LangLabel viene calcolato col
			Metodo della Distanza (se Value è sullo slope della membership)
			
			[Value-MinLangLabel]		[MaxLangLabel-Value]	
			____________________________	____________________________

			[PickLangLabel-MinLangLabel]	[MaxLangLabel-PickLangLabel]
        
	Rappresentazione: Valore booleano
		B -> {0,1} 



  Revisione: Novembre, 2016
	   Autore: Pasquadibisceglie V. - Zaza G.
	   1)Eliminazione variabile Istance dai predicati :
	     -rfact
	     -matchedrfact
	     -chkdrfact
	     -evalrfact
	   2)Commentato comando sleep.	 
			


*****************************************************************************/
:- dynamic (curr_kb/1).
:- dynamic (curr_flog/1).

%kb da fuzzificare corrente
:- dynamic (curr_rudekb/1).
%rappresentazione dei fatti grezzi della kb da fuzzificare

%:- dynamic (rfact/5). 
:- dynamic (rfact/4).

%lista dei fatti grezzi da fuzzificare
:- dynamic (idrfact/1).
%rappresentazione delle membership di input
:- dynamic (ufunctinput/4).
%contatore dei fatti fuzzificati
:- dynamic (idffact/1).

%rappresentazione dell'associazione fatto grezzo - variabile linguistica relativa

%:- dynamic (matchedrfact/6).
:- dynamic (matchedrfact/5).

%definizione dell'associazione fatto grezzo - membership relativa/e
%:- dynamic (chkdrfact/5).
:- dynamic (chkdrfact/4).

%definizione dell'associazione fatto grezzo - valore di certezza (fuzzificato)
%:- dynamic (evalrfact/4).
:- dynamic (evalrfact/3).
:- dynamic (fact/3).

%configurazione del modulo
idrfact([]).
idffact(0).

/***************************************************************************************************************************************
        Descrizione: 
		Creazione della lista degli ID dei fatti iniziali grezzi - initializing_rudefact/0
	Output: 
		un predicato dinamico idrfact/1
	Esempio:
	input
		rfact(1,survey1,box,1).
		rfact(2,survey1,natural_brightness,2640).
		rfact(3,survey1,internal_brightness,895).
	output
		idrfact([3,2,1]).
****************************************************************************************************************************************/
initializing_rudefact :-
	%rfact(IDRF,_,_,_,_),
	rfact(IDRF,_,_,_),
	idrfact(IdrfOldList),
	append([IDRF],IdrfOldList,IdrfNewList),
	retract(idrfact(IdrfOldList)),
	assert(idrfact(IdrfNewList)),
	fail.
initializing_rudefact.

/***************************************************************************************************************************************
        Descrizione: 
		Procedura di assegnazione della funzione di membership della variabile linguistica - matching_rudefact/0
	Output: 
		un predicato dinamico matchedrfact/6
	Esempio:
	input
		ufunctinput(1,natural_brightness,[low,middle,high],[[[0,800],1600],[800,1600,3200],[1600,[3200,100000]]]).
		rfact(2,survey1,natural_brightness,2640).
	output
		matchedrfact(survey1,natural_brightness,2640,[[[0,800],1600],[800,1600,3200],[1600,[3200,100000]]],[low,middle,high]).
****************************************************************************************************************************************/
matching_rudefact :- 
	idrfact([]),
	retract(idrfact(_)),
	!.

matching_rudefact :-
	idrfact([FID|ITail]),
	%rfact(FID,SurId,Istance,LangVar,SurValue),
	rfact(FID,SurId,LangVar,SurValue),
	ufunctinput(UID,LangVar,LangLabel,LangValue),
	retract(idrfact(_)),
	assert(idrfact(ITail)),
	%ssert(matchedrfact(SurId,Istance,LangVar,SurValue,LangValue,LangLabel)),
	assert(matchedrfact(SurId,LangVar,SurValue,LangValue,LangLabel)),
	%sleep(0.1),
	nl,write('     extracted fact (seva formalism)'),
	%retract(rfact(FID,_,_,_,_)),
	retract(rfact(FID,_,_,_)),
	retract(ufunctinput(UID,_,_,_)),
	matching_rudefact.

%-------------------------------------- INIZIO PROCEDURA CHECKING_RUDEFACT/0 -------------------------------------------------

/***************************************************************************************************************************************
       Modifica effettuata da Domenico V. 
	  Caso 5 non era stato gestito, un esempio: ufunctinput(29,activity,[nothing,party,writing,watching_device,conversing,eating,reading],[[1],[2],[3],[4],[5],[6],[7]]).
 
        Descrizione: 
		Procedura di Assegnazione delle label alle variabili linguistiche - checking_rudefact/0
	Output: 
		un predicato dinamico chkdrfact/5
	Esempio:
	input
		matchedrfact(survey1,bagno1,natural_brightness,2640,[[[0,800],1600],[800,1600,3200],[1600,[3200,100000]]],[low,middle,high]).
	output
		chkdrfact(survey1,bagno1,natural_brightness_middle,2640,[800,1600,3200]).
		chkdrfact(survey1,bagno1,natural_brightness_high,2640,[1600,[3200,100000]]).
****************************************************************************************************************************************/	
%Caso 1 - Membership Trapezioidale classica e Triangolare
processing_matchedrfact :-
	%matchedrfact(SurId,Istance,LangVar,SurValue,[[Min,Pick,Max]|LVTail],[LLabel|LLTail]),
	matchedrfact(SurId,LangVar,SurValue,[[Min,Pick,Max]|LVTail],[LLabel|LLTail]),
	%revisione delle funzioni di membership da considerare
	%retract(matchedrfact(SurId,Istance,LangVar,SurValue,[[Min,Pick,Max]|LVTail],[LLabel|LLTail])),
	retract(matchedrfact(SurId,LangVar,SurValue,[[Min,Pick,Max]|LVTail],[LLabel|LLTail])),
	%assert(matchedrfact(SurId,Istance,LangVar,SurValue,LVTail,LLTail)),
	assert(matchedrfact(SurId,LangVar,SurValue,LVTail,LLTail)),
	%relazioni strette perché in questo modo evito di asserire valori di certezza nulli
	SurValue > Min,
	SurValue < Max,
	%asserzione del fatto verificato
	renaming_rfact(LangVar,LLabel,ChkdLangVar),
	%assert(chkdrfact(SurId,Istance,ChkdLangVar,SurValue,[Min,Pick,Max])),
	assert(chkdrfact(SurId,ChkdLangVar,SurValue,[Min,Pick,Max])),
	%sleep(0.1),
	nl,write('     checked fact (ready for fuzzyness)').

%Caso 2 - Membership Trapezioidale rettangolare a sinistra
processing_matchedrfact :-
	%matchedrfact(SurId,Istance,LangVar,SurValue,[[[Pick1,Pick2],Max]|LVTail],[LLabel|LLTail]),
	matchedrfact(SurId,LangVar,SurValue,[[[Pick1,Pick2],Max]|LVTail],[LLabel|LLTail]),
	%revisione delle funzioni di membership da considerare
	%retract(matchedrfact(SurId,Istance,LangVar,SurValue,[[[Pick1,Pick2],Max]|LVTail],[LLabel|LLTail])),
	retract(matchedrfact(SurId,LangVar,SurValue,[[[Pick1,Pick2],Max]|LVTail],[LLabel|LLTail])),
	%assert(matchedrfact(SurId,Istance,LangVar,SurValue,LVTail,LLTail)),
	assert(matchedrfact(SurId,LangVar,SurValue,LVTail,LLTail)),
	%relazioni strette perché in questo modo evito di asserire valori di certezza nulli
	SurValue < Max,
	%asserzione del fatto verificato
	renaming_rfact(LangVar,LLabel,ChkdLangVar),
	%assert(chkdrfact(SurId,Istance,ChkdLangVar,SurValue,[[Pick1,Pick2],Max])),
	assert(chkdrfact(SurId,ChkdLangVar,SurValue,[[Pick1,Pick2],Max])),
	%sleep(0.1),
	nl,write('     checked fact (ready for fuzzyness)').

%Caso 3 - Membership Trapezioidale rettangolare a destra
processing_matchedrfact :-
	%matchedrfact(SurId,Istance,LangVar,SurValue,[[Min,[Pick1,Pick2]]|LVTail],[LLabel|LLTail]),
	matchedrfact(SurId,LangVar,SurValue,[[Min,[Pick1,Pick2]]|LVTail],[LLabel|LLTail]),
	%revisione delle funzioni di membership da considerare
	%retract(matchedrfact(SurId,Istance,LangVar,SurValue,[[Min,[Pick1,Pick2]]|LVTail],[LLabel|LLTail])),
	retract(matchedrfact(SurId,LangVar,SurValue,[[Min,[Pick1,Pick2]]|LVTail],[LLabel|LLTail])),
	%assert(matchedrfact(SurId,Istance,LangVar,SurValue,LVTail,LLTail)),
	assert(matchedrfact(SurId,LangVar,SurValue,LVTail,LLTail)),
	%relazioni strette perché in questo modo evito di asserire valori di certezza nulli
	SurValue > Min,
	%asserzione del fatto verificato
	renaming_rfact(LangVar,LLabel,ChkdLangVar),
	%assert(chkdrfact(SurId,Istance,ChkdLangVar,SurValue,[Min,[Pick1,Pick2]])),
	assert(chkdrfact(SurId,ChkdLangVar,SurValue,[Min,[Pick1,Pick2]])),
	%sleep(0.1),
	nl,write('     checked fact (ready for fuzzyness)').
	
%Caso 4 - Membership Singleton a due valori
processing_matchedrfact :-
	%matchedrfact(SurId,Istance,LangVar,SurValue,[SurValue,_],[LLabel,_]),
	matchedrfact(SurId,LangVar,SurValue,[SurValue,_],[LLabel,_]),
	%riduzione al passo base
	%retract(matchedrfact(SurId,Istance,LangVar,SurValue,[SurValue,_],[LLabel,_])),
	retract(matchedrfact(SurId,LangVar,SurValue,[SurValue,_],[LLabel,_])),
	%assert(matchedrfact(SurId,Istance,LangVar,SurValue,[],[])),
	assert(matchedrfact(SurId,LangVar,SurValue,[],[])),
	%eventuale asserzione del fatto verificato
	renaming_rfact(LangVar,LLabel,ChkdLangVar),
	%assert(chkdrfact(SurId,Istance,ChkdLangVar,SurValue,SurValue)),
	assert(chkdrfact(SurId,ChkdLangVar,SurValue,SurValue)),
	%sleep(0.1),
	nl,write('     checked fact (ready for fuzzyness)').

processing_matchedrfact :-
	%matchedrfact(SurId,Istance,LangVar,SurValue,[_,SurValue],[_,LLabel]),
	matchedrfact(SurId,LangVar,SurValue,[_,SurValue],[_,LLabel]),
	%riduzione al passo base	
	%retract(matchedrfact(SurId,Istance,LangVar,SurValue,[_,SurValue],[_,LLabel])),
	retract(matchedrfact(SurId,LangVar,SurValue,[_,SurValue],[_,LLabel])),		
	%assert(matchedrfact(SurId,Istance,LangVar,SurValue,[],[])),
	assert(matchedrfact(SurId,LangVar,SurValue,[],[])),
	%asserzione del fatto verificato
	renaming_rfact(LangVar,LLabel,ChkdLangVar),
	%assert(chkdrfact(SurId,Istance,ChkdLangVar,SurValue,SurValue)),
	assert(chkdrfact(SurId,ChkdLangVar,SurValue,SurValue)),
	%sleep(0.1),
	nl,write('     checked fact (ready for fuzzyness)').
	
%Caso 5 - Membership Singleton a pi� valori	
processing_matchedrfact :-
	%matchedrfact(SurId,Istance,LangVar,SurValue,[[SurValue]|_],[LLabel|_]),
	matchedrfact(SurId,LangVar,SurValue,[[SurValue]|_],[LLabel|_]),
	%riduzione al passo base
	%retract(matchedrfact(SurId,Istance,LangVar,SurValue,[[SurValue]|_],[LLabel|_])),
	retract(matchedrfact(SurId,LangVar,SurValue,[[SurValue]|_],[LLabel|_])),
	%assert(matchedrfact(SurId,Istance,LangVar,SurValue,[],[])),
	assert(matchedrfact(SurId,LangVar,SurValue,[],[])),
	%asserzione del fatto verificato
	renaming_rfact(LangVar,LLabel,ChkdLangVar),
	%assert(chkdrfact(SurId,Istance,ChkdLangVar,SurValue,SurValue)),
	assert(chkdrfact(SurId,ChkdLangVar,SurValue,SurValue)),
	%sleep(0.1),
	nl,write('     checked fact (ready for fuzzyness)').
	
processing_matchedrfact :-
	%matchedrfact(SurId,Istance,LangVar,SurValue,[[X]|LVTail],[LLabel|LLTail]),
	matchedrfact(SurId,LangVar,SurValue,[[X]|LVTail],[LLabel|LLTail]),
	%revisione delle funzioni di membership da considerare
	%retract(matchedrfact(SurId,Istance,LangVar,SurValue,[[X]|LVTail],[LLabel|LLTail])),
	retract(matchedrfact(SurId,LangVar,SurValue,[[X]|LVTail],[LLabel|LLTail])),
	%assert(matchedrfact(SurId,Istance,LangVar,SurValue,LVTail,LLTail)).
	assert(matchedrfact(SurId,LangVar,SurValue,LVTail,LLTail)).


%passo base	
processing_matchedrfact.

%ciclo principale
checking_rudefact :-	
	%matchedrfact(_,_,_,_,[],[]),
	matchedrfact(_,_,_,[],[]),		
	%retract(matchedrfact(_,_,_,_,[],[])),
	retract(matchedrfact(_,_,_,[],[])),
	!,
	checking_rudefact.
checking_rudefact :-		
	%matchedrfact(_,_,_,_,_,_),
	matchedrfact(_,_,_,_,_),
	processing_matchedrfact,
	!,
	checking_rudefact.
checking_rudefact.

%-------------------------------------- FINE PROCEDURA CHECKING_RUDEFACT/0 -------------------------------------------------

%-------------------------------------- INIZIO PROCEDURA EVALUATING_RUDEFACT/0 -------------------------------------------------

/***************************************************************************************************************************************
        Descrizione: 
		Procedura di Assegnazione dei valori di certezza alle variabili linguistiche - evaluating_rudefact/0
	Output: 
		un predicato dinamico evalrfact/4
	Esempio:
	input
		chkdrfact(survey1, bagno1, natural_brightness_middle,2640,[800,1600,3200]).
		chkdrfact(survey1,bagno1 box_occupied, 1, 1).
	output
		evalrfact(survey1,bagno1,natural_brightness_middle,0.35).
		evalrfact(survey1,bagno1, box_occupied, 1.00).
****************************************************************************************************************************************/	
%Caso 1 - Membership Trapezoidale isoscele
evaluating_rudefact :-		
	%chkdrfact(SurId,Istance,ChkdLangVar,SurValue,[Min,[Pick1,Pick2],Max]),
	chkdrfact(SurId,ChkdLangVar,SurValue,[Min,[Pick1,Pick2],Max]),
	computing_fuzzy_value(SurValue,[Min,[Pick1,Pick2],Max],FuzzyValue),		
	%retract(chkdrfact(SurId,Istance,ChkdLangVar,SurValue,[Min,[Pick1,Pick2],Max])),
	retract(chkdrfact(SurId,ChkdLangVar,SurValue,[Min,[Pick1,Pick2],Max])),				
	%assert(evalrfact(SurId,Istance,ChkdLangVar,FuzzyValue)),
	assert(evalrfact(SurId,ChkdLangVar,FuzzyValue)),
	%sleep(0.1)
	nl,write('     fuzzyness'),
	fail.

%Caso 2 - Membership Triangolare
evaluating_rudefact :-			
	%chkdrfact(SurId,Istance,ChkdLangVar,SurValue,[Min,Pick,Max]),
	chkdrfact(SurId,ChkdLangVar,SurValue,[Min,Pick,Max]),
	computing_fuzzy_value(SurValue,[Min,Pick,Max],FuzzyValue),			
	%retract(chkdrfact(SurId,Istance,ChkdLangVar,SurValue,[Min,Pick,Max])),
	retract(chkdrfact(SurId,ChkdLangVar,SurValue,[Min,Pick,Max])),				
	%assert(evalrfact(SurId,Istance,ChkdLangVar,FuzzyValue)),
	assert(evalrfact(SurId,ChkdLangVar,FuzzyValue)),
	%sleep(0.1),
	nl,write('     fuzzyness'),
	fail.

%Caso 3 - Membership Trapezoidale rettangolare a sinistra
evaluating_rudefact :-		
	%chkdrfact(SurId,Istance,ChkdLangVar,SurValue,[[Pick1,Pick2],Max]),
	chkdrfact(SurId,ChkdLangVar,SurValue,[[Pick1,Pick2],Max]),
	computing_fuzzy_value(SurValue,[[Pick1,Pick2],Max],FuzzyValue),		
	%retract(chkdrfact(SurId,Istance,ChkdLangVar,SurValue,[[Pick1,Pick2],Max])),
	retract(chkdrfact(SurId,ChkdLangVar,SurValue,[[Pick1,Pick2],Max])),				
	%assert(evalrfact(SurId,Istance,ChkdLangVar,FuzzyValue)),
	assert(evalrfact(SurId,ChkdLangVar,FuzzyValue)),
	%sleep(0.1)
	nl,write('     fuzzyness'),
	fail.

%Caso 4 - Membership Trapezoidale rettangolare a destra
evaluating_rudefact :-
	%chkdrfact(SurId,Istance,ChkdLangVar,SurValue,[Min,[Pick1,Pick2]]),
	chkdrfact(SurId,ChkdLangVar,SurValue,[Min,[Pick1,Pick2]]),
	computing_fuzzy_value(SurValue,[Min,[Pick1,Pick2]],FuzzyValue),	
	%retract(chkdrfact(SurId,Istance,ChkdLangVar,SurValue,[Min,[Pick1,Pick2]])),
	retract(chkdrfact(SurId,ChkdLangVar,SurValue,[Min,[Pick1,Pick2]])),	
	%assert(evalrfact(SurId,Istance,ChkdLangVar,FuzzyValue)),
	assert(evalrfact(SurId,ChkdLangVar,FuzzyValue)),
	%sleep(0.1)
	nl,write('     fuzzyness'),
	fail.
	
%Caso 5 - Membership Singleton
evaluating_rudefact :-	
	%chkdrfact(SurId,Istance,ChkdLangVar,SurValue,SurValue),
	chkdrfact(SurId,ChkdLangVar,SurValue,SurValue),		
	%retract(chkdrfact(SurId,Istance,ChkdLangVar,SurValue,SurValue)),
	retract(chkdrfact(SurId,ChkdLangVar,SurValue,SurValue)),				
	%assert(evalrfact(SurId,Istance,ChkdLangVar,1.0)),
	assert(evalrfact(SurId,ChkdLangVar,1.0)),
	%sleep(0.1)
	nl,write('     fuzzyness'),
	fail.

%passo base
evaluating_rudefact.

%-------------------------------------- FINE PROCEDURA EVALUATING_RUDEFACT/0 -------------------------------------------------

%-------------------------------------- INIZIO PROCEDURA ASSERTING_FACT/1 -------------------------------------------------

/***************************************************************************************************************************************
        Descrizione: 
		Procedura di Costruzione dei fatti in formato GIE e successiva asserzione - asserting_fact/1
	Output: 
		una modifica del file della KB corrente con i fatti fuzzificati
		asserzione nella WM dei fatti da sottoporre ad inferenza
	Esempio:
	input
		evalrfact(survey1,bagno1,natural_brightness_middle,0.35).
	output (su curr_kb)
		fact(1,natural_brightness_middle(survey1,bagno1),0.35).
****************************************************************************************************************************************/	
% edited by Fabio Fiorella & Davide G. 

asserting_facts(Stream) :-			
	%evalrfact(SurId,Istance,ChkdLangVar,FuzzyValue),
	evalrfact(SurId,ChkdLangVar,FuzzyValue),
	retract(idffact(_)),
	max_id(Max),	 % si individua il valore massimo tra gli ID dei fact.
	%incremento il contatore dei fatti
	NewIdFact is Max+1, % si assegna il valore massimo + 1 come ID del nuovo fatto che verrà asserito
	retract(max_id(Max)),
	assert(max_id(NewIdFact)), % si aggiorna il valore massimo. 
	assert(idffact(NewIdFact)),		
	%retract(evalrfact(SurId,Istance,ChkdLangVar,FuzzyValue)),
	retract(evalrfact(SurId,ChkdLangVar,FuzzyValue)),
	%salvataggio sul file della kb corrente
    %saving_facts(Stream,NewIdFact,ChkdLangVar,SurId,Istance,FuzzyValue),
	saving_facts(Stream,NewIdFact,ChkdLangVar,SurId,FuzzyValue),
	%sleep(0.1)
	nl,write('     asserting'),
	fail.
asserting_facts(Stream) :-
	%chiudo il file e lo reconsulto
	nl(Stream),
	close(Stream),
	retractall(idffact(_)),
	%Reconsult della KB, fuzzificata, in formalismo	GIE
	retract(curr_rudekb(CompleteKb)),
	retractall(curr_kb(_)),
	assert(curr_kb(CompleteKb)),
	reconsult(CompleteKb),
	retractall(rfact(_)).
%-------------------------------------- FINE PROCEDURA BUILDING_FACT/0 -------------------------------------------------
% added by Fabio F. & Davide G. %
%------------ INIZIO PROCEDURA PER L'INDIVIDUAZIONE DEL MASSIMO VALORE TRA GLI ID DEI FACT PRESENTI NELLA KB------------

    	  
				  
	find_max :- fact(Id, X , Y ),  
				assert(fact_presence(1)),
				max_id(Max),					
				Id > Max,
				retract(max_id(Max)),
				assert(max_id(Id)),
				assert(considered_fact(Id ,X, Y)),					
				retract(fact(Id,  X, Y)),						
				find_max.
	
	find_max :- fact(Id, X , Y ),  
				assert(considered_fact(Id ,X, Y)),					
				retract(fact(Id,  X, Y)),						
				find_max.
	
	find_max :-	not(fact(_, _ , _)), reassert_fact.

	
	reassert_fact :- 	fact_presence(1),	
						considered_fact(Id, X, Y),					
						retract(considered_fact(Id, X ,Y)),
						reassert_fact.
	
	reassert_fact :- 	fact_presence(1),
						not(considered_fact( _ , _ , _)).

%------------ FINE PROCEDURA PER L'INDIVIDUAZIONE DEL MASSIMO VALORE TRA GLI ID DEI FACT PRESENTI NELLA KB------------

%-------------------------------------- CICLO MAIN -------------------------------------------------------

fuzzyness_module :-
	curr_flog(FileLog),
	curr_rudekb(Rudekb),
	open(FileLog,append,Str1),
	nl(Str1),write(Str1,'%*********** TRACKING FUZZYNESS ON '),write(Str1,Rudekb),write(Str1,' ***********'),
	close(Str1),
	gui_fuzzymodule(heading_fuzzyness),
	gui_fuzzymodule(beginning),
	%ciclo main - begin
	initializing_rudefact,
	matching_rudefact,
	tracking_fuzzyness,
	checking_rudefact,
	tracking_fuzzyness,
	evaluating_rudefact,	
	tracking_fuzzyness,
	%ciclo main - end
	open(FileLog,append,Str2),
	nl(Str2),nl(Str2),write(Str2,'%*** END - Facts will be asserted on '),write(Str2,Rudekb),write(Str2,' ***'),
	nl(Str2),nl(Str2),
	close(Str2),
	%modifica della conoscenza di base
	open(Rudekb,append,Str3),
	nl(Str3),write(Str3,'%Facts (in GIE formalism) from SEVA Fuzzyness Module'),
	nl(Str3),write(Str3,'%fact (id,fact,certainty).'),
	asserting_facts(Str3),
	gui_fuzzymodule(closing).
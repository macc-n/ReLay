/*************************************************************************
        Nome: seva_utility.pl
         
      	Realizzazione: Febbraio, 2014
  		Descrizione: Utilities del sistema
       		Autore: Francesco Solare



  Revisione: Novembre, 2016
	   Autore: Pasquadibisceglie V. - Zaza G.
	   1)Eliminazione variabile Istance dai predicati :
	     -chkdrfact
	
	Revisione : Novembre, 2016
	Autore: Iovine A. - Lovascio C.
	Obiettivo:
		-Gestione dei moduli
			-Modifiche in multiconsult
			-Modifiche in save_dedfact
	   
*************************************************************************/
:- dynamic (curr_flog/1).
:- dynamic (final_adjustment/3).
:- dynamic (curr_rules/1).


/***************************************************************************************************************************************
        Descrizione: 
		Renaming del file .log
	Output: 
		un predicato dinamico curr_flog/1
	Esempio:
	input
		KbName = "seva_kb"
	output
		NFL = "seva_kb.log".
****************************************************************************************************************************************/
create_filelog(KbName) :-
	name(KbName,KBList),
	name('.log',Suffix),
	append(KBList,Suffix,NFLList),
	name(FileLog,NFLList),
	retractall(curr_flog(_)),
	assert(curr_flog(FileLog)).

/***************************************************************************************************************************************
        Descrizione: 
		Renaming del nome di predicato del fatto grezzo
	Output: 
		una stringa FLV
	Esempio:
	input
		LV = "box"
		L = "occupied"
	output
		FLV = "box_occupied".
****************************************************************************************************************************************/		
renaming_rfact(LV,L,FLV) :-
	name(LV,LVList),
	name(L,LList),
	% codice ascii dell'underscore
	append(LVList,[95],LVModify),
	append(LVModify,LList,FLVList),
	name(FLV,FLVList).

/***************************************************************************************************************************************
        Descrizione: 
		Calcolo del valore di membership del dato grezzo rilevato
	Output: 
		un valore numerico FValue
	Esempio:
	input
		SValue = 2640
		Membership = [800,1600,3200]
	output
		FValue = 0.35
****************************************************************************************************************************************/	
computing_fuzzy_value(SValue,[Min,[Pick1,_],_],FValue) :-
	SValue =< Pick1,
	!,
	FValue is (SValue - Min) / (Pick1 - Min).
computing_fuzzy_value(SValue,[_,[_,Pick2],Max],FValue) :-
	SValue >= Pick2,
	!,
	FValue is (Max - SValue) / (Max - Pick2).
computing_fuzzy_value(_,[_,[_,_],_],1.0) :-
	!.

computing_fuzzy_value(SValue,[Min,Pick,_],FValue) :-
	SValue =< Pick,
	!,
	FValue is (SValue - Min) / (Pick - Min).
computing_fuzzy_value(SValue,[_,Pick,Max],FValue) :-
	SValue >= Pick,
	!,
	FValue is (Max - SValue) / (Max - Pick).

computing_fuzzy_value(SValue,[[_,Pick2],Max],FValue) :-
	SValue >= Pick2,
	!,
	FValue is (Max - SValue) / (Max - Pick2).
computing_fuzzy_value(_,[[_,_],_],1.0) :-
	!.

computing_fuzzy_value(SValue,[Min,[Pick1,_]],FValue) :-
	SValue =< Pick1,
	!,
	FValue is (SValue - Min) / (Pick1 - Min).
computing_fuzzy_value(_,[_,[_,_]],1.0) :-
	!.

/***************************************************************************************************************************************
        Descrizione: 
		Ridefinizione della KB fuzzificata da sottoporre ad inferenza
	Output: 
		una modifica della kb corrente
	Esempio:
	input
		rfact(2,survey1,natural_brightness,2640).
	output (su curr_kb)
		fact(1,natural_brightness_middle(survey1),0.35).
		fact(3,natural_brightness_high(survey1),0.65).
****************************************************************************************************************************************/			   
	
	
	ifsystem(Istance,Y,Stream) :-
	write(Y),
    (Istance \= Y
    ->
    write(Stream,','),
    write(Stream,Istance),
    write(Stream,')');write(Stream,')')).
    
saving_facts(Stream,IDFact,CLVar,SId,Istance,FValue):-
	nl(Stream),write(Stream,'fact('),
	write(Stream,IDFact),
	write(Stream,','),
	write(Stream,CLVar),
	write(Stream,'('),
	write(Stream,SId),
	ifsystem(Istance,nulla,Stream),	
	write(Stream,','),
	write(Stream,FValue),
	write(Stream,').').


/*************************************************************************
 Modifica apportata da Domenico V.  assert(fact_ded(Idf,F,Cf))
 Asserisce i fatti dedotti per poi essere visualizzati dall'interfaccia java
 
  
       	Descrizione:
		Utility per il salvataggio dei nuovi fatti dedotti dal
		GIE nel file della KB corrente
	Output: 
		una modifica della kb corrente
*************************************************************************/
writededfact(Stream,If):-
	used_fact(Idf,F,Cf),
	not(member(Idf,If)),
	nl(Stream),
	write(Stream,'fact('),
	write(Stream,Idf),
	write(Stream,', '),
	write(Stream,F),
	write(Stream,', '),
	write(Stream,Cf),
	write(Stream,').'),
	assert(fact_ded(Idf,F,Cf)),
	fail.


writededfact(_,_).

save_dedfact :-
	curr_kb(Kb),
	%stampa_dedotti,
	
	/*
		Modifica Iovine-Lovascio: Questa procedura è stata ripristinata alla versione precedente perchè
		il server Java richiede che i fatti dedotti si trovino nello stesso file che contiene
		i file iniziali.
	*/
	% ---------------- modifica apportata da Anzivino Giuseppe, Novembre 2016
	% Questa modifica permette di salvare i nuovi fatti dedotti su un nuovo file, diverso da quello di partenza
	
	%atomic_list_concat(L,'.',Kb),
	%reversee(L,X),
	%lastt(X,Y),
	%atomic_concat(Y,'_inference.pl',K),
	%open(K,write,Stream),
	% --------------- 
	
	open(Kb,append,Stream),
	initfacts(If),
	nl(Stream),write(Stream,'%New deduct facts from inference'),
	writededfact(Stream,If),
	nl(Stream),
	close(Stream).

/********************************************************************************
        Descrizione: Tracking dei passi dei moduli di fuzzyness/defuzzyness
	Output: file processing.log
********************************************************************************/
tracking_fuzzyness :-
	matchedrfact(_,LangVariable,_,LangValue,LangLabel),
	curr_flog(FileLog),
	open(FileLog,append,Stream),
	nl(Stream),nl(Stream),write(Stream,'_____________ extracted facts (seva formalism) ___________'),
	nl(Stream),write(Stream,'Name: '),write(Stream,LangVariable),
	nl(Stream),write(Stream,'     with Linguistic Labels: '),write(Stream,LangLabel),
	nl(Stream),write(Stream,'     and Linguistic Values: '),write(Stream,LangValue),
	nl(Stream),write(Stream,'     in Istance: '),write(Stream,Istance),
	close(Stream),
	fail.
tracking_fuzzyness :-
	chkdrfact(_,LabeledVariable,SurveyValue,LangValue),
	curr_flog(FileLog),
	open(FileLog,append,Stream),
	nl(Stream),nl(Stream),write(Stream,'____________ checked facts - pre fuzzyness stage _________'),
	nl(Stream),write(Stream,'Name: '),write(Stream,LabeledVariable),
	nl(Stream),write(Stream,'     with Observed Value: '),write(Stream,SurveyValue),
	nl(Stream),write(Stream,'     and Fuzzy Membership: '),write(Stream,LangValue),
	nl(Stream),write(Stream,'     in Istance: '),write(Stream,Istance),
	close(Stream),
	fail.
tracking_fuzzyness :-
	evalrfact(_,LabeledVariable,FuzzyValue),
	curr_flog(FileLog),
	open(FileLog,append,Stream),
	nl(Stream),nl(Stream),write(Stream,'_____________ extracted fuzzyfied facts - fuzzyness stage __________'),
	nl(Stream),write(Stream,'Fact: '),write(Stream,LabeledVariable),write(Stream,', with Certainty: '),write(Stream,FuzzyValue),
	nl(Stream),write(Stream,'     in Istance: '),write(Stream,Istance),
	close(Stream),
	fail.
tracking_fuzzyness.

tracking_defuzzyness :-
	initialdedfact(FunctDFact,RegulationLevel,CertDFact,Istance),
	initialufunctout(FunctDFact,RegulationLevel,LangValue),
	curr_flog(FileLog),
	open(FileLog,append,Stream),
	nl(Stream),nl(Stream),write(Stream,'_____________ deducted fact (gie formalism) _____________'),
	nl(Stream),write(Stream,'Fact: '),write(Stream,FunctDFact),write(Stream,' at regulation '),write(Stream,RegulationLevel),
	nl(Stream),write(Stream,'     with Certainty: '),write(Stream,CertDFact),
	write(Stream,', and Fuzzy Membership: '),write(Stream,LangValue),
	write(Stream,', in Istance: '),write(Stream,Istance),
	close(Stream),
	fail.
tracking_defuzzyness :-
	final_adjustment(Istance,DedFact,Regulation),
	curr_flog(FileLog),
	open(FileLog,append,Stream),
	nl(Stream),nl(Stream),write(Stream,'%@@@@@@@@@@@@@ SEVA output (setting adjustments) @@@@@@@@@'),
	nl(Stream),write(Stream,'Effected Adjustment: '),write(Stream,DedFact),
	write(Stream,' with Regulation level: '),write(Stream,Regulation),write(Stream,'%'),
	write(Stream,', in Istance: '),write(Stream,Istance),
	close(Stream),
	retract(final_adjustment(Istance,DedFact,Regulation)),
	fail.
tracking_defuzzyness.

/***************************************************************************************************************************************
    Descrizione:    Calcolo delle prestazioni
	Output:    Tempo impiegato per compiere un'operazione
	Autore: Luigi Tedone
****************************************************************************************************************************************/	
		
start_count :- 
    statistics(walltime,[Xtime|_]),
	%get_time(Xtime),
	assert(start_time(Xtime)).
			
timediff :-
		%get_time(Ytime),
		statistics(walltime,[Ytime|SecE]),
		start_time(Xtime),
        Sec is Ytime - Xtime,
		%Round_sec is round(Sec),
		Round_sec is round(Sec/1000),
		nl,nl,write('The computation took '),write(Round_sec),write(' seconds'),nl,
		assert(sec_elapsed(Round_sec)),
		retract(start_time(Xtime)).
/***************************************************************************************************************************************
    Descrizione:    Valuta l'ultimo timestamp per asserire stagione,giorno, ecc.
	Output:    Informazioni circa il tempo
	Autore: Domenico Visaggio
****************************************************************************************************************************************/	

writeFact(Stream,Id,F,C):-
	nl(Stream),
	write(Stream,'fact('),
	write(Stream,Id),
	write(Stream,', '),
	write(Stream,F),
	write(Stream,', '),
	write(Stream,C),
	write(Stream,').').
	
valute_timestamp(Stream):-
	fact(_,ultimots(Timestamp),_),
	fact(_,timestamp(Timestamp),_),
	assertMonth(Stream,Timestamp),
	assertPeriodDay(Stream,Timestamp).
			
assertMonth(Stream,TIMESTAMP):-
    fact(_,mese(TIMESTAMP,01),_),
	findall(ID,fact(ID,_,_),Z),
	get_max(Z,M),
	Id is M+1,
	assert(fact(Id,month_january(TIMESTAMP),1)),
	writeFact(Stream,Id,month_january(TIMESTAMP),1),
	Id2 is Id+1,
	assert(fact(Id2,season_winter(TIMESTAMP),1)),
	writeFact(Stream,Id2,season_winter(TIMESTAMP),1).
	
assertMonth(Stream,TIMESTAMP):-
    fact(_,mese(TIMESTAMP,02),_),
	findall(ID,fact(ID,_,_),Z),
	get_max(Z,M),
	Id is M+1,
	assert(fact(Id,month_february(TIMESTAMP),1)),
	writeFact(Stream,Id,month_february(TIMESTAMP),1),
	Id2 is Id+1,
	assert(fact(Id2,season_winter(TIMESTAMP),1)),
	writeFact(Stream,Id2,season_winter(TIMESTAMP),1).
	
assertMonth(Stream,TIMESTAMP):-
    fact(_,mese(TIMESTAMP,03),_),
	findall(ID,fact(ID,_,_),Z),
	get_max(Z,M),
	Id is M+1,
	idflist_upd(Id),
	assert(fact(Id,month_march(TIMESTAMP),1)),
	writeFact(Stream,Id,month_march(TIMESTAMP),1),
	Id2 is Id+1,
	assert(fact(Id2,season_spring(TIMESTAMP),1)),
	writeFact(Stream,Id2,season_spring(TIMESTAMP),1).
	
assertMonth(Stream,TIMESTAMP):-
    fact(_,mese(TIMESTAMP,04),_),
	findall(ID,fact(ID,_,_),Z),
	get_max(Z,M),
	Id is M+1,
	assert(fact(Id,month_april(TIMESTAMP),1)),
	writeFact(Stream,Id,month_april(TIMESTAMP),1),
	Id2 is Id+1,
	assert(fact(Id2,season_spring(TIMESTAMP),1)),
	writeFact(Stream,Id2,season_spring(TIMESTAMP),1).
	
assertMonth(Stream,TIMESTAMP):-
    fact(_,mese(TIMESTAMP,05),_),
	findall(ID,fact(ID,_,_),Z),
	get_max(Z,M),
	Id is M+1,
	assert(fact(Id,month_may(TIMESTAMP),1)),
	writeFact(Stream,Id,month_may(TIMESTAMP),1),
	Id2 is Id+1,
	assert(fact(Id2,season_spring(TIMESTAMP),1)),
	writeFact(Stream,Id2,season_spring(TIMESTAMP),1).

assertMonth(Stream,TIMESTAMP):-
    fact(_,mese(TIMESTAMP,06),_),
	findall(ID,fact(ID,_,_),Z),
	get_max(Z,M),
	Id is M+1,
	assert(fact(Id,month_june(TIMESTAMP),1)),
	writeFact(Stream,Id,month_june(TIMESTAMP),1),
	Id2 is Id+1,
	assert(fact(Id2,season_summer(TIMESTAMP),1)),
	writeFact(Stream,Id2,season_summer(TIMESTAMP),1).

assertMonth(Stream,TIMESTAMP):-
    fact(_,mese(TIMESTAMP,07),_),
	findall(ID,fact(ID,_,_),Z),
	get_max(Z,M),
	Id is M+1,
	assert(fact(Id,month_july(TIMESTAMP),1)),
	writeFact(Stream,Id,month_july(TIMESTAMP),1),
	Id2 is Id+1,
	assert(fact(Id2,season_summer(TIMESTAMP),1)),
	writeFact(Stream,Id2,season_summer(TIMESTAMP),1).

assertMonth(Stream,TIMESTAMP):-
    fact(_,mese(TIMESTAMP,08),_),
	findall(ID,fact(ID,_,_),Z),
	get_max(Z,M),
	Id is M+1,
	assert(fact(Id,month_august(TIMESTAMP),1)),
	writeFact(Stream,Id,month_august(TIMESTAMP),1),
	Id2 is Id+1,
	assert(fact(Id2,season_summer(TIMESTAMP),1)),
	writeFact(Stream,Id2,season_summer(TIMESTAMP),1).

assertMonth(Stream,TIMESTAMP):-
    fact(_,mese(TIMESTAMP,09),_),
	findall(ID,fact(ID,_,_),Z),
	get_max(Z,M),
	Id is M+1,
	assert(fact(Id,month_september(TIMESTAMP),1)),
	writeFact(Stream,Id,month_september(TIMESTAMP),1),
	Id2 is Id+1,
	assert(fact(Id2,season_autumn(TIMESTAMP),1)),
	writeFact(Stream,Id2,season_autumn(TIMESTAMP),1).

assertMonth(Stream,TIMESTAMP):-
    fact(_,mese(TIMESTAMP,10),_),
	findall(ID,fact(ID,_,_),Z),
	get_max(Z,M),
	Id is M+1,
	assert(fact(Id,month_october(TIMESTAMP),1)),
	writeFact(Stream,Id,month_october(TIMESTAMP),1),
	Id2 is Id+1,
	assert(fact(Id2,season_autumn(TIMESTAMP),1)),
	writeFact(Stream,Id2,season_autumn(TIMESTAMP),1).

assertMonth(Stream,TIMESTAMP):-
    fact(_,mese(TIMESTAMP,11),_),
	findall(ID,fact(ID,_,_),Z),
	get_max(Z,M),
	Id is M+1,
	assert(fact(Id,month_november(TIMESTAMP),1)),
	writeFact(Stream,Id,month_november(TIMESTAMP),1),
	Id2 is Id+1,
	assert(fact(Id2,season_autumn(TIMESTAMP),1)),
	writeFact(Stream,Id2,season_autumn(TIMESTAMP),1).	

assertMonth(Stream,TIMESTAMP):-
    fact(_,mese(TIMESTAMP,12),_),
	findall(ID,fact(ID,_,_),Z),
	get_max(Z,M),
	Id is M+1,
	assert(fact(Id,month_december(TIMESTAMP),1)),
	writeFact(Stream,Id,month_december(TIMESTAMP),1),
	Id2 is Id+1,
	assert(fact(Id2,season_winter(TIMESTAMP),1)),
	writeFact(Stream,Id2,season_winter(TIMESTAMP),1).



assertPeriodDay(Stream,TIMESTAMP):-
	fact(_,ora(TIMESTAMP,05),_),
	findall(ID,fact(ID,_,_),Z),
	get_max(Z,M),
	Id is M+1,
	assert(fact(Id,is_sunrise(TIMESTAMP),1)),
	writeFact(Stream,Id,is_sunrise(TIMESTAMP),1).

assertPeriodDay(Stream,TIMESTAMP):-
	fact(_,ora(TIMESTAMP,06),_),
	findall(ID,fact(ID,_,_),Z),
	get_max(Z,M),
	Id is M+1,
	assert(fact(Id,is_sunrise(TIMESTAMP),1)),
	writeFact(Stream,Id,is_sunrise(TIMESTAMP),1).

assertPeriodDay(Stream,TIMESTAMP):-
	fact(_,ora(TIMESTAMP,07),_),
	findall(ID,fact(ID,_,_),Z),
	get_max(Z,M),
	Id is M+1,
	assert(fact(Id,is_sunrise(TIMESTAMP),1)),
	writeFact(Stream,Id,is_sunrise(TIMESTAMP),1).	
	
assertPeriodDay(Stream,TIMESTAMP):-
	fact(_,ora(TIMESTAMP,08),_),
	findall(ID,fact(ID,_,_),Z),
	get_max(Z,M),
	Id is M+1,
	assert(fact(Id,is_sunrise(TIMESTAMP),1)),
	writeFact(Stream,Id,is_sunrise(TIMESTAMP),1).	
	
assertPeriodDay(Stream,TIMESTAMP):-
	fact(_,ora(TIMESTAMP,06),_),
	findall(ID,fact(ID,_,_),Z),
	get_max(Z,M),
	Id is M+1,
	assert(fact(Id,is_morning(TIMESTAMP),1)),
	writeFact(Stream,Id,is_morning(TIMESTAMP),1).	

assertPeriodDay(Stream,TIMESTAMP):-
	fact(_,ora(TIMESTAMP,07),_),
	findall(ID,fact(ID,_,_),Z),
	get_max(Z,M),
	Id is M+1,
	assert(fact(Id,is_morning(TIMESTAMP),1)),
	writeFact(Stream,Id,is_morning(TIMESTAMP),1).	
	
assertPeriodDay(Stream,TIMESTAMP):-
	fact(_,ora(TIMESTAMP,08),_),
	findall(ID,fact(ID,_,_),Z),
	get_max(Z,M),
	Id is M+1,
	assert(fact(Id,is_morning(TIMESTAMP),1)),
	writeFact(Stream,Id,is_morning(TIMESTAMP),1).	
	
assertPeriodDay(Stream,TIMESTAMP):-
	fact(_,ora(TIMESTAMP,09),_),
	findall(ID,fact(ID,_,_),Z),
	get_max(Z,M),
	Id is M+1,
	assert(fact(Id,is_morning(TIMESTAMP),1)),
	writeFact(Stream,Id,is_morning(TIMESTAMP),1).

assertPeriodDay(Stream,TIMESTAMP):-
	fact(_,ora(TIMESTAMP,10),_),
	findall(ID,fact(ID,_,_),Z),
	get_max(Z,M),
	Id is M+1,
	assert(fact(Id,is_morning(TIMESTAMP),1)),
	writeFact(Stream,Id,is_morning(TIMESTAMP),1).	
	
assertPeriodDay(Stream,TIMESTAMP):-
	fact(_,ora(TIMESTAMP,11),_),
	findall(ID,fact(ID,_,_),Z),
	get_max(Z,M),
	Id is M+1,
	assert(fact(Id,is_morning(TIMESTAMP),1)),
	writeFact(Stream,Id,is_morning(TIMESTAMP),1).	
	
assertPeriodDay(Stream,TIMESTAMP):-
	fact(_,ora(TIMESTAMP,12),_),
	findall(ID,fact(ID,_,_),Z),
	get_max(Z,M),
	Id is M+1,
	assert(fact(Id,is_morning(TIMESTAMP),1)),
	writeFact(Stream,Id,is_morning(TIMESTAMP),1).			

assertPeriodDay(Stream,TIMESTAMP):-
	fact(_,ora(TIMESTAMP,13),_),
	findall(ID,fact(ID,_,_),Z),
	get_max(Z,M),
	Id is M+1,
	assert(fact(Id,is_midday(TIMESTAMP),1)),
	writeFact(Stream,Id,is_midday(TIMESTAMP),1).
	
assertPeriodDay(Stream,TIMESTAMP):-
	fact(_,ora(TIMESTAMP,14),_),
	findall(ID,fact(ID,_,_),Z),
	get_max(Z,M),
	Id is M+1,
	assert(fact(Id,is_midday(TIMESTAMP),1)),
	writeFact(Stream,Id,is_midday(TIMESTAMP),1).	
	
assertPeriodDay(Stream,TIMESTAMP):-
	fact(_,ora(TIMESTAMP,15),_),
	findall(ID,fact(ID,_,_),Z),
	get_max(Z,M),
	Id is M+1,
	assert(fact(Id,is_midday(TIMESTAMP),1)),
	writeFact(Stream,Id,is_midday(TIMESTAMP),1).	

assertPeriodDay(Stream,TIMESTAMP):-
	fact(_,ora(TIMESTAMP,16),_),
	findall(ID,fact(ID,_,_),Z),
	get_max(Z,M),
	Id is M+1,
	assert(fact(Id,is_afternoon(TIMESTAMP),1)),
	writeFact(Stream,Id,is_afternoon(TIMESTAMP),1).
	
assertPeriodDay(Stream,TIMESTAMP):-
	fact(_,ora(TIMESTAMP,17),_),
	findall(ID,fact(ID,_,_),Z),
	get_max(Z,M),
	Id is M+1,
	assert(fact(Id,is_afternoon(TIMESTAMP),1)),
	writeFact(Stream,Id,is_afternoon(TIMESTAMP),1).

assertPeriodDay(Stream,TIMESTAMP):-
	fact(_,ora(TIMESTAMP,18),_),
	findall(ID,fact(ID,_,_),Z),
	get_max(Z,M),
	Id is M+1,
	assert(fact(Id,is_afternoon(TIMESTAMP),1)),
	writeFact(Stream,Id,is_afternoon(TIMESTAMP),1).

assertPeriodDay(Stream,TIMESTAMP):-
	fact(_,ora(TIMESTAMP,19),_),
	findall(ID,fact(ID,_,_),Z),
	get_max(Z,M),
	Id is M+1,
	assert(fact(Id,is_evening(TIMESTAMP),1)),
	writeFact(Stream,Id,is_evening(TIMESTAMP),1).
	
assertPeriodDay(Stream,TIMESTAMP):-
	fact(_,ora(TIMESTAMP,20),_),
	findall(ID,fact(ID,_,_),Z),
	get_max(Z,M),
	Id is M+1,
	assert(fact(Id,is_evening(TIMESTAMP),1)),
	writeFact(Stream,Id,is_evening(TIMESTAMP),1).
	
assertPeriodDay(Stream,TIMESTAMP):-
	fact(_,ora(TIMESTAMP,21),_),
	findall(ID,fact(ID,_,_),Z),
	get_max(Z,M),
	Id is M+1,
	assert(fact(Id,is_evening(TIMESTAMP),1)),
	writeFact(Stream,Id,is_evening(TIMESTAMP),1).
	
assertPeriodDay(Stream,TIMESTAMP):-
	fact(_,ora(TIMESTAMP,22),_),
	findall(ID,fact(ID,_,_),Z),
	get_max(Z,M),
	Id is M+1,
	assert(fact(Id,is_evening(TIMESTAMP),1)),
	writeFact(Stream,Id,is_evening(TIMESTAMP),1).
	
	

assertPeriodDay(Stream,TIMESTAMP):-
	fact(_,ora(TIMESTAMP,23),_),
	findall(ID,fact(ID,_,_),Z),
	get_max(Z,M),
	Id is M+1,
	assert(fact(Id,is_night(TIMESTAMP),1)),
	writeFact(Stream,Id,is_night(TIMESTAMP),1),
	Id2 is Id+1,
	assert(fact(Id2,is_night_am(TIMESTAMP),1)),
	writeFact(Stream,Id2,is_night_am(TIMESTAMP),1).

assertPeriodDay(Stream,TIMESTAMP):-
	fact(_,ora(TIMESTAMP,00),_),
	findall(ID,fact(ID,_,_),Z),
	get_max(Z,M),
	Id is M+1,
	assert(fact(Id,is_night(TIMESTAMP),1)),
	writeFact(Stream,Id,is_night(TIMESTAMP),1),
	Id2 is Id+1,
	assert(fact(Id2,is_night_am(TIMESTAMP),1)),
	writeFact(Stream,Id2,is_night_am(TIMESTAMP),1).

assertPeriodDay(Stream,TIMESTAMP):-
	fact(_,ora(TIMESTAMP,01),_),
	findall(ID,fact(ID,_,_),Z),
	get_max(Z,M),
	Id is M+1,
	assert(fact(Id,is_night(TIMESTAMP),1)),
	writeFact(Stream,Id,is_night(TIMESTAMP),1),
	Id2 is Id+1,
	assert(fact(Id2,is_night_pm(TIMESTAMP),1)),
	writeFact(Stream,Id2,is_night_pm(TIMESTAMP),1).
	
assertPeriodDay(Stream,TIMESTAMP):-
	fact(_,ora(TIMESTAMP,02),_),
	findall(ID,fact(ID,_,_),Z),
	get_max(Z,M),
	Id is M+1,
	assert(fact(Id,is_night(TIMESTAMP),1)),
	writeFact(Stream,Id,is_night(TIMESTAMP),1),
	Id2 is Id+1,
	assert(fact(Id2,is_night_pm(TIMESTAMP),1)),
	writeFact(Stream,Id2,is_night_pm(TIMESTAMP),1).

assertPeriodDay(Stream,TIMESTAMP):-
	fact(_,ora(TIMESTAMP,03),_),
	findall(ID,fact(ID,_,_),Z),
	get_max(Z,M),
	Id is M+1,
	assert(fact(Id,is_night(TIMESTAMP),1)),
	writeFact(Stream,Id,is_night(TIMESTAMP),1),
	Id2 is Id+1,
	assert(fact(Id2,is_night_pm(TIMESTAMP),1)),
	writeFact(Stream,Id2,is_night_pm(TIMESTAMP),1).	

assertPeriodDay(Stream,TIMESTAMP):-
	fact(_,ora(TIMESTAMP,04),_),
	findall(ID,fact(ID,_,_),Z),
	get_max(Z,M),
	Id is M+1,
	assert(fact(Id,is_night(TIMESTAMP),1)),
	writeFact(Stream,Id,is_night(TIMESTAMP),1),
	Id2 is Id+1,
	assert(fact(Id2,is_night_pm(TIMESTAMP),1)),
	writeFact(Stream,Id2,is_night_pm(TIMESTAMP),1).	
/***************************************************************************************************************************************
    Descrizione:    Estra timestamp, luoghi, persone per i fatti non dedotti da interfaccia
	Output:    Liste di timestamp, luoghi, persone
	Autore: Domenico Visaggio
	
	Revisione: Novembre, 2016
	Autore: Iovine A. - Lovascio C.
	Obiettivo: Modifica di multiconsult per la gestione dei moduli
****************************************************************************************************************************************/	
	
getTPL(LiT,LiP,LiL):-
	findall(X,used_fact(_,timestamp(X),_),LiT),
	findall(Y,used_fact(_,persona(Y),_),LiP),
	findall(Z,used_fact(_,posizione(_,Z,_),_),LiL).

multiconsult(H):-
	%reconsult(H).
	get_element_from_list(H, Elem),
	retractall(curr_rules(_)),
	assert(curr_rules(Elem)),
	load_first(Elem). 	

multiconsult([H|L]):-
	%reconsult(H),
	load_first(H),
	retractall(curr_rules(_)),
	assert(curr_rules(H)),
	multiconsult(L).

multiconsult([]).


get_element_from_list([H], Elem) :- 
	Elem = H.





/***************************************************************************************************************************************

Revisione: Novembre 2016
	   Autore: Anzivino Giuseppe
	   Obiettivo:
			-Aggiunto predicato reversee: permette di invertire gli elementi in una lista
			-Aggiunto predicato lastt: permette di recuperare l'ultimo elemento di una lista
		    -Aggiunti predicati timee, write_file, my_write, time_calculation, readaa: sono tutti utili per calcolare la durata di un primo pronto soccorso (funzionalità utile alla mia base di conoscenza)
			-Aggiunto predicato sum: permette di sommare tutti gli elementi di una lista
			-Aggiunto predicato deletee: permette di cancellare un elemento da una lista
			-Aggiunti predicati control_one e control_two: sono utili per constatare la morte di un infortunato (funzionalità utile alla mia base di conoscenza)
****************************************************************************************************************************************/	


reversee([],[]).
reversee([H|T],Lr):- reversee(T,T2),
 append(T2,[H],Lr).


 
lastt([X],X).
lastt([_|T],X):-lastt(T,X).



timee(F):- 
    append([F],[],X),
	lastt(X,Y),
	format(atom(A), "~w", [Y]),
	atomic_list_concat(L,',',A),
	lastt(L,U),
	deletee(U,L,P),
	lastt(P,M),
	assert(op(M)),
	format(atom(LL), "~w", [U]),
	atomic_list_concat(LLL,')',LL),
	lastt(LLL,UU),
	format(atom(XX), "~w", [UU]),
	atom_number(XX, RIS),
	assert(tempo(RIS)),
	write_file.

	
write_file:-
open('tempo.pl', write, Stream),
forall(tempo(X), my_write(Stream,X)),
close(Stream).

my_write(Stream,X):-
write(Stream,X),
write(Stream,'.'),
nl(Stream).


time_calculation(K,II):-
open('tempo.pl',read,S),
readaa(S,LL),
close(S),
deletee(end_of_file,LL,Lista),
nl,nl,
write('La durata totale del primo pronto soccorso all''infortunato risulta essere di '),
sum(Lista,X),
nl,write(X),
write(' secondi, ossia '),
Ris is X/60,
write(Ris),
write(' minuti'),

open(K,append,Stream),
nl(Stream),
nl(Stream),
nl(Stream),
write(Stream,'La durata totale del primo pronto soccorso all''infortunato risulta essere di '),
nl(Stream),
write(Stream,X),
write(Stream,' secondi, ossia '),
write(Stream,Ris),
append([X],[],UU),
lastt(UU,II),
write(Stream,' minuti'),
close(Stream),
nl.



readaa(S,[]):-
at_end_of_stream(S), !.

readaa(S,[X|L]):-
read(S,X),
readaa(S, L).



sum([],0).
sum([Testa|Coda],S):-
sum(Coda,Scoda),
S is Scoda + Testa.


deletee(T,[],[]).
deletee(T,[T|TAIL],TAIL):-!.
deletee(T,[HEAD|TAIL],[HEAD|L]):-deletee(T,TAIL,L).





control_one:- op(respirazione_artificiale),
op(manovra_heimlich),!,
assert(tempo_totale(1800)).     %1800 sono secondi

control_one:- op(respirazione_artificiale),
op(pls_insufflazioni),!,
assert(tempo_totale(2040)). 



control_one:- op(rianimazione_cardiopolmonare),
op(manovra_heimlich),!,
assert(tempo_totale(2100)).    

control_one:- op(rianimazione_cardiopolmonare),
op(pls_insufflazioni),!,
assert(tempo_totale(2340)). 



control_one:- op(fermare_emorragie_esterne_compressione_diretta),
op(tranquillizza_infortunato),!,
assert(tempo_totale(1350)). 

control_one:- op(fermare_emorragie_esterne_compressione_diretta),
op(posizionamento_pls),!,
assert(tempo_totale(1350)).

control_one:- op(fermare_emorragie_esterne_compressione_diretta),
op(manovra_heimlich),!,
assert(tempo_totale(1530)).    

control_one:- op(fermare_emorragie_esterne_compressione_diretta),
op(pls_insufflazioni),!,
assert(tempo_totale(1770)). 

control_one:- op(fermare_emorragie_esterne_compressione_diretta),
op(libera_vieaeree),!,
assert(tempo_totale(1470)). 



control_one:- op(compressione_indiretta_arteria_temporale),
op(tranquillizza_infortunato),!,
assert(tempo_totale(1410)). 

control_one:- op(compressione_indiretta_arteria_temporale),
op(posizionamento_pls),!,
assert(tempo_totale(1410)).

control_one:- op(compressione_indiretta_arteria_temporale),
op(manovra_heimlich),!,
assert(tempo_totale(1590)).    

control_one:- op(compressione_indiretta_arteria_temporale),
op(pls_insufflazioni),!,
assert(tempo_totale(1830)). 

control_one:- op(compressione_indiretta_arteria_temporale),
op(libera_vieaeree),!,
assert(tempo_totale(1530)). 



control_one:- op(compressione_indiretta_arteria_facciale),
op(tranquillizza_infortunato),!,
assert(tempo_totale(1410)). 

control_one:- op(compressione_indiretta_arteria_facciale),
op(posizionamento_pls),!,
assert(tempo_totale(1410)).

control_one:- op(compressione_indiretta_arteria_facciale),
op(manovra_heimlich),!,
assert(tempo_totale(1590)).    

control_one:- op(compressione_indiretta_arteria_facciale),
op(pls_insufflazioni),!,
assert(tempo_totale(1830)). 

control_one:- op(compressione_indiretta_arteria_facciale),
op(libera_vieaeree),!,
assert(tempo_totale(1530)). 



control_one:- op(compressione_indiretta_arteria_succlavia),
op(tranquillizza_infortunato),!,
assert(tempo_totale(1410)). 

control_one:- op(compressione_indiretta_arteria_succlavia),
op(posizionamento_pls),!,
assert(tempo_totale(1410)).

control_one:- op(compressione_indiretta_arteria_succlavia),
op(manovra_heimlich),!,
assert(tempo_totale(1590)).    

control_one:- op(compressione_indiretta_arteria_succlavia),
op(pls_insufflazioni),!,
assert(tempo_totale(1830)). 

control_one:- op(compressione_indiretta_arteria_succlavia),
op(libera_vieaeree),!,
assert(tempo_totale(1530)). 




control_one:- op(compressione_indiretta_arteria_ascellare),
op(tranquillizza_infortunato),!,
assert(tempo_totale(1410)). 

control_one:- op(compressione_indiretta_arteria_ascellare),
op(posizionamento_pls),!,
assert(tempo_totale(1410)).

control_one:- op(compressione_indiretta_arteria_ascellare),
op(manovra_heimlich),!,
assert(tempo_totale(1590)).    

control_one:- op(compressione_indiretta_arteria_ascellare),
op(pls_insufflazioni),!,
assert(tempo_totale(1830)). 

control_one:- op(compressione_indiretta_arteria_ascellare),
op(libera_vieaeree),!,
assert(tempo_totale(1530)). 





control_one:- op(compressione_indiretta_arteria_omerale),
op(tranquillizza_infortunato),!,
assert(tempo_totale(1410)). 

control_one:- op(compressione_indiretta_arteria_omerale),
op(posizionamento_pls),!,
assert(tempo_totale(1410)).

control_one:- op(compressione_indiretta_arteria_omerale),
op(manovra_heimlich),!,
assert(tempo_totale(1590)).    

control_one:- op(compressione_indiretta_arteria_omerale),
op(pls_insufflazioni),!,
assert(tempo_totale(1830)). 

control_one:- op(compressione_indiretta_arteria_omerale),
op(libera_vieaeree),!,
assert(tempo_totale(1530)). 






control_one:- op(compressione_indiretta_arteria_omerale_avambraccio),
op(tranquillizza_infortunato),!,
assert(tempo_totale(1410)). 

control_one:- op(compressione_indiretta_arteria_omerale_avambraccio),
op(posizionamento_pls),!,
assert(tempo_totale(1410)).

control_one:- op(compressione_indiretta_arteria_omerale_avambraccio),
op(manovra_heimlich),!,
assert(tempo_totale(1590)).    

control_one:- op(compressione_indiretta_arteria_omerale_avambraccio),
op(pls_insufflazioni),!,
assert(tempo_totale(1830)). 

control_one:- op(compressione_indiretta_arteria_omerale_avambraccio),
op(libera_vieaeree),!,
assert(tempo_totale(1530)). 






control_one:- op(compressione_indiretta_arteria_poplitea),
op(tranquillizza_infortunato),!,
assert(tempo_totale(1410)). 

control_one:- op(compressione_indiretta_arteria_poplitea),
op(posizionamento_pls),!,
assert(tempo_totale(1410)).

control_one:- op(compressione_indiretta_arteria_poplitea),
op(manovra_heimlich),!,
assert(tempo_totale(1590)).    

control_one:- op(compressione_indiretta_arteria_poplitea),
op(pls_insufflazioni),!,
assert(tempo_totale(1830)). 

control_one:- op(compressione_indiretta_arteria_poplitea),
op(libera_vieaeree),!,
assert(tempo_totale(1530)). 





control_one:- op(controllo_epistassi),
op(tranquillizza_infortunato),!,
assert(tempo_totale(930)). 

control_one:- op(controllo_epistassi),
op(posizionamento_pls),!,
assert(tempo_totale(930)).

control_one:- op(controllo_epistassi),
op(manovra_heimlich),!,
assert(tempo_totale(1110)).    

control_one:- op(controllo_epistassi),
op(pls_insufflazioni),!,
assert(tempo_totale(1350)). 

control_one:- op(controllo_epistassi),
op(libera_vieaeree),!,
assert(tempo_totale(1050)).




control_one:- op(controllo_otorragia),
op(tranquillizza_infortunato),!,
assert(tempo_totale(930)). 

control_one:- op(controllo_otorragia),
op(posizionamento_pls),!,
assert(tempo_totale(930)).

control_one:- op(controllo_otorragia),
op(manovra_heimlich),!,
assert(tempo_totale(1110)).    

control_one:- op(controllo_otorragia),
op(pls_insufflazioni),!,
assert(tempo_totale(1350)). 

control_one:- op(controllo_otorragia),
op(libera_vieaeree),!,
assert(tempo_totale(1050)).





control_one:- op(controllo_emottisi),
op(tranquillizza_infortunato),!,
assert(tempo_totale(930)). 

control_one:- op(controllo_emottisi),
op(posizionamento_pls),!,
assert(tempo_totale(930)).

control_one:- op(controllo_emottisi),
op(manovra_heimlich),!,
assert(tempo_totale(1110)).    

control_one:- op(controllo_emottisi),
op(pls_insufflazioni),!,
assert(tempo_totale(1350)). 

control_one:- op(controllo_emottisi),
op(libera_vieaeree),!,
assert(tempo_totale(1050)).





control_one:- op(controllo_ematemesi),
op(tranquillizza_infortunato),!,
assert(tempo_totale(930)). 

control_one:- op(controllo_ematemesi),
op(posizionamento_pls),!,
assert(tempo_totale(930)).

control_one:- op(controllo_ematemesi),
op(manovra_heimlich),!,
assert(tempo_totale(1110)).    

control_one:- op(controllo_ematemesi),
op(pls_insufflazioni),!,
assert(tempo_totale(1350)). 

control_one:- op(controllo_ematemesi),
op(libera_vieaeree),!,
assert(tempo_totale(1050)).





control_one:- op(controllo_ematuria),
op(tranquillizza_infortunato),!,
assert(tempo_totale(930)). 

control_one:- op(controllo_ematuria),
op(posizionamento_pls),!,
assert(tempo_totale(930)).

control_one:- op(controllo_ematuria),
op(manovra_heimlich),!,
assert(tempo_totale(1110)).    

control_one:- op(controllo_ematuria),
op(pls_insufflazioni),!,
assert(tempo_totale(1350)). 

control_one:- op(controllo_ematuria),
op(libera_vieaeree),!,
assert(tempo_totale(1050)).





control_one:- op(controllo_melena),
op(tranquillizza_infortunato),!,
assert(tempo_totale(930)). 

control_one:- op(controllo_melena),
op(posizionamento_pls),!,
assert(tempo_totale(930)).

control_one:- op(controllo_melena),
op(manovra_heimlich),!,
assert(tempo_totale(1110)).    

control_one:- op(controllo_melena),
op(pls_insufflazioni),!,
assert(tempo_totale(1350)). 

control_one:- op(controllo_melena),
op(libera_vieaeree),!,
assert(tempo_totale(1050)).






control_one:- op(controllo_rettorragia),
op(tranquillizza_infortunato),!,
assert(tempo_totale(930)). 

control_one:- op(controllo_rettorragia),
op(posizionamento_pls),!,
assert(tempo_totale(930)).

control_one:- op(controllo_rettorragia),
op(manovra_heimlich),!,
assert(tempo_totale(1110)).    

control_one:- op(controllo_rettorragia),
op(pls_insufflazioni),!,
assert(tempo_totale(1350)). 

control_one:- op(controllo_rettorragia),
op(libera_vieaeree),!,
assert(tempo_totale(1050)).






control_two(K,II):- tempo_totale(Y),
II=<Y,
!, nl,nl,write('L''infortunato e'' stato messo in salvo'),
open(K,append,Stream),
nl(Stream),
nl(Stream),
write(Stream,'L''infortunato e'' stato messo in salvo'),
nl(Stream),
close(Stream).

control_two(K,II):- nl,nl,write('L''infortunato purtroppo non e'' riuscito a sopravvivere'),
open(K,append,Stream),
nl(Stream),
nl(Stream),
write(Stream,'L''infortunato purtroppo non e'' riuscito a sopravvivere'),
nl(Stream),
close(Stream).


/***********************************************************************

Realizzazione: Novembre, 2016
Obiettivo: Realizzazione di un set di predicati che permettono la gestione del tempo, in particolare:
			- lt_time: Dati in input due time, verifica se il primo è minore del secondo.
			- lte_time: Dati in input due time, verifica se il primo è minore o uguale del secondo.
			- gt_time: Dati in input due time, verifica se il primo è maggiore del secondo.
			- gte_time: Dati in input due time, verifica se il primo è maggiore o uguale del secondo.
			- eq_time: Dati in input due time, verifica se il primo e il secondo sono uguali.
			- sum_time: Dati in input due time, ne fa la somma e ne fornisce in output il risultato.
			- sub_time: Dati in input due time, ne fa la differenza e ne fornisce in output il risultato.
			- time_to_minutes: Dato in input un time, ne fornisce in output l'equivalente in minuti.
			- minutes_to_time: Dato in input dei minuti, ne fornisce in output l'equivalente in time.
Autori: Bruno S. - Morelli N. - Pinto A.

************************************************************************/

time(H, M) :-
	number(H),
	number(M),
	H < 24,
	H >= 0,
	M < 60,
	M >= 0.

lt_time(time(H1, M1), time(H2, M2)) :- 
	time(H1, M1),
	time(H2, M2),
	H1 < H2.

lt_time(time(H, M1), time(H, M2)) :- 
	time(H, M1),
	time(H, M2),
	M1 < M2.

lte_time(time(H1, M1), time(H2, M2)) :- 
	time(H1, M1),
	time(H2, M2),
	H1 < H2.

lte_time(time(H, M1), time(H, M2)) :- 
	time(H, M1),
	time(H, M2),
	M1 =< M2.
	
gt_time(time(H1, M1), time(H2, M2)) :- 
	time(H1, M1),
	time(H2, M2),
	H1 > H2.

gt_time(time(H, M1), time(H, M2)) :- 
	time(H, M1),
	time(H, M2),
	M1 > M2.	
	
gte_time(time(H1, M1), time(H2, M2)) :- 
	time(H1, M1),
	time(H2, M2),
	H1 > H2.

gte_time(time(H, M1), time(H, M2)) :- 
	time(H, M1),
	time(H, M2),
	M1 >= M2.	
	
eq_time(time(H, M), time(H, M)).

sum_time(time(H1, M1), time(H2,M2), time(X, Y)) :-
	time(H1, M1), 
	time(H2, M2),
	X is mod(H1+H2, 24),
	M is M1+M2,
	M < 60,
	Y is mod(M, 60).

sum_time(time(H1, M1), time(H2,M2), time(X, Y)) :-
	time(H1, M1),
	time(H2, M2),
	X1 is mod(H1+H2, 24),
	M is M1+M2,
	M > 59,
	Y is mod(M, 60),
	X is X1+1.

sub_time(time(H1, M1), time(H2,M2), time(X, Y)) :-
	time(H1, M1), 
	time(H2, M2),
	X is mod(H1-H2, 24),
	M is M1-M2,
	M >= 0,
	Y is mod(M, 60).

sub_time(time(H1, M1), time(H2,M2), time(X, Y)) :-
	time(H1, M1),
	time(H2, M2),
	X1 is mod(H1-H2, 24),
	M is M1-M2,
	M < 0,
	Y is mod(M, 60),
	X is X1-1.

time_to_minutes(time(H, M), Y) :-
	X is H*60,
	Y is X+M.
	
minutes_to_time(X, time(H,M)) :-
	Y is round(X),
	H is Y//60,
	M is mod(Y, 60).	

/***********************************************************************

Realizzazione: Novembre, 2016
Obiettivo: Realizzazione di un set di predicati che consentono di formattare e stampare su un file alcuni fatti asseriti 
			in modo tale da fornire all'utente una loro adeguata rappresentazione grafica. In particolare:
			- Predicati per il calcolo dell'orario minimo e massimo di tutta la conferenza e stampa su file 'dedotti' dei due orari.
			- Stampa su file 'dedotti' di tutte le date della conferenza.
			- Stampa su file 'dedotti' di tutte le sessioni della conferenza.
			- Stampa su file 'errori' di eventuali errori a livello organizzativo della conferenza.
Autori: Bruno S. - Morelli N. - Pinto A.

************************************************************************/
	
calcolo_ora_inizio_fine(OraInizio, OraFine) :-
	calcolo_minimo_orario(OraInizio),
	calcolo_massimo_orario(OraFine).
	
calcolo_minimo_orario(OraInizio) :-
	findall([H, M], used_fact(_, sessione(registrazione, _, time(H, M), _), 1), Lista),
	minTime_list(Lista, OraInizio).
	
calcolo_massimo_orario(OraFine) :-
	findall([H, M], used_fact(_, orario(_, time(H, M)), 1), Lista0),
	findall([H, M], used_fact(_, sessione(closing, _, _, time(H, M)), 1), Lista1),
	findall([H, M], used_fact(_, sessione(cena, _, _, time(H, M)), 1), Lista2),
	findall([H, M], used_fact(_, sessione(escursione, _, _, time(H, M)), 1), Lista3),
	not(Lista2 == []),
	not(Lista3 == []),
	maxTime_list(Lista0, OraF0),
	maxTime_list(Lista1, OraF1),
	maxTime_list(Lista2, OraF2),
	maxTime_list(Lista3, OraF3),
	append([OraF0], [], L0),
	append([OraF1], L0, L),
	append([OraF2], L, L1),
	append([OraF3], L1, L2),
	maxTime_list(L2, OraFine).
	
calcolo_massimo_orario(OraFine) :-
	findall([H, M], used_fact(_, orario(_, time(H, M)), 1), Lista0),
	findall([H, M], used_fact(_, sessione(closing, _, _, time(H, M)), 1), Lista1),
	findall([H, M], used_fact(_, sessione(cena, _, _, time(H, M)), 1), Lista2),
	findall([H, M], used_fact(_, sessione(escursione, _, _, time(H, M)), 1), Lista3),
	Lista2 == [],
	not(Lista3 == []),
	maxTime_list(Lista0, OraF0),	
	maxTime_list(Lista1, OraF1),
	maxTime_list(Lista3, OraF3),
	append([OraF0], [], L0),
	append([OraF1], L0, L),
	append([OraF3], L, L2),
	maxTime_list(L2, OraFine).
	
calcolo_massimo_orario(OraFine) :-
	findall([H, M], used_fact(_, orario(_, time(H, M)), 1), Lista0),
	findall([H, M], used_fact(_, sessione(closing, _, _, time(H, M)), 1), Lista1),
	findall([H, M], used_fact(_, sessione(cena, _, _, time(H, M)), 1), Lista2),
	findall([H, M], used_fact(_, sessione(escursione, _, _, time(H, M)), 1), Lista3),
	not(Lista2 == []),
	Lista3 == [],
	maxTime_list(Lista0, OraF0),
	maxTime_list(Lista1, OraF1),
	maxTime_list(Lista2, OraF2),
	append([OraF0], [], L0),
	append([OraF1], L0, L),
	append([OraF2], L, L1),
	maxTime_list(L1, OraFine).
	
calcolo_massimo_orario(OraFine) :-
	findall([H, M], used_fact(_, orario(_, time(H, M)), 1), Lista0),
	findall([H, M], used_fact(_, sessione(closing, _, _, time(H, M)), 1), Lista1),
	findall([H, M], used_fact(_, sessione(cena, _, _, time(H, M)), 1), Lista2),
	findall([H, M], used_fact(_, sessione(escursione, _, _, time(H, M)), 1), Lista3),
	Lista2 == [],
	Lista3 == [],
	maxTime_list(Lista0, OraF0),
	maxTime_list(Lista1, OraF1),
	append([OraF0], [], L0),
	append([OraF1], L0, L),
	maxTime_list(L, OraFine).
	
%Funzione che calcola l'ora minima in una lista
minTime_list([[Min1, Min2]],[Min1, Min2]).

minTime_list([[H1, M1],[H2, M2]|T],[Min1, Min2]) :-
    lte_time(time(H1, M1), time(H2, M2)),
    minTime_list([[H1, M1]|T],[Min1, Min2]).

minTime_list([[H1, M1],[H2, M2]|T],[Min1, Min2]) :-
    gt_time(time(H1, M1), time(H2, M2)),
    minTime_list([[H2, M2]|T],[Min1, Min2]). 
	
%Funzione che calcola l'ora massima in una lista
maxTime_list([[Max1, Max2]],[Max1, Max2]).

maxTime_list([[H1, M1],[H2, M2]|T],[Max1, Max2]) :-
    gte_time(time(H1, M1), time(H2, M2)),
    maxTime_list([[H1, M1]|T],[Max1, Max2]).

maxTime_list([[H1, M1],[H2, M2]|T],[Max1, Max2]) :-
    lt_time(time(H1, M1), time(H2, M2)),
    maxTime_list([[H2, M2]|T],[Max1, Max2]). 

print_sess :-
	calcolo_ora_inizio_fine([A, B], [C, D]),
    format('~w,~w-~w,~w~n', [A, B, C, D]),
	open('res/users/demoorganization/conferenza/dedotti',append,Stream1), 
	write(Stream1,'orari'),write(Stream1,'-'),write(Stream1,A),write(Stream1,','),write(Stream1,B),write(Stream1,'-'),write(Stream1,C),write(Stream1,','),write(Stream1,D), nl(Stream1), 
	close(Stream1),
    false.
	
print_sess :-
	used_fact(_, giorno(_, data(Data), _), 1),
    format('~w~n', [Data]),
	open('res/users/demoorganization/conferenza/dedotti',append,Stream1), 
	write(Stream1,'data'),write(Stream1,'-'),write(Stream1,Data), nl(Stream1), 
	close(Stream1),
    false.
	
print_sess :-
    format('-------------'),
	open('res/users/demoorganization/conferenza/dedotti',append,Stream1), 
	write(Stream1,'-------------'), nl(Stream1), 
	close(Stream1),
    false.	
	
print_sess :-
	used_fact(_, sessione(Tipo, Data, Inizio, Fine), 1),
	used_fact(_, adibita(Tipo, IdAula), 1),
	used_fact(_, aula(IdAula, NomeAula, _, _), 1),
    format('~w-~w-~w-~w-~w~n', [Tipo, Data, Inizio, Fine, NomeAula]),
	open('res/users/demoorganization/conferenza/dedotti',append,Stream1), 
	write(Stream1,Tipo), write(Stream1,'-'), write(Stream1,Data), write(Stream1,'-'), write(Stream1,Inizio),
	write(Stream1,'-'), write(Stream1,Fine), write(Stream1,'-'), write(Stream1,NomeAula), nl(Stream1), 
	close(Stream1),
    false.	
	
print_sess :-
	used_fact(_, sessione(Tipo, Data, Inizio, Fine), 1),
	not(used_fact(_, adibita(Tipo, IdAula), 1)),
    format('~w-~w-~w-~w~n', [Tipo, Data, Inizio, Fine]),
	open('res/users/demoorganization/conferenza/dedotti',append,Stream1), 
	write(Stream1,Tipo), write(Stream1,'-'), write(Stream1,Data), write(Stream1,'-'), write(Stream1,Inizio), 
	write(Stream1,'-'), write(Stream1,Fine), nl(Stream1), 
	close(Stream1),
    false.	
	
print_sess :-
	used_fact(_, sessione_cont(Tipo, Argomento, Data, Inizio, Fine), 1),
	used_fact(_, adibita(Tipo, IdAula), 1),
	used_fact(_, aula(IdAula, NomeAula, _, _), 1),
    format('~w (~w)-~w-~w-~w-~w~n', [Tipo, Argomento, Data, Inizio, Fine, NomeAula]),
	open('res/users/demoorganization/conferenza/dedotti',append,Stream1), 
	write(Stream1,Tipo), write(Stream1,' ('), write(Stream1,Argomento), write(Stream1,')-'), write(Stream1,Data), 
	write(Stream1,'-'), write(Stream1,Inizio), write(Stream1,'-'), write(Stream1,Fine), write(Stream1,'-'), write(Stream1,NomeAula), nl(Stream1), 
	close(Stream1),
    false.

print_sess :-
	used_fact(_, sessione_no_pp(_, Tipo, Argomento, Data, Inizio, Fine), 1),
	used_fact(_, adibita(Tipo, IdAula), 1),
	used_fact(_, aula(IdAula, NomeAula, _, _), 1),
    format('~w (~w)-~w-~w-~w-~w~n', [Tipo, Argomento, Data, Inizio, Fine, NomeAula]),
	open('res/users/demoorganization/conferenza/dedotti',append,Stream1), 
	write(Stream1,Tipo), write(Stream1,' ('), write(Stream1,Argomento), write(Stream1,')-'), write(Stream1,Data), 
	write(Stream1,'-'), write(Stream1,Inizio), write(Stream1,'-'), write(Stream1,Fine), write(Stream1,'-'), write(Stream1,NomeAula), nl(Stream1), 
	close(Stream1),
    false.
	
print_sess :-
	used_fact(_, sessione_pp(Id, Tipo, Data, Inizio, Fine), 1),
	used_fact(_, adibita_pp(Id, _, IdAula), 1),
	used_fact(_, aula(IdAula, NomeAula, _, _), 1),
    format('~w-~w-~w-~w-~w~n', [Tipo, Data, Inizio, Fine, NomeAula]),
	open('res/users/demoorganization/conferenza/dedotti',append,Stream1), 
	write(Stream1,'Paper Presentation ('), write(Stream1,Tipo), write(Stream1,')-'),  write(Stream1,Data), write(Stream1,'-'), 
	write(Stream1,Inizio), write(Stream1,'-'),  write(Stream1,Fine), write(Stream1,'-'),  write(Stream1,NomeAula), nl(Stream1), 
	close(Stream1),
	false.
		
print_sess :-
	used_fact(_, sessione_parallela(Id, Tipo, Data, Inizio, Fine), 1),
	used_fact(_, adibita_pp(Id, _, IdAula), 1),
	used_fact(_, aula(IdAula, NomeAula, _, _), 1),
    format('~w-~w-~w-~w-~w~n', [Tipo, Data, Inizio, Fine, NomeAula]),
	open('res/users/demoorganization/conferenza/dedotti',append,Stream1), 
	write(Stream1,'*'), write(Stream1,'Paper Presentation ('), write(Stream1,Tipo), write(Stream1,')-'),write(Stream1,Data), 
	write(Stream1,'-'), write(Stream1,Inizio), write(Stream1,'-'), write(Stream1,Fine), write(Stream1,'-'), write(Stream1,NomeAula), nl(Stream1), 
	close(Stream1),
	false.
	
print_sess :-
	used_fact(_, sessione_parallela1(Id, Tipo, Data, Inizio, Fine), 1),
	used_fact(_, adibita_pp(Id, _, IdAula), 1),
	used_fact(_, aula(IdAula, NomeAula, _, _), 1),
    format('~w-~w-~w-~w-~w~n', [Tipo, Data, Inizio, Fine, NomeAula]),
	open('res/users/demoorganization/conferenza/dedotti',append,Stream1), 
	write(Stream1,'*'), write(Stream1,'Paper Presentation ('), write(Stream1,Tipo), write(Stream1,')-'), write(Stream1,Data), 
	write(Stream1,'-'), write(Stream1,Inizio), write(Stream1,'-'), write(Stream1,Fine), write(Stream1,'-'), write(Stream1,NomeAula), nl(Stream1), 
	close(Stream1),
	false.
	
print_sess.	
	
print_error :-
	call(used_fact(_, errore(X), 1)),
    format('Errore: ~w~n', [X]),
	open('res/users/demoorganization/conferenza/errori',append,Stream2), 
	write(Stream2,X), nl(Stream2), 
	close(Stream2),
	false.
	
print_error.

stampa_dedotti :-
	open('res/users/demoorganization/conferenza/errori',write,Stream2), 
	close(Stream2),
	print_error,
	open('res/users/demoorganization/conferenza/dedotti',write,Stream1), 
	close(Stream1),
	print_sess.
		

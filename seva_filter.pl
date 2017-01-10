/***********************************************************************

Modulo: seva_filter.pl 
Autori: Bruno S. - Morelli N. - Pinto A.
Descrizione: Modulo che permette di eseguire i seguenti filtri:
			- Visualizzazione di fatti dato in input il loro nome.
			- Visualizzazione di fatti che contengono il valore di un termine dato in input.
			- Visualizzazione di fatti che contengono il nome di un fatto e il valore di un suo termine dati in input (Combinazione delle due precedenti). 

************************************************************************/

filter_menu :-
        nl,nl,
		nl,write('@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@'),
		nl,nl,
		nl,write('************************ Filters ************************'),
		nl,nl,
        nl,write('   1 - Get facts by name'),
        nl,write('   2 - Get facts by value of a term'),
        nl,write('   3 - Get facts by name and value of a term'),
		nl,write('   0 - Return to main menu'),nl,
		nl,write('   Type number: '),
        read(X),
	    do_filter(X).
		
do_filter(0) :-
	nl,nl,
	nl,write('************************ Closing ************************'),
	nl,nl,
	nl,write('@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@'),
	start.
	
do_filter(1) :-
	nl,write('   Insert name: '),
	read(NameFact),
	nl,write('   Results: '),
	nl,nl,
	estrai_nome_fatto(NameFact, Y),
	filter_menu.
	
do_filter(2) :-
	nl,write('   Insert value of a term: '),
	read(ValueTerm),
	nl,write('   Results: '),
	nl,nl,
	estrai_valore_termine(ValueTerm, Y),
	filter_menu.
	
do_filter(3) :-
	nl,write('   Insert name: '),
	read(NameFact),
	nl,write('   Insert value of a term: '),
	read(ValueTerm),
	nl,write('   Results: '),
	nl,nl,
	estrai_termine_fatto(NameFact, ValueTerm, Y),
	filter_menu.
	
% -------------------------------------------------------

estrai_nome_fatto(Nome_Fatto, Y) :-
	used_fact(_, Y, _),
	functor(Y, Nome_Fatto, Z),
	write('   '),
	write(Y),
	nl,
	fail.
	
estrai_nome_fatto(Nome_Fatto, Y).
	
estrai_valore_termine(Valore_Termine, Y) :-
	used_fact(_, Fatto, _),
	functor(Fatto, Nome, NPosti),
	verifica(Fatto, Valore_Termine, NPosti, Y),
	Fatto == Y,
	write('   '),
	write(Y),
	nl,
	fail.
	
estrai_valore_termine(Valore_Termine, Y).
	
estrai_termine_fatto(Nome_Fatto, Valore_Termine, Y) :-
	call(used_fact(_, Fatto, _)),
	functor(Fatto, Nome_Fatto, NPosti),
	verifica(Fatto, Valore_Termine, NPosti, Y),
	Fatto == Y,
	write('   '),
	write(Y),
	nl,
	fail.
	
estrai_termine_fatto(Nome_Fatto, Valore_Termine, Y).
	
verifica(Fatto, Target, NPosti, Y) :-
	not(NPosti == 0),
	arg(NPosti, Fatto, Target),
	N is NPosti - 1,
	Y = Fatto.
	
verifica(Fatto, Target, NPosti, Y) :-
	not(NPosti == 0),
	not(arg(NPosti, Fatto, Target)),
	N is NPosti - 1,
	verifica(Fatto, Target, N, Y).
	
verifica(Fatto, Target, NPosti, Y) :-
	NPosti == 0,
	fail.
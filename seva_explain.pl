/*************************************************************************
        Nome: seva_explain.pl
        
	Realizzazione: Febbraio, 2014
  		Obiettivo: Modulo di Spiegazione delle Deduzioni del SEVA
       		Autore: Francesco Solare
    
	Revisione : Giugno,2014
	Autore: Fabio Fiorella & Davide Giannico
*************************************************************************/
:- dynamic (tracker/2).
:- dynamic (inferedrule/2).

/*******************************************************************************************
        Realizzazione: Estrazione delle regole che hanno originato
		       le deduzioni finali del processo
	Esempio:
	input
		IdHunter = 21 (equivale all'id del fatto dedotto)
	output
		IdHunted = 201 (equivale all'id della regola che ha prodotto la deduzione)
********************************************************************************************/

/*
tracking_inferences(IdHunted,IdHunter) :-
	tracker(IdNewHunter,IdHunter),
	!,	
	tracking_inferences(IdHunted,IdNewHunter).
tracking_inferences(IdHunter,IdHunter).%modifica raimondi: spostato come seconda opzione
*/
tracking_inferences(IdHunted,IdHunter):-
	tracker(IdHunted,IdHunter).

retrievaling_usedrules :-
	used_fact(IdfDeduct,DedFact,CertDeduct),
	%controllo se il fatto è un fatto dedotto
	initfacts(InitialFact),		
	not(member(IdfDeduct,InitialFact)),
	%controllo se siamo interessati a spiegare il fatto dedotto

	explainer(DedFact,1,_,_),
	%traccio il percorso di risoluzione forward
	tracking_inferences(IdInfRule,IdfDeduct), 
	assert(inferedrule(IdInfRule,CertDeduct)),
	fail.
retrievaling_usedrules.

/*************************************************************************
        Realizzazione: Costruzione della Spigazione
*************************************************************************/
writer_explain([], _) :- !.
/*writer_explain([UFact|FactTail]) :-
	used_fact(_,UFact,CertUFact),
	explainer(UFact,_,FactExp,X),
	Cert is ceiling(CertUFact*100),
	nl,write('     --> '),write(FactExp),stampList(X),write(' (certainty '),write(Cert),write('%)'),
	writer_explain(FactTail).
*/
writer_explain([UFact|FactTail], DedFact) :-	
	used_fact(_,UFact,CertUFact),
	explainer(UFact,_,FactExp,X),
	not(explained_condition_rule(FactExp, DedFact )),
	Cert is ceiling(CertUFact*100),
	nl,write('     --> '),write(FactExp),stampList(X),write(' (certainty '),write(Cert),write('%)'),
	assert(explained_condition_rule(FactExp, DedFact)),
	writer_explain(FactTail, DedFact).
	
writer_explain([UFact|FactTail], DedFact) :-	%variante operazione call_p
	explainer(UFact,_,FactExp,X),
	not(explained_condition_rule(FactExp, DedFact )),
	nl,write('     --> '),write(FactExp),stampList(X),
	assert(explained_condition_rule(FactExp, DedFact)),
	writer_explain(FactTail, DedFact).
	
writer_explain([_|FactTail], DedFact) :-
	writer_explain(FactTail, DedFact).	

explaining_rule(IDIRule,CERTDed) :-
%gtrace,
	exp_rule(IDIRule,DedFact,UsedFacts,_,_),
	not(explained_fact(DedFact)),
	%used_fact(_ , DedFact, _),
	explainer(DedFact,_,DFactExp,X),
	Cert is ceiling(CERTDed*100),
	nl,nl,write('____________________________________________________________________'),
	nl,write('     '),write(DFactExp),stampList(X),write(' (certainty '),write(Cert),write('%)'),write(', whereas'),nl,
	assert(explained_fact(DedFact)),
	get_condition(UsedFacts,NC), %modifica raimondi: aggiunto metodo per considerare solo le condizioni a prescindere dal loro annidamento 
	writer_explain(NC, DedFact),
	!.
explaining_rule(_,_).

/*%added by Fabio F. e Davide G.
explaining_rule(IDIRule,CERTDed) :-
	rule(IDIRule,DedFact,or(UsedFacts),_,_),
	explainer(DedFact,_,DFactExp,X),
	Cert is ceiling(CERTDed*100), 
	nl,nl,write('____________________________________________________________________'),
	nl,write('     '),write(DFactExp),stampList(X),write(' (certainty '),write(Cert),write('%)'),write(', whereas'),nl,
	writer_explain(UsedFacts, DedFact).
explaining_rule(_,_).*/

building_explain :-	
		%gtrace,
	inferedrule(IdInfRule,CertDeduct),
	explaining_rule(IdInfRule,CertDeduct),
	%retract(inferedrule(IdInfRule,CertDeduct)),
	fail.
building_explain.

stampList([]).
stampList([H|T]):- write(H),
                   stampList(T).








				  
				  
				   
/*************************************************************************    
	Realizzazione: Novembre, 2016
  		Obiettivo: E' stato realizzato un nuovo modulo di Spiegazione partendo da quello sopra e apportando delle modifiche.
		           Oltre alla spiegazione (a video) testuale di come sono stati dedotti i nuovi fatti, 
				   è stata data la possibilità di vedere quali e quante sono le regole che sono state utilizzate, 
				   e per ogni regola è specificato anche il nuovo fatto dedotto dall’inferenza.
       		
			Autore: Anzivino Giuseppe
    
*************************************************************************/


tracking_inferences_2(IdHunted,IdHunter) :-
	tracker(IdNewHunter,IdHunter),
	!,
	tracking_inferences_2(IdHunted,IdNewHunter).
tracking_inferences_2(IdHunter,IdHunter).


retrievaling_usedrules_2 :-	
	used_fact(IdfDeduct,DedFact,CertDeduct),
	%controllo se il fatto è un fatto dedotto
	initfacts(InitialFact),	
	not(member(IdfDeduct,InitialFact)),
	%controllo se siamo interessati a spiegare il fatto dedotto
	explainer(DedFact,1,_,_),                  
	%traccio il percorso di risoluzione forward
	tracking_inferences_2(IdInfRule,IdfDeduct),
	assert(inferedrule(IdInfRule,CertDeduct)),
	fail.
retrievaling_usedrules_2.


	
writer_explain_2([]) :- !.
writer_explain_2([UFact|FactTail]) :-

	used_fact(_,UFact,CertUFact),
    rule(ID,_,and([UFact]),_,_),
	explainer(UFact,_,FactExp,_),  
	Cert is ceiling(CertUFact*100),
	nl,write('     --> '),write(FactExp),
	open('explain.pl', append, Stream),
	write(Stream,ID),
	write(Stream,'.'),
    nl(Stream),
	close(Stream),
	assert_facts(ID,UFact),
	write(' (certainty '),write(Cert),write('%)'),
	writer_explain_2(FactTail).

	

explaining_rule_2(IDIRule,CERTDed) :-
	rule(IDIRule,DedFact,and(UsedFacts),_,_),
	explainer(DedFact,_,DFactExp,_),
	assert_facts(IDIRule,DedFact),     
	Cert is ceiling(CERTDed*100),
	nl,nl,write('____________________________________________________________________'),
	nl,write('     '),write(DFactExp),write(' (certainty '),write(Cert),write('%)'),write(','),nl,
	writer_explain_2(UsedFacts).
explaining_rule_2(_,_).

building_explain_2 :-	
	inferedrule(IdInfRule,CertDeduct),
	open('explain.pl', append, Stream),
	write(Stream,IdInfRule),
	write(Stream,'.'),
    nl(Stream),
	close(Stream),
	explaining_rule_2(IdInfRule,CertDeduct),
	retract(inferedrule(IdInfRule,CertDeduct)),
	fail.
building_explain_2.


rules:-
open('explain.pl',read,S),
readaa(S,LL),
close(S),nl,
deletee(end_of_file,LL,Lista),
nl,
del_dup(Lista,Listanuova),
nl,
write('Le regole utilizzate per dedurre i nuovi fatti sono: '),
nl,
write(Listanuova),
lungh(Listanuova,X),nl,nl,
write('Il numero di regole utilizzate e'': '),
write(X),nl,nl,nl.


assert_facts(X,Fact):- 
    open('rulefact.pl', append, SS),
    write(SS,'''La regola '), write(SS,X),
	transform(Fact,AA),
	write(SS,' serve per dedurre il fatto: '), write(SS,AA),
	write(SS,'\n''.'),
    nl(SS),
	close(SS).




delete_nuovo(_,[],[]).
delete_nuovo(X,[X|T],R):-!,delete_nuovo(X,T,R).
delete_nuovo(X,[H|T],[H|R]):-delete_nuovo(X,T,R).


del_dup([],[]).
del_dup([X|T],[X|T1]):-memberr(X,T),!,delete_nuovo(X,T,R),del_dup(R,T1).
del_dup([X|T],[X|T1]):-del_dup(T,T1).

memberr(X,[X|_]).
memberr(X,[_|L]):-memberr(X,L).


lungh([],0).
lungh([_|L],N):-lungh(L,N1), N is N1+1.

stamp_rule_fact:-
open('rulefact.pl',read,S),
readaa(S,LL),
close(S),
write(LL), nl.


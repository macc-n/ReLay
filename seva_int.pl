:- use_module(library(ordsets)).
:- dynamic (pattern/5).

translateToInthelexBody(Observation):-
	write('INIZIO PATTERN'),
	consult('apprendimento/pattern.pl'),
	findall(F,fact(X,F,C),LiF),
	trad_facts(LiF,Observation,Classes),
	assert(corpo(Observation)),
	write(Observation),
	write('\n'),
	write(Classes),
	write('FINE PATTERN').
	

translateToInthelexTune(Observation):-
	write('INIZIO PATTERN'),
	consult('apprendimento/pattern.pl'),
	findall(F,headFact(F,_),LiF),
	findall(V,headFact(_,V),LiV),
	trad_factsHead(LiF,LiV,Observation,Classes),
	assert(testa(Observation)),
	write(Observation),
	write('\n'),
	write(Classes),
	write('FINE PATTERN').

translateToInthelexClassify(ListC):-
	consult('apprendimento/pattern.pl'),
	fact(_,ultimots(T),_),
	findall(ID,fact(ID,posizione(_,_,_),1),List),
	findPosizione(List,ListC),
	assert(testa(ListC)),
	write(ListC).
	

	
	
findPosizione([],ListC).
findPosizione([ID|RestID],ListC):-
	findPosizione(RestID,ListC),
	fact(ID,posizione(T,L,Pers),_),
	setof(X,P^A^pattern(P,A,X,y),ListArgsPattern),
	classify(T,L,Pers,ListArgsPattern,ListC).

classify(T,L,Pers,ListArgsPattern,ListC):-
	madeClassify(T,L,Pers,ListArgsPattern,ListC).

madeClassify(T,L,Pers,[],ListC).
madeClassify(T,L,Pers,[ArgPattern|RestArgsPattern],ListC3):-
	ListC=[],
	madeClassify(T,L,Pers,RestArgsPattern,ListCpat),
	traduceArg(T,L,Pers,ArgPattern,ListC,ListC2),
	ord_union(ListC2,ListCpat,ListC3).

traduceArg(T,L,Pers,[t],ListC,ListC2):-
	atom_number(Ct, T),
	atom_concat('tmstmp',Ct, Tm),
	At=..[classify,Tm],
	ord_insert(ListC,At,ListC2),
	!.
	 
traduceArg(T,L,Pers,[c],ListC,ListC2):-
	At=..[classify,Pers],
	ord_insert(ListC,At,ListC2),
	!.
	 	 
traduceArg(T,L,Pers,[t],ListC,ListC2):-
	atom_number(Ct, T),
	atom_concat('tmstmp',Ct, Tm),
	At=..[classify,Tm],
	ord_insert(ListC,At,ListC2),
	!.
	 
traduceArg(T,L,Pers,[t,l,c],ListC,ListC2):-
	atom_number(Ct, T),
	atom_concat('tmstmp',Ct, Tm),
	At=..[classify,Tm,L,Pers],
	ord_insert(ListC,At,ListC2),
	!.
	 
traduceArg(T,L,Pers,[t,c],ListC,[At|ListC]):-
	atom_number(Ct, T),
	atom_concat('tmstmp',Ct, Tm),
	At=..[classify,Tm,L,Pers],
	ord_insert(ListC,At,ListC2),
	!.
	 	
traduceArg(T,L,Pers,_,ListC,ListC):-
	!.

trad_factsHead([],[],[],[]).
trad_factsHead([Fact|RestFacts],[V|RestV],Observation,Classes) :-
	trad_factsHead(RestFacts,RestV,PartObs,PartClasses),
	functor(Fact,P,A),
	pattern(P,A,ArgPattern,ObsFlag),
	trad_fact(Fact,V,A,ArgPattern,TradFact,AddLits,Timestamp,Location,Person),
	( V == pos ->
	  Classes = [TradFact|PartClasses]
	;
		TradFactNeg =.. [neg,TradFact],
		Classes = [TradFactNeg|PartClasses]
	).			

	
	
	

trad_facts([],[],[]).
trad_facts([Fact|RestFacts],Observation,Classes) :-
	trad_facts(RestFacts,PartObs,PartClasses),
	functor(Fact,P,A),
	pattern(P,A,ArgPattern,ObsFlag),
	trad_fact(Fact,V,A,ArgPattern,TradFact,AddLits,Timestamp,Location,Person),
	ord_union(AddLits,PartObs,PartObservation),
	( ObsFlag == y ->
	  ord_insert(PartObservation,TradFact,Observation),
		Classes = PartClasses
	;
		Observation = PartObservation,
		Classes = [TradFact|PartClasses]
	).
	
trad_fact(F,V,A,ArgPattern,TradPred,AddPreds,Timestamp,Location,Person) :-
	F =.. [Pred|Args],
	findArgDep(ArgPattern,Args,Timestamp,Location,Person),
	trad_args(ArgPattern,Args,TradArgs,AddPreds,Timestamp,Location,Person),
	TradPred =.. [Pred|TradArgs].
	
trad_args([],[],[],[],Timestamp,Location,Person).
trad_args([ArgPattern|RestPatterns],[Arg|RestArgs],[TradArg|RestTradArgs],AddLits,Timestamp,Location,Person) :-
	trad_args(RestPatterns,RestArgs,RestTradArgs,PartAddLits,Timestamp,Location,Person),
	trad_arg(ArgPattern,Arg,Timestamp,Location,Person,TradArg,ArgAddLits,L1),
	ord_union(ArgAddLits,PartAddLits,AddLits).


findArgDep([],[],Timestamp,Location,Person).
findArgDep([ArgPattern|RestPatterns],[Arg|RestArgs],Timestamp,Location,Person):-
	(ArgPattern==t -> atom_number(Ct, Arg), Timestamp = Ct),
		findArgDep(RestPatterns,RestArgs,Timestamp,Location,Person).
	
findArgDep([ArgPattern|RestPatterns],[Arg|RestArgs],Timestamp,Location,Person):-
	(ArgPattern==l -> Location = Arg),
		findArgDep(RestPatterns,RestArgs,Timestamp,Location,Person).
	
findArgDep([ArgPattern|RestPatterns],[Arg|RestArgs],Timestamp,Location,Person):-
	(ArgPattern==c -> Person = Arg),
		findArgDep(RestPatterns,RestArgs,Timestamp,Location,Person).
	
findArgDep([ArgPattern|RestPatterns],[Arg|RestArgs],Timestamp,Location,Person):-
	findArgDep(RestPatterns,RestArgs,Timestamp,Location,Person).
	


trad_arg(p,C,_,_,_,C,[],[]) :-
	!.
trad_arg(n,C,_,_,_,C,[],[]) :-
	!.
trad_arg(l,C,_,_,_,C,[],[]) :-
	!.
trad_arg(t,C,_,_,_,T,[],[]) :-
	atom_number(Ct, C),
	atom_concat('tmstmp',Ct, T),
	!.

	
trad_arg(P,Arg,Timestamp,Location,Person,T,L,L1) :-
	P =.. [c|Dependencies],
	trad_Dependencies(Arg,Dependencies,Timestamp,Location,Person,T,L,L1),
	!.

trad_Dependencies(Arg,[t,l,c],Timestamp,Location,Person,T,L,L1):-
	atom_concat(Arg,'_tmstmp', At),
	atom_concat(At,Timestamp, At2),
	atom_concat(At2,'_', At3),
	atom_concat(At3,Location, At4),
	atom_concat(At4,'_', At5),
	atom_concat(At5,Person, T),
	Newlit=..[Arg,T],
	ord_insert(L1,Newlit,L),
	!.
	
trad_Dependencies(Arg,[],Timestamp,Location,Person,T,L,L1):-
	T = Arg,
	Newlit=..[Arg,Arg],
	ord_insert(L1,Newlit,L),
	!.	
		
trad_Dependencies(Arg,[t,l],Timestamp,Location,Person,T,L,L1):-
	atom_concat(Arg,'_tmstmp', At),
	atom_concat(At,Timestamp, At2),
	atom_concat(At2,'_', At3),
	atom_concat(At3,Location, T),
	Newlit=..[Arg,T],
	ord_insert(L1,Newlit,L),
	!.

trad_Dependencies(Arg,[t,c],Timestamp,Location,Person,T,L,L1):-
	atom_concat(Arg,'_tmstmp', At),
	atom_concat(At,Timestamp, At2),
	atom_concat(At2,'_', At3),
	atom_concat(At3,Person, T),
	Newlit=..[Arg,T],
	ord_insert(L1,Newlit,L),
	!.
	

	
	
	
	
/*************************************************************************
        Nome: tree_utility.pl
        
	Realizzazione: Luglio, 2015
  		Obiettivo: Implementare la gestione del motore forward utilizzando un  albero di condizioni per ogni regola.
		La classe contiene tutti i metodi che riguardano la gestione dell'albero:
			-init_trees: da utilizzare in fase di inizializzazione dell'ambiente per la crazione degli alberi vuoti (uno per regola)
			-elabora_tree: da utilizzare per aggiornare l'albero di una regola con un nuovo fatto.
			-assert_verified_rule: da utilizzare per creare le regole aventi condizioni verificate.
       		Autore: Vincenzo Raimondi
	
	Revisione: Ottobre, 2016 
	Autori: Iovine A. - Lovascio C.
		Obiettivo: 
		-Aggiunta dell'operatore not_exists. Metodi:
			-check_not_exists
			-inside_not_exists
			-Modifiche in assert_verified_rule
			-Modifiche in updatecond_sublist
			-Modifiche in get_condition
		-Gestione dei moduli
			-Procedure init_tree/1 e init_trees/1
			-Procedura deuse_facts
			
			
*************************************************************************/

:- dynamic (t/2).
:- dynamic (t_rule/2).
:- dynamic(exp_rule/3).

init_trees:-
	rule(Id,_,C,_,_),
	get_condition(C,NC),
	assert(t_rule(Id,t(NC,[]))),
	fail.
init_trees.

% Modulo per l'inizializzazione delle regole di un modulo appena caricato
init_trees(Module) :-
	rule(id(Module,N),_,C,_,_),
	get_condition(C,NC),
	assert(t_rule(id(Module,N),t(NC,[]))),
	fail.
init_trees(Module).

init_tree(rule(Idr, Head, Conds, Crt, P)) :-
	get_condition(Conds, NC),
	assert(t_rule(Idr,t(NC,[]))).

/**
	La procedura deuse_facts è usata per riattivare i fatti precedentemente usati.
	Questa procedura è necessaria per permettere la verifica delle nuove regole
	ottenute dal caricamento di un nuovo modulo.
*/
deuse_facts :-
	retract(used_fact(Id, A, C)),
	assert(fact(Id, A, C)),
	deuse_facts.
	
deuse_facts.

get_condition(and([L|Lr]),NC):-
	get_condition(L,NC1),
	!,
	get_condition(and(Lr),NC2),
	append(NC1,NC2,NC).

get_condition(and([]),[]):-!.

get_condition(and([L|Lr]),NC):-
	get_condition(and(Lr),NL),
	append([L],NL,NC).

get_condition(or([L|Lr]),NC):-
	get_condition(L,NC1),
	!,
	get_condition(or(Lr),NC2),
	append(NC1,NC2,NC).

get_condition(or([]),[]):-!.

get_condition(or([L|Lr]),NC):-
	get_condition(or(Lr),NL),
	append([L],NL,NC).

get_condition(no(T),[T]).

get_condition(not_exists(T), ST) :-
	get_condition(T, ST).

get_condition(not_exists(T), [T]).
	
%passo base, gestione genitore senza figli(foglia).
elabora_tree(t(N,[]),F,Cf,NTree):-
	copy_term(N,N_c),
	make_permutation_tree(N_c,F,Cf,PList),
	make_tree(PList,TreeList), %aggiunta
	NTree=t(N,TreeList).

%gestione genitore con figli
elabora_tree(t(N,Lista),F,Cf,NTree):-
	copy_term(N,N_c),
	make_permutation_tree(N_c,F,Cf,PList), % se PList è vuoto, non ci sono state permutazioni --> non aggiornare il resto
	PList\=[],
	make_tree(PList,TreeList), 
	elabora_tree(Lista,F,Cf,NTree2),
	append(TreeList,NTree2,NTree3),
	NTree=t(N,NTree3).
	
elabora_tree(t(N,Lista),_,_,t(N,Lista)). %si attiva quando la permutazione restituisce lista vuota, è inutile sostituire nei figli.
	
%gestione lista figli 
elabora_tree([L|RL],F,Cf,NTree):-
	elabora_tree(L,F,Cf,NTree1),
	elabora_tree(RL,F,Cf,NTree2),
	append([NTree1],NTree2,NTree).
%passo base
elabora_tree([],_,_,[]).



/***************************************************************************
*	Procedure check_not_exists e inside_not_exists
*	Autori: Iovine - Lovascio
*	Obiettivo: individuare gli operatori di tipo not_exists nelle regole
*		e sostituire i fatti contenuti all'interno con i valori di certezza
*		corrispondenti. 
*		I valori utilizzati sono:
*		-1 : Fatto non esistente nella base di conoscenza
*		0  : Fatto presente nella base di conoscenza ma non ancora unificato
*
****************************************************************************/

check_not_exists_list([], []) :- !.
	
check_not_exists(and(H), and(NH)) :-
	!,
	check_not_exists_list(H, NH).
	
check_not_exists(or(H), or(NH)) :-
	!,
	check_not_exists_list(H, NH).
		
check_not_exists(no(H), no(NH)) :-
	!,
	check_not_exists(H, NH).

check_not_exists_list([and(H)|T], [and(NH)|NT]) :-
	check_not_exists_list(H, NH),
	!,
	check_not_exists_list(T, NT).
	
check_not_exists_list([or(H)|T], [or(NH)|NT]) :-
	check_not_exists_list(H, NH),
	!,
	check_not_exists_list(T, NT).
	
check_not_exists_list([no(H)|T], [no(NH)|NT]) :-
	check_not_exists(H, NH),
	!,
	check_not_exists_list(T, NT).
	
check_not_exists_list([not_exists(H)|T], [not_exists(NH)|NT]) :-
	inside_not_exists(H, NH),
	!,
	check_not_exists_list(T, NT).	
	
check_not_exists_list([X|T], [X|NT]) :-
	!,
	check_not_exists_list(T, NT).

check_not_exists(not_exists(H), not_exists(NH)) :-
	!,
	inside_not_exists(H, NH).
	
check_not_exists(Num, Num) :-
	!, 
	number(Num).
	
check_not_exists(H, H) :- !.
		
inside_not_exists(and(X), and(Y)) :-
	!,
	inside_not_exists_list(X, Y).
	
inside_not_exists(or(X), or(Y)) :-
	!,
	inside_not_exists_list(X, Y).

inside_not_exists(no(X), no(Y)) :-
	!, 
	inside_not_exists(X, Y).
		
inside_not_exists(not_exists(X), not_exists(Y)) :-
	!,
	inside_not_exists(X, Y).
	
inside_not_exists(call_p(Proc), -1) :- 
	not(call(Proc)),
	!.
	
inside_not_exists(call_p(Proc), 1) :- 
	call_p(Proc),
	!,
	assert(explainer(call_p(S),0,'Operazione Call '+S,[])).
		
inside_not_exists(Num, Num) :-
	number(Num),
	!.
	
inside_not_exists(Fact, -1) :-
	not(fact(_, Fact, _)),
	not(used_fact(_, Fact, _)),
	!.
	
inside_not_exists(X, 0) :- !.

inside_not_exists_list([], []) :- !.
	
inside_not_exists_list([and(L)|T], [and(NL)|NT]) :-
	!,
	inside_not_exists_list(L, NL),
	!,
	inside_not_exists_list(T, NT).
	
inside_not_exists_list([or(L)|T], [or(NL)|NT]) :-
	!,
	inside_not_exists_list(L, NL),
	!,
	inside_not_exists_list(T, NT).

inside_not_exists_list([no(L)|T], [no(NL)|NT]) :-
	!,
	inside_not_exists(L, NL),
	!,
	inside_not_exists_list(T, NT).
	
inside_not_exists_list([call_p(Proc)|T], [-1|NT]) :-
	not(call(Proc)),
	!,
	inside_not_exists_list(T, NT).
	
inside_not_exists_list([call_p(Proc)|T], [1|NT]) :-
	call_p(Proc),
	!,
	assert(explainer(call_p(S),0,'Operazione Call '+S,[])),
	inside_not_exists_list(T, NT).	
		
inside_not_exists_list([Num|T], [Num|NT]) :-
	number(Num),
	!,
	inside_not_exists_list(T, NT).
		
inside_not_exists_list([Fact|T], [-1|NT]) :-
	not(fact(_, Fact, _)),
	not(used_fact(_, Fact, _)),
	!,
	inside_not_exists_list(T, NT).
		
inside_not_exists_list([Fact|T], [0|NT]) :-
	!,
	inside_not_exists_list(T, NT).
	
	make_permutation_tree(N,F,Cf,PList):-
		findall(Sost,replace_fact(N,F,Cf,Sost),Permutation), %ottengo tutte le permutazioni delle condizioni
		make_permutation_tree_list(Permutation,F,Cf,PList).%per ogni permutazione ottengo altre permutazioni

	make_permutation_tree_list([],_,_,[]).
	make_permutation_tree_list([L|RL],F,Cf,PList):-
		make_permutation_tree(L,F,Cf,PL_L),
		make_permutation_tree_list(RL,F,Cf,PL_RL),
		append([L|RL],PL_L,PL1),
		append(PL1,PL_RL,PListDup),
		remove_dups(PListDup,PList).

	
	replace_fact(N,F,Cf,Sost):-
		nth0(I,N,F,R),
		nth0(I,Sost,[F,Cf],R).
	
	make_tree([],[]).
	make_tree([L|RL],TreeList):-
		make_tree(RL,TreeList1),
		append([t(L,[])],TreeList1,TreeList).
	
	
	
	
	remove_dups([], []).
remove_dups([First | Rest], NewRest) :-
	member(First, Rest),
	remove_dups(Rest, NewRest).
remove_dups([First | Rest], [First | NewRest]) :-
	remove_dups(Rest, NewRest).

	
	
% assert_verified_rule(t(N,[]),_,_,_,_,_,t(N,[])). %nodo genitore=radice=foglia->la regola base non ha subito modifiche.

/*
	Modifica Iovine-Lovascio: si effettua la verifica della regola anche se
	questa non ha subito alcuna unificazione
*/
assert_verified_rule(t(N,[]),Idr,R,C,P,Crt,t(N,[])) :-
	updatecond_lists(t(N,[]),Idr,R,C,P,Crt,[]),
	!.

assert_verified_rule(t(N,L),Idr,R,C,P,Crt,t(N,RtreeL)):-%nodo radice, con figli-> analizzo i figli.
	updatecond_lists(L,Idr,R,C,P,Crt,RtreeL),
	!.

updatecond_lists(t(N,[]),Idr,R,C,P,Crt,[]):-
	copy_term([C,R],[Cdup,Rdup]),
	%duplicate_term([C,R],[Cdup,Rdup]),
	updatecond_subList(N,Idr,Rdup,Cdup,P,Crt,Cdup).
updatecond_lists(t(N,[]),_,_,_,_,_,t(N,[])).%radice
%updatecond_lists(t(N,[]),_,_,_,_,_,[t(N,[])]).	%figlio

updatecond_lists(t(N,L),Idr,R,C,P,Crt,t(N,RTreeL)):-
	updatecond_lists(L,Idr,R,C,P,Crt,RTreeL).

updatecond_lists([],_,_,_,_,_,[]).	
updatecond_lists([T|Ts],Idr,R,C,P,Crt,RTreeL):-
	updatecond_lists(Ts,Idr,R,C,P,Crt,RTree2L),
	updatecond_lists(T,Idr,R,C,P,Crt,RTree1),
	append_figlio(RTree1,RTree2L,RTreeL).
	
	append_figlio([],RTree2L,RTree2L):-!. %se il nodo è utilizzato per generare la regola non mi serve piu
	
	append_figlio(RTree1,RTree2L,RTreeL):-
		append([RTree1],RTree2L,RTreeL).

updatecond_subList([],Idr,R,C,P,Crt,AllCond):-
	%ottimizzazione rimossa in quanto non più valida
	% not(rule(_,R,C,P,Crt)),
	not(used_rule(_,R,C,P,Crt)),	%la regola scatta durante il fireset e viene riasserita in frule
	check_not_exists(C, EvC),		% Ricerca degli operatori not_exists
	evaluate_cond(EvC,NEvC), %cerco le call_p
	%ottimizzazione possibile: rimuovere i nodi foglia in cui solo le call_p/1 non risolvono
	verify(NEvC,B),
	B=1,
	!,
	updating(Idr,R,NEvC,P,Crt,B,AllCond).
	updatecond_subList([],_,_,_,_,_,_):-fail. %B=0 voglio il fallimento perchè devo gestirlo da updatecond_list per modificare l'albero

updatecond_subList([[F,Cf]|RL],Idr,R,C,P,Crt,AllCond):-
	getfunct(C,Funct),
	%gtrace,
	updatecond(C,F,Cf,Funct,Nc), 
	%updatecond(AllCond,F,F,Funct,NAllCond),%l'unificazione avviene automaticamente nell'istruzione precedente 
	!,
	updatecond_subList(RL,Idr,R,Nc,P,Crt,AllCond).
	
updatecond_subList([_|RL],Idr,R,C,P,Crt,AllCond):-%predicato non sostituito
	updatecond_subList(RL,Idr,R,C,P,Crt,AllCond). 

updating(Idr,R,C,P,Crt,B,AllCond) :-  
	not(rule(_,R,C,P,Crt)),
	not(used_rule(_,R,C,P,Crt)),	%la regola scatta durante il fireset e viene riasserita in frule
	maxidr(M),
	IdrNew is M+1,
	idrlist_upd(IdrNew),
	!,
	assert(verified(IdrNew,B)),   %Modifica apportata da Domenico V. - Revisione di Luigi Tedone
	assert(rule(IdrNew,R,C,P,Crt)),	%Revisione di Luigi Tedone
	assert(exp_rule(IdrNew,R,AllCond)),
	%%tracker. Idr -> IdrNew ...
	assert(tracker(Idr,IdrNew)).	%Revisione di Luigi Tedone

	
	


%%%%%%%%%%%%%%%%%%%%%%% CODICE NON USATO 

% get_leafs(+Tree,-LeafList)
% Dato in input un albero restituisce una lista di tutte le sue foglie.
get_leafs(t(N,[]),[N]):-!.	
get_leafs([],[]).

get_leafs(t(_,Lista),L):-
	get_leafs(Lista,L).

get_leafs([T|Ts],L):-
	get_leafs(T,L1),
	get_leafs(Ts,L2),
	append(L1,L2,L).
	
% clean_tree(+Tree,Elem,-ResultTree)
% Dato in input un albero e un fatto da rimuovere,
% Restituisce un nuovo albero in cui sono rimossi tutti i nodi in cui era presente tale fatto.	
clean_tree(t(N,[]),X,t(NL,[])):-
	select([X,_],N,NL).
clean_tree(t(N,[]),_,t(N,[])).%radice


clean_tree(t(N,L),X,t(NL,RTreeL)):-
	select([X,_],N,NL),
	clean_tree(L,X,RTreeL).
	
clean_tree(t(N,L),X,t(N,RTreeL)):-
	clean_tree(L,X,RTreeL).

clean_tree([],_,[]).	
clean_tree([T|Ts],X,RTreeL):-
	clean_tree(Ts,X,RTree2L),
	clean_tree(T,X,RTree1),
	append_figlio(RTree1,RTree2L,RTreeL).
	
copy_keep_unification(C,R,Cdup,Rdup):-
		copy_term(C,Cdup),
		copy_term(R,Rdup),
		term_variables(Cdup,L2),
		term_variables(Rdup,L1),
		term_variables(C,L2o),
		term_variables(R,L1o),
		scandisci(L2o,L1o,L2,L1).
	
 scandisci([],_,[],_).	
	scandisci([L2o|RL2o],L1o,[L2|RL2],L1):-
		nth0_eq(I,L1o,L2o,_),
		nth0(I,L1,L2,_),
		!,%unificazione effettuata
		scandisci(RL2o,L1o,RL2,L1).
	scandisci([_|RL2o],L1o,[_|RL2],L1):-
	 %non è stato unificato
		scandisci(RL2o,L1o,RL2,L1).	
		
 nth0_eq(V, In, Element, Rest) :-
 	var(V), !,
        generate_nth_eq(0, V, In, Element, Rest).
 %nth0_eq funzionante solo per variabili
 %nth0_eq(V, In, Element, Rest) :-
 %	must_be(nonneg, V),
 %	find_nth0(V, In, Element, Rest).	
	
generate_nth_eq(I, I, [H|Rest], Head, Rest):-H==Head.
generate_nth_eq(I, IN, [H|List], El, [H|Rest]) :-
        I1 is I+1,
generate_nth_eq(I1, IN, List, El, Rest).

/*
variante di make_permutation_tree  per avere ogni permutazione con più elementi come figlia della precedente
ingloba il metodo make_tree

make_permutation_tree(N,F,Cf,TreeList):-
		findall(Sost,replace_fact(N,F,Cf,Sost),Permutation), %ottengo tutte le permutazioni delle condizioni
		make_permutation_tree1(Permutation,F,Cf,TreeList).

	make_permutation_tree1([],F,Cf,[]).
	make_permutation_tree1([L|RL],F,Cf,TreeList):-
		make_permutation_tree(L,F,Cf,TreeList99),
		make_permutation_tree1(TreeList99,F,Cf,TreeList990),
		make_permutation_tree1(RL,F,Cf,TreeList1),
		append([t(L,TreeList990)],TreeList1,TreeList).
		
		
		es
		t([f(_),f(_),f(_)],
  [ t([[f(1),1],f(_),f(_)],
      [ t(t([[f(1),1],[f(1),1],f(_)],
	    [t(t([[f(1),1],[f(1),1],[f(1),1]],[]),[])]),
	  []),
	t(t([[f(1),1],f(_),[f(1),1]],
	    [t(t([[f(1),1],[f(1),1],[f(1),1]],[]),[])]),
	  [])
      ]),
    t([f(_),[f(1),1],f(_)],
      [ t(t([[f(1),1],[f(1),1],f(_)],
	    [t(t([[f(1),1],[f(1),1],[f(1),1]],[]),[])]),
	  []),
	t(t([f(_),[f(1),1],[f(1),1]],
	    [t(t([[f(1),1],[f(1),1],[f(1),1]],[]),[])]),
	  [])
      ]),
    t([f(_),f(_),[f(1),1]],
      [ t(t([[f(1),1],f(_),[f(1),1]],
	    [t(t([[f(1),1],[f(1),1],[f(1),1]],[]),[])]),
	  []),
	t(t([f(_),[f(1),1],[f(1),1]],
	    [t(t([[f(1),1],[f(1),1],[f(1),1]],[]),[])]),
	  [])
      ])
  ])
		
		
	*/
	
/*

variante di make_permutation_tree  per avere ogni permutazione singola, quindi che utilizzi il vincolo Object Identity

make_permutation_tree(N,F,Cf,Permutation):-
		findall(Sost,replace_fact(N,F,Cf,Sost),Permutation). %ottengo tutte le permutazioni delle condizioni

	*/
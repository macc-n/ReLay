/************************************************************************
        Nome: gie_operation.pl
        
	Realizzazione: Luglio, 2015
  		Obiettivo: Separare la logica del funzionamento delle operazioni prolog-based inserite nelle condizioni delle regole dal resto del motore forward.
       		
			Autori: Liso Giuseppe, Proscia Adriano
			
			Revisore: Vincenzo Raimondi  
	
	Revisione: Ottobre, 2016
	Autori: Iovine A. - Lovascio C.
		Obiettivo: Aggiunta dell'operatore not_exists
			-Modifiche in evaluate_cond
*************************************************************************/



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% call_p\2 deprecato
evaluate_cond([call_p(S, Z)|List],EvList):-
        call_p(S),
		 !,
        assert(explainer(call_p(S,Z),0,'Operazione Call '+S,[])),
		evaluate_cond(List,EvList1), %vincenzo modifica per più condizioni contemporanee
		append([1],EvList1,EvList) %operazone effettuata con successo, le variabili saranno bind anche in altri predicati della stessa regola
       .
evaluate_cond([call_p(X, Y)|List],EvList):-
        !,
        %call_p(S), valutare S ha fallito
		evaluate_cond(List,EvList1), %vincenzo modifica per più condizioni contemporanee
		append([call_p(X, Y)],EvList1,EvList).
		
	

% evaluate_cond(+Call_p_List,-Evalutated_List)
% Dato in input una lista il cui primo elemento sia un predicato di tipo call_p\1,
% esegue il predicato e in caso di non fallimento sostituisce la sua dichiarazione nella lista con il valore 1.
% il valore 1 indica che l'operazione è stata eseguita con successo, e quindi è una condizione verificata.
% Autore: Vincenzo Raimondi
evaluate_cond([call_p(S)|List],EvList):-
        call_p(S),
		 !,
        assert(explainer(call_p(S),0,'Operazione Call '+S,[])),
		evaluate_cond(List,EvList1), %vincenzo modifica per più condizioni contemporanee
		append([1],EvList1,EvList) %operazone effettuata con successo, le variabili saranno bind anche in altri predicati della stessa regola
       .
evaluate_cond([call_p(X)|List],EvList):-
        !,
		evaluate_cond(List,EvList1), %vincenzo modifica per più condizioni contemporanee
		append([call_p(X)],EvList1,EvList).
		
evaluate_cond([],[]):-
    !.


	%%%%%%%%%%Codice per scandire altre condizioni di tipo non call_p
	
	evaluate_cond([and(A)|B],EvList):-
		evaluate_cond(A,EvList1),
		evaluate_cond(B,EvList2),
		append([and(EvList1)],EvList2,EvList).
	
	evaluate_cond([or(A)|B],EvList):-
		evaluate_cond(A,EvList1),
		evaluate_cond(B,EvList2),
		append([or(EvList1)],EvList2,EvList).
	
	evaluate_cond([no(A)|B],EvList):-
		evaluate_cond([A],[EvList1]),
		evaluate_cond(B,EvList2),
		append([no(EvList1)],EvList2,EvList).
	
	evaluate_cond([not_exists(A)|B],EvList):-
		evaluate_cond([A],[EvList1]),
		!,
		evaluate_cond(B,EvList2),
		append([not_exists(EvList1)],EvList2,EvList).
	
	evaluate_cond([A|B],EvList):-
		evaluate_cond(B,EvList1),
		append([A],EvList1,EvList).

	evaluate_cond(and(L),and(NC)):-
	evaluate_cond(L,NC).

evaluate_cond(or(L),or(NC)):-
	evaluate_cond(L,NC).
		
call_p(S) :-
catch(S, X, error_process(X)). % in caso di eccezione il ciclo segnerà fallimento e continuerà. 
%error_process(instantiation_error).   
error_process(_):- fail.
	


%%%%%%%%%%%%%%CODICE non utilizzato
operation:-
	rule(_,_,C,_,_),
	(C=and(X) ; C=or(X)),
	evaluate_cond(X).
operation. %vincenzo, passo base
	

find_operation(or([L|Lr]),NC):-
	find_operation(L,NC1),
	!,
	find_operation(or(Lr),NC2),
	append(NC1,NC2,NC).

find_operation(or([]),[]):-!.

find_operation(or([call_p(X,Y)|Lr]),NC):-
	find_operation(or(Lr),NL),
	append([call_p(X,Y)],NL,NC).
find_operation(or([_|Lr]),NC):-
	find_operation(or(Lr),NC).

find_operation(no(call_p(X,Y)),[call_p(X,Y)]).
find_operation(no(_),_).



	
	
	find_operation(and([L|Lr]),NC):-
	find_operation(L,NC1),
	!,
	find_operation(and(Lr),NC2),
	append(NC1,NC2,NC).

find_operation(and([]),[]):-!.

find_operation(and([call_p(X,Y)|Lr]),NC):-
	find_operation(and(Lr),NL),
	append([call_p(X,Y)],NL,NC).
	
find_operation(and([_|Lr]),NC):-
	find_operation(and(Lr),NC).
	

find_operation(or([L|Lr]),NC):-
	find_operation(L,NC1),
	!,
	find_operation(or(Lr),NC2),
	append(NC1,NC2,NC).

find_operation(or([]),[]):-!.

find_operation(or([call_p(X,Y)|Lr]),NC):-
	find_operation(or(Lr),NL),
	append([call_p(X,Y)],NL,NC).
find_operation(or([_|Lr]),NC):-
	find_operation(or(Lr),NC).

find_operation(no(call_p(X,Y)),[call_p(X,Y)]).
find_operation(no(_),_).


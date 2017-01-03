:- multifile (rule/5).
/*************************************************************************
        Nome: gie_utility.pl
        
	Realizzazione: Settembre, 2013
        	Descrizione: Modulo di Utilities del sistema GIE
        	Autore: Nicola Milella

      	Revisioni: Febbraio, 2014
       	Autore: Francesco Solare

		Procedura: save/0
		Obiettivo: Taglio e riuso (con opportune modifiche)
		Output: procedura save_dedfact/0 in seva_utility.pl

		Procedura: idflist/0
		Obiettivo: Snellimento e Pulizia del Codice
		Autore: Francesco Solare 

		Predicato: initfacts/1 - initrules/1
		Obiettivo: Taglio e riuso (con opportune modifiche)
		Output: configurazione iniziale definita in seva_setting.pl  	

		
	    Revisioni: Ottobre, 2014
       Autore: Morisco M. - Petrera M.
       Obiettivo:
       Inserimento dei predicati necessari alle operazioni aritmetiche creati da Giannico e Fiorella.		
		
		Revisione: Ottobre, 2016
		Autori: Iovine A. - Lovascio C.
		
		Obiettivo: 
			-Aggiunta dell'operatore not_exists
				-Modifiche in get_min
				-Modifiche in get_max
			-Gestione dell'inizializzazione dei moduli
				-Procedure initialfact/1 e initialfacts/1
				-Procedure initialrule/1 e initialrules/1
				-Modifiche in initializefacts
*************************************************************************/
:- dynamic idr/1.
:- dynamic idf/1.
:- dynamic fact/3.
:- dynamic rule/5.
:- dynamic used_fact/3.
:- dynamic used_rule/5.
:- dynamic initfacts/1.
:- dynamic initrules/1.
:- dynamic maxinitialidr/1.
:- dynamic maxinitialidf/1.
:- dynamic maxidr_val/1. %Vincenzo
:- dynamic maxidf_val/1.
:- dynamic asserting_head/4.
/*************************************************************************
        Utilities per il calcolo del minimo/massimo 
	di liste normali e NON normali
*************************************************************************/
%Calcolo del minimo
get_min([X],Min) :- 
	Min = X,
	number(Min),
	!. %MODIFICAMINAFRA
get_min([and(L),Y|T],Min) :-
	!,
	get_min(L,M),
	get_min([M,Y|T],Min).
get_min([X,and(L)|T],Min) :-
	!,
	get_min(L,M),
	get_min([X,M|T],Min).
get_min([or(L),Y|T],Min) :-
	!,
	get_max(L,M),
	get_min([M,Y|T],Min).
get_min([X,or(L)|T],Min) :- 
	!,
	get_max(L,M),
	get_min([X,M|T],Min).
get_min([no(L),Y|T],Min) :-
	!,
	M is 1 - L,
	get_min([M,Y|T],Min).
get_min([X,no(L)|T],Min) :-
	!,
	M is 1 - L,
	get_min([X,M|T],Min).
get_min([not_exists(-1)],1) :-
	!.
get_min([not_exists(L)],0) :-
	get_val(L,Min,_),
	Min >= 0,
	!.
get_min([not_exists(L)],1) :-
	!,
	get_val(L,Min,_).
get_min([not_exists(-1),Y|T],Min) :-
	!,
	get_min([1,Y|T],Min).
get_min([not_exists(L),Y|T],Min) :-
	!,
	get_min([0,Y|T],Min).
get_min([X,not_exists(-1)|T],Min) :-
	!,
	get_min([X,1|T],Min).
get_min([X,not_exists(L)|T],Min) :-
	!,
	get_min([X,0|T],Min).
	
% Questa regola è stata spostata in basso	
get_min([_],Min) :- 
	Min = 0,
	!. %MODIFICAMINAFRA
get_min([X,Y|T],Min) :-
	not(number(X)),
	functor(X,N,_),
	N\==and,
	N\==or,
	N\==no,
	N\==not_exists,
	!, %MODIFICAMINAFRA
	get_min([Y|T],Min).
get_min([X,Y|T],Min) :-
	not(number(Y)),
	functor(Y,N,_),
	N\==and,
	N\==or,
	N\==no,
	N\==not_exists,
	!, %MODIFICAMINAFRA
	get_min([X|T],Min).
get_min([X,Y|T],Min) :- 
	X<Y,
	!,
	get_min([X|T],Min).
get_min([_,Y|T],Min) :-
	get_min([Y|T],Min).

%Calcolo del massimo
get_max([X],Max) :- 
	Max = X,
	number(Max),
	!. %MODIFICAMINAFRA
get_max([_],Max) :- 
	Max = 0,
	!. %MODIFICAMINAFRA
get_max([and(L),Y|T],Max) :-
	!,
	get_min(L,M),
	get_max([M,Y|T],Max).
get_max([X,and(L)|T],Max) :-
	!,
	get_min(L,M),
	get_max([X,M|T],Max).
get_max([or(L),Y|T],Max) :-
	!,
	get_max(L,M),
	get_max([M,Y|T],Max).
get_max([X,or(L)|T],Max) :-
	!,
	get_max(L,M),
	get_max([X,M|T],Max).
get_max([no(L),Y|T],Max) :-
	!,
	write('SAI '),
	write('L ' ),
	M is 1 - L,
	get_max([M,Y|T],Max).
get_max([X,no(L)|T],Max) :-
	!,
	write('SAI '),
	write('L ' ),
	M is 1 - L,
	get_max([X,M|T],Max).
	
get_max([not_exists(-1)],1) :-
	!.
get_max([not_exists(L)],0) :-
	get_val(L,Min,_),
	Min >= 0,
	!.
get_max([not_exists(L)],1) :-
	!,
	get_val(L,Min,_).
get_max([not_exists(-1),Y|T],Min) :-
	!,
	get_max([1,Y|T],Min).
get_max([not_exists(L),Y|T],Min) :-
	!,
	get_max([0,Y|T],Min).
get_max([X,not_exists(-1)|T],Min) :-
	!,
	get_max([X,1|T],Min).
get_max([X,not_exists(L)|T],Min) :-
	!,
	get_max([X,0|T],Min).
	
get_max([X,Y|T],Max) :-
	not(number(X)),
	functor(X,N,_),
	N\==and,
	N\==or,
	N\==no,
	N\==not_exists,
	!, %MODIFICAMINAFRA
	get_max([Y|T],Max).
get_max([X,Y|T],Max) :-
	not(number(Y)),
	functor(Y,N,_),
	N\==and,
	N\==or,
	N\==no,
	N\==not_exists,
	!, %MODIFICAMINAFRA
	get_max([X|T],Max).
get_max([X,Y|T],Max) :- 
	X > Y,
	!,
	get_max([X|T],Max).
get_max([_,Y|T],Max) :-
	get_max([Y|T],Max).
	

get_add([X,Y], Add) :-  
	number(X),
	number(Y),
	Add is X + Y.
	
get_mul([X,Y], Mul) :-  
	number(X),
	number(Y),
	Mul is X * Y.
	
get_div([X,Y], Div) :-  
	number(X),nl,  %Vincenzo a che serve aggiungere una riga?
	number(Y),
	Div is X / Y.
	
get_minus([X,Y], Minus) :-  
	number(X),nl, 
	number(Y),
	Minus is X - Y.




	
/*************************************************************************
        Utilities di aggiornamento degli "id" di fatti e regole
*************************************************************************/
%Crea la lista di tutti gli id delle regole presenti nella kb
idrlist :-
	rule(Idr,_,_,_,_),
	idr(L),
	append([Idr],L,Ln),
	retract(idr(L)),
	assert(idr(Ln)),
	fail.
idrlist.

%Aggiunge il nuovo id alla lista
idrlist_upd(Idr) :-
	idr(L),
	append([Idr],L,Ln),
	retract(idr(L)),
	assert(idr(Ln)),
	retract(maxidr_val(_)),%VINCENZO
	assert(maxidr_val(Idr)).%VINCENZO il nuovo valore massimo sarà proprio il nuovo valore aggiunto

%Calcola l'ultimo id 
maxidr(M) :-
	maxidr_val(M). %VINCENZO
	%idr(L),
	%get_max(L,M).

%Aggiunge il nuovo id alla lista
idflist_upd(Idf) :-
	idf(L),
	append([Idf],L,Ln),
	retract(idf(L)),
	assert(idf(Ln)),
	retract(maxidf_val(_)),%VINCENZO
	assert(maxidf_val(Idf)).%VINCENZO il nuovo valore massimo sarà proprio il nuovo valore aggiunto.

%Calcola l'ultimo id 
maxidf(M) :-
	maxidf_val(M). %VINCENZO
	%idf(L),
	%get_max(L,M).

/*************************************************************************
        Utilities per l'inizializzazione/reinizializzazione 
	dell'ambiente
*************************************************************************/
% Crea la lista contenente gli id delle regole iniziali
initialrules :-
	rule(Idr,_,_,_,_),
	initrules(I),
	idr(L),
	append([Idr],L,Ln),
	retract(idr(L)),
	assert(idr(Ln)),
	append([Idr],I,In),
	retract(initrules(I)),
	assert(initrules(In)),
	fail.
initialrules :-
	initrules(I),
	get_max(I,M),
	assert(maxinitialidr(M)),
	assert(maxidr_val(M)),!.%vincenzo
	
% Inizializzazione delle regole di un modulo con nome
initialrules(ModuleName) :-
	rule(id(ModuleName, N),_,_,_,_),
	initrules(I),
	idr(L),
	append([id(ModuleName, N)],L,Ln),
	retract(idr(L)),
	assert(idr(Ln)),
	append([Idr],I,In),
	retract(initrules(I)),
	assert(initrules(In)).
	
initialrules(ModuleName).

% Inizializzazione delle regole di un modulo anonimo
initialrule(rule(Idr, F, Cond, P, Crt)) :-
	initrules(I),
	idr(L),
	append([Idr],L,Ln),
	retract(idr(L)),
	assert(idr(Ln)),
	append([Idr],I,In),
	retract(initrules(I)),
	assert(initrules(In)).

%Crea la lista contenente gli id dei fatti iniziali
initialfacts :-
	fact(Idf,_,_),
	initfacts(I),
	idf(L),
	append([Idf],L,Ln),
	retract(idf(L)),
	assert(idf(Ln)),
	append([Idf],I,In),
	retract(initfacts(I)),
	assert(initfacts(In)),
	fail.
initialfacts :-
	initfacts(I),
	get_max(I,M),
	assert(maxinitialidf(M)),
	assert(maxidf_val(M)),!. %vincenzo
	
%Inizializzazione dei fatti di un modulo anonimo
initialfact(fact(Idf, F, C)) :-
	initfacts(I),
	idf(L),
	append([Idf],L,Ln),
	retract(idf(L)),
	assert(idf(Ln)),
	append([Idf],I,In),
	retract(initfacts(I)),
	assert(initfacts(In)).

%Inizializzazione dei fatti in un modulo con nome
initialfacts(ModuleName) :-
	fact(id(ModuleName, N),_,_),
	initfacts(I),
	idf(L),
	append([id(ModuleName, N)],L,Ln),
	retract(idf(L)),
	assert(idf(Ln)),
	append([id(ModuleName, N)],I,In),
	retract(initfacts(I)),
	assert(initfacts(In)).
	
initialfacts(ModuleName).

%Rimuove tutti i fatti asseriti, lasciando quelli originali
initializefacts([]) :-
	retractall(used_fact(_,_,_)),
	retract(idf(_)),
	assert(idf([])).				 
initializefacts([Idf|T]) :-
	used_fact(Idf,F,Crt),
	asserta(fact(Idf,F,Crt)),
	!,		% Modifica Iovine-Lovascio
	initializefacts(T).
	
% Modifica Iovine-Lovascio
initializefacts([Idf|T]) :-
	initializefacts(T).

%Rimuove tutte le regole asserite, lasciando quelle originali
initializerules :-
	rule(Idr,_,_,_,_),
	initrules(I),
	not(member(Idr,I)),
	retract(rule(Idr,_,_,_,_)),
	fail.
initializerules :-
	retractall(used_rule(_,_,_,_,_)),
	retractall(irule(_,_,_)),
	retract(idr(_)),
	assert(idr([])).

%Data una condizione, restituisce la stessa inizializzata con lista vuota
getfunct(X,F) :-
	functor(X,N,_),
	N==and,
	F=and([]),!.
getfunct(X,F) :-
	functor(X,N,_),
	N==or,  
	F=or([]),!.
getfunct(X,F) :-
	functor(X,N,_),
	N==no,
	F=no(0),!.
getfunct(X,F) :-
	functor(X,N,_),
	N==not_exists,
	F=not_exists(-1),!.		
getfunct(X,F) :-
	functor(X,N,_),
	N==add,
	F=add([]),!.
getfunct(X,F) :-
	functor(X,N,_),
	N==mul,
	F=mul([]),!.	
getfunct(X,F) :-
	functor(X,N,_),
	N==div,
	F=div([]),!.	
getfunct(X,F) :-
	functor(X,N,_),
	N==minus,
	F=minus([]),!.	
	
	

/*************************************************************************
        Utility per l'ordinamento della lista di [id,priority]
*************************************************************************/
sort_list(L,Sorted) :-
	exchange(L,L1),!,
	sort_list(L1,Sorted).				
% nessuno scambio e' possibile. la lista è sorted
sort_list(Sorted,Sorted).
% X e Y vanno scambiati
exchange([[Ix,X],[Iy,Y]|Rest],[[Iy,Y],[Ix,X]|Rest]) :- 
	X < Y.
% si cerca di fare uno scambio nella coda
exchange([[Ix,X]|Rest],[[Ix,X]|Rest1]) :- 
	exchange(Rest,Rest1).

/*************************************************************************
	Crea la lista di tutti gli id dei fatti presenti nella kb. 
	VARIANTE - è stata inglobata in initialfacts/0.
idflist :-
	fact(Idf,_,_),
	idf(L),
	append([Idf],L,Ln),
	retract(idf(L)),
	assert(idf(Ln)),
	fail.
idflist.

        Utility per il salvataggio dei fatti dedotti nella kb corrente

save :-
	curr_kb(Kb),
	open(Kb,append,Stream),
	initfacts(If),
	write(Stream,'%New facts'),
	nl(Stream),
	write_fact(Stream,If),
	close(Stream).
			   
write_fact(Stream,If) :-
	used_fact(Idf,F,Cf),
	not(member(Idf,If)),
	write(Stream,'fact('),
	write(Stream,Idf),
	write(Stream,', '),
	write(Stream,F),
	write(Stream,', '),
	write(Stream,Cf),
	write(Stream,').'),
	nl(Stream),
	fail.
write_fact(Stream,If).
*************************************************************************/


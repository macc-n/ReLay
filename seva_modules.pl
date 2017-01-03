/**
*        Nome: seva_modules.pl
*
*	Realizzazione: Settembre, 2016
* 		Obiettivo: Implementare il caricamento e lo scaricamento dei moduli
*     		Autori: Andrea Iovine, Cosimo Lovascio
*
**********************************************/

:- use_module(library(lineutils)).
:- use_module(library(charsio)).

% scarica il modulo di nome Module

unload(Module) :-
	retractall(rule(id(Module, _), _, _, _, _)),
	retractall(used_rule(id(Module, _), _, _, _, _)),
	retractall(irule(id(Module, _), _, _)),
	retractall(t_rule(id(Module, _), _)).
	
/*
	Caricamento iniziale del modulo
*/	
	
load_first(ModulePath) :-
	open(ModulePath, 'read', Stream),  				 %Carica il file
	readModuleName(Stream, ModuleName),				 %Leggi il nome del modulo, se presente
	close(Stream),
	!,
	open(ModulePath, 'read', Stream2), 
	readAssertionsFromModule(ModuleName, Stream2).
	
% Nel caso il modulo non ha nome
load_first(ModulePath) :-
	open(ModulePath, 'read', Stream), 
	readAssertionsFromModule(Stream).

/**
	Caricamento dei moduli durante il processo di inferenza
*/
	
% Caso in cui il file possiede un nome di modulo
load(ModulePath) :-
	getAbsolutePath(ModulePath, AbsPath),
	open(AbsPath, 'read', Stream),  				 %Carica il file
	readModuleName(Stream, ModuleName),				 %Leggi il nome del modulo, se presente
	close(Stream),
	!,
	load2(AbsPath, ModuleName).
		
	
load2(ModulePath, ModuleName) :-
	check_not_already_loaded(ModuleName),			%Controlla che il modulo non sia già caricato
	open(ModulePath, 'read', Stream2), 
	readAssertionsFromModule(ModuleName, Stream2),
	deuse_facts,
	indexing,
	init_trees(ModuleName),
	initialfacts(ModuleName).
	initialrules(ModuleName).
	
load2(ModulePath, ModuleName).

% Nel caso in cui il modulo non dispone di un nome, si usa un semplice
% id incrementale.
load(ModulePath) :-
	getAbsolutePath(ModulePath, AbsPath),
	open(AbsPath, 'read', Stream), 
	readAssertionsFromModule(Stream),
	deuse_facts,
	indexing.
	
load(ModulePath).
	
% Controlla se non sia già stato caricato un modulo con lo stesso nome
check_not_already_loaded(ModuleName) :-
	not(rule(id(ModuleName, _), _, _, _, _)),
	not(fact(id(ModuleName, _), _, _)).
	
/**
	Lettura del nome del modulo
*/
	
% Legge il nome del modulo. Il nome del modulo deve essere specificato
% con il predicato module_name(Nome). Il nome del modulo deve essere 
% il primo predicato del file.
readModuleName(Stream, ModuleName) :-
	read(Stream, Assertion),
	readModuleName(Stream, Assertion, ModuleName).

readModuleName(Stream, module_name(ModuleName), ModuleName).

readModuleName(Stream, end_of_file, ModuleName) :- !, fail.

/**
	Lettura del file
*/	
	
	
% Legge i predicati Prolog uno alla volta	
readAssertionsFromModule(ModuleName, Stream) :-
	read(Stream, X),
	dispatchAssertion(ModuleName, Stream, X).
	
% Versione senza il nome del modulo
readAssertionsFromModule(Stream) :-
	read(Stream, X),
	dispatchAssertion(Stream, X).

/**
	Versione con il nome del modulo
**/	
	
% Se si è raggiunta la fine del file, termina l'esecuzione.
dispatchAssertion(ModuleName, Stream, end_of_file) :- !.

% Se l'asserzione letta è una regola, creala
dispatchAssertion(ModuleName, Stream, rule(IDNumber, Con, Ant, Prior, Crt)) :-
	makeARule(ModuleName, rule(IDNumber, Con, Ant, Prior, Crt)),
	!,
	readAssertionsFromModule(ModuleName, Stream).			%ripeti
	
dispatchAssertion(ModuleName, Stream, fact(IDNumber, Fact, Crt)) :-
	makeAFact(ModuleName, fact(IDNumber, Fact, Crt)),
	!,
	readAssertionsFromModule(ModuleName, Stream).  			%ripeti
	
dispatchAssertion(ModuleName, Stream, module_name(_)) :-
	!,
	readAssertionsFromModule(ModuleName, Stream).  			%ripeti
	
dispatchAssertion(ModuleName, Stream, X) :-
	makeAPrologClause(X),
	!,
	readAssertionsFromModule(ModuleName, Stream).  			%ripeti

% Crea una regola, modifica l'ID secondo la struttura id(Modulo, Numero) e la aggiunge alla KB
makeARule(ModuleName, rule(IDNumber, Con, Ant, Prior, Crt)) :-
	assert(rule(id(ModuleName, IDNumber), Con, Ant, Prior, Crt)).
	
% Crea un fatto, modifica l'ID secondo la struttura id(Modulo, Numero) e lo aggiunge alla KB
makeAFact(ModuleName, fact(IDNumber, Fact, Crt)) :-
	assert(fact(id(ModuleName, IDNumber), Fact, Crt)).
	
/**
	Versione senza nome del modulo
**/
	
% Se si è raggiunta la fine del file, termina l'esecuzione.
dispatchAssertion(Stream, end_of_file) :- !.

% Se l'asserzione letta è una regola, creala
dispatchAssertion(Stream, rule(IDNumber, Con, Ant, Prior, Crt)) :-
	makeARule(rule(IDNumber, Con, Ant, Prior, Crt)),
	!,
	readAssertionsFromModule(Stream).			%ripeti
	
dispatchAssertion(Stream, fact(IDNumber, Fact, Crt)) :-
	makeAFact(fact(IDNumber, Fact, Crt)),
	!,
	readAssertionsFromModule(Stream).  			%ripeti
	
dispatchAssertion(Stream, X) :-
	makeAPrologClause(X),
	!,
	readAssertionsFromModule(Stream).  			%ripeti
	

% Caso in cui la regola è caricata durante il processo di inferenza,
% Bisogna aggiornare l'id in modo corretto
makeARule(rule(IDNumber, Con, Ant, Prior, Crt)) :-
	maxidr(M),
	IdrNew is M + 1,
	idrlist_upd(IdrNew),
	assert(rule(IdrNew, Con, Ant, Prior, Crt)),
	init_tree(rule(IdrNew, Con, Ant, Prior, Crt)),
	initialrule(rule(IdrNew, Con, Ant, Prior, Crt)).

% Caso in cui la regola è caricata all'inizio
% Si usa semplicemente l'id scritto nel file
makeARule(rule(IDNumber, Con, Ant, Prior, Crt)) :-
	assert(rule(IDNumber, Con, Ant, Prior, Crt)).
	
% Caso in cui il fatto è caricato durante il processo di inferenza,
% Bisogna aggiornare l'id in modo corretto
makeAFact(fact(IDNumber, Fact, Crt)) :-
	maxidf(M),
	IdfNew is M + 1,
	idflist_upd(IdfNew),
	assert(fact(IdfNew, Fact, Crt)),
	initialfact(fact(IdfNew, Fact, Crt)).
	
% Caso in cui il fatto è caricato all'inizio
% Si usa semplicemente l'id scritto nel file
makeAFact(fact(IDNumber, Fact, Crt)) :-
	assert(fact(IDNumber, Fact, Crt)).
	
	
% Caricamento di una clausola prolog pura
makeAPrologClause(X) :-
	catch(assert(X), error(permission_error(_,_,_),_), true).
	
	
/*****
	Utility per la lettura del path
*****/	

getAbsolutePath(Filename, AbsPath) :-
	curr_rules(KbPath),
	atom_to_chars(KbPath, KbPathS),
	readPath(KbPathS, DirectoryS),
	atom_to_chars(Filename, FilenameS),
	append(DirectoryS, FilenameS, AbsPathS),
	name(AbsPath, AbsPathS).

% Legge il path di un file, e restituisce la directory in cui esso si trova
readPath(PathS, CompletePathS) :-
	starts_with_slash(PathS),		% Se il path comincia per slash, bisogna aggiungerlo all'inizio
	split(PathS, "/", Split),
	buildPath(Split, CompletePathWOSlash),
	append("/", CompletePathWOSlash, CompletePathS).
	
readPath(PathS, CompletePathS) :-
	split(PathS, "/", Split),
	buildPath(Split, CompletePathS).

buildPath([H|T], X) :-
	buildPath([H|T], "", X).

buildPath([H|[]], Partial, Partial) :- !.
	
buildPath([H|T], Partial, X) :-
	append(H, "/", Concat),
	append(Partial, Concat, C),
	buildPath(T, C, X).

% Verifica se il path del file comincia con /	
starts_with_slash([C|T]) :-
	char_code(/, Code),
	C =:= Code.
	
	
	
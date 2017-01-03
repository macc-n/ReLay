/*************************************************************************
        Nome: seva_textgui.pl
        
	Realizzazione: Febbraio, 2014
  		Obiettivo: GUI testuale del SEVA
       		Autore: Francesco Solare
       	 
*************************************************************************/
/****************************
	SEVA/GIE GENERIC
****************************/
gui_seva(heading) :- 
	nl,
        write('@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@'),nl,
        write('@                                UNIBA                                  @'),nl,
	    write('@                        ARTIFICIAL INTELLIGENCE                        @'),nl,
        write('@-----------------------------------------------------------------------@'),nl,
        write('@                                ReLay                                  @'),nl,
        write('@           (Sistema Esperto sulla gestione di varie componenti)        @'),nl,
        write('@                       Autore: Visaggio Domenico                       @'),nl,

	write('@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@').
gui_seva(menu) :- 	
        nl,nl,write('     *************************** MENU ******************************'),	
	nl,nl,write('     1 - Load Knowledge Base. '),      % modifica Anzivino giuseppe, Pasquadibisceglie Vincenzo, Zaza Gianluca, Novembre 2016
	nl,write('     2 - Load facts. '),                % modifica Anzivino giuseppe, Pasquadibisceglie Vincenzo, Zaza Gianluca, Novembre 2016
	nl,write('     3 - Start GIE - Generic Inferential Engine. '),
	nl,write('     4 - Saving Adjustments. '),
	nl,write('     5 - Explain Deductions. '),
	nl,write('     6 - Ask Questions.'),
	nl,write('     7 - Reinizialize SEVA Environment. '),	
	nl,write('     8 - Refresh Working Memory. '),
	nl,write('     9 - Modify membership setting. '),   %aggiunto da Pasquadibisceglie V. - Zaza G.
	nl,write('    10 - Forced Removal. '),   %aggiunto da Bruno S. - Morelli N. - Pinto A.
	nl,write('    11 - Filters. '),   %aggiunto da Bruno S. - Morelli N. - Pinto A.
	nl,write('    12 - GIE with RETE pattern matchin. '),	%aggiunto da noi
	nl,write('     0 - Exit. '),
	nl,nl,write('     Type number: ').
gui_seva(closing) :- 
        nl,write('@--------------------------- CLOSING ------------------------------@').

gui_gie(heading) :- 
	nl,write('@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@'),
	nl,write('@                                                                       @'),
	nl,write('@                     GIE - Generic Inferential Engine                  @'),
        nl,nl,write('     ********************** START INFERENCE ************************'),nl,nl.
gui_gie(closing) :- 
        nl,nl,write('     ************************* FINISH ******************************'),
	nl,write('@                                                                       @'),
	nl,write('@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@').

/****************************
	SEVA POPUP
****************************/

 % modifica Anzivino giuseppe, Pasquadibisceglie Vincenzo, Zaza Gianluca, Novembre 2016
 % aggiunto gui_popup(info6), modificato gui_popup(wrong1), modificato gui_popup(wrong2), aggiunto gui_popup(wrong6)


gui_popup(info0) :-
	nl,write('     _____________________ STAGE COMPLETED _____________________       '),nl.
gui_popup(info1) :-
	nl,write('     ___________________ WARNING: reccurring choice ____________       '),
	nl,write('     Explain: loading knowledge base completed.'),nl.
gui_popup(info2) :-
	nl,write('     ___________________ WARNING: reccurring choice ____________       '),
	nl,write('     Explain: processing GIE completed.'),nl.
gui_popup(info3) :-
	nl,write('     ___________________ WARNING: reccurring choice ____________       '),
	nl,write('     Explain: saving deductions completed.'),nl.
gui_popup(info4) :-
	nl,write('     ___________________ QUESTION ____________       '),
	nl,write('     Insert the question to ask: '),nl.
gui_popup(info5) :-
	nl,nl,write('     ____________ INFORMING: no answer found ___________          '),
	nl,write('     Explain: There is no answer to the question'),nl.
gui_popup(info6) :-
	nl,write('     ___________________ WARNING: reccurring choice ____________       '),
	nl,write('     Explain: loading facts completed.'),nl.
gui_popup(info7) :-
	nl,write('     ___________________ FORCED REMOVAL ____________       '),
	nl,write('     Insert the fact to not assert during the GIE process: '),nl.
gui_popup(saving) :-
	curr_flog(FileLog),
	nl,nl,write('     ____________ INFORMING: saving of deductions ___________          '),
	nl,write('     Explain: saving completed on "'),write(FileLog),write('".'),nl.
gui_popup(wrong0) :-
	nl,write('     ___________________ WARNING: wrong choice _________________       '),
	nl,write('     Explain: type one of the number corresponding to the choices above, please.'),nl.
gui_popup(wrong1) :-
	nl,write('     ___________________ WARNING: wrong choice _________________       '),
	nl,write('     Explain: first one produce inferences (choice 3), please.'),nl.
gui_popup(wrong2) :-
	nl,write('     ___________________ WARNING: wrong choice _________________       '),
	nl,write('     Explain: first one load a knowledge base and facts (choice 1 - 2), please.'),nl.
gui_popup(wrong3) :-
	nl,write('     ___________________ WARNING: wrong choice _________________       '),
	nl,write('     Explain: SEVA Environment is already initialized.'),nl.
gui_popup(wrong4) :-
	nl,write('     ___________________ WARNING: wrong choice _________________       '),
	nl,write('     Explain: No one deduction to explain.'),nl.
gui_popup(wrong5) :-
	nl,write('     ___________________ WARNING: wrong choice _________________       '),
	nl,write('     Explain: Errore nel backward.'),nl.
gui_popup(wrong6) :-
	nl,write('     ___________________ WARNING: wrong choice _________________       '),
	nl,write('     Explain: first one load a knowledge base (choice 1), please.'),nl.
gui_popup(wrong7) :-
	nl,write('     ___________________ WARNING: wrong choice _________________       '),%aggiunto da Pasquadibisceglie V. - Zaza G.
	nl,write('     Explain: In order to change the membership values, the environment must be initialized, please.'),nl.	


/****************************
	FUZZY MODULE
****************************/
gui_fuzzymodule(loader) :-
	nl,nl,write('     *************************** LOADER ****************************'),
	nl,nl,write('     Insert path of complete knowledge base, please: '),nl.
	
% ---------------modifica Anzivino giuseppe, Pasquadibisceglie Vincenzo, Zaza Gianluca, Novembre 2016

gui_factsmodule(loaderfacts) :-
	nl,nl,write('     *************************** LOADER ****************************'),
	nl,nl,write('     Insert path of complete facts, please: '),nl.

% ---------------------------
	
gui_fuzzymodule(heading_fuzzyness) :-
	nl,write('@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@'),
	nl,write('@                                                                       @'),
	nl,write('@                           Fuzzyness Module                            @').
gui_fuzzymodule(heading_defuzzyness) :-
	nl,write('@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@'),
	nl,write('@                                                                       @'),
	nl,write('@                           Defuzzyness Module                          @'),
        nl,nl,write('     *********************** INIZIALIZING **************************'),nl.

gui_fuzzymodule(beginning) :-
	nl,nl,write('     *************************** START *****************************'),nl.
gui_fuzzymodule(closing) :-
	nl,nl,write('     *************************** FINISH ****************************'),
	nl,write('@                                                                       @'),
	nl,write('@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@').

/****************************
	EXPLAIN MODULE
****************************/
gui_expmodule(heading) :-
	nl,write('@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@'),
	nl,write('@                                                                                                @'),
	nl,write('@                                       Explain Module                                           @').
gui_expmodule(closing) :-
	nl,nl,write('@                                                                                                @'),
	nl,write('@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@').
/****************************
	BACKWARD MODULE
****************************/
gui_backmodule(heading) :-
	nl,write('@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@'),
	nl,write('@                                                                                                @'),
	nl,write('@                                       Backward Module                                           @').
	
gui_backmodule(beginning) :-
	nl,nl,write('     *************************** START *****************************'),nl.
gui_backmodule(closing) :-
	nl,nl,write('     *************************** FINISH ****************************'),
	nl,write('@                                                                       @'),
	nl,write('@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@').

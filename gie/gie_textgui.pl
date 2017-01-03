/*************************************************************************
        Nome: gie_textgui.pl
        
	Realizzazione: Luglio, 2015
  		Obiettivo: Separare il codice riguardante l'interfaccia da quello riguardante il funzionamento del programma
       		Autore: Vincenzo Raimondi
       	 
*************************************************************************/

gui_check_certainty(0) :- write('     Error: this fact will not be asserted, 0 means false.'),nl.

gui_check_certainty(IdfNew,R,Crt):- write('     Error: '),
	write('fact('),  write(IdfNew),write(', '),write(R),write(', '),write(Crt),
	write(') has wrong certainty value. It will not be asserted.').
	
gui_calculateK(Id,K1,C1):-write( ' ID is ' ),
					 write( Id),
					 write(' k is '),
					 write( K1 ),
					 write(' C1 is '),
					 write( C1 ).
					 
gui_mainloop(forward_finished):-write('     forward finished'),nl.
gui_mainloop(fire_finished):-write('     fire finished'),nl.
gui_mainloop(fact_finished):-nl,write('     No more facts to be analyzed'),nl.

gui_forward(Idf,F):-write('     forward using IDf:'),write(Idf),write(' fact:'),write(F),nl.
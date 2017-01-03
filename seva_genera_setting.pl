/***********************************************************************

Modulo: seva_genera_setting.pl 
Autori: Pasquadibisceglie V. - Zaza G.
Descrizione: Modulo che permette la modifica dei valori delle membership
             delle varibili linguistiche di: ufunctinput ed ufunctoutput .  


************************************************************************/



:- dynamic (ufunctoutput/4).
:- dynamic (ufunctinput/4).
:- dynamic (explainer/3).

inizio:-
        write('-------------------------------------MENU----------------------------------------'),nl,
        write('-----------------------------Modifiche membership--------------------------------'),nl,
        write('0- Ritorna al menu principale'),nl,
        write('1- Modifica membership input'),nl,
        write('2- Modifica membership output'),nl,
        read(Op),
	    scelta(Op).

scelta(0):-
    start.

scelta(1):-
    intestazione,    
    write('Lista variabili input: '),nl,
    stampaufunctioinput(X,Y,Z,W),nl,
    leggiInput,
    svuota,
    ricercaInput(X,Y,Z,W),
    !.

scelta(2):-
    intestazione,   
    write('Lista variabili output: '),nl,
    stampaufunctionoutput(X,Y,Z,W),nl,
    leggiOutput,
    svuota,
    ricercaOutput(X,Y,Z,W),
    !.



%---------------------------------------------------------------------------------------------------------------------------  
%---------------------------------------------------------------------------------------------------------------------------  

%Predicato che permette di azzerare il file
svuota:- 
    open('seva_setting_unfunction.pl',write,Stream),
    write(Stream,' '),
    close(Stream),
    intestazione.

leggiInput :-  scriviufunctioinput(X,Y,Z,W).
leggiOutput:- scriviufunctionoutput(X,Y,Z,W).

%Predicato per l'inizializzazione del file di seva_setting_unfunction
intestazione:-
        open('seva_setting_unfunction.pl',append,Stream),
        write(Stream,':- dynamic (ufunctoutput/4).'), 
        write(Stream,'\n'), 
        write(Stream,':- dynamic (ufunctinput/4).'), 
        write(Stream,'\n'),
        close(Stream).

%Predicato per la scrittura degli ufunctinput 
scriviufunctioinput(X,Y,Z,W) :- 
                ufunctinput(X,Y,Z,W),                  
                scriviFileInput(X,Y,Z,W),
                fail.
                scriviufunctioinput(X,Y,Z,W).

scriviFileInput(X,Y,Z,W):-  
         open('seva_setting_unfunction.pl',append,Stream),
         write(Stream,'ufunctinput('),
         write(Stream,X),write(Stream,','),
         write(Stream,Y),write(Stream,','),
         write(Stream,Z),write(Stream,','),
         write(Stream,W),write(Stream,').'),
         write(Stream,'\n'),
         close(Stream).

%Predicato per la stampa a video degli ufunctinput
stampaufunctioinput(X,Y,Z,W) :- 
                ufunctinput(X,Y,Z,W),                  
                write(Y),
                nl,
                fail.
                stampaufunctioinput(X,Y,Z,W).

%Predicato per la scrittura degli ufunctoutput
scriviufunctionoutput(X,Y,Z,W) :- 
                ufunctoutput(X,Y,Z,W),
                scriviFileOutput(X,Y,Z,W),               
                fail.
                scriviufunctionoutput(X,Y,Z,W).

scriviFileOutput(X,Y,Z,W):-
         open('seva_setting_unfunction.pl',append,Stream),
         write(Stream,'ufunctoutput('),
         write(Stream,X),write(Stream,','),
         write(Stream,Y),write(Stream,','),
         write(Stream,Z),write(Stream,','),
         write(Stream,W),write(Stream,').'),
         write(Stream,'\n'),
         close(Stream).


%Predicato per la stampa a video degli ufunctoutput
stampaufunctionoutput(X,Y,Z,W) :- 
                ufunctoutput(X,Y,Z,W),              
                write(Y),
                nl,
                fail.
                stampaufunctionoutput(X,Y,Z,W).

%Predicato di ricerca e della modifica delle variabili di input
ricercaInput(X,Y,Z,W):-
        write('Inserisci il nome della variabile linguistica di input da modificare: '),
        read(Elemento),
        nl,
        ufunctinput(X,Y,Z,W),                  
        Elemento==Y,
                write('Valore della membership attuale: '),
                write(W),
                nl,
                modificaInput(X,Y,Z,W),
        !,
        nl,
        fail.
        ricercaInput(X,Y,Z,W).

%Predicato di ricerca e della modifica delle variabili di output
ricercaOutput(X,Y,Z,W):-
        write('Inserisci il nome della variabile linguistica di output da modificare: '),
        read(Elemento),
        nl,
        ufunctoutput(X,Y,Z,W),                  
        Elemento==Y,
                write('Valore della membership attuale: '),
                write(W),
                nl,
                modificaOutput(X,Y,Z,W),
        !,
        nl,
        fail.
        ricercaOutput(X,Y,Z,W).

%Predicato per la modifica della membership di input
modificaInput(X,Y,Z,W):-
         nl,
         write('Inserisci nuovi valori di membership (es.[0,1,2,3]): '),
         read(Valore),
         nl,
         assert(ufunctinput(X,Y,Z,Valore)),         
         retract(ufunctinput(X,Y,Z,W)),
         leggiInput,
         leggiOutput,
         inizio.

%Predicato per la modifica della membership di output      
modificaOutput(X,Y,Z,W):-
         nl,
         write('Inserisci nuovi valori di membership (es.[0,1,2,3]): '),
         read(Valore),
         nl,
         assert(ufunctoutput(X,Y,Z,Valore)),         
         retract(ufunctoutput(X,Y,Z,W)),
         leggiInput,
         leggiOutput,
         inizio.

        

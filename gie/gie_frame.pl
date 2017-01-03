:- dynamic (fact/3).
:- dynamic (used_fact/3).
:- dynamic (rule/5).
:- dynamic (irule/3).
:- dynamic (frule/5).
:- dynamic (verified/2).
:- dynamic (min_threshold/1).
:- dynamic (tracker/2).
:- dynamic (frameAsserted/1).
:- dynamic (use_frame/1).
:- dynamic (def_frame/2).
:- dynamic (frame/2).

%:- consult('prove_kb'). 
%:- consult('WebContent/ES/IE/gie/FRAME/frame_content.pl'). 
load_class(Frame):-
	path_frame(P),
	atom_concat(P,Frame, Path),
	consult(Path).
	
frameAsserted([]).

findframe:-
	
	use_frame(Frame),
	load_class(Frame),
	frame(Frame, ListOfList_slot_value),
	write('     frame <'),write(Frame),write('> active'),nl,
	def_frame(Frame, ListOfList_slot_value),
	fail.
	   
findframe:-
	!.	 
	   
%mammifero( relative_size, execute( relative_size(Object, Value), Object, Value)).

def_frame(Name_Frame, ListOfList_slot_value) :-     
	nonvar(Name_Frame),
	nonvar(ListOfList_slot_value),
	is_list(ListOfList_slot_value),
	ListOfList_slot_value \== [],
	verifyListOfList(ListOfList_slot_value),
	%length(List_slot, X),
	%length(ListOfList_slot_value, Y),
	%X == Y,
	%write('X: '), write(X),  write(', Y: '), write(Y), nl,
	asserzione(Name_Frame, ListOfList_slot_value),
	!. 
	
%def_frame(Name_Frame, List_slot, List_value_slot) :- write('Errore, le variabili devono essere tutte istanziate e la lunghezza delle liste deve essere la stessa.').

verifyListOfList( [ Head | Tail ] ) :-
	!,
	is_list(Head),
	length(Head, 3),
	verify_bound(Head),
	verifyListOfList(Tail).

verifyListOfList([]).

asserzione(_,[]) :- !. 
                                                   
asserzione(Name_Frame, [ [Attributo | [Value, Crt] ] | OthersPairSlotValue]) :- 
	FrameAssert =.. [ Attributo, Name_Frame, Value ],
   	not(fact(_,FrameAssert,_)),
%   	maxidf(Idf),
%    Id is Idf + 1,
%   	idflist_upd(Id),
    assert(frame_data(FrameAssert,Crt)),
    !,
    asserzione(Name_Frame, OthersPairSlotValue).
        
asserzione(Name_Frame, [ [Attributo | [Value, _] ] | OthersPairSlotValue]) :- 
	FrameAssert =.. [ Attributo, Name_Frame, Value ],
	fact(_,FrameAssert,_),
	asserzione(Name_Frame, OthersPairSlotValue).

%relative_size( Object, RelativeSize) :- value_frame( Object, size, ObjSize),
%                                        value_frame(Object,instance_of, ObjClass),
%                                        value_frame( ObjClass, size, ClassSize),
%                                        RelativeSize is ObjSize/ClassSize * 100. % Percentage of class size

execute( relative_size( Object, RelSize), Object, RelSize).

value_frame( Frame, Slot, Value, Crt) :- value_frame( Frame, Frame, Slot, Value, Crt ).
% Directly retrieving information in slot of (super)frame
% Value directly retrieved
% Information is either a value
% or a procedurecall
value_frame( Frame, SuperFrame, Slot, Value, Crt) :- Query =.. [ Slot, SuperFrame, Information ],
                                          frame_data(Query, Crt),
                                          process( Information, Frame, Value, Crt), 
                                          !.
% Inferring value through inheritance
value_frame( Frame, SuperFrame, Slot, Value, Crt) :- parent(SuperFrame, ParentSuperFrame),
                                          value_frame( Frame, ParentSuperFrame, Slot, Value, Crt).
                                          
parent( Frame, ParentFrame):- ( Query =.. [ a_kind_of, Frame, ParentFrame]
                             ;
                             Query =.. [ instance_of, Frame, ParentFrame] 
                             ; 
                             Query =.. [ a_part_of, Frame, _WholeFrame] ),
                             frame_data(Query, _Crt).
                                          
% process( Information, Frame,Value)
process(execute(Goal, Frame, Value), Frame, Value, _Crt) :- Goal,
                                                      !.

process(Value, _, Value, _Crt). % A value, not procedure call                                           	   
	   

% Copyright (c) Gruppo IA, 2017


%Comando Relay 14
%Dislpay RETE structure


display_net :-
	display_roots,nl,
	display_bis,nl,
	display_teses,nl,
	display_ruls.

display_roots :-
	root(N,A,B),
	write( root(N,A,B) ),nl,
	fail.
display_roots.

display_bis :-
	bi(A,B,C,D),
	write( bi(A) ),nl,
	write_list([left|B]),
	write_list([right|C]),
	write(D),nl,nl,
	fail.
display_bis.

display_teses :-
	tes(A,B,C,D),
	write( tes(A) ),nl,
	write_list([left|B]),
	write_list([right|C]),nl,
	write(D),nl,nl,
	fail.
display_teses.

display_ruls :-
	rul(A,B,C),
	write( rul(A) ),nl,
	write_list([left|B]),
	write_list([right|C]),nl,
	fail.
display_ruls.

write_list([]).
write_list([H|T]) :-
	write(H),nl,
	wr_lis(T).

wr_lis([]).
wr_lis([H|T]) :-
	tab(5),write(H),nl,
	wr_lis(T).

%Comando Relay 15
%Dislpay working memory

print :-
	write_nl('Facts:'),
	forall(fact(X,Y,Z),write_nl(fact(X,Y,Z))),
	write_nl('Rules:'),
	forall(rule(A,B,C,D,E),write_nl(rule(A,B,C,D,E))).

write_nl(X) :-
	write(X),
	nl.

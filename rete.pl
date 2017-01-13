% definizione del nodo nadice
root(NID, Pattern, NextList).

% definizione dei two-input node
bi(NID, LeftPattern, RightPattern, NextList). 

% definizione dei nodi foglia, rappresentanti le regole
rul(N, LHS, RHS). 

% ----------------------------------------------------------------

addrete(Class, Name, TimeStamp) :-
    root(ID, Class-Name with ReqList, NextList),
    ffsend(Class, Name, ReqList, TimeStamp, NextList),
    fail. 
addrete(_, _, _).

ffsend(Class, Name, ReqList, TimeStamp, NextList) :-   
    getf(Class, Name, ReqList),
    send(tok(add, [(Class-Name with ReqList)/TimeStamp]), NextList),
    !.

delrete(Class, Name, TimeStamp) :-   
    root(ID, Class-Name with ReqList, NextList),    
    delr(Class, Name, ReqList, TimeStamp),    
    fail.
delrete(_, _, _).

delr(Class, Name, ReqList, TimeStamp) :-   
    getf(Class, Name, ReqList),
    !,
    send(tok(del, [(Class-Name with ReqList)/TimeStamp]), NextList).
delr(Class, Name, ReqList, TimeStamp)

send(_, []). 
send(Token, [Node|Rest]) :-   
    sen(Node, Token),
    send(Token, Rest). 

sen(rule-N, tok(AD, Token)) :-
    rul(N, Token, Actions),   
    (AD = add, add_conflict_set(N, Token, Actions);    
    AD = del, del_conflict_set(N, Token, Actions)),    
    !.

sen(Node-l, tok(AD, Token)) :-   
    bi(Node, Token, Right, NextList),    
    (AD = add, asserta( memory(Node-l, Token) );    
    AD = del, retract( memory(Node-l, Token) )),    
    !,
    matchRight(Node, AD, Token, Right, NextList).

sen(Node-r, tok(AD, Token)) :-   
    bi(Node, Left, Token, NextList),    
    (AD = add, asserta( memory(Node-r, Token) );    
    AD = del, retract( memory(Node-r, Token) )),    
    !,   
    matchLeft(Node, AD, Token, Left, NextList). 

matchRight(Node, AD, Token, Right, NextList) :-   
    memory(Node-r, Right),    
    append(Token, Right, NewTok),    
    send(tok(AD, NewTok), NextList),    
    fail. 
matchRight(_, _, _, _, _). 

matchLeft(Node, AD, Token, Left, NextList) :-   
    memory(Node-l, Left),    
    append(Left, Token, NewTok),
    send(tok(AD, NewTok), NextList),
    fail.
matchLeft(_, _, _, _, _). 

% ----------------------------------------------------------------------

rete_comp(N, [H|T], RHS) :-   
    term(H, Hw),    
    check_root(RN, Hw, HList),    
    retcom(root(RN), [Hw/_], HList, T, N, RHS),    
    !.
rete_comp(N, _, _).

term(Class-Name, Class-Name with []). 
term(Class-Name with List, Class-Name with List).

retcom(PNID, OutPat, PrevList, [], N, RHS) :-   
    build_rule(OutPat, PrevList, N, RHS),    
    update_node(PNID, PrevList, rule-N),    
    !.

retcom(PNID, PrevNode, PrevList, [H|T], N, RHS) :-   
    term(H, Hw),    
    check_root(RN, Hw, HList),    
    check_node(PrevNode, PrevList, [Hw/_], HList, NID, OutPat, NList),    
    update_node(PNID, PrevList, NID-l),    
    update_root(RN, HList, NID-r),    
    !,    
    retcom(NID, OutPat, NList, T, N, RHS). 

build_rule(OutPat, PrevList, N, RHS) :-   
    assertz( rul(N, OutPat, RHS)).

check_root(NID, Pattern, []) :-   
    not(root(_, Pattern, _)),    
    gen_nid(NID),    
    assertz( root(NID, Pattern, [])),   
    !. 

check_root(N, Pattern, List) :-   
    asserta(temp(Pattern)),
    retract(temp(T1)),    
    root(N, Pattern, List),    
    root(N, T2, _),    
    comp_devar(T1, T2),   
    !. 

check_root(NID, Pattern, []) :-   
    gen_nid(NID),    
    assertz( root(NID, Pattern, []) ).

check_node(PNode, PList, H, HList, NID, OutPat, []) :-   
    not (bi(_, PNode, H, _)),
    append(PNode, H, OutPat),
    gen_nid(NID),
    assertz( bi(NID, PNode, H, [])),    
    !.

check_node(PNode, PList, H, HList, NID, OutPat, NList) :-   
    append(PNode, H, OutPat),    
    asserta(temp(OutPat)),    
    retract(temp(Tot1)),    
    bi(NID, PNode, H, NList),    
    bi(NID, T2, T3, _),    
    append(T2, T3, Tot2),    
    %comp_devar(Tot1, Tot2), 
    comp_devar(Tot1, Tot2).

check_node(PNode, PList, H, HList, NID, OutPat, []) :-   
    append(PNode, H, OutPat),    
    gen_nid(NID),    
    assertz( bi(NID, PNode, H, [])).

update_root(RN, HList, NID) :-   
    member(NID, HList),   
    !. 

update_root(RN, HList, NID) :-   
    retract( root(RN, H, HList) ),    
    asserta( root(RN, H, [NID|HList])).

update_node(root(RN), HList, NID) :-   
    update_root(RN, HList, NID),   
    !.

update_node(X, PrevList, NID) :-   
    member(NID, PrevList),   
    !.

update_node(PNID, PrevList, NID) :-   
    retract( bi(PNID, L, R, _) ),    
    asserta( bi(PNID, L, R, [NID|PrevList])).

comp_devar(T1, T2) :-   
    del_variables(T1),    
    del_variables(T2),    
    T1 = T2.

del_variables(T) :-   
    init_vargen,    
    de_vari(T).

de_vari([]).

de_vari([H|T]) :-   
    de_var(H),    
    de_vari(T). 

de_vari(X) :-   
    de_var(X).

de_var(X/_) :-   
    de_var(X). 

de_var(X-Y with List) :-   
    de_v(X-Y),    
    de_vl(List),   
    !. 

de_var(X-Y) :-   
    de_v(X-Y),   
    !.

de_vl([]). 

de_vl([H|T]) :-   
    de_v(H),    
    de_vl(T).

de_v(X-Y) :-   
    d_v(X),    
    d_v(Y).

d_v(V) :-   
    var(V),    
    var_gen(V),   
    !. 

d_v(_).

init_vargen :-   
    abolish(varg, 1),    
    asserta(varg(1)). 

var_gen(V) :-   
    retract(varg(N)),    
    NN is N + 1,    
    asserta(varg(NN)),    
    int2string(N, NS),    
    stringconcat("#VAR_", NS, X),    
    name(V, X).
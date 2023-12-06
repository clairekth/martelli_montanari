% =================================================================================================
% ========================== Définition de l'opérateur ?=
:- op(20,xfy,?=).

% =================================================================================================
% ============= set_echo: ce prédicat active l'affichage par le prédicat echo
set_echo :- assert(echo_on).

% =================================================================================================
% ============= clr_echo: ce prédicat inhibe l'affichage par le prédicat echo
clr_echo :- retractall(echo_on).

% =================================================================================================
% ========== echo(T): si le flag echo_on est positionné, echo(T) affiche le terme T
% =================== sinon, echo(T) réussit simplement en ne faisant rien.
echo(T) :- echo_on, !, write(T).
echo(_).

% =================================================================================================
% ====== Prédicat regles(E,R) : définit la règle de transformation R qui s'applique à l'équation E.
regle(X ?= Y, rename) :- var(X), var(Y).

regle(X ?= Y, simplify) :- var(X), atomic(Y) ; atomic(X), atomic(Y), X == Y.

regle(X ?= Y, expand) :- var(X), compound(Y), \+occur_check(X,Y).

regle(X ?= Y, check) :- var(X), occur_check(X, Y), (X \== Y).

regle(X ?= Y, orient) :- nonvar(X), var(Y).

% A et B = nom de la fonction, M et N = ariétés
regle(X ?= Y, decompose) :- compound(X), compound(Y), functor(X,A,M), functor(Y,B,N), (A == B), (M == N).

regle(X ?= Y, clash) :- compound(X), compound(Y), functor(X,A,M), functor(Y,B,N), (A \== B ; M \== N).

% =================================================================================================
% ========== Prédicat occur_check(V,T) : teste si la variable V apparaît dans le terme T.
occur_check(V, T) :- contains_var(V, T).

% =================================================================================================
% == Prédicat reduit(R, E, P, Q) : Transforme le système d'équations P en Q en appliquant la règle R à l'équation E.
reduit(rename, X ?= Y, P, Q) :-  X = Y, Q = P.

reduit(simplify, X ?= Y, P, Q) :-  X = Y, Q = P.

reduit(expand, X ?= Y, P, Q) :-  X = Y, Q = P.

reduit(check, _, _, _) :-  fail.

reduit(orient, X ?= Y, P, Q) :- Q = [Y ?= X|P].

reduit(decompose, X ?= Y, P, Q) :- X =.. [_|L1], Y =.. [_|L2], decomposition(L1, L2, R), append(R, P, Q).

reduit(clash,_, _, _) :- fail.

decomposition([H1|T1], [H2|T2], R) :- decomposition(T1, T2, S), append([H1 ?= H2], S, R).
decomposition([], [], R) :- R=[].


% =================================================================================================
% ====== Prédicat unifie(P) : unifie le système d'équations P où P est une liste d'équations.
unifie([H|T], choix_premier) :- print_system([H|T]), choix_premier(_, H, T, Q), unifie(Q, choix_premier),!.
unifie([], _) :- write("Unification réussie ! Voici le résultat : "), nl.

choix_premier(R, E, P, Q) :- regle(E, R),print_regle(R,E), reduit(R, E, P, Q).

print_system(P) :- echo('system : '), echo(P), echo('\n').
print_regle(R,E) :- echo(R), echo(E), echo('\n').  

unif(P,C) :- clr_echo, unifie(P,C).
trace_unif(P,C) :- set_echo, echo('Stratégie : '), echo(C), nl, nl, unifie(P,C).
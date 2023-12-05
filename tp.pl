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

write_named_var(Name, Var) :-
	Term =.. [Name, Var],
	write(Term).

% =================================================================================================
% ====== Prédicat regles(E,R) : définit la règle de transformation R qui s'applique à l'équation E.
regle(X ?= Y, rename) :- nl, write("rename: "), write_named_var('X', X), write(" ?= "), write_named_var('Y', Y), var(X), var(Y).

regle(X ?= Y, simplify) :- nl, write("simplify: "), write(X ?= Y), var(X), atomic(Y).

regle(X ?= Y, expand) :- nl, write("expand: "), write(X ?= Y), var(X), compound(Y), \+occur_check(X,Y).

regle(X ?= Y, check) :- nl, write("check: "), write(X ?= Y), var(X), occur_check(X, Y), (X \== Y).

regle(X ?= Y, orient) :- nl, write("orient: "), write(X ?= Y), nonvar(X), var(Y).

% A et B = nom de la fonction, M et N = ariétés
regle(X ?= Y, decompose) :- nl, write("decompose: "), write(X ?= Y), compound(X), compound(Y), functor(X,A,M), functor(Y,B,N), (A == B), (M == N).

regle(X ?= Y, clash) :- nl, write("clash: "), write(X ?= Y), compound(X), compound(Y), functor(X,A,M), functor(Y,B,N), (A \== B ; M \== N).

% =================================================================================================
% ========== Prédicat occur_check(V,T) : teste si la variable V apparaît dans le terme T.
occur_check(V, T) :- contains_var(V, T).

% =================================================================================================
% == Prédicat reduit(R, E, P, Q) : Transforme le système d'équations P en Q en appliquant la règle R à l'équation E.
reduit(rename, X ?= Y, P, Q) :- regle(X ?= Y, rename), X = Y, Q = P.

reduit(simplify, X ?= Y, P, Q) :- regle(X ?= Y, simplify), X = Y, Q = P.

reduit(expand, X ?= Y, P, Q) :- regle(X ?= Y, expand), X = Y, Q = P.

reduit(check, X ?= Y, _, _) :- regle(X ?= Y, check), !.

% reduit(orient, X ?= Y, P, Q) :- regle(X ?= Y, orient), Y = X, select(X ?= Y, P, Q), !.
reduit(orient, X ?= Y, P, Q) :- regle(X ?= Y, orient), Q = [Y ?= X|P].

reduit(decompose, X ?= Y, P, Q) :- regle(X ?= Y, decompose), arg(1, X, X1), arg(1, Y, Y1), append([X1 ?= Y1], P, Q).

reduit(clash, X ?= Y, _, _) :- \+regle(X ?= Y, clash).

decomposition([H1|T1], [H2|T2], R) :- decomposition(T1, T2, S), append([H1 ?= H2], S, R).
decomposition([], [], R) :- R=[].


% =================================================================================================
% ====== Prédicat unifie(P) : unifie le système d'équations P où P est une liste d'équations.
unifie([H|T]) :- sleep(1), aff_sys([H|T]), choix_premier(_, H, T, Q), unifie(Q), !.
unifie([]) :- nl, write("SUCCESS").

choix_premier(R, E, P, Q) :- reduit(R, E, P, Q), !.

aff_sys(P) :- set_echo, nl, echo('system: '), echo(P).
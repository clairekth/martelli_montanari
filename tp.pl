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
reduit(rename, X ?= Y, P, Q) :- regle(X ?= Y, rename),print_regle('rename :', X?=Y),  Q = P, X = Y.

reduit(simplify, X ?= Y, P, Q) :- regle(X ?= Y, simplify), print_regle('simplify :', X?=Y),  Q = P, X = Y.

reduit(expand, X ?= Y, P, Q) :- regle(X ?= Y, expand), print_regle('expand :', X?=Y),  Q = P,X = Y.

reduit(check, X ?= Y, _, _) :- regle(X ?= Y, check), print_regle('clash :', X?=Y), fail.

% reduit(orient, X ?= Y, P, Q) :- regle(X ?= Y, orient), Y = X, select(X ?= Y, P, Q), !.
reduit(orient, X ?= Y, P, Q) :- regle(X ?= Y, orient), print_regle('orient :', X?=Y), Q = [Y ?= X|P].

reduit(decompose, X ?= Y, P, Q) :- regle(X ?= Y, decompose), print_regle('decompose :', X?=Y), X =.. [A|B], Y =.. [A|C], decomposition(B, C, R), append(R, P, Q).

reduit(clash, X ?= Y, _, _) :- regle(X ?= Y, clash), print_regle('clash :', X?=Y), fail.

decomposition([H1|T1], [H2|T2], R) :- decomposition(T1, T2, S), append([H1 ?= H2], S, R).
decomposition([], [], R) :- R=[].


% =================================================================================================
% ====== Prédicat unifie(P) : unifie le système d'équations P où P est une liste d'équations.
unifie([H|T]) :- print_system([H|T]), choix_premier(_, H, T, Q), unifie(Q),!.
unifie([]) :- nl, write("SUCCESS").

choix_premier(R, E, P, Q) :- reduit(R, E, P, Q), !.

print_system(P) :- set_echo, echo('system : '), echo(P), echo('\n').
print_regle(R,E) :- echo(R), echo(E), echo('\n').  
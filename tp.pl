% Définition de l'opérateur ?=
:- op(20,xfy,?=).

% Prédicats d'affichage fournis

% set_echo: ce prédicat active l'affichage par le prédicat echo
set_echo :- assert(echo_on).

% clr_echo: ce prédicat inhibe l'affichage par le prédicat echo
clr_echo :- retractall(echo_on).

% echo(T): si le flag echo_on est positionné, echo(T) affiche le terme T
%          sinon, echo(T) réussit simplement en ne faisant rien.

echo(T) :- echo_on, !, write(T).
echo(_).

% =================================================================================================
% ====== Prédicat regles(E,R) : définit la règle de transformation R qui s'applique à l'équation E.
regle(X ?= Y, rename) :- var(X), var(Y), X == Y, !.

regle(X ?= Y, simplify) :- var(X), atomic(Y), !.

regle(X ?= Y, expand) :- var(X), compound(Y), \+occur_check(X,Y), !.

regle(X ?= Y, check) :- var(X), occur_check(X, Y), (X \== Y), !.

regle(X ?= Y, orient) :- var(Y), nonvar(X), !.

% A et B = nom de la fonction, M et N = ariétés 
regle(X ?= Y, decompose) :- compound(X), compound(Y), functor(X,A,M), functor(Y,B,N), (A == B), (M == N), !.

regle(X ?= Y, clash) :- compound(X), compound(Y), functor(X,A,M), functor(Y,B,N), (A \== B ; M \== N), !.

% =================================================================================================
% ========== Prédicat occur_check(V,T) : teste si la variable V apparaît dans le terme T.
% A voir pour peut-être faire autrement : y'a des pred qui vont peut etre pas
occur_check(V, T) :- \+cyclic_term(V), \+cyclic_term(T), contains_var(V, T).

% =================================================================================================
% ========== Prédicat unifie(P) : unifie le système d'équations P où P est une liste d'équations.
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


% règles(E,R) : définit la règle de transformation R qui s'applique à l'équation E

regle(X ?= Y, rename) :- var(X), var(Y), X=Y,!.

regle(X ?= Y, simplify) :- var(X), atomic(Y), !.

% A et B = nom de la fonction, M et N = ariétés 
regle( X ?= Y, decompose) :- compound(X), compound(Y), functor(X,A,M), functor(Y,B,N), (A == B), (M == N), !.
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
% ====== Prédicat regle(E,R) : définit la règle de transformation R qui s'applique à l'équation E.
regle(X ?= Y, rename) :- var(X), var(Y).

regle(X ?= Y, simplify) :-
    var(X), atomic(Y) ;
    atomic(X), atomic(Y), X == Y.

regle(X ?= Y, expand) :-
    var(X), compound(Y),
    \+occur_check(X,Y).

regle(X ?= Y, check) :-
    var(X), occur_check(X, Y), (X \== Y).

regle(X ?= Y, orient) :- nonvar(X), var(Y).

% A et B = nom de la fonction, M et N = ariétés
regle(X ?= Y, decompose) :-
    compound(X), compound(Y),
    functor(X, A, M), functor(Y, B, N),
    (A == B), (M == N).

regle(X ?= Y, clash) :-
    compound(X), compound(Y),
    functor(X, A, M), functor(Y, B, N),
    (A \== B ; M \== N).

% =================================================================================================
% ========== Prédicat occur_check(V,T) : teste si la variable V apparaît dans le terme T.
occur_check(V, T) :- contains_var(V, T).

% =================================================================================================
% == Prédicat reduit(R, E, P, Q) : Transforme le système d'équations P en Q en appliquant la règle R à l'équation E.
reduit(rename, X ?= Y, P, Q) :-  X = Y, Q = P.

reduit(simplify, X ?= Y, P, Q) :-  X = Y, Q = P.

reduit(expand, X ?= Y, P, Q) :-  X = Y, Q = P.

reduit(check, _, _, _) :-
    write('Occurrence - unification impossible\n'), fail.

reduit(orient, X ?= Y, P, Q) :- Q = [Y ?= X|P].

reduit(decompose, X ?= Y, P, Q) :-
    X =.. [_|L1], Y =.. [_|L2],
    decomposition(L1, L2, R), append(R, P, Q).

reduit(clash, _, _, _) :-
    write('Clash - unification impossible\n'), fail.

decomposition([H1|T1], [H2|T2], R) :-
    decomposition(T1, T2, S), append([H1 ?= H2], S, R).
decomposition([], [], R) :- R = [].

% =================================================================================================
% ====== Prédicat unifie(P) : unifie le système d'équations P où P est une liste d'équations.

unifie([H|T]) :- unifie([H|T], choix_premier).

unifie([H|T], choix_premier) :-
    print_system([H|T]), choix_premier(T, Q, H, _),
    unifie(Q, choix_premier), !.

unifie(P, choix_pondere_1) :-
    print_system(P), choix_pondere_1(P, Q, _, _),
    unifie(Q, choix_pondere_1), !.

unifie(P, choix_pondere_2) :-
    print_system(P), choix_pondere_2(P, Q, _, _),
    unifie(Q, choix_pondere_2), !.

unifie([], _) :-
    write('Unification réussie !'), nl.

% =================================================================================================
% ====== Prédicat choix_premier(P, Q, E, R) : choisit la première règle R qui s'applique à l'équation E du système P.
choix_premier(P, Q, E, R) :- 
    regle(E, R),print_regle(R, E), reduit(R, E, P, Q).

choix_pondere_1(P, Q, _, _) :-
    choix_equation(P, [clash, check, rename, simplify, orient, decompose, expand], E, R),
    print_regle(R, E),
    select(E, P, N), % select permet de supprimer E de P et de mettre le résultat dans N
    reduit(R, E, N, Q).

choix_pondere_2(P, Q, _, _) :-
    choix_equation(P, [decompose, expand, orient, simplify, rename, check, clash], E, R),
    print_regle(R, E),
    select(E, P, N),
    reduit(R, E, N, Q).

choix_equation(P , [R_TESTE | RESTE_LR], E, R) :-
    choix_equation_aux(P, R_TESTE, E, R), !;
    choix_equation(P, RESTE_LR, E, R).

choix_equation_aux([E_TESTE | RESTE_P], R_TESTE, E, R) :-
    (   regle(E_TESTE, R_TESTE)
    ->  E = E_TESTE, R = R_TESTE , !
    ;   choix_equation_aux(RESTE_P, R_TESTE, E, R)
    ).
choix_equation_aux(_, [], _, _).

print_system(P) :- echo('system : '), echo(P), echo('\n').
print_regle(R, E) :- echo(R),echo(' : '), echo(E), echo('\n').

unif(P) :- unif(P, choix_premier).
unif(P, C) :- clr_echo, unifie(P, C).
trace_unif(P) :- trace_unif(P, choix_premier).
trace_unif(P, C) :-
    set_echo, echo('Stratégie : '), echo(C), nl, nl, unifie(P, C).

main :-
	repeat,
    write('Entrez votre système d\'équations'),
	nl,
	write('ex: [A ?= x, f(x) ?= f(A)]'), nl, read(P),
    write('Entrez votre stratégie (0/1/2)'),
	nl,
	write('0 -> \'choix_premier\''), nl,
	write('1 -> \'choix_pondere_1\''), nl,
	write('2 -> \'choix_pondere_2\''), nl,
	read(CI),
	(CI == 0 -> C = choix_premier ; CI == 1 -> C = choix_pondere_1 ; C = choix_pondere_2),
	write('Voulez-vous activer le mode trace ? (y/n) >> '), read(T),
	(T == y ; T == n),
	(T == y -> trace_unif(P, C) ; unif(P, C)),
	write('Voulez-vous recommencer ? (y/n) : '), read(R),
	(R == n), !.
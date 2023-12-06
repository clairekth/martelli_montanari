:- [martelli_montanari].
:- op(20,xfy,?=).
:- style_check(-singleton).
test_1(C) :- unif([ a?=a], C).
test_2(C) :- unif([ a?=b], C).
test_3(C) :- unif([ X?=a], C), format('X = ~w', [X]).
test_4(C) :- unif([ X?=Y], C), format('X = ~w Y = ~w', [X, Y]).
test_5(C) :- unif([ a ?= X], C), format('X = ~w', [X]).
test_6(C) :- unif([ f(X)?=f(a)], C), format('X = ~w', [X]).
test_7(C) :- unif([ f(X)?=f(Y)], C), format('X = ~w Y = ~w', [X, Y]).
test_8(C) :- unif([ f(X)?=g(X)], C).
test_9(C) :- unif([ f(X)?=g(a)], C).
test_10(C) :- unif([ f(X)?=X], C).
test_11(C) :- unif([ f(X, Y)?=f(a,b)], C), format('X = ~w, Y = ~w', [X, Y]).
test_12(C) :- unif([f(X,Y) ?= f(g(Z),h(a)), Z ?= f(Y)], C), format('X = ~w, Y = ~w, Z = ~w~n', [X, Y, Z]).
test_13(C) :- unif([f(X,Y) ?= f(g(Z),h(a)), Z ?= f(X)], C), format('X = ~w, Y = ~w, Z = ~w~n', [X, Y, Z]).

run_tests(C):-
    write('Test 1 : a ?=a - Succès attendu'), nl, test_1(C), nl,
    nl, write('Test 2 : a ?=b - Echec attendu'), nl, not(test_2(C)), write('Echec'),nl,
    nl, write('Test 3 : X ?=a - Succès attendu - {X = a}'), nl, test_3(C), nl,
    nl, write('Test 4 : X ?=Y - Succès attendu - {X = Y}'), nl, test_4(C), nl,
    nl, write('Test 5 : a ?=X - Succès attendu - {X = a}'), nl, test_5(C), nl,
    nl, write('Test 6 : f(X) ?=f(a) - Succès attendu - {X = a}'), nl, test_6(C), nl,
    nl, write('Test 7 : f(X) ?=f(Y) - Succès attendu - {X = Y}'), nl, test_7(C), nl,
    nl, write('Test 8 : f(X) ?=g(X) - Echec attendu'), nl, not(test_8(C)), write('Echec'), nl,
    nl, write('Test 9 : f(X) ?=g(a) - Echec attendu'), nl, not(test_9(C)),write('Echec'), nl,
    nl, write('Test 10 : f(X) ?=X - Echec attendu'), nl, not(test_10(C)), write('Echec'), nl,
    nl, write('Test 11 : f(X, Y) ?=f(a,b) - Succès attendu - {X = a, Y = b}'), nl, test_11(C), nl,
    nl, write('Test 12 : f(X,Y) ?= f(g(Z),h(a)), Z ?= f(Y) - Succès attendu - {X = g(f(h(a))), Y = h(a), Z = f(h(a))}'), nl, test_12(C), nl,
    nl, write('Test 13 : f(X,Y) ?= f(g(Z),h(a)), Z ?= f(X) - Echec attendu'), nl, not(test_13(C)), write('Echec'), nl.

main :-
    write('------- Choix premier : ---------\n'),
    run_tests(choix_premier),
    write('---------------------------------\n'),
    halt.
:- initialization(main).




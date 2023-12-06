:- [martelli_montanari].
:- op(20,xfy,?=).
:- style_check(-singleton).
test_1_premier_choix :- unif([ a?=a], choix_premier).
test_2_premier_choix :- unif([ a?=b], choix_premier).
test_3_premier_choix :- unif([ X?=a], choix_premier), format('X = ~w', [X]).
test_4_premier_choix :- unif([ X?=Y], choix_premier), format('X = ~w Y = ~w', [X, Y]).
test_5_premier_choix :- unif([ a ?= X], choix_premier), format('X = ~w', [X]).
test_6_premier_choix :- unif([ f(X)?=f(a)], choix_premier), format('X = ~w', [X]).
test_7_premier_choix :- unif([ f(X)?=f(Y)], choix_premier), format('X = ~w Y = ~w', [X, Y]).
test_8_premier_choix :- unif([ f(X)?=g(X)], choix_premier).
test_9_premier_choix :- unif([ f(X)?=g(a)], choix_premier).
test_10_premier_choix :- unif([ f(X)?=X], choix_premier).
test_11_premier_choix :- unif([ f(X, Y)?=f(a,b)], choix_premier), format('X = ~w, Y = ~w', [X, Y]).
test_12_premier_choix :- unif([f(X,Y) ?= f(g(Z),h(a)), Z ?= f(Y)], choix_premier), format('X = ~w, Y = ~w, Z = ~w~n', [X, Y, Z]).
test_13_premier_choix :- unif([f(X,Y) ?= f(g(Z),h(a)), Z ?= f(X)], choix_premier), format('X = ~w, Y = ~w, Z = ~w~n', [X, Y, Z]).

test_premier_choix(_, Q) :- Q, !.

run_tests_premier_choix:-
    write('Test 1 : a ?=a - Succès attendu'), nl, test_1_premier_choix, nl,
    nl, write('Test 2 : a ?=b - Echec attendu'), nl, not(test_2_premier_choix), write('Echec'),nl,
    nl, write('Test 3 : X ?=a - Succès attendu - {X = a}'), nl, test_3_premier_choix, nl,
    nl, write('Test 4 : X ?=Y - Succès attendu - {X = Y}'), nl, test_4_premier_choix, nl,
    nl, write('Test 5 : a ?=X - Succès attendu - {X = a}'), nl, test_5_premier_choix, nl,
    nl, write('Test 6 : f(X) ?=f(a) - Succès attendu - {X = a}'), nl, test_6_premier_choix, nl,
    nl, write('Test 7 : f(X) ?=f(Y) - Succès attendu - {X = Y}'), nl, test_7_premier_choix, nl,
    nl, write('Test 8 : f(X) ?=g(X) - Echec attendu'), nl, not(test_8_premier_choix), write('Echec'), nl,
    nl, write('Test 9 : f(X) ?=g(a) - Echec attendu'), nl, not(test_9_premier_choix),write('Echec'), nl,
    nl, write('Test 10 : f(X) ?=X - Echec attendu'), nl, not(test_10_premier_choix), write('Echec'), nl,
    nl, write('Test 11 : f(X, Y) ?=f(a,b) - Succès attendu - {X = a, Y = b}'), nl, test_11_premier_choix, nl,
    nl, write('Test 12 : f(X,Y) ?= f(g(Z),h(a)), Z ?= f(Y) - Succès attendu - {X = g(f(h(a))), Y = h(a), Z = f(h(a))}'), nl, test_12_premier_choix, nl,
    nl, write('Test 13 : f(X,Y) ?= f(g(Z),h(a)), Z ?= f(X) - Echec attendu'), nl, not(test_13_premier_choix), write('Echec'), nl.

main :-
    run_tests_premier_choix,
    halt.
:- initialization(main).




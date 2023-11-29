:- [tp].
:- op(20,xfy,?=).

test_rename_true :- regle(X ?= Y, rename).
test_simplify_true :- regle(X ?= a, simplify).
test_expand_true :- regle(X ?= f(Y), expand).
test_check_true :- regle(X ?= f(X), check).
test_orient_true :- regle(a ?= Y, orient).
test_decompose_true:- regle(f(a, b) ?= f(c, d), decompose).
test_clash_true :- regle(f(a, b) ?= g(c, d), clash).
test_clash_true_2 :- regle(f(a, b) ?= f(c), clash).

run_tests_True :-
    echo("Rename\n"), test_rename_true,
    echo("Simplify\n"), test_simplify_true,
    echo("Expand\n"), test_expand_true,
    echo("Check\n"), test_check_true,
    echo("Orient\n"), test_orient_true,
    echo("Decompose\n"), test_decompose_true,
    echo("Clash - Nom fonction différent \n"), test_clash_true,
    echo("Clash - Nombre argument différent \n"), test_clash_true_2,
    echo("Tous les tests Vrai sont passées.\n").
    

test_rename_false :- regle(X ?= f(X), rename).
test_simplify_false :- regle(X ?= X, simplify).
test_expand_false :- regle(X ?= f(X), expand).
test_check_false :- regle(X ?= f(Y), check).
test_orient_false :- regle(X ?= f(X), orient).
test_decompose_false:- regle(f(a) ?= f(c, d), decompose).
test_decompose_false_2:- regle(f(a, b) ?= g(a,b), decompose).
test_clash_false :- regle(f(a, b) ?= f(a,c), clash).

run_tests_False :-
    echo("Rename\n"), not(test_rename_false),
    echo("Simplify\n"), not(test_simplify_false),
    echo("Expand\n"), not(test_expand_false),
    echo("Check\n"), not(test_check_false),
    echo("Orient\n"), not(test_orient_false),
    echo("Decompose - Nombre argument différent \n"), not(test_decompose_false),
    echo("Decompose - Nom fonction différent \n"), not(test_decompose_false_2),
    echo("Clash\n"), not(test_clash_false),
    echo("Tous les tests Faux sont passées.\n").

main :-
    set_echo,
    run_tests_True,
    run_tests_False,
    echo("Tous les tests sont passées.\n"),
    clr_echo,
    halt.

:- main.

#!/usr/bin/swipl

:- set_prolog_flag(verbose, silent).
:- initialization(main).

main :-
    consult('tp.pl'),  % Charger le fichier tp.pl
    set_echo,          % Activer l'écho
    echo("test\n"),      % Afficher "test"
    clr_echo.          % Désactiver l'écho
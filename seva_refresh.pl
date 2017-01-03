/*************************************************************************
        Nome: seva_cleaner.pl
        
	Realizzazione: Febbraio, 2014
  		Obiettivo: Modulo di pulizia della Working Memory del SEVA
       		Autore: Francesco Solare
       	 
*************************************************************************/
:- dynamic (curr_kb/1).
:- dynamic (curr_flog/1).
:- dynamic (fact/3).
:- dynamic (rule/5).

:- dynamic (idf/1).
:- dynamic (idr/1).
:- dynamic (initfacts/1).
:- dynamic (initrules/1).
:- dynamic (maxinitialidf/1).
:- dynamic (maxinitialidr/1).

:- dynamic (irule/3).

:- dynamic (confl/1).
:- dynamic (fireset/1).
:- dynamic (frule/5).
:- dynamic (verified/2).
:- dynamic (tracker/2).

:- dynamic (used_fact/3).
:- dynamic (used_rule/5).
:- dynamic (inferedrule/2).

:- dynamic (final_adjustment/2).

:- dynamic (curr_task/1).
:- dynamic (fuzzycheck/1).
:- dynamic (used_frame_fact/3).
:- dynamic (use_frame/1).
:- dynamic (def_frame/2).



:- retractall(curr_kb(_)).
:- retractall(curr_flog(_)).
:- retractall(fact(_,_,_)).
:- retractall(rule(_,_,_,_,_)).
:- retractall(exp_rule(_,_,_)).


:- retractall(idf(_)).
:- retractall(idr(_)).
:- retractall(initfacts(_)).
:- retractall(initrules(_)).
:- retractall(t_rule(_,_)).
:- retractall(maxinitialidf(_)).
:- retractall(maxinitialidr(_)).
:- retractall(maxidf_val(_)).
:- retractall(maxidr_val(_)).

:- retractall(irule(_,_,_)).

:- retractall(confl(_)).
:- retractall(fireset(_)).
:- retractall(frule(_,_,_,_,_)).
:- retractall(verified(_,_)).
:- retractall(tracker(_,_)).
:- retractall(final_k(_,_,_)).

%pulisce la working memory dai predicati usati dai frame AUTORI: Liso- Proscia

:- retractall(used_frame_fact(_,_,_)).
:- retractall(use_frame(_)).
:- retractall(def_frame(_,_)).


:- retractall(used_fact(_,_,_)).
:- retractall(used_rule(_,_,_,_,_)).
:- retractall(inferedrule(_,_)).

:- retractall(final_adjustment(_,_)).

:- retractall(curr_task(_)).
:- retractall(fuzzycheck(_)).

:- retractall( fact_presence(_)).
:- retractall( max_id(_)).
:- retractall( explained_fact(_)).
:- retractall( explained_condition_rule(_ , _)).
/**************************************************
      	Eliminazione dei predicati di servizio
	dedotti durante il processo inferenziale 
**************************************************/
:- dynamic hygrometric_situation_dry/1.
:- dynamic hygrometric_situation_humid/1.
:- dynamic hygrometric_situation_rain/1.

:- dynamic wheatering_situation_very_cold/1.
:- dynamic wheatering_situation_middle_cold/1.
:- dynamic wheatering_situation_temperate/1.
:- dynamic wheatering_situation_middle_hot/1.
:- dynamic wheatering_situation_very_hot/1.

:- dynamic thermostate_cooling/1.
:- dynamic thermostate_economy/1.
:- dynamic thermostate_standby/1.
:- dynamic thermostate_comfort/1.
:- dynamic thermostate_heating/1.

:- retractall(hygrometric_situation_dry(_)).
:- retractall(hygrometric_situation_humid(_)).
:- retractall(hygrometric_situation_rain(_)).

:- retractall(wheatering_situation_very_cold(_)).
:- retractall(wheatering_situation_middle_cold(_)).
:- retractall(wheatering_situation_temperate(_)).
:- retractall(wheatering_situation_middle_hot(_)).
:- retractall(wheatering_situation_very_hot(_)).

:- retractall(thermostate_cooling(_)).
:- retractall(thermostate_economy(_)).
:- retractall(thermostate_standby(_)).
:- retractall(thermostate_comfort(_)).
:- retractall(thermostate_heating(_)).

/********************************************
      	Setting iniziale dell'ambiente
********************************************/
curr_task(0).
curr_kb(unknow).
curr_flog(unknow).
idf([]).
idr([]).
initfacts([]).
initrules([]).
fireset([]).

fact_presence(0).
max_id(0).
explained_fact( 0 ).
explained_condition_rule(0 , 0).
final_k(0,1,0).

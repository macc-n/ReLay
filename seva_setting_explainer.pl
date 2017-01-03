/**********************************************************
        
        Modulo: seva_setting_explainer.pl
        Autori: Pasquadibisceglie V. - Zaza G.
        Descrizione: modulo contenente gli explainer
                     del caso di studio "Smart Home for Elderly People" 


**********************************************************/
:- dynamic (explainer/3).

%EXPLAINER
%PARKINSON_ALZHEIMER_GRAVI
explainer(parkinson_grave_no(_),0,'l''utente non e'' affetto da parkinson grave').
explainer(parkinson_grave_si(_),0,'l''utente e'' affetto da parkinson grave').
explainer(alzheimer_grave_no(_),0,'l''utente non e'' affetto da alzheimer garve').
explainer(alzheimer_grave_si(_),0,'l''utente e'' affetto da alzheimer grave').
%PARKINSON_ALZHEIMER_LIEVI
explainer(parkinson_lieve_no(_),0,'l''utente non e'' affetto da parkinson lieve').
explainer(parkinson_lieve_si(_),0,'l''utente e'' affetto da parkinson lieve').
explainer(alzheimer_lieve_no(_),0,'l''utente non e'' affetto da alzheimer lieve').
explainer(alzheimer_lieve_si(_),0,'l''utente e'' affetto da alzheimer lieve').
%CARDIOPATIA
explainer(cardipatia_no(_),0,'l''utente non e'' affetto da cardiopatia').
explainer(cardiopatia_si(_),0,'l''utente e'' affetto da cardiopatia').
%ARTROSI
explainer(artrosi_no(_),0,'l''utente non e'' affetto da artrosi').
explainer(artrosi_si(_),0,'l''utente e'' affetto da artrosi').
%DIABETE
explainer(diabete_no(_),0,'l''utente non e'' affetto da diabete').
explainer(diabete_si(_),0,'l''utente e'' affetto da diabete').
%RESPIRATORIA
explainer(respiratoria_no(_),0,'l''utente non e'' affetto da problemi respiratori').
explainer(respiratoria_si(_),0,'l''utente e'' affetto da problemi respiratori').
%DEFICIT_UDITIVO
explainer(deficit_uditivo_no(_),0,'l''utente non e'' affetto da deficit uditivo').
explainer(deficit_uditivo_si(_),0,'l''utente e'' affetto da deficit uditivo').
%DEFICIT_VISIVO
explainer(deficit_visivo_no(_),0,'l''utente non e'' affetto da deficit visivo').
explainer(deficit_visivo_si(_),0,'l''utente e'' affetto da deficit visivo').
%PERIODO_DEL_GIORNO
explainer(periodo_del_giorno_alba(_),0,'periodo della giornata: alba').
explainer(periodo_del_giorno_mattina(_),0,'periodo della giornata: mattina').
explainer(periodo_del_giorno_mezzogiorno(_),0,'periodo della giornata: mezzoggiorno').
explainer(periodo_del_giorno_pomeriggio(_),0,'periodo della giornata: pomeriggio').
explainer(periodo_del_giorno_sera(_),0,'periodo della giornata: sera').
explainer(periodo_del_giorno_notte(_),0,'periodo della giornata: notte').
%SITUAZIONE_ATMOSFERICA
explainer(situazione_atmosferica_sereno(_),0,'la situazione atmosferica e'': serena').
explainer(situazione_atmosferica_nuvoloso(_),0,'la situazione atmosferica e'': nuvolosa').
explainer(situazione_atmosferica_maltempo(_),0,'la situazione atmosferica e'': maltempo').
%PIR
explainer(pir_bagno_spento(_),0,'il pir del bagno non ha rivelato nessuna presenza').
explainer(pir_bagno_acceso(_),0,'il pir del bagno ha rivelato una presenza').
explainer(pir_cucina_spento(_),0,'il pir della cucina non ha rivelato nessuna presenza').
explainer(pir_cucina_acceso(_),0,'il pir della cucina ha rivelato una presenza').
explainer(pir_camera_da_letto_spento(_),0,'il pir della camera da letto non ha rivelato nessuna presenza').
explainer(pir_camera_da_letto_acceso(_),0,'il pir della camera da letto ha rivelato una presenza').
explainer(pir_salotto_spento(_),0,'il pir del salotto non ha rivelato nessuna presenza').
explainer(pir_salotto_acceso(_),0,'il pir del salotto ha rivelato una presenza').
%MISURA_GLICEMIA
explainer(misura_glicemia_ipoglicemia(_),0,'l''utente e'' in stato ipoglicemico').
explainer(misura_glicemia_normalita(_),0,'l''utente ha valori di glicemia nella norma').
explainer(misura_glicemia_iperglicemia(_),0,'l''utente e'' in stato di iperglicemia').
%MISURA_PRESSIONE
explainer(misura_pressione_troppo_bassa(_),0,'l''utente ha un valore di pressione sanguigna troppo bassa').
explainer(misura_pressione_bassa(_),0,'l''utente ha un valore di pressione sanguigna bassa').
explainer(misura_pressione_ottimale(_),0,'l''utente ha valori di pressione sanguigna ottimali').
explainer(misura_pressione_accettabile(_),0,'l''utente ha un valore di pressione sanguigna acettabile').
explainer(misura_pressione_pre_ipertensione(_),0,'l''utente ha un valore di pressione sanguigna di pre ipertensione').
explainer(misura_pressione_ipertensione(_),0,'l''utente ha un valore di pressione sanguigna di ipertensione').
%MISURA_BATTITO_CARDIACO
explainer(misura_battito_cardiaco_brachicardia(_),0,'l''utente ha un valore di battito cardiaco di brachicardia').
explainer(misura_battito_cardiaco_normalita(_),0,'l''utente ha valore di battito cardiaco normale').
explainer(misura_battito_cardiaco_tachicardia(_),0,'l''utente ha valore di battito cardiaco di tachicardia').
%MISURA_TEMPERATURA_CORPOREA
explainer(misura_temperatura_corporea_subfebbrile(_),0,'l''utente ha un valore di temperatura corporea subfebbrile').
explainer(misura_temperatura_corporea_febbricola(_),0,'l''utente ha un valore di temperatura corporea febbricola').
explainer(misura_temperatura_corporea_moderata(_),0,'l''utente ha un valore di temperatura corporea moderata').
explainer(misura_temperatura_corporea_elevata(_),0,'l''utente ha un valore di temperatura corporea elevata').
explainer(misura_temperatura_corporea_iperpiressia(_),0,'l''utente ha un valore di temperatura corporea di iperpiressia').
%MISURA_SATURAZIONE_OSSIGENO
explainer(misura_saturazione_ossigeno_grave_ipossia(_),0,'l''utente ha un valore di saturazione dell''ossigeno grave ipossia').
explainer(misura_saturazione_ossigeno_lieve_ipossia(_),0,'l''utente ha un valore di saturazione dell''ossigeno di lieve ipossia').
explainer(misura_saturazione_ossigeno_normalita(_),0,'l''utente ha un valore di saturazione dell''ossigeno di normalità').
%MISURA_CADUTA		
explainer(misura_caduta_terra(_),0,'l''utente e'' caduto').
explainer(misura_caduta_piegato(_),0,'l''utente e'' piegato').
explainer(misura_caduta_dritto(_),0,'l''utente e'' in piedi').
%MISURA_IDRATAZIONE_PELLE
explainer(misura_idratazione_pelle_molto_secca(_),0,'l''utente ha un valore di idratazione della pelle molto secca').
explainer(misura_idratazione_pelle_secca(_),0,'l''utente ha un valore di idratazione della pelle secca').
explainer(misura_idratazione_pelle_idratata(_),0,'l''utente ha una pelle idratata').
%MISURA_FREQUENZA_RESPIRATORIA
explainer(misura_frequenza_respiratoria_bradipnea(_),0,'l''utente ha un valore di frequenza respiratoria di bradipnea').
explainer(misura_frequenza_respiratoria_normalita(_),0,'l''utente ha un valore di frequenza respiratoria di normalità').
explainer(misura_frequenza_respiratoria_tachipnea(_),0,'l''utente ha un valore di frequenza respiratoria di tachipnea').
%TERMOMETRO
explainer(termometro_freddo(_),0,'il clima in casa e'' freddo').
explainer(termometro_mite(_),0,'il clima in casa e'' mite').
explainer(termometro_caldo(_),0,'il clima in casa e'' caldo').
%SENSORE_GAS
explainer(sensore_gas_minimo(_),0,'il sensore del gas non ha rilevato nessun pericolo').
explainer(sensore_gas_intermedio(_),0,'il sensore del gas ha rilevato un valore di perdita minima').
explainer(sensore_gas_massimo(_),0,'il sensore del gas ha rilevato un valore di perdita massima').
%SENSORE_ALLAGAMENTO
explainer(sensore_allagamento_allerta_minima(_),0,'il sensore di allagamento non ha rilevato nessun pericolo').
explainer(sensore_allagamento_allerta_media(_),0,'il sensore di allagamento ha rilevato un allerta media').
explainer(sensore_allagamento_allerta_massima(_),0,'il sensore di allagamento ha rilevato un allerta massima').
%SENSORE_TV
explainer(sensore_tv_spento(_),0,'tv spenta').
explainer(sensore_tv_acceso(_),0,'tv accesa').
%SENSORE_PERSONALE
explainer(sensore_personale(_,no),1,'l''utente non ha nessun sensore personale').
explainer(sensore_personale(_,glicemico),1,'l''utente ha un sensore personale di rilevazione di glicemia').
explainer(sensore_personale(_,pressione),1,'l''utente ha un sensore personale di rilevazione di pressione sanguigna').
explainer(sensore_personale(_,idratazione_corpo),1,'l''utente ha un sensore personale di rilevazione di idratazione del corpo').
explainer(sensore_personale(_,frequenza_respiratoria),1,'l''utente ha un sensore personale di frequenza respiratoria').
explainer(sensore_personale(_,frequenza_cardiaca),1,'l''utente ha un sensore personale di frequenza cardiaca').
explainer(sensore_personale(_,saturazione_ossigeno),1,'l''utente ha un sensore personale di saturazione dell''ossigeno').
explainer(sensore_personale(_,temperatura_corporea),1,'l''utente ha un sensore personale di temperatura corporea').
explainer(sensore_personale(_,caduta),1,'l''utente ha un sensore personale di caduta').
%SENSORE_AMBIENTALE
explainer(sensore_ambientale(_,no),1,'l''ambiente non ha nessun sensore ambientale attivo').
explainer(sensore_ambientale(_,attuatore_luce),1,'il sensore ambientale attivo e'' la luce').
explainer(sensore_ambientale(_,attuatore_volume),1,'il sensore ambientale attivo e'' il volume').
explainer(sensore_ambientale(_,attuatore_gas),1,'il sensore il sensore ambientale attivo e'' il gas').
explainer(sensore_ambientale(_,attuatore_allagamento),1,'il sensore il sensore ambientale attivo e'' l''allagamento').
%ATTIVITA
explainer(attivita(_,lavare),1,'l''utente si sta lavando').
explainer(attivita(_,mangiare),1,'l''utente sta mangiando').
explainer(attivita(_,cucinare),1,'l''utente sta cucinando').
explainer(attivita(_,leggere),1,'l''utente sta leggendo').
explainer(attivita(_,guardare_tv),1,'l''utente sta guardando la tv').
explainer(attivita(_,dormire),1,'l''utente sta dormendo').
explainer(attivita(_,camminare),1,'l''utente sta camminando').
explainer(attivita(_,lavare_piatti),1,'l''utente sta lavando le stoviglie').
%ATTUATORI
explainer(attuatore_luce(_,spento),1,'luce spenta').
explainer(attuatore_luce(_,acceso),1,'luce accesa').
explainer(attuatore_allagamento(_,spento),1,'nessuno pericolo di allagamento').
explainer(attuatore_allagamento(_,acceso),1,'allarme casa allagata').
explainer(attuatore_finestra(_,chiuso),1,'finestra chiusa').
explainer(attuatore_finestra(_,aperto),1,'finestra aperta').
explainer(attuatore_volume(_,spento),1,'attuatore volume spento').
explainer(attuatore_volume(_,acceso),1,'attuatore volume acceso').
%ALLARMI
explainer(allarme_gas(_,spento),1,'nessun pericolo di gas').
explainer(allarme_gas(_,acceso),1,'allarme perdita di gas').
explainer(allarme_glicemico(_,ipoglicemia),1,'l''utente presenta un livello di glicemia nel sangue al di sotto della norma').
explainer(allarme_glicemico(_,normalita),1,'l''utente presenta un livello di glicemia nel sangue nella norma').
explainer(allarme_glicemico(_,iperglicemia),1,'l''utente presenta un livello di glicemia nel sangue al di sopra della norma').
explainer(allarme_pressione(_,troppo_bassa),1,'l''utente presenta una pressione arteriosa al di sotto della norma').
explainer(allarme_pressione(_,bassa),1,'l''utente presenta una pressione arteriosa quasi al di sotto della norma').
explainer(allarme_pressione(_,ottimale),1,'l''utente presenta una pressione arteriosa ottimale').
explainer(allarme_pressione(_,accettabile),1,'l''utente presenta una pressione arteriosa nella norma').
explainer(allarme_pressione(_,pre_ipertensione),1,'l''utente presenta una pressione arteriosa quasi al di sopra della norma').
explainer(allarme_pressione(_,ipertensione),1,'l''utente presenta una pressione arteriosa al di sopra della norma').
explainer(allarme_battito_cardiaco(_,brachicardia),1,'l''utente presenta un battito cardiaco al di sotto della norma').
explainer(allarme_battito_cardiaco(_,normalita),1,'l''utente presenta un battito cardiaco nella norma').
explainer(allarme_battito_cardiaco(_,tachcardia),1,'l''utente presenta un battito cardiaco al di sopra della norma').
explainer(allarme_temperatura_corporea(_,subfebbrile),1,'l''utente presenta un livello di temperatura corporea al di sotto della norma').
explainer(allarme_temperatura_corporea(_,febbricola),1,'l''utente presenta un livello di temperatura corporea quasi al di sotto della norma').
explainer(allarme_temperatura_corporea(_,moderata),1,'l''utente presenta un livello di temperatura corporea nella norma').
explainer(allarme_temperatura_corporea(_,elevata),1,'l''utente presenta un livello di temperatura corporea quasi al di sopra della norma').
explainer(allarme_temperatura_corporea(_,iperpiressia),1,'l''utente presenta un livello di temperatura corporea al di sopra della norma').
explainer(allarme_misura_saturazione_ossigeno(_,grave_ipossia),1,'l''utente presenta un livello di ossigeno nel corpo al di sotto della norma').
explainer(allarme_misura_saturazione_ossigeno(_,lieve_ipossia),1,'l''utente presenta un livello di ossigeno nel corpo al quasi di sotto della norma').
explainer(allarme_misura_saturazione_ossigeno(_,normalita),1,'l''utente presenta un livello di ossigeno nel corpo nella norma').
explainer(allarme_idratazione_corpo(_,molto_secca),1,'l''utente presenta un livello di idratazione del corpo al di sotto della norma').
explainer(allarme_idratazione_corpo(_,secca),1,'l''utente presenta un livello di idratazione del corpo quasi al di sotto della norma ').
explainer(allarme_idratazione_corpo(_,idratata),1,'l''utente presenta un livello di idratazione del corpo nella norma').
explainer(allarme_caduta(_,terra),1,'allarme: l''utente e'' a terra').
explainer(allarme_caduta(_,piegato),1,'l''utente e'' piegato').
explainer(allarme_caduta(_,dritto),1,'l''utente e'' in piedi').
explainer(allarme_frequenza_misura_respiratoria(_,bradipnea),1,'l''utente presenta una frequenza respiratoria al di sotto della norma').
explainer(allarme_frequenza_misura_respiratoria(_,normalita),1,'l''utente presenta una frequenza respiratoria nella norma').
explainer(allarme_frequenza_misura_respiratoria(_,tachipnea),1,'l''utente presenta una frequenza respiratoria al di sopra della norma').









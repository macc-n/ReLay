/**********************************************************
        
        Modulo: seva_setting_unfunction.pl
        Autori: Pasquadibisceglie V. - Zaza G.
        Descrizione: modulo contenente gli ufunctinput e ufunctoutput
                     del caso di studio "Smart Home for Elderly People" 


**********************************************************/


:- dynamic (ufunctoutput/4).
:- dynamic (ufunctinput/4).

ufunctinput(1,parkinson_grave,[no,si],[0,1]).
ufunctinput(2,alzheimer_grave,[no,si],[0,1]).
ufunctinput(3,parkinson_lieve,[no,si],[0,1]).
ufunctinput(4,alzheimer_lieve,[no,si],[0,1]).
ufunctinput(5,cardiopatia,[no,si],[0,1]).
ufunctinput(6,artrosi,[no,si],[0,1]).
ufunctinput(7,diabete,[no,si],[0,1]).
ufunctinput(8,respiratoria,[no,si],[0,1]).
ufunctinput(9,deficit_uditivo,[no,si],[0,1]).
ufunctinput(10,deficit_visivo,[no,si],[0,1]).

%periodo_della_giornata
ufunctinput(11,periodo_del_giorno,[alba,mattina,mezzoggiorno,pomeriggio,sera,notte],[[[4,6],8],[6,[8,10],12],[12,14,16],[14,16,18],[16,[18,20],22],[22,[24,4]]]).
%Situazone_atmosferica
ufunctinput(12,situazione_atmosferica,[sereno,nuvoloso,maltempo],[[0],[1],[2]]).

%pir
ufunctinput(13,pir_bagno,[spento,acceso],[0,1]).
ufunctinput(14,pir_cucina,[spento,acceso],[0,1]).
ufunctinput(15,pir_camera_da_letto,[spento,acceso],[0,1]).
ufunctinput(16,pir_salotto,[spento,acceso],[0,1]).

%sensori
ufunctinput(17,misura_glicemia,[ipoglicemia,normalita,iperglicemia],[[[0,30],60],[50,80,110],[90,[120,140]]]).
%pressione
ufunctinput(18,misura_pressione,[troppo_bassa,bassa,ottimale,accettabile,pre_ipertensione,ipertensione],[[[0,30],60],[50,[60,70],90],[95,105,115],[105,115,130],[120,[125,130],140],[135,[145,160]]]).
%frequenza battito cardiaco
ufunctinput(19,misura_battito_cardiaco,[brachicardia,normalita,tachicardia],[[[0,30],60],[50,70,90],[80,[110,140]]]).
%temperatura
ufunctinput(20,misura_temperatura_corporea,[subfebbrile,febbricola,moderata,elevata,iperpiressia],[[[37.1,37.2],37.3],[37.2,37.4,37.6],[37.5,38,38.9],[38.8,39.5,39.9],[40,[40.5,41]]]).
%ossigeno
ufunctinput(21,misura_saturazione_ossigeno,[grave_ipossia,lieve_ipossia,normalita],[[[70,80],90],[88,93,95],[94,[96,99]]]).
%sensore_caduta
ufunctinput(22,misura_caduta,[terra,piegato,dritto],[[[0,23],45],[23,45,60],[45,[60,90]]]).
%idratazione_pelle
ufunctinput(23,misura_idratazione_pelle,[molto_secca,secca,idratata],[[[0,7.5],15],[7.5,15,25],[15,[25,30]]]).
%misura_frequenza_respiratoria
ufunctinput(24,misura_frequenza_respiratoria,[bradipnea,normalita,tachipnea],[[[0,6],12],[8,12,16],[13,[15,20]]]).
%termometro
ufunctinput(25,termometro,[freddo,mite,caldo],[[0,10,20],[15,20,27],[25,[30,40]]]).
%sensore gas
ufunctinput(26,sensore_gas,[minimo,intermedio,massimo],[[0,2,4.4],[3,8,10],[9,[12,15]]]).
%allagamento
ufunctinput(27,sensore_allagamento,[allerta_minima,allerta_media,allerta_massima],[[0,7.5,10],[7.5,10,15],[8,[15,20]]]).
ufunctinput(28,sensore_tv,[spento,acceso],[[0],[1]]).

%OUTPUT
ufunctoutput(1,sensore_personale,[no,glicemico,pressione,idratazione_corpo,frequenza_respiratoria,frequenza_cardiaca,saturazione_ossigeno,temperatura_corporea,caduta],[0,1,2,3,4,5,6,7,8,9]).
ufunctoutput(2,sensore_ambientale,[no,attuatore_luce,attuatore_volume,attuatore_gas,attuatore_allagamento],[0,1,2,3,4]).
ufunctoutput(3,attivita,[lavare,mangiare,cucinare,leggere,guardare_tv,dormire,camminare,lavare_piatti],[0,1,2,3,4,5,6,7]).
%attuatori
ufunctoutput(4,attuatore_luce,[spento,acceso],[0,1]).
ufunctoutput(5,allarme_gas,[spento,acceso],[0,1]).
ufunctoutput(6,attuatore_allagamento,[spento,acceso],[0,1]).
ufunctoutput(7,attuatore_finestra,[chiuso,aperto],[0,1]).
ufunctoutput(8,attuatore_volume,[spento,acceso],[0,1]).
ufunctoutput(9,allarme_glicemico,[iperglicemia,normalita,iperglicemia],[0,1,2]).
ufunctoutput(10,allarme_pressione,[troppo_bassa,bassa,ottimale,accettabile,pre_ipertensione,ipertensione],[0,1,2,3,4,5]).
ufunctoutput(11,allarme_battito_cardiaco,[brachicardia,normalita,tachicardia],[0,1,2]).
ufunctoutput(12,allarme_temperatura_corporea,[subfebbrile,febbricola,moderata,elevata,iperpiressia],[0,1,2,3,4]).
ufunctoutput(13,allarme_misura_saturazione_ossigeno,[grave_ipossia,lieve_ipossia,normalita],[0,1,2]).
ufunctoutput(14,allarme_idratazione_corpo,[molto_secca,secca,idratata],[0,1,2]).
ufunctoutput(15,allarme_caduta,[terra,piegato,dritto],[0,1,2]).
ufunctoutput(16,allarme_frequenza_misura_respiratoria,[bradipnea,normalita,tachipnea],[0,1,2]). 
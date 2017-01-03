:- dynamic (ufunctoutput/4).
:- dynamic (ufunctinput/4).
:- dynamic (explainer/4).

%***********************************************************************
%** Fuzzification
%***********************************************************************

%****************__ FUNCTION__*********************************************

%Funzioni di membership di input S garden
ufunctinput(1,music_level,[low,middle_low,middle,middle_high,high],[[[0,20],35],[20,35,50],[35,50,65],[50,65,80],[65,[80,100]]]).
ufunctinput(2,natural_brightness_garden,[low,middle,high],[[[0,40],10000],[40,10000,20000],[10000,[20000,30000]]]). %MODIFICATA IN QUANTO IN CONFLITTO CON SEVA E LIVING
ufunctinput(3,chlorinature,[low,middle,high],[[[0,40],10000],[40,10000,20000],[10000,[20000,30000]]]).
ufunctinput(4,pollution,[low,middle,high],[[[0,25],50],[25,50,150],[50,[150,200]]]). 
ufunctinput(5,insolation_level,[low,middle,high],[[[0,0.45],0.7],[0.45,0.7,0.9],[0.7,[0.9,1]]]).
ufunctinput(6,external_humidity_garden,[low,middle,high],[[[0,20],35],[20,35,50],[35,[50,100]]]).
ufunctinput(7,wind_strength,[low,middle,high],[[[0,2],3.5],[2,3.5,5],[3.5,[5,10]]]).
ufunctinput(8,water_temperature,[min,low, middle_low, middle, middle_high,high, max],[[[0,9],11],[9,11,13.5],[11,13.5,20],[13.5,20,25.5],[20,25.5,28.5],[25.5,28.5, 32],[28.5,[30,32]]]).
ufunctinput(9,hardness_water,[soft,middle,hard],[[[0,0.45],0.7],[0.45,0.7,0.9],[0.7,[0.9,1]]]).

%Funzioni di membership di input living
ufunctinput(10,natural_brightness,[low,middle,high],[[[0,800],1600],[800,1600,3200],[1600,[3200,100000]]]). %OK
ufunctinput(11,internal_brightness,[very_low,middle_low,middle,middle_high,very_high],[[[0,50],200],[50,200,500],[200,500,800],[500,800,950],[800,[950,100000]]]). %OK
ufunctinput(12,living_room,[free,occupied],[0,1]). %OK
ufunctinput(13,present_rain,[no,yes],[0,1]).%OK
ufunctinput(14,external_humidity,[low,middle,high],[[[0,25],50],[25,50,75],[50,[75,100]]]).%OK
ufunctinput(15,external_temperature,[low,middle,high],[[[0,5],10],[10,[15,20],25],[25,[30,50]]]).%OK
ufunctinput(16,wind_speed,[low,middle,high],[[[0.0,2.0],8.0],[2.0,8.0,14.0],[8.0,[14.0,30.0]]]). %OK
ufunctinput(17,solar_radiation,[low,middle,high],[[[0,2000],4000],[2000,4000,8000],[4000,[8000,50000]]]). %OK
ufunctinput(18,is,[sunrise,morning,midday,afternoon,evening,night],[[[4,6],8],[6,[8,10],12],[12,14,16],[14,16,18],[16,[18,20],22],[22,[24,4]]]). %OK
ufunctinput(19,internal_temperature,[low,middle,high],[[[0,9],16],[9,[16,20],27],[20,[27,100]]]). %OK
ufunctinput(20,air_speed,[low,middle,high],[[[0,0.3],0.6],[0.3,0.6,1.2],[0.6,[1.2,30.0]]]). %OK
ufunctinput(21,internal_humidity,[low,middle,high],[[[0,25],40],[25,[40,60],75],[60,[75,100]]]). %OK
ufunctinput(22,box,[break,occupied],[0,1]).

%Funzioni di membership di seva
ufunctinput(23,rain_presence,[no,yes],[0,1]).
ufunctinput(24,external_temperature_seva,[low,middle,high],[[[0,10],20],[10,20,30],[20,[30,100]]]). %MODIFICATA IN QUANTO IN CONFLITTO CON LIVING
ufunctinput(25,wind_strength_seva,[low,middle,high],[[[0.0,2.0],8.0],[2.0,8.0,14.0],[8.0,[14.0,30.0]]]). %MODIFICATA IN QUANTO IN CONFLITTO CON S-GARDEN
ufunctinput(26,solar_radiation_seva,[low,middle,high],[[[0,2000],4000],[2000,4000,8000],[4000,[8000,100000]]]). %MODIFICATA IN QUANTO IN CONFLITTO CON LIVING
ufunctinput(27,is_seva,[morning,midday,evening],[[[1,8],12],[8,[12,16],20],[16,[20,24]]]). %MODIFICATA IN QUANTO IN CONFLITTO CON LIVING
ufunctinput(28,internal_air_speed,[low,middle,high],[[[0,0.3],0.6],[0.3,0.6,1.2],[0.6,[1.2,30.0]]]).
ufunctinput(29,activity,[nothing,party,writing,watching_device,conversing,eating,reading],[[1],[2],[3],[4],[5],[6],[7]]).

%Funzioni di membership di input smart bathroom
ufunctinput(30,touch,[razor,brush,electric_toothbrush,dryer,shower_tap,sink_tap,makeup,wc,bidet],[[1],[2],[3],[4],[5],[6],[7],[8],[9]]).
ufunctinput(31,used,[wc,bidet,sink,shower,razor,brush,makeup,electric_toothbrush],[[1],[2],[3],[4],[5],[6],[7],[8]]).
ufunctinput(32,is_naked,[yes,no],[1,0]).
ufunctinput(33,dirty,[wc_feces,wc_urine,face,hands,teeth],[[1],[2],[3],[4],[5]]).
ufunctinput(34,is_near,[sink_yes,sink_no,mirror_yes,mirror_no,shower_yes,shower_no,wc_yes,wc_no,bidet_yes,bidet_no],[[1],[2],[3],[4],[5],[6],[7],[8],[9],[10]]).
ufunctinput(35,is_present,[yes,no],[1,0]).
ufunctinput(36,mode,[eco,comfort,max,manual],[[1],[2],[3],[4]]).
ufunctinput(37,external_temp,[vBelowMinus10,vMinus10_0,v0_10,v10_20,v20_30,v30_40,vPlus40],[[[-100,-10],-9],[-10,[-9,0],1],[0,[1,10],11],[10,[11,20],21],[20,[21,30],31],[30,[31,40],41],[40,[41,100]]]).
ufunctinput(38,internal_temp,[v0_5,v5_10,v10_20,v20_30,v30_40,vPlus40],[[[0,5],6],[5,[6,10],11],[10,[11,20],21],[20,[21,30],31],[30,[31,40],41],[40,[41,100]]]).
ufunctinput(39,ext_humidity,[v0_20,v20_30,v30_40,v40_50,v50_60,v60_70,v70_80,v80_90,v90_100],[[[0,20],21],[20,[21,30],31],[30,[31,40],41],[40,[41,50],51],[50,[51,60],61],[60,[61,70],71],[70,[71,80],81],[80,[81,90],91],[90,[91,100]]]).
ufunctinput(40,int_humidity,[v0_20,v20_30,v30_40,v40_50,v50_60,v60_70,v70_80,v80_90,v90_100],[[[0,20],21],[20,[21,30],31],[30,[31,40],41],[40,[41,50],51],[50,[51,60],61],[60,[61,70],71],[70,[71,80],81],[80,[81,90],91],[90,[91,100]]]).
ufunctinput(41,shower_temp,[v0_10,v10_20,v20_30,v30_40,v40_50,v50_60,vPlus60],[[[0,10],11],[10,[11,20],21],[20,[21,30],31],[30,[31,40],41],[40,[41,50],51],[50,[51,60],61],[60,[61,100]]]).
ufunctinput(42,bidet_temp,[v0_10,v10_20,v20_30,v30_40,v40_50,v50_60,vPlus60],[[[0,10],11],[10,[11,20],21],[20,[21,30],31],[30,[31,40],41],[40,[41,50],51],[50,[51,60],61],[60,[61,100]]]).
ufunctinput(43,sink_temp,[v0_10,v10_20,v20_30,v30_40,v40_50,v50_60,vPlus60],[[[0,10],11],[10,[11,20],21],[20,[21,30],31],[30,[31,40],41],[40,[41,50],51],[50,[51,60],61],[60,[61,100]]]).
ufunctinput(44,nat_lux,[v0_50,v50_100,v100_200,v200_300,v300_400,v400_500,v500_600,vPlus600],[[[0,50],51],[50,[51,100],101],[100,[101,200],201],[200,[201,300],301],[300,[301,400],401],[400,[401,500],501],[500,[501,600],601],[600,[601,100000]]]).
ufunctinput(45,tot_lux,[v0_50,v50_100,v100_200,v200_300,v300_400,v400_500,v500_600,v600_1000,vPlus1000],[[[0,50],51],[50,[51,100],101],[100,[101,200],201],[200,[201,300],301],[300,[301,400],401],[400,[401,500],501],[500,[501,600],601],[600,[601,1000],1001],[1000,[1001,100000]]]).
ufunctinput(46,month,[january,february,march,april,may,june,july,august,september,october,november,december],[[1],[2],[3],[4],[5],[6],[7],[8],[9],[10],[11],[12]]).
ufunctinput(47,gender,[male,female],[1,0]).
ufunctinput(48,toilet_seat,[up,down],[1,0]).


%***********************************************************************
%** Funzioni di membership di input butler (morisco petrera)
%***********************************************************************
ufunctinput(58,temp_esterna,[molto_bassa,bassa,medio_bassa,medio_alta,alta,molto_alta],[[[0,5],6],[5,[6,10],11],[10,[11,24],25],[24,[25,30],31],[30,[31,40],41],[40,[41,100]]]).		
ufunctinput(50,pioggia,[si,no],[1,2]).
ufunctinput(59,lum_esterna,[molto_bassa,bassa,medio_bassa,medio_alta,alta,molto_alta],[[[0,50],51],[50,[51,200],201],[200,[201,300],301],[300,[301,400],401],[400,[401,500],501],[500,[501,100000]]]). 
ufunctinput(53,attivazione_allarme,[on,off],[1,2]).
ufunctinput(54,perimetrale,[on,off],[1,2]).
ufunctinput(55,volumetrico,[on,off],[1,2]).
ufunctinput(56,stanza,[camera1,camera2,camera3,bagno,soggiorno,cucina],[[1],[2],[3],[4],[5],[6]]).
ufunctinput(57,fascia_ora,[notte,mattina,pomeriggio,notte],[[0,[1,6],7],[6,[7,11],12],[11,[12,19],20],[19,[20,23],24]]).

%temperatura interna
ufunctinput(58,temperatura,[molto_bassa,bassa,medio_bassa,medio_alta,alta,molto_alta],[[[0,5],6],[5,[6,10],11],[10,[11,24],25],[24,[25,30],31],[30,[31,40],41],[40,[41,100]]]).
% luminosit? interna
ufunctinput(59,luminosita,[molto_bassa,bassa,medio_bassa,medio_alta,alta,molto_alta],[[[0,50],51],[50,[51,200],201],[200,[201,300],301],[300,[301,400],401],[400,[401,500],501],[500,[501,100000]]]).

%rumore 20 40 60 80 100 120 140
ufunctinput(60,rumore,[basso,medio,alto],[[[0,49],50],[49,[50,74],75],[74,[75,150]]]). 

%utenti

ufunctinput(61,utente,[medio,medio,caloroso,freddoloso,altro],[[1],[2],[3],[4],[5]]).
ufunctinput(62,presenza,[si,no],[1,2]).
ufunctinput(63,attivita_utente,[studia,dorme,relax,mangia,altro],[[1],[2],[3],[4],[5]]).


%sensori fumo gas allagamento
ufunctinput(67,sensore_gas,[si,no],[1,2]).
ufunctinput(66,sensore_fumo,[si,no],[1,2]).
ufunctinput(69,sensore_acqua,[si,no],[1,2]).
ufunctinput(70,valvola_gas,[aperta,chiusa],[1,2]).
ufunctinput(71,valvola_acqua,[aperta,chiusa],[1,2]).

%stagione
ufunctinput(72,stagione,[inverno,inverno,primavera,primavera,primavera,estate,estate,estate,autunno,autunno,autunno,inverno],[[1],[2],[3],[4],[5],[6],[7],[8],[9],[10],[11],[12]]).





/***********************************************************************
ATTENZIONE: SPOSTATE PER INTERPROLOG
 Funzioni di membership di input smart_menu (minafra)
 le funzioni commentate sono quelle gi? definite per altri progetti e riutilizzate per uniformit?
***********************************************************************/
%cattivi odori

%affollamento
ufunctinput(73, tempo_serata, [inizio, inizio, inizio, meta, meta, meta, fine, fine, fine, fine],  [ [18] , [19] , [20] , [21] , [22] , [23] , [24] , [1] , [2] , [3] ]  ).
ufunctinput(74, aroma, [sgradevole, neutrale, gradevole], [ [0] , [1] , [2] ] ).
ufunctinput(76, cattivi_odori, [no, si], [ [0] , [1] ]).
ufunctinput(77, livello_affollamento, [basso, medio, alto], [ [[0,3],4] , [3,[4,6],7], [6,[7,10]] ]).
%ufunctinput(66,sensore_fumo,[si,no],[1,2]).
%ufunctinput(58,temp_esterna,[molto_bassa,bassa,medio_ bassa,medio_alta,alta,molto_alta],[[[0,5],6],[5,[6,10],11],[10,[11,24],25],[24,[25,30],31],[30,[31,40],41],[40,[41,100]]]).		
%ufunctinput(72,stagione,[inverno,inverno,primavera,primavera,primavera,estate,estate,estate,autunno,autunno,autunno,inverno],[[1],[2],[3],[4],[5],[6],[7],[8],[9],[10],[11],[12]]).
%ufunctinput(23,rain_presence,[no,yes],[0,1]).
%ufunctinput(1,music_level,[low,middle_low,middle,middle_high,high],[[[0,20],35],[20,35,50],[35,50,65],[50,65,80],[65,[80,95]]]).
%%%%%%%%%%%%%%^^^USATE^^^


%%%%%%%%%%%%%%^^^DA USARE^^^
%ufunctinput(73, thermalComfort, [freddo, benessere, caldo],  [ [[0,19],20] , [21,[22,26],27] , [28,[29,100]] ]  ). %non pi? usata



%Funzioni di membership di output living 
ufunctoutput(1,lux_level,[stop_l,l1_l,l2_l,l3_l,l4_l],[0,25,50,75,100]).
ufunctoutput(2,central_heating_level,[stop_h,l1_h,l2_h,l3_h,l4_h],[0,25,50,75,100]).
ufunctoutput(3,air_conditioning_level,[stop_c,l1_c,l2_c,l3_c,l4_c],[0,25,50,75,100]).
ufunctoutput(4,ventilation_level,[stop_v,l1_v,l2_v,l3_v,l4_v],[0,25,50,75,100]).
ufunctoutput(5,state_windows,[close_w,open_w],[0,100]).
ufunctoutput(6,sunshade_home,[close_su,open_su],[0,100]).
ufunctoutput(7,shutters_home,[close_sh,l1_sh,open_sh],[0,50,100]).

%Funzioni di membership di output seva
ufunctoutput(8,lux_dimming_level,[stop,l1,l2,l3,max],[0,25,50,75,100]).
ufunctoutput(9,degree_dimming_level,[stop,l1,l2,l3,max],[0,25,50,75,100]).
ufunctoutput(10,air_dimming_level,[stop,l1,l2,l3,max],[0,25,50,75,100]).
ufunctoutput(11,blind_dimming_level,[stop,l1,l2,l3,max],[0,25,50,75,100]).

%Funzioni di membership di output smart bathroom
ufunctoutput(12,wc_clean,[off,short,long],[0,50,100]).
ufunctoutput(13,bidet_fill,[no,current_water,half,full],[0,1,50,100]).
ufunctoutput(14,bidet_empty,[no,yes],[0,1]).
ufunctoutput(15,shower_dispense,[no,yes],[0,1]).
ufunctoutput(16,sink_fill,[no,current_water,half,full],[0,1,50,100]).
ufunctoutput(17,sink_empty,[no,yes],[0,1]).
ufunctoutput(18,window_choice,[close,open],[0,1]).
ufunctoutput(19,radiators_choice,[off,low,middle,max],[0,25,50,100]).
ufunctoutput(20,air_conditioner_choice,[off,dehumidifier,low,middle,max],[0,1,25,50,100]).
ufunctoutput(21,showertemp_setting,[temp0,temp10,temp20,temp30,temp40,temp50],[0,10,20,30,40,50]).
ufunctoutput(22,bidettemp_setting,[temp0,temp10,temp20,temp30,temp40,temp50],[0,10,20,30,40,50]).
ufunctoutput(23,sinktemp_setting,[temp0,temp10,temp20,temp30,temp40,temp50],[0,10,20,30,40,50]).
ufunctoutput(24,lux_setting,[lux0,lux100,lux200,lux300,lux400,lux500],[0,100,200,300,400,500]).
ufunctoutput(25,ceiling_lamp_choice,[zero,one,two,three],[0,1,2,3]).
ufunctoutput(26,mirror_lamp_choice,[off,one],[0,1]).
ufunctoutput(27,rollupshutter_choice,[close,half,open],[0,50,100]).





explainer(tempo_serata_inizio(_),1,'La serata ? appena iniziata',[]).
explainer(tempo_serata_meta(_),1,'La serata ? nel pieno',[]).
explainer(tempo_serata_fine(_),1,'La serata ? quasi conclusa',[]).

explainer(aroma_sgradevole(_),1,'Si sente un aroma sgradevole',[]).
explainer(aroma_neutrale(_),1,'Si sente un aroma neutrale',[]).
explainer(aroma_gradevole(_),1,'Si sente un aroma gradevole',[]).

explainer(cattivi_odori_si(_),1,'Si sentono cattivi odori',[]).
explainer(cattivi_odori_no(_),1,'Non si sentono cattivi odori',[]).

explainer(livello_affollamento_basso(_),1,'Il livello di affollamento ? basso',[]).
explainer(livello_affollamento_medio(_),1,'Il livello di affollamento ? medio',[]).
explainer(livello_affollamento_alto(_),1,'Il livello di affollamento ? alto',[]).



explainer(libero(A, _),1,'Il tavolo ? libero: '+A, [] ).
explainer(num_capotavola(TAVOLO, NUM),1,'Il tavolo '+TAVOLO+' ha '+NUM+' capotavola', [] ).
explainer(appartato(A, _),1,'Il tavolo ? appartato: '+A, [] ).
explainer(autorevole(IDcliente),1,'Il cliente ? autorevole: '+IDcliente, [] ).
explainer(thermal_comfort_tav(A, _),1,'Il tavolo ? nelle condizioni di temperatura ottimali: '+A, [] ).
explainer(ha_posti_compatibili(A,C),1,'Il tavolo '+A+' ha posti compatibili con il cliente: '+C, [] ).
explainer(tavolo_disponibile(A, C, _),1,'Il tavolo '+A+' ? libero e il cliente '+C+' si potrebbe accomodare', [] ).
explainer(far_vedere_fuori(A, _),1,'Il tavolo '+A+' ? da far vedere dal esterno', [] ).
explainer(thermal_comfort_tav(A, _),1,'Il tavolo '+A+' ? da nelle condizioni ideali di temperatura', [] ).
explainer(preoccupati_temperatura(_),1,'La tmeperatura esterna ? a livelli critici', [] ).
explainer(fattore_sala(A, _, piove_si),1,'Il tavolo '+A+' ? vicino alla finestra mentre piove', [] ).
explainer(fattore_sala(A, _, bagno_rotto),1,'Il tavolo '+A+' ? vicino al bagno rotto', [] ).
explainer(fattore_sala(A, _, aroma_no),1,'Il tavolo '+A+' ? vicino alla cucina mentre esce un aroma sgradevole', [] ).
explainer(fattore_sala(A, _, forno_fumo),1,'Il tavolo '+A+' ? vicino al forno mentre esce del fumo', [] ).
explainer(fattore_sala(A, _, affollato_si),1,'Il tavolo '+A+' ? vicino alla cassa mentre la zona ? affollata', [] ).



%S GARDEN
/*************************************************
  IRRIGATION PREMISES
*************************************************/

explainer(rain_level( _, 0),0,'it has not rained', [] ).
explainer(nearby_green_no(_),0,'there are not person nearby the green',[]).
explainer(nearby_green_yes(_),0,'there are person nearby the green',[]).
explainer(setted_irrigation_time_yes(_), 0 , ' it is arrived the time to active the irrigation' ,[]).
explainer(setted_irrigation_time_no(_), 0 , ' it is not arrived the time to active the irrigation' ,[]).

explainer(system_activity(calculate_parameter), 0,' I was calculating paremeters',[]).

explainer(month_january(_), 0 , ' we are in january',[]).
explainer(month_february(_), 0 , ' we are in february',[]).
explainer(month_march(_), 0 , ' we are in march',[]).
explainer(month_april(_), 0 , ' we are in april',[]).
explainer(month_may(_), 0 , ' we are in may',[]).
explainer(month_june(_), 0 , ' we are in june',[]).
explainer(month_july(_), 0 , ' we are in july',[]).
explainer(month_august(_), 0 , ' we are in august',[]).
explainer(month_september(_), 0 , ' we are in september',[]).
explainer(month_october(_), 0 , ' we are in october',[]).
explainer(month_november(_), 0 , ' we are in november',[]).
explainer(month_december(_), 0 , ' we are in december',[]).

explainer(astronomic_day_N(X), 1 , ' the mean light exposition is  ', [X]).


explainer(insolation_level_low(_), 0 , ' the day mean level of insolation was low ' ,[]).
explainer(insolation_level_middle(_), 0 , ' the day mean level of insolation was middle ',[] ).
explainer(insolation_level_high(_), 0 , ' the day mean level of insolation was high ',[] ).

explainer(external_humidity_low(_) , 0 , ' the day mean level of external humidity was low  ',[] ).
explainer(external_humidity_middle(_) , 0 , ' the day mean level of external humidity was middle ',[] ).
explainer(external_humidity_high(_) , 0 , ' the day mean level of external humidity was high  ',[] ).

explainer(wind_strength_low(_), 0 , 'the day mean level of the wind was low  ',[]  ).
explainer(wind_strength_middle(_), 0 , 'the day mean level of the wind was middle  ' ,[] ).
explainer(wind_strength_high(_), 0 , 'the day mean level of the wind was high  ' ,[] ).

explainer(soil_composition_clay(_), 0 , ' The soil is clay ',[] ).
explainer(soil_composition_middle_clay(_), 0 , ' The soil is middle clay',[] ).
explainer(soil_composition_middle_silty(_), 0 , ' The soil is middle silty',[] ).
explainer(soil_composition_middle_sandy(_), 0 , ' The soil is middle_sandy',[] ).
explainer(soil_composition_sandy(_), 0 , ' The soil is sandy',[] ).

explainer(r(_,it), 0, 'the system consider the daily water need of the green and the irrigation system water capacity',[]).
explainer(r(_, et), 0, 'obtained considering the evapotraspirazione, the coltural coefficient and the rain level' ,[]).
explainer(r(_, etp0), 0 , 'Obtained considering the k coefficient and calculate follow the Blaney-Criddle method ',[] ).
explainer(r(_, not_activation), 0 , 'the soil water riserve is grater than 0 mm',[]).

explainer(etp0(X) , 1, 'The etp0 (evapotraspirazione) is ', [X] ).

explainer( soil_water_capacity(X), 1 , ' The soil water capacity is ', [X]  ).
explainer( water_need( X ), 1, ' The water need is ' ,[X]).
explainer(irrigation_time(X), 1, 'It s needed irrigate for ', [X] ).
explainer( k(X), 1 , ' K coefficient is ' ,[X]).

explainer(non(system_action_active_irrigation), 1, 'It\'s not necessary activate the irrigation system',[]).

explainer( system_activity(valutate_irrigation), 1, 'it s needed valutate if activate the irrigation or not ',[]).

/*************************************************
  POOL PREMISES
*************************************************/

explainer(water_temperature_min(_,_),0,'min temperature detected',[]).
explainer(water_temperature_0(_,_),0,'0 temperature detected',[]).
explainer(water_temperature_1(_,_),0,'1 temperature detected',[]).
explainer(water_temperature_2(_,_),0,'2 temperature detected',[]).
explainer(water_temperature_3(_,_),0,'3 temperature detected',[]).
explainer(water_temperature_4(_,_),0,'4 temperature detected',[]).
explainer(water_temperature_5(_,_),0,'5 temperature detected',[]).
explainer(water_temperature_max(_,_),0,'max temperature detected',[]). 

explainer(pressure_filter_alert(_,_),0,'the pressure filter is abnormal(+0.7 bar compare to the original value)',[]).  
explainer(pressure_filter_danger(_,_),0,'the pressure filter is abnormal(+1.5 bar compare to the original value)',[]).  

explainer(hardness_water_hard(_,_),0,'the livel of hardness is high',[]).
explainer(hardness_water_middle(_,_),0,'the livel of hardness is average',[]).
explainer(hardness_water_soft(_,_),0,'the livel of hardness is soft',[]).

explainer(capacity_small(_,_),0,'the capacity level is small',[]).
explainer(capacity_middle(_,_),0,'the capacity level is middle',[]).
explainer(capacity_large(_,_),0,'the capacity level is large',[]).
explainer(capacity_extra_large(_,_),0,'the capacity level is extra-large',[]).

explainer(chlorine_level_alert(_,_),0,'A high-average livel of chlorine has been dected',[]).
explainer(chlorine_level_danger(_,_),0,'A dangerous livel of chlorine has been dected',[]).

explainer(pollution_high(_,_),0,'the pollution level is high',[]).
explainer(inadequate_filtering_on(_,_),0,'the filtering is inadequate',[]).

explainer(algae_alert(_,_),0,'detected algae in the swimming pool',[]).
explainer(algae_danger(_,_),0,'detected high level of algae in the swimming pool',[]).
explainer(algaecide_low(_,_),0,'the algaecide level is low',[]).
explainer(phosphates_alert(_,_),0,'detected phosphates in the swimming pool',[]).

explainer(detergents_alert(_,_),0,'detergents detected',[]).
explainer(corrosion_alert(_,_),0,'corrosion risk',[]).

explainer(iron_alert_yes(_,_),0,'iron detected',[]).
explainer(copper_alert_yes(_,_),0,'copper detected',[]).
explainer(black_sposts_alert(_,_),0,'black spots detected',[]).

explainer(green_water(_,_),0,'green water',[]). 
explainer(cloudy_water(_,_),0,'cloudy water',[]).
explainer(brown_water(_,_),0,'brown water',[]).

explainer(presence_none(_,_),0,'there is no one in the swimming pool',[]).
explainer(weather_rain(_,_),0,'it started to rain',[]).

/************************************************* 
  INTRUDER DEDUCTIONS
*************************************************/

explainer(system_activity_regulate_algaecide(_,_),0,'The system has to regulate the algaecide level',[]).
explainer(system_activity_calculate_filtering_level(_,_),1,'the system needs to calculate the  filtering water level',[]).
explainer(system_activity_regulate_pH(_,_),1,'the system needs to regulate the pH-',[]).

explainer(system_activity_activate_filtering_water(_,_),1,'the system has to filter the water',[]).
explainer(system_activity_activate_backwash(_,_),1,'the system has to active the backwash',[]).
explainer(system_activity_call_owner(_,_),1,'the system has to call the owner',[]).
explainer(system_activity_add_pH(X,_),1,'the system is adding chlorine to regulate the pH',[X]).
explainer(system_activity_activate_chlorination(_,_),1,'the system has to chlorine the water',[]).
explainer(system_activity_add_algaecide(_,_),1,'the system has to add algaecide the water',[]).
explainer(system_activity_activate_robot_alga(_,_),1,'activate the robot to remove the alga',[]).
explainer(system_activity_add_water(_,_),1,'add water to the swimming pool',[]).
explainer(system_activity_close_pool(_,_),1,'close the swimming pool',[]).

explainer(ph_need_low(_,_),1,'pH need is LOW',[]).   
explainer(ph_need_middle(_,_),1,'pH need is MIDDLE',[]).   
explainer(ph_need_high(_,_),1,'pH need is HIGH',[]).   

explainer(cloudy_water(_,_),1,'cloudy water',[]).
explainer(milky_water(_,_),1,'milky water',[]).

explainer(slippery_wall_on(_,_),1,'the wall of the swimming pool is slippery',[]).
explainer(slippery_floor_on(_,_),1,'the floor of the swimming pool is slippery',[]).

explainer(slippery_wall(_,_),1,'the wall of the swimming pool is slippery',[]).
explainer(slippery_floor(_,_),1,'the floor of the swimming pool is slippery',[]).

explainer(smell_chlorine(_,_),1,'smell of chlorine in the air',[]).
explainer(eye_irritation(_,_),1,'eye irritation risk',[]).

explainer(foam_alert(_,_),1,'foam in the swimming pool',[]). 


/*************************************************
  SYSTEM LIGHTING PREMISES
*************************************************/

explainer(natural_brightness_low_garden(_,_),0,'the natural brightness level is LOW',[]).
explainer(natural_brightness_middle_garden(_,_),0,'the natural brightness level is ACCEPTABLE',[]).
explainer(natural_brightness_high_garden(_,_),0,'the natural brightness level is HIGH',[]).

explainer(activity_reading(_,_),0,'the activity of the User is READING',[]).
explainer(activity_writing(_,_),0,'the activity of the User is WRITING',[]). 
explainer(activity_studying(_,_),0,'the activity of the User is STUDYING',[]).
explainer(activity_eating(_,_),0,'the activity of the User is EATING',[]).
explainer(activity_dancing(_,_),0,'the activity of the User is DANCING',[]).
explainer(activity_cooking(_,_),0,'the activity of the User is COOKING',[]).
explainer(activity_resting(_,_),0,'the activity of the User is RESTING',[]). 
explainer(activity_chatting(_,_),0,'the activity of the User is CHATTING',[]).   

explainer(event_none(_,_),0,'NO specific event',[]). 
explainer(special_program_no(_,_),0,'NO special lighting program setted',[]).
explainer(presence_none(_,_),0,'NO ONE in the garden',[]).  

/************************************************* 
  SYSTEM LIGHTING DEDUCTIONS
*************************************************/

explainer(lux_illumimance_off(_,_),1,'SWITCH-OFF the artificial lighting system',[]).
explainer(lux_illumimance_high(_,_),1,'applied a HIGH level adjustment at the artificial lighting system',[]).
explainer(lux_illumimance_low(_,_),1,'applied a LOW level adjustment at the artificial lighting system',[]).
explainer(lux_illumimance_middle(_,_),1,'applied an AVERAGE level adjustment at the artificial lighting system',[]).
explainer(lux_illumimance_middle_low(_,_),1,'applied an AVERAGE-LOW level adjustment at the artificial lighting system',[]).
explainer(lux_illumimance_middle_high(_,_),1,'applied an AVERAGE-HIGH level adjustment at the artificial lighting system',[]). 

explainer(activity_system(regulate_illuminance,_),1,'REGULATE the artificial lighting system',[]).  
 
/*************************************************
  MUSIC PREMISES
*************************************************/

explainer(event_party(_,_),0,'party detected',[]).
explainer(event_hangout(_,_),0,'hangout detected',[]).

explainer(is_morning(_,_),0,'is morning',[]).
explainer(is_afternoon(_,_),0,'is afternoon',[]).
explainer(is_night(_,_),0,'is night',[]).
explainer(is_evening(_,_),0,'is evening',[]).

explainer(activity_studying(_,_),0,'activity detected: STUDYING',[]).
explainer(activity_waiting(_,_),0,'activity detected: WAITING',[]).

/*************************************************
  MUSIC DEDUCTIONS
*************************************************/

explainer(system_activity_set_music_level_low(_,_),1,'set the music level to LOW',[]).
explainer(system_activity_set_music_level_middle(_,_),1,'set the music level to MIDDLE',[]).
explainer(system_activity_set_music_level_high(_,_),1,'set the music level to HIGH',[]).

explainer(system_activity_set_music_genre_rock(_,_),1,'set the music level to ROCK',[]).
explainer(system_activity_set_music_genre_classic(_,_),1,'set the music level to CLASSIC',[]).
explainer(system_activity_set_music_genre_pop(_,_),1,'set the music level to POP',[]).
explainer(system_activity_set_music_genre_jazz(_,_),1,'set the music level to JAZZ',[]).
explainer(system_activity_set_music_genre_electro(_,_),1,'set the music level to ELECTRO',[]).
explainer(system_activity_set_music_genre_divertentismo(_,_),1,'set the music level to DIVERTENTISMO',[]).
explainer(system_activity_set_music_genre_instrumental(_,_),1,'set the music level to INSTRUMENTAL',[]).
explainer(system_activity_set_music_genre_soft(_,_),1,'set the music level to SOFT',[]). 

/*************************************************
  DOG PREMISES
*************************************************/

explainer(dog_tail_semi_high(_,_),0,'the dog s tail is semi-high',[]).
explainer(dog_tail_horizontal(_,_),0,'the dog s tail is horizontal',[]).
explainer(dog_tail_low(_,_),0,'the dog s tail is low',[]).
explainer(dog_tail_rigid(_,_),0,'the dog s tail is rigid',[]).
explainer(dog_tail_relaxed(_,_),0,'the dog s tail is relaxed',[]).
explainer(dog_tail_agitated(_,_),0,'the dog s tail is agitated',[]).

explainer(dog_body_back_raised(_,_),0,'the dog s back is raised',[]).
explainer(dog_body_lowered(_,_),0,'the dog s back is lowered',[]).
explainer(dog_body_front_low(_,_),0,'the dog s back is front-low',[]).
explainer(dog_body_on_the_back(_,_),0,'the dog s back is on the back',[]).
explainer(dog_body_normal(_,_),0,'the dog s back is normal',[]).

explainer(dog_ears_back(_,_),0,'the dog s ears are back',[]).
explainer(dog_ears_low(_,_),0,'the dog s ears are low',[]).
explainer(dog_ears_head(_,_),0,'the dog s ears are head',[]).
explainer(dog_ears_rised(_,_),0,'the dog s ears are rised',[]).

explainer(dog_paw_normal(_,_),0,'the dog s pawn is normal',[]).
explainer(dog_paw_raised(_,_),0,'the dog s pawn is raised',[]).

explainer(dog_mouth_open(_,_),0,' the dog s mouth is open',[]).
explainer(dog_mouth_yawn(_,_),0,' the dog s mouth is yawn',[]).
explainer(dog_mouth_relaxed(_,_),0,' the dog s mouth is relaxed',[]).
explainer(dog_mouth_teeh(_,_),0,' the dog s mouth is teeh',[]).
explainer(dog_mouth_normal(_,_),0,' the dog s mouth is normal',[]).

explainer(dog_hair_normal(_,_),0,'the dog s hair is normal',[]).
explainer(dog_hair_high(_,_),0,'the dog s hair is high',[]).

explainer(it_rained_no(_,_),0,'It has not rained',[]). 
explainer(it_rained_yes(_,_),0,'It has rained',[]). 

explainer(dog_action_bark(_,_),0,'the dog is barking',[]).
explainer(dog_action_dig(_,_),0,'the dog is digging',[]).
explainer(dog_action_hot(_,_),0,'the dog is getting hot',[]).
explainer(dog_action_defecate(_,_),0,'the dog is defecating',[]).
explainer(dog_action_run(_,_),0,'the dog is running',[]).
explainer(dog_action_fix(_,_),0,'the dog is fixing',[]).
  
explainer(dog_action_bark_times_many(_,_),0,'the dog is barking many times',[]).
explainer(dog_action_bark_times_one(_,_),0,'the dog has barked just one time',[]).
explainer(dog_action_bark_times_no(_,_),0,'the dog has not barked',[]).

explainer(dog_bark_tune_normal(_,_),0,'the bark tune is normal',[]).
explainer(dog_bark_tune_grave(_,_),0,'the bark tune is grave',[]).
explainer(dog_bark_tune_acute(_,_),0,'the bark tune is acute',[]).

explainer(nearby_dog_wall(_,_),0,'the dog is near to the wall',[]).
explainer(nearby_dog_green(_,_),0,'the dog is near to the green',[]).
explainer(nearby_dog_gate(_,_),0,'the dog is near to the gate',[]).
explainer(nearby_dog_bedding(_,_),0,'the dog is near to the bedding',[]).
explainer(nearby_dog_prohibited_area(_,_),0,'the dog is near to a prohibited area',[]).

explainer(dog_toys_active(_,_),0,'the dog toys are active',[]). 
explainer(spray_water_active(_,_),0,'the spray water is active',[]). 
explainer(orange_peels_active(_,_),0,'the orange peels are active',[]). 

/*************************************************  
  DEDUCTIONS
*************************************************/

explainer(dog_state_bored(_,_),1,'the dog is getting bored',[]).    
explainer(dog_state_playful(_,_),1,'the dog is playful',[]).  
explainer(dog_state_afraid(_,_),1,'the dog is afraid',[]).   

explainer(system_action_activate_toys(_,_),1,'activate dog toys',[]).
explainer(system_action_spray_water(_,_),1,'spray water in the dog direction',[]).
explainer(system_action_spread_orange_peels(_,_),1,'spread orange in the dog direction',[]).
explainer(system_action_check_water(_,_),1,'check the dog water',[]).
explainer(system_action_change_water(_,_),1,'change the dog water',[]). 
explainer(system_action_check_dog(_,_),1,'check the dog',[]). 
explainer(system_action_dangerous_situation(_,_),1,'dangerous situation detected for the dog',[]). 

/*************************************************
  INTRUDER PREMISES
*************************************************/

explainer(presence_owner_no(_,_),0,'owner is not present',[]).
explainer(presence_owner_yes(_,_),0,'owner is present',[]).

explainer(presence_person_yes(_,_),0,'someone is present',[]).
explainer(presence_person_no(_,_),0,'someone is not present',[]).

explainer(owner_pitch_mean_low(_,_),0,'owner pitch mean is LOW',[]).
explainer(owner_pitch_mean_middle_low(_,_),0,'owner pitch mean is LESS THAN NORMAL',[]).
explainer(owner_pitch_mean_middle(_,_),0,'owner pitch mean is NORMAL',[]).
explainer(owner_pitch_mean_middle_high(_,_),0,'owner pitch mean is MORE THAN NORMAL',[]).
explainer(owner_pitch_mean_high(_,_),0,'owner pitch mean is HIGH',[]).

explainer(owner_pitch_range_low(_,_),0,'owner pitch range is LOW',[]).
explainer(owner_pitch_range_middle_low(_,_),0,'owner pitch range is LESS THAN NORMAL',[]).
explainer(owner_pitch_range_middle(_,_),0,'owner pitch range is NORMAL',[]).
explainer(owner_pitch_range_middle_high(_,_),0,'owner pitch range is MORE THAN NORMAL',[]).
explainer(owner_pitch_range_high(_,_),0,'owner pitch range is HIGH',[]).

explainer(owner_pitch_variance_low(_,_),0,'owner pitch variance is LOW',[]).
explainer(owner_pitch_variance_middle_low(_,_),0,'owner pitch variance is LESS THAN NORMAL',[]).
explainer(owner_pitch_variance_middle(_,_),0,'owner pitch variance is NORMAL',[]).
explainer(owner_pitch_variance_middle_high(_,_),0,'owner pitch variance is MORE THAN NORMAL',[]).
explainer(owner_pitch_variance_high(_,_),0,'owner pitch variance is HIGH',[]).

explainer(owner_pitch_contour_inclines(_,_),0,'owner pitch contour inclines',[]).
explainer(owner_pitch_contour_declines(_,_),0,'owner pitch contour declines',[]).

explainer(owner_intensity_mean_low(_,_),0,'owner intensity mean is LOW',[]).
explainer(owner_intensity_mean_middle_low(_,_),0,'owner intensity mean is LESS THAN NORMAL',[]).
explainer(owner_intensity_mean_middle(_,_),0,'owner intensity mean is NORMAL',[]).
explainer(owner_intensity_mean_middle_high(_,_),0,'owner intensity mean is MORE THAN NORMAL',[]).
explainer(owner_intensity_mean_high(_,_),0,'owner intensity mean is HIGH',[]).

explainer(owner_intensity_range_low(_,_),0,'owner intensity range is LOW',[]).
explainer(owner_intensity_range_middle_low(_,_),0,'owner intensity range is LESS THAN NORMAL',[]).
explainer(owner_intensity_range_middle(_,_),0,'owner intensity range is NORMAL',[]).
explainer(owner_intensity_range_middle_high(_,_),0,'owner intensity range is MORE THAN NORMAL',[]).
explainer(owner_intensity_range_high(_,_),0,'owner intensity range is HIGH',[]).

explainer(owner_timing_speech_rate_low(_,_),0,'owner timing speech rate is LOW',[]).
explainer(owner_timing_speech_rate_middle_low(_,_),0,'owner timing speech rate is LESS THAN NORMAL',[]).
explainer(owner_timing_speech_rate_middle(_,_),0,'owner timing speech rate is NORMAL',[]).
explainer(owner_timing_speech_rate_middle_high(_,_),0,'owner timing speech rate is MORE THAN NORMAL',[]).
explainer(owner_timing_speech_rate_high(_,_),0,'owner timing speech rate is HIGH',[]).

explainer(owner_timing_trasmission_durate_low(_,_),0,'owner timing trasmission durate is LOW',[]).
explainer(owner_timing_trasmission_durate_low(_,_),0,'owner timing trasmission durate is LESS THAN NORMAL',[]).
explainer(owner_timing_trasmission_durate_middle(_,_),0,'owner timing trasmission durate is NORMAL',[]).
explainer(owner_timing_trasmission_durate_middle_high(_,_),0,'owner timing trasmission durate is MORE THAN NORMAL',[]).
explainer(owner_timing_trasmission_durate_high(_,_),0,'owner timing trasmission durate is HIGH',[]).


explainer(person_pitch_mean_low(_,_),0,'person pitch mean is LOW',[]).
explainer(person_pitch_mean_middle_low(_,_),0,'person pitch mean is LESS THAN NORMAL',[]).
explainer(person_pitch_mean_middle(_,_),0,'person pitch mean is NORMAL',[]).
explainer(person_pitch_mean_middle_high(_,_),0,'person pitch mean is MORE THAN NORMAL',[]).
explainer(person_pitch_mean_high(_,_),0,'person pitch mean is HIGH',[]).

explainer(person_pitch_range_low(_,_),0,'person pitch range is LOW',[]).
explainer(person_pitch_range_middle_low(_,_),0,'person pitch range is LESS THAN NORMAL',[]).
explainer(person_pitch_range_middle(_,_),0,'person pitch range is NORMAL',[]).
explainer(person_pitch_range_middle_high(_,_),0,'person pitch range is MORE THAN NORMAL',[]).
explainer(person_pitch_range_high(_,_),0,'person pitch range is HIGH',[]).

explainer(person_pitch_variance_low(_,_),0,'person pitch variance is LOW',[]).
explainer(person_pitch_variance_middle_low(_,_),0,'person pitch variance is LESS THAN NORMAL',[]).
explainer(person_pitch_variance_middle(_,_),0,'person pitch variance is NORMAL',[]).
explainer(person_pitch_variance_middle_high(_,_),0,'person pitch variance is MORE THAN NORMAL',[]).
explainer(person_pitch_variance_high(_,_),0,'person pitch variance is HIGH',[]).

explainer(person_pitch_contour_inclines(_,_),0,'person pitch contour inclines',[]).
explainer(person_pitch_contour_declines(_,_),0,'person pitch contour declines',[]).

explainer(person_intensity_mean_low(_,_),0,'person intensity mean is LOW',[]).
explainer(person_intensity_mean_middle_low(_,_),0,'person intensity mean is LESS THAN NORMAL',[]).
explainer(person_intensity_mean_middle(_,_),0,'person intensity mean is NORMAL',[]).
explainer(person_intensity_mean_middle_high(_,_),0,'person intensity mean is MORE THAN NORMAL',[]).
explainer(person_intensity_mean_high(_,_),0,'person intensity mean is HIGH',[]).

explainer(person_intensity_range_low(_,_),0,'person intensity range is LOW',[]).
explainer(person_intensity_range_middle_low(_,_),0,'person intensity range is LESS THAN NORMAL',[]).
explainer(person_intensity_range_middle(_,_),0,'person intensity range is NORMAL',[]).
explainer(person_intensity_range_middle_high(_,_),0,'person intensity range is MORE THAN NORMAL',[]).
explainer(person_intensity_range_high(_,_),0,'person intensity range is HIGH',[]).

explainer(person_timing_speech_rate_low(_,_),0,'person timing speech rate is LOW',[]).
explainer(person_timing_speech_rate_middle_low(_,_),0,'person timing speech rate is LESS THAN NORMAL',[]).
explainer(person_timing_speech_rate_middle(_,_),0,'person timing speech rate is NORMAL',[]).
explainer(person_timing_speech_rate_middle_high(_,_),0,'person timing speech rate is MORE THAN NORMAL',[]).
explainer(person_timing_speech_rate_high(_,_),0,'person timing speech rate is HIGH',[]).

explainer(person_timing_trasmission_durate_low(_,_),0,'person timing trasmission durate is LOW',[]).
explainer(person_timing_trasmission_durate_low(_,_),0,'person timing trasmission durate is LESS THAN NORMAL',[]).
explainer(person_timing_trasmission_durate_middle(_,_),0,'person timing trasmission durate is NORMAL',[]).
explainer(person_timing_trasmission_durate_middle_high(_,_),0,'person timing trasmission durate is MORE THAN NORMAL',[]).
explainer(person_timing_trasmission_durate_high(_,_),0,'person timing trasmission durate is HIGH',[]).

explainer(accepted_by_owner_no(_,_),0,'someone has not been accepted by owner',[]).
explainer(accepted_by_owner_yes(_,_),0,'someone has been accepted by owner',[]).

explainer(accepted_by_guess_no(_,_),0,'someone has not been accepted by guess',[]).
explainer(accepted_by_guess_yes(_,_),0,'someone has been accepted by guess',[]). 

explainer(emotion_person_fear(_,_),0,'owner is feeling fear',[]).
explainer(emotion_person_anger(_,_),0,'he is angry',[]).
explainer(emotion_person_stealthy(_,_),0,'he is stealth',[]).
explainer(emotion_person_serenity(_,_),0,'owner is feeling serenity',[]).
explainer(emotion_person_happiness(_,_),0,'owner is happy',[]).

explainer(person_possess_weapon(_,_),0,'someone has a weapon',[]). 
explainer(person_possess_knife(_,_),0,'someone has a knife',[]). 

explainer(owner_welcome_give_a_kiss(_,_),0,'owner kissed someone',[]).
explainer(owner_welcome_give_a_hug(_,_),0,'owner hugged someone',[]).
explainer(owner_welcome_say_hello(_,_),0,'owner sayed hello to someone',[]).

explainer(guess_welcome_give_a_kiss(_,_),0,'guess kissed someone',[]).
explainer(guess_welcome_give_a_hug(_,_),0,'guess hugged someone',[]).
explainer(guess_welcome_say_hello(_,_),0,'guess sayed hello to someone',[]).

/************************************************* 
  INTRUDER DEDUCTIONS
*************************************************/

explainer(emotion_person_anger(_,_),1,'emotion person : ANGER',[]).
explainer(emotion_person_disgust(_,_),1,'emotion person : DISGUST',[]).
explainer(emotion_person_fear(_,_),1,'emotion person : FEAR',[]).
explainer(emotion_person_joy(_,_),1,'emotion person : JOY',[]).
explainer(emotion_person_sadness(_,_),1,'emotion person : SADNESS',[]).

explainer(owner_person_anger(_,_),1,'emotion owner : ANGER',[]).
explainer(owner_person_disgust(_,_),1,'emotion owner : DISGUST',[]).
explainer(owner_person_fear(_,_),1,'emotion owner : FEAR',[]).
explainer(owner_person_joy(_,_),1,'emotion owner : JOY',[]).
explainer(owner_person_sadness(_,_),1,'emotion owner : SADNESS',[]).

explainer(person_guest(_,_),1,'a guest has been detected',[]).
explainer(person_intruder(_,_),1,'a intruder has been detected',[]).
explainer(system_activity_guest_detected(_,_),1,'a guest has been detected',[]).
explainer(system_activity_intrusion_detected(_,_),1,'an intruder has been detected',[]).

%rule conditions

explainer(non(presence(owner(_,_))),0,'owner not present',[]).
explainer( presence(person(_,_)),0,'someone is present',[]).
explainer(non(accepted(_,_)),0,'someone has not been accepted by owner',[]).

explainer(presence(owner(_,_)),0,'owner is present',[]).

explainer(emotion(person(_,_),fear),0,'owner is feeling fear',[]).
explainer(emotion(person(_,_),anger),0,'he is angry',[]).
explainer(emotion(person(_,_),stealthy),0,'he is stealth',[]).
explainer(emotion(person(_,_),serenity),0,'owner is feeling serenity',[]).
explainer(emotion(person(_,_),happiness),0,'owner is happy',[]).

explainer(accepted(owner(person(_,_)), person(_,_)),0,'the person has been accepted from the owner',[]). 

explainer(possess(person(_,_), weapon),0,'he has a weapon',[]). 

%explainer(give_kiss(_,_),0,'',[]).
explainer(give_hug(person(_X) , person(_Y)),0,'owner is hugging someone',[]).
explainer(give_kiss(_,_),0, 'owner is kissing someone',[]).
explainer(say_hello(_,_),0,'owner is saying hello to someone',[]).

%explainer(guest(person(_,_)), 0 , 'someone is identified as guest',[]).

%deductions
explainer(accepted(person(owner(_,_)), person(_,_)),1,'the person has been accepted from the owner',[]). 
explainer(accepted(person(guest(_,_)), person(_,_)),1,'the person has been accepted from another guest',[]). 
explainer(intruder(_,_),1,'an introduer has been detected',[]).
explainer(guest(_,_),1,'a guest has been detected',[]).



/*************************************************************************************************
        Nome: living_room_setting.pl
		
  		Obiettivo: Modulo di Configurazione di membership ed explainer del Living Room
************************************************************************************************/

%Explainer
explainer(living_room_occupied(_,_),0,'the living room is occupied',[]).
explainer(living_room_free(_,_),0,'the living room is free',[]).
explainer(natural_brightness_low(_,_),0,'the natural brightness level entered from outside is low',[]).
explainer(natural_brightness_middle(_,_),0,'the natural brightness level entered from outside is acceptable',[]).
explainer(natural_brightness_high(_,_),0,'the natural brightness level entered from outside is high',[]).
explainer(internal_brightness_very_low(_,_),0,'the brightness level inside the environment is much lower than the ideal',[]).
explainer(internal_brightness_middle_low(_,_),0,'the brightness level inside the environment is lower than the ideal',[]).
explainer(internal_brightness_middle(_,_),0,'the brightness level inside the environment is ideal',[]).
explainer(internal_brightness_middle_high(_,_),0,'the brightness level inside the environment is higher than the ideal',[]).
explainer(internal_brightness_very_high(_,_),0,'the brightness level inside the environment is much higher than the ideal',[]).
explainer(internal_temperature_low(_,_),0,'the temperature level inside the environment is low',[]).
explainer(internal_temperature_middle(_,_),0,'the temperature level inside the environment is acceptable',[]).
explainer(internal_temperature_high(_,_),0,'the temperature level inside the environment is high',[]).
explainer(internal_air_speed_low(_,_),0,'the air speed level inside the environment is low',[]).
explainer(internal_air_speed_middle(_,_),0,'the air speed level inside the environment is acceptable',[]).
explainer(internal_air_speed_high(_,_),0,'the air speed level inside the environment is high',[]).
explainer(internal_humidity_low(_,_),0,'the rate of relative humidity inside the environment is low',[]).
explainer(internal_humidity_middle(_,_),0,'the rate of relative humidity inside the environment is acceptable',[]).
explainer(internal_humidity_high(_,_),0,'the rate of relative humidity inside the environment is high',[]).
explainer(rain_presence_yes(_,_),0,'has been detected rain presence outside',[]).
explainer(rain_presence_no(_,_),0,'has not been detected rain presence outside',[]).
explainer(external_humidity_low(_,_),0,'the rate of relative humidity from outside is low',[]).
explainer(external_humidity_middle(_,_),0,'the rate of relative humidity from outside is acceptable',[]).
explainer(external_humidity_high(_,_),0,'the rate of relative humidity from outside is high',[]).
explainer(hygrometric_situation_dry(_,_),0,'outside is a dry day',[]).
explainer(hygrometric_situation_humid(_,_),0,'outside is a humid day',[]).
explainer(hygrometric_situation_rain(_,_),0,'is raining outside',[]).
explainer(external_temperature_low(_,_),0,'the external temperature is low',[]).
explainer(external_temperature_middle(_,_),0,'the external temperature is acceptable',[]).
explainer(external_temperature_high(_,_),0,'the external temperature is high',[]).
explainer(wind_speed_low(_,_),0,'the wind is at low speed',[]).
explainer(wind_speed_middle(_,_),0,'the wind is at acceptable speed',[]).
explainer(wind_speed_high(_,_),0,'the wind is at high speed',[]).
explainer(air_speed_low(_,_),0,'the internal air is at low speed',[]).
explainer(air_speed_middle(_,_),0,'the internal air is at acceptable speed',[]).
explainer(air_speed_high(_,_),0,'the internal air is at high speed',[]).
explainer(solar_radiation_low(_,_),0,'the light level outside is low',[]).
explainer(solar_radiation_middle(_,_),0,'the light level outside is acceptable',[]).
explainer(solar_radiation_high(_,_),0,'the light level outside is high',[]).
explainer(weatering_situation_very_cold(_,_),0,'the macro-climatic situation, outside, tends to cold accentuated',[]).
explainer(weatering_situation_middle_cold(_,_),0,'the macro-climatic situation, outside, tends to acceptable cold',[]).
explainer(weatering_situation_temperate(_,_),0,'the macro-climatic situation, outside, tends to temperate',[]).
explainer(weatering_situation_middle_hot(_,_),0,'the macro-climatic situation, outside, tends to acceptable warm',[]).
explainer(weatering_situation_very_hot(_,_),0,'the macro-climatic situation, outside, tends to warm accentuated',[]).
explainer(is_sunset(_,_),0,'are in the sunset',[]).
explainer(is_morning(_,_),0,'are in the morning',[]).
explainer(is_midday(_,_),0,'are in the middle of day',[]).
explainer(is_afternoon(_,_),0,'are in the aífternoon',[]).
explainer(is_evening(_,_),0,'are in the evening',[]).
explainer(is_night(_,_),0,'are in the night',[]).
explainer(state_windows(_,_,open_W),1,'the window is open',[]).
explainer(state_windows(_,_,close_w),1,'the window is close',[]).
explainer(lux_level(_,_,stop_),1,'did not applied any adjustment at artificial lighting level',[]).
explainer(lux_level(_,_,l1_l),1,'applied a low level adjustment at artificial lighting level',[]).
explainer(lux_level(_,_,l2_l),1,'applied an average level adjustment at artificial lighting level',[]).
explainer(lux_level(_,_,l3_l),1,'applied a high adjustment at artificial lighting level',[]).
explainer(lux_level(_,_,l4_l),1,'applied the maximum level adjustment at artificial lighting level',[]).
explainer(air_conditioning_level(_,_,stop_c),1,'did not applied any adjustment at air conditioning level ',[]).
explainer(air_conditioning_level(_,_,l1_c),1,'applied a low level adjustment at air conditioning level ',[]). 
explainer(air_conditioning_level(_,_,l2_c),1,'applied an average level adjustment at air conditioning level ',[]).
explainer(air_conditioning_level(_,_,l3_c),1,'applied a high level adjustment at  air conditioning level ',[]).
explainer(air_conditioning_level(_,_,l4_c),1,'applied the maximum level adjustment at air conditioning level ',[]).
explainer(central_heating_level(_,_,stop_h),1,'did not applied any adjustment at central heating level ',[]).
explainer(central_heating_level(_,_,l1_h),1,'applied a low level adjustment at central heating level ',[]).
explainer(central_heating_level(_,_,l2_h),1,'applied an average level adjustment at central heating level ',[]).
explainer(central_heating_level(_,_,l3_h),1,'applied a high level adjustment at central heating level ',[]).
explainer(central_heating_level(_,_,l4_h),1,'applied the maximum level adjustment at central heating level ',[]).
explainer(ventilation_level(_,_,stop_v),1,'did not applied any adjustment at internal air level ',[]).
explainer(ventilation_level(_,_,l1_v),1,'applied a low level adjustment at internal air level ',[]).
explainer(ventilation_level(_,_,l2_v),1,'applied an average level adjustment at internal air level ',[]).
explainer(ventilation_level(_,_,l3_v),1,'applied a high level adjustment at internal air level ',[]).
explainer(ventilation_level(_,_,l4_v),1,'applied the maximum level adjustment at internal air level ',[]).
explainer(sunshade_home(_,_,close_su),1,'applied the close sunshade',[]).
explainer(sunshade_home(_,_,open_su),1,'applied the open sunshade for repairing of sun',[]).
explainer(shutters_home(_,_,close_sh),1,'applied the close shutters',[]).
explainer(shutters_home(_,_,l1_sh),1,'applied the close shutters home with adjustable slats',[]).
explainer(shutters_home(_,_,open_sh),1,'applied the open shutters home',[]).


/*************************************************************************************************
        Nome: seva_setting.pl
        
	Realizzazione: Febbraio, 2014
  		Obiettivo: Modulo di Configurazione di membership ed explainer del SEVA
       		Autore: Francesco Solare

**************************************************************************************************/




%Explainer
explainer(box_occupied(_,_),0,'the working station is occupied',[]).
explainer(box_break(_,_),0,'the worker is in pause',[]).
explainer(natural_brightness_low(_,_),0,'the natural brightness level entered from outside is low',[]).
/*
explainer(natural_brightness_middle(_,_),0,'the natural brightness level entered from outside is acceptable',[]).
explainer(natural_brightness_high(_,_),0,'the natural brightness level entered from outside is high',[]).
explainer(internal_brightness_very_low(_,_),0,'the brightness level inside the environment is much lower than the ideal',[]).
explainer(internal_brightness_middle_low(_,_),0,'the brightness level inside the environment is lower than the ideal',[]).
explainer(internal_brightness_middle(_,_),0,'the brightness level inside the environment is ideal',[]).
explainer(internal_brightness_middle_high(_,_),0,'the brightness level inside the environment is higher than the ideal',[]).
explainer(internal_brightness_very_high(_,_),0,'the brightness level inside the environment is much higher than the ideal',[]).
explainer(internal_temperature_low(_,_),0,'the temperature level inside the environment is low',[]).
explainer(internal_temperature_middle(_,_),0,'the temperature level inside the environment is acceptable',[]).
explainer(internal_temperature_high(_,_),0,'the temperature level inside the environment is high',[]).
explainer(internal_air_speed_low(_,_),0,'the air speed level inside the environment is low',[]).
explainer(internal_air_speed_middle(_,_),0,'the air speed level inside the environment is acceptable',[]).
explainer(internal_air_speed_high(_,_),0,'the air speed level inside the environment is high',[]).
explainer(internal_humidity_low(_,_),0,'the rate of relative humidity inside the environment is low',[]).
explainer(internal_humidity_middle(_,_),0,'the rate of relative humidity inside the environment is acceptable',[]).
explainer(internal_humidity_high(_,_),0,'the rate of relative humidity inside the environment is high',[]).
explainer(rain_presence_yes(_,_),0,'has been detected rain presence outside',[]).
explainer(rain_presence_no(_,_),0,'has not been detected rain presence outside',[]).
explainer(external_humidity_low(_,_),0,'the rate of relative humidity from outside is low',[]).
explainer(external_humidity_middle(_,_),0,'the rate of relative humidity from outside is acceptable',[]).
explainer(external_humidity_high(_,_),0,'the rate of relative humidity from outside is high',[]).
explainer(hygrometric_situation_dry(_,_),0,'outside is a dry day',[]).
explainer(hygrometric_situation_humid(_,_),0,'outside is a humid day',[]).
explainer(hygrometric_situation_rain(_,_),0,'is raining outside',[]).
explainer(external_temperature_low(_,_),0,'the external temperature is low',[]).
explainer(external_temperature_middle(_,_),0,'the external temperature is acceptable',[]).
explainer(external_temperature_high(_,_),0,'the external temperature is high',[]).*/
explainer(wind_strength_low(_,_),0,'the wind is at low speed',[]).
explainer(wind_strength_middle(_,_),0,'the wind is at acceptable speed',[]).
explainer(wind_strength_high(_,_),0,'the wind is at high speed',[]).
/*explainer(solar_radiation_low(_,_),0,'the light level outside is low',[]).
explainer(solar_radiation_middle(_,_),0,'the light level outside is acceptable',[]).
explainer(solar_radiation_high(_,_),0,'the light level outside is high',[]).*/



explainer(wheatering_situation_very_cold(_,_),0,'the macro-climatic situation, outside, tends to cold accentuated',[]). %precedentemente 1%
explainer(wheatering_situation_middle_cold(_,_),0,'the macro-climatic situation, outside, tends to acceptable cold',[]).
explainer(wheatering_situation_temperate(_,_),0,'the macro-climatic situation, outside, tends to temperate',[]).
explainer(wheatering_situation_middle_hot(_,_),0,'the macro-climatic situation, outside, tends to acceptable warm',[]).
explainer(wheatering_situation_very_hot(_,_),0,'the macro-climatic situation, outside, tends to warm accentuated',[]).




explainer(is_morning(_,_),0,'are in the morning',[]).
explainer(is_midday(_,_),0,'are in the middle of day',[]).
explainer(is_evening(_,_),0,'are in the evening',[]).
explainer(thermostate_cooling(_,_),1,'configure thermostat on cooling mode',[]).
explainer(thermostate_economy(_,_),1,'configure thermostat on economy mode',[]).
explainer(thermostate_standby(_,_),1,'configure thermostat on standby mode',[]).
explainer(thermostate_comfort(_,_),1,'configure thermostat on comfort mode',[]).
explainer(thermostate_heating(_,_),1,'configure thermostat on heating mode',[]).
explainer(lux_dimming_level(_,_,stop),1,'did not applied any adjustment at artificial lighting level',[]).
explainer(lux_dimming_level(_,_,l1),1,'applied a low level adjustment at artificial lighting level',[]).
explainer(lux_dimming_level(_,_,l2),1,'applied an average level adjustment at artificial lighting level',[]).
explainer(lux_dimming_level(_,_,l3),1,'applied a high adjustment at artificial lighting level',[]).
explainer(lux_dimming_level(_,_,max),1,'applied the maximum level adjustment at artificial lighting level',[]).
explainer(degree_dimming_level(_,_,stop),1,'did not applied any adjustment at air degree level of fun coil system',[]).
explainer(degree_dimming_level(_,_,l1),1,'applied a low level adjustment at air degree level of fun coil system',[]).
explainer(degree_dimming_level(_,_,l2),1,'applied an average level adjustment at air degree level of fun coil system',[]).
explainer(degree_dimming_level(_,_,l3),1,'applied a high level adjustment at air degree level of fun coil system',[]).
explainer(degree_dimming_level(_,_,max),1,'applied the maximum level adjustment at air degree level of fun coil system',[]).
explainer(air_dimming_level(_,_,stop),1,'did not applied any adjustment at air speed level of fun coil system',[]).
explainer(air_dimming_level(_,_,l1),1,'applied a low level adjustment at air speed level of fun coil system',[]).
explainer(air_dimming_level(_,_,l2),1,'applied an average level adjustment at air speed level of fun coil system',[]).
explainer(air_dimming_level(_,_,l3),1,'applied a high level adjustment at air speed level of fun coil system',[]).
explainer(air_dimming_level(_,_,max),1,'applied the maximum level adjustment at air speed level of fun coil system',[]).
explainer(blind_dimming_level(_,_,stop),1,'did not applied any adjustment at artificial blinding level',[]).
explainer(blind_dimming_level(_,_,l1),1,'applied a low level adjustment at artificial blinding level',[]).
explainer(blind_dimming_level(_,_,l2),1,'applied an average level adjustment at artificial blinding level',[]).
explainer(blind_dimming_level(_,_,l3),1,'applied a high adjustment at artificial blinding level',[]).
explainer(blind_dimming_level(_,_,max),1,'applied the maximum level adjustment at artificial blinding level',[]).




%INTELLICARE
explainer(raffreddore(Nome_Soggetto),0,'cold',[Nome_Soggetto]).
explainer(mal_di_gola(Nome_Soggetto),0,'sore throat',[Nome_Soggetto]).
explainer(spossatezza(Nome_Soggetto),0,'fatigue',[Nome_Soggetto]).
explainer(pallore(Nome_Soggetto),0,'pallor',[Nome_Soggetto]).
explainer(dolori_diffusi(Nome_Soggetto),0,'widespread pain',[Nome_Soggetto]).
explainer(dolori_addominali(Nome_Soggetto),0,'abdominal pains',[Nome_Soggetto]).
explainer(abuso_alcolici(Nome_Soggetto),0,'alcohol abuse',[Nome_Soggetto]).
explainer(stato_denutrimento(Nome_Soggetto),0,'underfed',[Nome_Soggetto]).
explainer(sintomi_gastrointestinali(Nome_Soggetto),0,'gastrointestinal symptoms',[Nome_Soggetto]).
explainer(probabile_mestruo(Nome_Soggetto),0,'menstruation',[Nome_Soggetto]).
explainer(alimentazione_scorretta(Nome_Soggetto),0,'Unhealthy diets',[Nome_Soggetto]).
explainer(emottisi(Nome_Soggetto),0,'hemoptysis',[Nome_Soggetto]).
explainer(sangue_nelle_feci(Nome_Soggetto),0,'blood in stool',[Nome_Soggetto]).
explainer(mancata_risposta(Nome_Soggetto),0,'no answer',[Nome_Soggetto]).
explainer(consigliato(_T,P,Consiglio),1,'è consigliato',[P,Consiglio]).
explainer(probabile_carenza_vitaminica(_,Nome_Soggetto),1,'probabile carenza vitaminica',[Nome_Soggetto]).
/************************************************* 
  INTRUDER DEDUCTIONS
*************************************************/

explainer(system_activity_regulate_algaecide(_),0,'The system has to regulate the algaecide level',[]).
explainer(system_activity_calculate_filtering_level(_),1,'the system needs to calculate the  filtering water level',[]).
explainer(system_activity_regulate_pH(_),1,'the system needs to regulate the pH-',[]).

explainer(system_activity_activate_filtering_water(_),1,'the system has to filter the water',[]).
explainer(system_activity_activate_backwash(_),1,'the system has to active the backwash',[]).
explainer(system_activity_call_owner(_),1,'the system has to call the owner',[]).
explainer(system_activity_add_pH(X,_),1,'the system is adding chlorine to regulate the pH',[X]).
explainer(system_activity_activate_chlorination(_),1,'the system has to chlorine the water',[]).
explainer(system_activity_add_algaecide(_),1,'the system has to add algaecide the water',[]).
explainer(system_activity_activate_robot_alga(_),1,'activate the robot to remove the alga',[]).
explainer(system_activity_add_water(_),1,'add water to the swimming pool',[]).
explainer(system_activity_close_pool(_),1,'close the swimming pool',[]).

explainer(ph_need_low(_),1,'pH need is LOW',[]).   
explainer(ph_need_middle(_),1,'pH need is MIDDLE',[]).   
explainer(ph_need_high(_),1,'pH need is HIGH',[]).   

explainer(cloudy_water(_),1,'cloudy water',[]).
explainer(milky_water(_),1,'milky water',[]).

explainer(slippery_wall_on(_),1,'the wall of the swimming pool is slippery',[]).
explainer(slippery_floor_on(_),1,'the floor of the swimming pool is slippery',[]).

explainer(slippery_wall(_),1,'the wall of the swimming pool is slippery',[]).
explainer(slippery_floor(_),1,'the floor of the swimming pool is slippery',[]).

explainer(smell_chlorine(_),1,'smell of chlorine in the air',[]).
explainer(eye_irritation(_),1,'eye irritation risk',[]).

explainer(foam_alert(_),1,'foam in the swimming pool',[]). 


/*************************************************************************************************
        Nome: smarth bathroom settings
        
	Realizzazione: Agosto, 2014
  		Obiettivo: Explainer di smart bathroom
       		Autore: Luigi Tedone
**************************************************************************************************/



explainer(month_january(_),0,'the month is January',[]).
explainer(month_february(_),0,'the month is February',[]).
explainer(month_march(_),0,'the month is March',[]).
explainer(month_april(_),0,'the month is April',[]).
explainer(month_may(_),0,'the month is May',[]).
explainer(month_june(_),0,'the month is June',[]).
explainer(month_july(_),0,'the month is July',[]).
explainer(month_august(_),0,'the month is August',[]).
explainer(month_september(_),0,'the month is September',[]).
explainer(month_october(_),0,'the month is October',[]).
explainer(month_november(_),0,'the month is November',[]).
explainer(month_december(_),0,'the month is December',[]).
explainer(external_temp_vBelowMinus10(_,_),0,'the external temperature is below -10 �C',[]).
explainer(external_temp_vMinus10_0(_,_),0,'la temperatura esterna è compresa tra -10°C and 0°C',[]).
explainer(external_temp_v0_10(_,_),0,'the external temperature is between 0 �C and 10 �C',[]).
explainer(external_temp_v10_20(_,_),0,'la temperatura esterna è compresa tra 10°C and 20°C',[]).
explainer(external_temp_v20_30(_,_),0,'the external temperature is between 20 �C and 30 �C',[]).
explainer(external_temp_v30_40(_,_),0,'the external temperature is between 30 �C and 40 �C',[]).
explainer(external_temp_vPlus40(_,_),0,'the external temperature is more than 40 �C',[]).
explainer(internal_temp_v0_5(_,_),0,'la temperatura interna è compresa tra 0°C and 5°C',[]).
explainer(internal_temp_v5_10(_,_),0,'the internal temperature is between 5 �C and 10 �C',[]).
explainer(internal_temp_v10_20(_,_),0,'la temperatura interna è compresa tra 10°C and 20°C',[]).
explainer(internal_temp_v20_30(_,_),0,'the internal temperature is between 20 �C and 30 �C',[]).
explainer(internal_temp_v30_40(_,_),0,'the internal temperature is between 30 �C and 40 �C',[]).
explainer(internal_temp_vPlus40(_,_),0,'the internal temperature is more than 40 �C',[]).
explainer(ext_humidity_v0_20(_,_),0,'the external humidity is between 0% and 20%',[]).
explainer(ext_humidity_v20_30(_,_),0,'the external humidity is between 20% and 30%',[]).
explainer(ext_humidity_v30_40(_,_),0,'the external humidity is between 30% and 40%',[]).
explainer(ext_humidity_v40_50(_,_),0,'the external humidity is between 40% and 50%',[]).
explainer(ext_humidity_v50_60(_,_),0,'the external humidity is between 50% and 60%',[]).
explainer(ext_humidity_v60_70(_,_),0,'the external humidity is between 60% and 70%',[]).
explainer(ext_humidity_v70_80(_,_),0,'the external humidity is between 70% and 80%',[]).
explainer(ext_humidity_v80_90(_,_),0,'the external humidity is between 80% and 90%',[]).
explainer(ext_humidity_v90_100(_,_),0,'the external humidity is between 90% and 100%',[]).
explainer(int_humidity_v0_20(_,_),0,'the internal humidity is between 0% and 20%',[]).
explainer(int_humidity_v20_30(_,_),0,'the internal humidity is between 20% and 30%',[]).
explainer(int_humidity_v30_40(_,_),0,'the internal humidity is between 30% and 40%',[]).
explainer(int_humidity_v40_50(_,_),0,'the internal humidity is between 40% and 50%',[]).
explainer(int_humidity_v50_60(_,_),0,'the internal humidity is between 50% and 60%',[]).
explainer(int_humidity_v60_70(_,_),0,'the internal humidity is between 60% and 70%',[]).
explainer(int_humidity_v70_80(_,_),0,'the internal humidity is between 70% and 80%',[]).
explainer(int_humidity_v80_90(_,_),0,'the internal humidity is between 80% and 90%',[]).
explainer(int_humidity_v90_100(_,_),0,'the internal humidity is between 90% and 100%',[]).
explainer(tot_lux_v50_100(_,_),0,'the lux level inside (total brightness) is between 50 lux and 100 lux',[]).
explainer(tot_lux_v100_200(_,_),0,'the lux level inside (total brightness) is between 100 lux and 200 lux',[]).
explainer(tot_lux_v200_300(_,_),0,'the lux level inside (total brightness) is between 200 lux and 300 lux',[]).
explainer(tot_lux_v300_400(_,_),0,'the lux level inside (total brightness) is between 300 lux and 400 lux',[]).
explainer(tot_lux_v400_500(_,_),0,'the lux level inside (total brightness) is between 400 lux and 500 lux',[]).
explainer(tot_lux_v500_600(_,_),0,'the lux level inside (total brightness) is between 500 lux and 600 lux',[]).
explainer(tot_lux_v600_1000(_,_),0,'the lux level inside (total brightness) is between 600 lux and 1000 lux',[]).
explainer(tot_lux_vPlus1000(_,_),0,'the lux level inside (total brightness) is more than 1000 lux',[]).


/*************************************************
  SYSTEM PREMISES
*************************************************/


explainer(gender_female(_,_),0,'the user is female',[]).
explainer(toilet_seat_up(_,_),0,'the toilet seat is up',[]).
explainer(toilet_seat_down(_,_),0,'the toilet seat is down',[]).
explainer(touch_razor(_,_),0,'the user is touching the razor',[]).
explainer(touch_brush(_,_),0,'the user is touching the brush',[]).
explainer(touch_electric_toothbrush(_,_),0,'the user is touching the electric toothbrush',[]).
explainer(touch_dryer(_,_),0,'the user is touching the dryer',[]).
explainer(touch_shower_tap(_,_),0,'the user is touching the shower tap',[]).
explainer(touch_sink_tap(_,_),0,'the user is is touching the sink tap',[]).
explainer(touch_makeup(_,_),0,'the user is touching the make-up',[]).
explainer(touch_wc(_,_),0,'the user is touching the WC',[]).
explainer(touch_bidet(_,_),0,'the user is touching the bidet',[]).
explainer(used_wc(_,_),0,'the user used the WC',[]).
explainer(used_bidet(_,_),0,'the user used the bidet',[]).
explainer(used_sink(_,_),0,'the user used the sink',[]).
explainer(used_shower(_,_),0,'the user used the shower',[]).
explainer(used_razor(_,_),0,'the user used the razor',[]).
explainer(used_brush(_,_),0,'the user used the brush',[]).
explainer(used_makeup(_,_),0,'the user used the make-up',[]).
explainer(used_dryer(_,_),0,'the user used the dryer',[]).
explainer(used_electric_toothbrush(_,_),0,'the user used the electric toothbrush',[]).
explainer(is_near_sink_yes(_,_),0,'the user is near the sink',[]).
explainer(is_near_sink_no(_,_),0,'the user is not near the sink',[]).
explainer(is_near_mirror_yes(_,_),0,'the user is near the mirror',[]).
explainer(is_near_mirror_no(_,_),0,'the user is not near the mirror',[]).
explainer(is_near_shower_yes(_,_),0,'the user is near the shower',[]).
explainer(is_near_shower_no(_,_),0,'the user is not near the shower',[]).
explainer(is_near_wc_yes(_,_),0,'the user is near the wc',[]).
explainer(is_near_wc_no(_,_),0,'the user is not near the wc',[]).
explainer(is_near_bidet_yes(_,_),0,'the user is near the bidet',[]).
explainer(is_near_bidet_no(_,_),0,'the user is not near the bidet',[]).
explainer(is_present_yes(_,_),0,'the user is present',[]).
explainer(is_present_no(_,_),0,'the user is not present',[]).
explainer(mode_eco(_,_),0,'the mode is on eco',[]).
explainer(mode_comfort(_,_),0,'the mode is on comfort',[]).
explainer(mode_max(_,_),0,'the mode is on max',[]).
explainer(mode_manual(_,_),0,'the mode is on manual',[]).
explainer(dirty_wc_feces(_,_),0,'the WC is dirty with feces',[]).
explainer(dirty_wc_urine(_,_),0,'the WC is dirty with urine',[]).
explainer(dirty_face(_,_),0,'the face is dirty',[]).
explainer(dirty_hands(_,_),0,'the hands are dirty',[]).
explainer(dirty_teeth(_,_),0,'the teeth are dirty',[]).
explainer(is_naked_yes(_,_),0,'the user is naked',[]).
explainer(is_naked_no(_,_),0,'the user is not naked',[]).
explainer(shower_temp_v0_10(_,_),0,'the temperature of the water of the shower is between 0 ?C and 10 ?C',[]).
explainer(shower_temp_v10_20(_,_),0,'the temperature of the water of the shower is between 10 ?C and 20 ?C',[]).
explainer(shower_temp_v20_30(_,_),0,'the temperature of the water of the shower is between 20 ?C and 30 ?C',[]).
explainer(shower_temp_v30_40(_,_),0,'the temperature of the water of the shower is between 30 ?C and 40 ?C',[]).
explainer(shower_temp_v40_50(_,_),0,'the temperature of the water of the shower is between 40 ?C and 50 ?C',[]).
explainer(shower_temp_v50_60(_,_),0,'the temperature of the water of the shower is between 50 ?C and 60 ?C',[]).
explainer(shower_temp_vPlus60(_,_),0,'the temperature of the water of the shower is more than 60 ?C',[]).
explainer(bidet_temp_v0_10(_,_),0,'the temperature of the water of the bidet is between 0 ?C and 10 ?C',[]).
explainer(bidet_temp_v10_20(_,_),0,'the temperature of the water of the bidet is between 10 ?C and 20 ?C',[]).
explainer(bidet_temp_v20_30(_,_),0,'the temperature of the water of the bidet is between 20 ?C and 30 ?C',[]).
explainer(bidet_temp_v30_40(_,_),0,'the temperature of the water of the bidet is between 30 ?C and 40 ?C',[]).
explainer(bidet_temp_v40_50(_,_),0,'the temperature of the water of the bidet is between 40 ?C and 50 ?C',[]).
explainer(bidet_temp_v50_60(_,_),0,'the temperature of the water of the bidet is between 50 ?C and 60 ?C',[]).
explainer(bidet_temp_vPlus60(_,_),0,'the temperature of the water of the bidet is more than 60 ?C',[]).
explainer(sink_temp_v0_10(_,_),0,'the temperature of the water of the sink is between 0 ?C and 10 ?C',[]).
explainer(sink_temp_v10_20(_,_),0,'the temperature of the water of the sink is between 10 ?C and 20 ?C',[]).
explainer(sink_temp_v20_30(_,_),0,'the temperature of the water of the sink is between 20 ?C and 30 ?C',[]).
explainer(sink_temp_v30_40(_,_),0,'the temperature of the water of the sink is between 30 ?C and 40 ?C',[]).
explainer(sink_temp_v40_50(_,_),0,'the temperature of the water of the sink is between 40 ?C and 50 ?C',[]).
explainer(sink_temp_v50_60(_,_),0,'the temperature of the water of the sink is between 50 ?C and 60 ?C',[]).
explainer(sink_temp_vPlus60(_,_),0,'the temperature of the water of the sink is more than 60 ?C',[]).
explainer(nat_lux_v0_50(_,_),0,'the lux level outside (natural brightness) is between 0 lux and 50 lux',[]).
explainer(nat_lux_v50_100(_,_),0,'the lux level outside (natural brightness) is between 50 lux and 100 lux',[]).
explainer(nat_lux_v100_200(_,_),0,'the lux level outside (natural brightness) is between 100 lux and 200 lux',[]).
explainer(nat_lux_v200_300(_,_),0,'the lux level outside (natural brightness) is between 200 lux and 300 lux',[]).
explainer(nat_lux_v300_400(_,_),0,'the lux level outside (natural brightness) is between 300 lux and 400 lux',[]).
explainer(nat_lux_v400_500(_,_),0,'the lux level outside (natural brightness) is between 400 lux and 500 lux',[]).
explainer(nat_lux_v500_600(_,_),0,'the lux level outside (natural brightness) is between 500 lux and 600 lux',[]).
explainer(nat_lux_vPlus600(_,_),0,'the lux level outside (natural brightness) is more than 600 lux',[]).



/************************************************* 
  SYSTEM DEDUCTIONS
*************************************************/

explainer(want_shave(_,_),1,'the user wants to shave',[]).
explainer(want_brush(_,_),1,'the user wants to brush his hair',[]).
explainer(want_teeth(_,_),1,'the user wants to brush his teeth',[]).
explainer(want_hair(_,_),1,'the user wants to dry his hair',[]).
explainer(want_shower(_,_),1,'the user wants to have a shower',[]).
explainer(want_face(_,_),1,'the user wants to wash his face',[]).
explainer(want_hands(_,_),1,'the user wants to wash his hands',[]).
explainer(want_makeup(_,_),1,'the user wants to make-up',[]).
explainer(want_urinate(_,_),1,'the user wants to urinate',[]).
explainer(want_evacuate(_,_),1,'the user wants to evacuate',[]).
explainer(want_bidet(_,_),1,'the user wants to have a bidet',[]).
explainer(season_winter(_),1,'the season is winter',[]).
explainer(season_spring(_),1,'the season is spring',[]).
explainer(season_summer(_),1,'the season is summer',[]).
explainer(season_autumn(_),1,'the season is fall',[]).
explainer(wc_clean(_,_,long),1,'the system cleans the WC with a long shot',[]). 
explainer(wc_clean(_,_,short),1,'the system cleans the WC with a short shot',[]).
explainer(bidet_fill(_,_,full),1,'the system fill the bidet at full level',[]).
explainer(bidet_fill(_,_,half),1,'the system fill the bidet at half level',[]).
explainer(bidet_fill(_,_,current_water),1,'the system use the bidet with current water',[]).
explainer(bidet_fill(_,_,no),1,'the system do not fill the bidet',[]).
explainer(bidet_empty(_,_,yes),1,'the system empty the bidet',[]).
explainer(bidet_empty(_,_,no),1,'the system do not empty the bidet',[]).
explainer(shower_dispense(_,_,yes),1,'the system dispense water from the shower',[]).
explainer(shower_dispense(_,_,no),1,'the system do not dispense water from the shower',[]).
explainer(sink_fill(_,_,full),1,'the system fill the sink at the full level',[]).
explainer(sink_fill(_,_,half),1,'the system fill the sink at the half level',[]).
explainer(sink_fill(_,_,current_water),1,'the system use the sink with current water',[]).
explainer(sink_fill(_,_,no),1,'the system do not fill the sink',[]).
explainer(sink_empty(_,_,yes),1,'the system empty the sink',[]).
explainer(sink_empty(_,_,no),1,'the system do not empty the sink',[]).
explainer(window_choice(_,_,open),1,'the system open the window',[]).
explainer(window_choice(_,_,close),1,'the system close the window',[]).
explainer(radiators_choice(_,_,off),1,'the system sets the radiators to off',[]).
explainer(radiators_choice(_,_,low),1,'the system sets the radiators to low level',[]).
explainer(radiators_choice(_,_,middle),1,'the system sets the radiators to middle level',[]).
explainer(radiators_choice(_,_,max),1,'the system sets the radiators to max level',[]).
explainer(air_conditioner_choice(_,_,off),1,'the system sets the air conditioner to off',[]).
explainer(air_conditioner_choice(_,_,dehumidifier),1,'the system sets the air conditioner to dehumidifier mode',[]).
explainer(air_conditioner_choice(_,_,low),1,'the system sets the air conditioner to low level',[]).
explainer(air_conditioner_choice(_,_,middle),1,'the system sets the air contitioner to middle level',[]).
explainer(air_conditioner_choice(_,_,max),1,'the system sets the air conditioner to max level',[]).
explainer(showertemp_setting(_,_,temp0),1,'the system sets the temperature of the water of the shower to 0 �C',[]).
explainer(showertemp_setting(_,_,temp10),1,'the system sets the temperature of the water of the shower to 10 �C',[]).
explainer(showertemp_setting(_,_,temp20),1,'the system sets the temperature of the water of the shower to 20 �C',[]).
explainer(showertemp_setting(_,_,temp30),1,'the system sets the temperature of the water of the shower to 30 �C',[]).
explainer(showertemp_setting(_,_,temp40),1,'the system sets the temperature of the water of the shower to 40 �C',[]).
explainer(showertemp_setting(_,_,temp50),1,'the system sets the temperature of the water of the shower to 50 �C',[]).
explainer(bidettemp_setting(_,_,temp0),1,'the system sets the temperature of the water of the bidet to 0 �C',[]).
explainer(bidettemp_setting(_,_,temp10),1,'the system sets the temperature of the water of the bidet to 10 �C',[]).
explainer(bidettemp_setting(_,_,temp20),1,'the system sets the temperature of the water of the bidet to 20 �C',[]).
explainer(bidettemp_setting(_,_,temp30),1,'the system sets the temperature of the water of the bidet to 30 �C',[]).
explainer(bidettemp_setting(_,_,temp40),1,'the system sets the temperature of the water of the bidet to 40 �C',[]).
explainer(bidettemp_setting(_,_,temp50),1,'the system sets the temperature of the water of the bidet to 50 �C',[]).
explainer(sinktemp_setting(_,_,temp0),1,'the system sets the temperature of the water of the sink to 0 �C',[]).
explainer(sinktemp_setting(_,_,temp10),1,'the system sets the temperature of the water of the sink to 10 �C',[]).
explainer(sinktemp_setting(_,_,temp20),1,'the system sets the temperature of the water of the sink to 20 �C',[]).
explainer(sinktemp_setting(_,_,temp30),1,'the system sets the temperature of the water of the sink to 30 �C',[]).
explainer(sinktemp_setting(_,_,temp40),1,'the system sets the temperature of the water of the sink to 40 �C',[]).
explainer(sinktemp_setting(_,_,temp50),1,'the system sets the temperature of the water of the sink to 50 �C',[]).
explainer(lux_setting(_,_,lux0),1,'the system sets the artificial brightness level to 0 lux',[]).
explainer(lux_setting(_,_,lux100),1,'the system sets the artificial brightness level to 100 lux',[]).
explainer(lux_setting(_,_,lux200),1,'the system sets the artificial brightness level to 200 lux',[]).
explainer(lux_setting(_,_,lux300),1,'the system sets the artificial brightness level to 300 lux',[]).
explainer(lux_setting(_,_,lux400),1,'the system sets the artificial brightness level to 400 lux',[]).
explainer(lux_setting(_,_,lux500),1,'the system sets the artificial brightness level to 500 lux',[]).
explainer(ceiling_lamp_choice(_,_,zero),1,'the system switches off all the lamps of the chandelier',[]).
explainer(ceiling_lamp_choice(_,_,one),1,'the system switches on one lamp of the chandelier',[]).
explainer(ceiling_lamp_choice(_,_,two),1,'the system switches on two lamps of the chandelier',[]).
explainer(ceiling_lamp_choice(_,_,three),1,'the system switches on three lamps of the chandelier',[]).
explainer(mirror_lamp_choice(_,_,on),1,'the system switchrs on the lamp of the mirror',[]).
explainer(mirror_lamp_choice(_,_,off),1,'the system switchrs off the lamp of the mirror',[]).
explainer(rollupshutter_choice(_,_,close),1,'il sistema ha chiuso le tapparelle',[]).
explainer(rollupshutter_choice(_,_,half),1,'the system opens the roll-up shutter at half',[]).
explainer(rollupshutter_choice(_,_,open),1,'il sistema ha aperto le tapparelle al massimo',[]).
explainer(dryer_choice(_,_,on),1,'the system switches on the dryer',[]).
explainer(dryer_choice(_,_,off),1,'the system switches off the dryer',[]).
explainer(el_toothbrush_choice(_,_,on),1,'the system switches on the electric toothbrush',[]).
explainer(el_toothbrush_choice(_,_,off),1,'the system switches off the electric tootbrush',[]).
explainer(humidier_inside_low(_,_),1,'the humidity level is higher inside than outside (the difference is less than 20%)',[]).
explainer(humidier_inside_middle(_,_),1,'the humidity level is higher inside than outside (the difference is between 20% and 40%)',[]).
explainer(humidier_inside_high(_,_),1,'the humidity level is higher inside than outside (the difference is more than 40%)',[]).
explainer(humidier_outside_low(_,_),1,'the humidity level is higher outside than inside (the difference is less than 20%)',[]).
explainer(humidier_outside_middle(_,_),1,'the humidity level is higher outside than inside (the difference is between 20% and 40%)',[]).
explainer(humidier_outside_high(_,_),1,'the humidity level is higher outside than inside (the difference is more than 40%)',[]).
explainer(humidier_equal(_,_),1,'the humidity level inside and outside is equal',[]).
explainer(int_humidity_accettable_yes(_,_),1,'the internal humidity level is accettable',[]).
explainer(int_humidity_accettable_no_low(_,_),1,'the internal humidity level is not accettable because it is low',[]).
explainer(int_humidity_accettable_no_high(_,_),1,'the internal humidity level is not accettable because it is high',[]).
explainer(warmer_inside_low(_,_),1,'la temperatura è bassa dentro quanto fuori (la differenza è minore di 20°C)',[]).
explainer(warmer_inside_middle(_,_),1,'the temperature is higher inside than outside (the difference is between 20 �C and 40 �C)',[]).
explainer(warmer_inside_high(_,_),1,'the temperature is higher inside than outside (the difference is more than 40 �C)',[]).
explainer(warmer_outside_low(_,_),1,'the temperature is higher outside than inside (the difference is less than 20 �C)',[]).
explainer(warmer_outside_middle(_),1,'the temperature is higher outside than inside (the difference is between 20 �C and 40 �C)',[]).
explainer(warmer_outside_high(_,_),1,'the temperature is higher outside than inside (the difference is more than 40 �C)',[]).
explainer(warmer_equal(_,_),1,'la temperatura interna ed esterna è uguale',[]).
explainer(int_temperature_accettable_yes(_,_),1,'la temperatura interna è accettabile',[]).
explainer(int_temperature_accettable_no_cold(_,_),1,'la temperatura interna non è accettabile perchè fa freddo',[]).
explainer(int_temperature_accettable_no_hot(_,_),1,'the internal temperature is not accettable because it is hot',[]).

%Funzioni di membership di output butler (morisco petrera)
/****************************************************************************************** 
  Explainer Morisco Petrera
*******************************************************************************************/


explainer(temp_esterna_molto_bassa(_,_),1,'La temperatura esterna � molto bassa',[]).
explainer(temp_esterna_bassa(_,_),1,'La temperatura esterna � bassa',[]).
explainer(temp_esterna_medio_bassa(_,_),1,'La temperatura esterna � medio bassa',[]).
explainer(temp_esterna_medio_alta(_,_),1,'La temperatura esterna � medio alta',[]).
explainer(temp_esterna_alta(_,_),1,'La temperatura esterna � alta',[]).
explainer(temp_esterna_molto_alta(_,_),1,'La temperatura esterna � molto alta',[]).
explainer(pioggia_si(_,_),1,'Piove',[]).
explainer(pioggia_no(_,_),1,'Non piove',[]).
explainer(lum_esterna_molto_bassa(_,_),1,'La luminosit� esterna � molto bassa',[]).
explainer(lum_esterna_bassa(_,_),1,'La luminosit� esterna � bassa',[]).
explainer(lum_esterna_medio_bassa(_,_),1,'La luminosit� esterna � medio bassa',[]).
explainer(lum_esterna_medio_alta(_,_),1,'La luminosit� esterna � medio alta',[]).
explainer(lum_esterna_alta(_,_),1,'La luminosit� esterna � alta',[]).
explainer(lum_esterna_molto_alta(_,_),1,'La luminosit� esterna � molto alta',[]).
explainer(rumore_basso(_,_),1,'Il rumore esterno � basso',[]).
explainer(rumore_medio(_,_),1,'Il rumore esterno � medio',[]).
explainer(rumore_alto(_,_),1,'Il rumore esterno � alto',[]).
explainer(attivazione_allarme_on(_,_),1,'Attivazione dell impianto di allarme',[]).
explainer(attivazione_allarme_off(_,_),1,'Disattivazione dell impianto di allarme',[]).
explainer(perimetrale_on(_,_),1,'Antifurto perimetrale inserito',[]).
explainer(perimetrale_off(_,_),1,'Antifurto perimetrale disinserito',[]).
explainer(volumetrico_on(_,_),1,'Antifurto volumetrico inserito',[]).
explainer(volumetrico_off(_,_),1,'Antifurto volumetrico disinserito',[]).
explainer(fascia_ora_notte(_,_),1,'� notte',[]).
explainer(fascia_ora_mattina(_,_),1,'� mattina',[]).
explainer(fascia_ora_pomeriggio(_,_),1,'� pomeriggio',[]).
explainer(temperatura_molto_bassa(_,_),1,'La temperatura interna � molto bassa',[]).
explainer(temperatura_bassa(_,_),1,'La temperatura interna � bassa',[]).
explainer(temperatura_medio_bassa(_,_),1,'La temperatura interna � medio bassa',[]).
explainer(temperatura_medio_alta(_,_),1,'La temperatura interna � medio alta',[]).
explainer(temperatura_alta(_,_),1,'La temperatura interna � alta',[]).
explainer(temperatura_molto_alta(_,_),1,'La temperatura interna � molto alta',[]).
explainer(luminosita_molto_bassa(_,_),1,'La luminosit� interna � molto bassa',[]).
explainer(luminosita_bassa(_,_),1,'La luminosit� interna � bassa',[]).
explainer(luminosita_medio_bassa(_,_),1,'La luminosit� interna � medio bassa',[]).
explainer(luminosita_medio_alta(_,_),1,'La luminosit� interna � medio alta',[]).
explainer(luminosita_alta(_,_),1,'La luminosit� interna � alta',[]).
explainer(luminosita_molto_alta(_,_),1,'La luminosit� interna � molto alta',[]).
explainer(utente_medio(_,_),1,'La tipologia di utente � medio',[]).
explainer(utente_caloroso(_,_),1,'La tipologia di utente � caloroso',[]).
explainer(utente_freddoloso(_,_),1,'La tipologia di utente � freddoloso',[]).
explainer(utente_altro(_,_),1,'La tipologia di utente � altro',[]).
explainer(presenza_si(_,_),1,'In camera � presente qualcuno',[]).
explainer(presenza_no(_,_),1,'In camera non � presente nessuno',[]).
explainer(attivita_utente_studia(_,_),1,'l utente presente in stanza sta studiando',[]).
explainer(attivita_utente_dorme(_,_),1,'l utente presente in stanza sta dormendo',[]).
explainer(attivita_utente_relax(_,_),1,'l utente presente in stanza si sta rilassando',[]).
explainer(attivita_utente_mangia(_,_),1,'l utente presente in stanza sta mangiando',[]).
explainer(attivita_utente_altro(_,_),1,'l utente presente in stanza sta facendo altro',[]).
explainer(sensore_gas_si(_,_),1,'Il sensore del gas ha rilevato la presenza di gas',[]).
explainer(sensore_gas_no(_,_),1,'Il sensore del gas non ha rilevato la presenza di gas',[]).
explainer(sensore_fumo_si(_,_),1,'Il sensore antifumo ha rilevato la presenza di fumo',[]).
explainer(sensore_fumo_no(_,_),1,'Il sensore antifumo non ha rilevato la presenza di fumo',[]).
explainer(sensore_acqua_si(_,_),1,'Il sensore antiacqua ha rilevato la presenza di acqua',[]).
explainer(sensore_acqua_no(_,_),1,'Il sensore antiacqua non ha rilevato la presenza di acqua',[]).
explainer(valvola_gas_aperta(_,_),1,'La valvola del gas � aperta',[]).
explainer(valvola_gas_chiusa(_,_),1,'La valvola del gas � chiusa',[]).
explainer(valvola_acqua_aperta(_,_),1,'La valvola dell acqua � aperta',[]).
explainer(valvola_acqua_chiusa(_,_),1,'La valvola dell acqua � chiusa',[]).
explainer(stagione_inverno(_,_),1,'� inverno',[]).
explainer(stagione_autunno(_,_),1,'� autunno',[]).
explainer(stagione_estate(_,_),1,'� estate',[]).
explainer(stagione_primavera(_,_),1,'� primavera',[]).
explainer(precon_fin(_,_),1,'ci sono le condizioni per lasciare la finesta chiusa',[]).


explainer(pref_lum(_Ts,_Istance,_Camera,molto_bassa),1,' La luminosit� preferita � molto bassa',[]).
explainer(pref_lum(_Ts,_Istance,_Camera,molto_alta),1,' La luminosit� preferita � molto alta',[]).
explainer(pref_lum(_Ts,_Istance,_Camera,medio_bassa),1,' La luminosit� preferita � medio bassa',[]).
explainer(pref_lum(_Ts,_Istance,_Camera,alta),1,' La luminosit� preferita � alta',[]).
explainer(lum_est_magg_alta(_Ts,_Istance),1,' La luminosit� esterna � maggiore di alta',[]).
explainer(lum_est_magg_medio_bassa(_Ts,_Istance),1,' La luminosit� esterna � maggiore di medio bassa',[]).
explainer(lum_est_magg_molto_bassa(_Ts,_Istance),1,' La luminosit� esterna � maggiore di molto bassa',[]).
explainer(lum_est_min_medio_bassa(_Ts,_Istance),1,' La luminosit� esterna � minore di medio bassa',[]).
explainer(lum_est_min_alta(_Ts,_Istance),1,' La luminosit� esterna � minore di alta',[]).
explainer(lum_in_stanza(_Ts,_Istance,_Camera,molto_bassa),1,' La luminosit� in stanza � molto bassa ',[]).
explainer(lum_in_stanza(_Ts,_Istance,_Camera,medio_bassa),1,' La luminosit� in stanza � medio bassa',[]).
explainer(lum_in_stanza(_Ts,_Istance,_Camera,alta),1,' La luminosit� in stanza � alta',[]).
explainer(magg_lum_alta(_Ts,_Istance,_Camera),1,' La luminosit� interna � maggiore di alta',[]).
explainer(magg_lum_medio_bassa(_Ts,_Istance,_Camera),1,' La luminosit� interna � maggiore di medio bassa',[]).
explainer(magg_lum_molto_bassa(_Ts,_Istance,_Camera),1,' La luminosit� interna � maggiore di molto bassa',[]).
explainer(min_lum_medio_bassa(_Ts,_Istance,_Camera),1,' La luminosit� interna � minore di medio bassa',[]).
explainer(min_lum_alta(_Ts,_Istance,_Camera),1,' La luminosit� interna � minore di alta',[]).
explainer(lum_eff_magg_pref(_Ts,_Istance,_Camera,molto_bassa),1,' La luminosit� effettiva in stanza � maggiore di molto bassa',[]).
explainer(lum_eff_magg_pref(_Ts,_Istance,_Camera,medio_bassa),1,' La luminosit� effettiva in stanza � maggiore di medio bassa',[]).
explainer(lum_eff_magg_pref(_Ts,_Istance,_Camera,alta),1,' La luminosit� effettiva in stanza � maggiore di alta',[]).
explainer(lum_eff_min_pref(_Ts,_Istance,_Camera,medio_bassa),1,' La luminosit� effettiva in stanza � minore di medio bassa',[]).
explainer(lum_eff_min_pref(_Ts,_Istance,_Camera,alta),1,' La luminosit� effettiva in stanza � minore di alta',[]).
explainer(set_lum(_Ts,_Istance,_Camera,Lum),1,' La luminosit� deve essere settata a '+ Lum,[]).
explainer(tap_chiusa_in_stanza(_Ts,_Istance,_Camera),1,' La tapparella in camera � chiusa',[]).
explainer(tap_aperta_in_stanza(_Ts,_Istance,_Camera),1,' La tapparella in camera � aperta',[]).
explainer(tap_chiusa_lum_eff(_Ts,_Istance,_Camera,alta),1,' Tapparella chiusa e luminosita effettiva alta',[]).
explainer(tap_aperta_lum_eff(_Ts,_Istance,_Camera,alta),1,' Tapparella chiusa e luminosita effettiva alta',[]).
explainer(tap_chiusa_lum_esterna(_Ts,_Istance,_Camera,molto_bassa),1,' Tapparella chiusa, luminosit� esterna molto bassa',[]).
explainer(tap_chiusa_lum_esterna(_Ts,_Istance,_Camera,medio_bassa),1,' Tapparella chiusa, luminosit� esterna medio bassa',[]).
explainer(tap_chiusa_lum_esterna(_Ts,_Istance,_Camera,alta),1,' Tapparella chiusa, luminosit� esterna alta',[]).
explainer(tap_aperta_lum_esterna(_Ts,_Istance,_Camera,molto_bassa),1,' Tapparella aperta, luminosit� esterna molto bassa',[]).
explainer(tap_aperta_lum_esterna(_Ts,_Istance,_Camera,medio_bassa),1,' Tapparella aperta, luminosit� esterna medio bassa',[]).
explainer(tap_aperta_lum_esterna(_Ts,_Istance,_Camera,alta),1,' Tapparella aperta, luminosit� esterna alta',[]).
explainer(tapparella(_Ts,_Istance,_Camera,aperta),1,' Tapparella aperta',[]).
explainer(tapparella(_Ts,_Istance,_Camera,chiusa),1,' Tapparella chiusa',[]).
explainer(luce_accesa(_Ts,_Istance,_Camera),1,' Luce accesa',[]).
explainer(luce_spenta(_Ts,_Istance,_Camera),1,' Luce spenta',[]).
explainer(luce(_Ts,_Istance,_Camera,liv1),1,' Luce accesa intensit� 1',[]).
explainer(luce(_Ts,_Istance,_Camera,liv2),1,' Luce accesa intensit� 2',[]).
explainer(luce(_Ts,_Istance,_Camera,liv3),1,' Luce accesa intensit� 3',[]).
explainer(luce(_Ts,_Istance,_Camera,liv4),1,' Luce accesa intensit� 4',[]).
explainer(luce(_Ts,_Istance,_Camera,liv5),1,' Luce accesa intensit� 5',[]).
explainer(luce(_Ts,_Istance,_Camera,accesa),1,' Luce accesa',[]).
explainer(temp_est_magg_alta(_Ts,_Istance),1,' Temperatura esterna maggiore di alta',[]).
explainer(temp_est_magg_medio_bassa(_Ts,_Istance),1,' Temperatura esterna maggiore di medio bassa',[]).
explainer(temp_est_magg_molto_bassa(_Ts,_Istance),1,' Temperatura esterna maggiore di molot bassa',[]).
explainer(temp_est_min_medio_bassa(_Ts,_Istance),1,' Temperatura esterna minore di medio bassa',[]).
explainer(temp_est_min_alta(_Ts,_Istance),1,' Temperatura esterna minore di alta',[]).
explainer(rumore_ok(_Ts,_Istance),1,' Il livello di rumore � basso, la finestra pu� rimanere aperta',[]).
explainer(camera_calorosa(_Camera,_Utente),1,' L utente in stanza � di tipo caloroso',[]).
explainer(camera_freddolosa_calorosa(_Camera,_Utente1,_Utente2),1,' Gli utenti in stanza sono uno di tipo caloroso, ed uno di tipo freddoloso',[]).
explainer(camera_freddolosa_media(_Camera,_Utente1,_Utente2),1,' Gli utenti in stanza sono uno di tipo freddoloso, ed uno di tipo medio',[]).
explainer(camera_freddolosa_freddolosa(_Camera,_Utente1,_Utente2),1,' Gli utenti in stanza sono entrambi di tipo freddoloso',[]).
explainer(camera_calorosa_media(_Camera,_Utente1,_Utente2),1,' Gli utenti in stanza sono uno di tipo caloroso, ed uno di tipo medio',[]).
explainer(camera_media_media(_Camera,_Utente1,_Utente2),1,' Gli utentiin stanza sono entrambidi tipo medio',[]).
explainer(utente_in_camera_freddolosa(_Ts,_Istance,_Camera),1,' L utente in camera � freddolosa',[]).
explainer(utente_in_camera_media(_Ts,_Istance,_Camera,medio_alta),1,' L utente in camera � media',[]).
explainer(pref_temp(_Ts,_Istance,_Camera,medio_alta),1,' la temperatura preferita � medio alta',[]).
explainer(pref_temp(_Ts,_Istance,_Camera,medio_bassa),1,' la temperatura preferita � medio bassa',[]).
explainer(temp_in_stanza(_Ts,_Istance,_Camera,molto_bassa),1,' La temperatura in stanza � molto bassa',[]).
explainer(temp_in_stanza(_Ts,_Istance,_Camera,medio_bassa),1,' La temperatura in stanza � medio bassa',[]).
explainer(temp_in_stanza(_Ts,_Istance,_Camera,alta),1,' La temperatura in stanza � alta',[]).
explainer(magg_temp_alta(_Ts,_Istance,_Camera),1,' La temperatura � maggiore di alta',[]).
explainer(magg_temp_medio_bassa(_Ts,_Istance,_Camera),1,' La temperatura � maggiore di medio bassa',[]).
explainer(magg_temp_molto_bassa(_Ts,_Istance,_Camera),1,' La temperatura � maggiore di molto bassa',[]).
explainer(min_temp_medio_bassa(_Ts,_Istance,_Camera),1,' La temperatura � minore di bassa',[]).
explainer(min_temp_alta(_Ts,_Istance,_Camera),1,' La temperatura � minore di alta',[]).
explainer(temp_eff_magg_pref(_Ts,_Istance,_Camera,_),1,' La temperatura effettiva � maggiore di quella preferita',[]).
explainer(temp_eff_min_pref(_Ts,_Istance,_Camera,_),1,' La temperatura effettiva � minore di quella preferita',[]).
explainer(set_temp(_Ts,_Istance,_Camera,_Temp,aum),1,' Il sistema deve aumentare la temperatura',[]).
explainer(set_temp(_Ts,_Istance,_Camera,_Temp,dim),1,' Il sistema deve diminuire la temperatura',[]).
explainer(fin_chiusa_in_stanza(_Ts,_Istance,_Camera),1,' Finestra chiusa in stanza ',[]).
explainer(fin_aperta_in_stanza(_Ts,_Istance,_Camera),1,' Finestra aperta in stanza ',[]).
explainer(precon_fin(_Ts,_Istance,_Camera,apri),1,' Ci sono le condizioni per aprire la finestra',[]).
explainer(precon_fin(_Ts,_Istance,_Camera,chiudi),1,' Ci sono le condizioni per chiudere la finestra',[]).
explainer(finestra(_Ts,_Istance,_Camera,aperta),1,' La finestra � aperta ',[]).
explainer(finestra(_Ts,_Istance,_Camera,chiusa),1,' La finestra � chiusa ',[]).
explainer(cond_spento_in_stanza(_Ts,_Istance,_Camera),1,' Il condizionatore � spento',[]).
explainer(cond_acceso_in_stanza(_Ts,_Istance,_Camera),1,' Il condizionatore � acceso',[]).
explainer(cond_acceso_temp_est_magg(_Ts,_Istance,_Camera,medio_bassa),1,' Il condizionatore � acceso e la temperatura esterna � maggiore di medio bassa',[]).
explainer(cond_spento_temp_est_magg(_Ts,_Istance,_Camera,medio_bassa),1,' Il condizionatore � spento e la temperatura esterna � maggiore di medio bassa',[]).
explainer(condizionatore(_Ts,_Istance,_Camera,liv1),1,' Condizionatore acceso a livello 1',[]).
explainer(condizionatore(_Ts,_Istance,_Camera,spento),1,' Condizionatore spento',[]).
explainer(risc_spento_in_stanza(_Ts,_Istance,_Camera),1,' Il riscaldamento in stanza � spento',[]).
explainer(risc_acceso_in_stanza(_Ts,_Istance,_Camera),1,' Il riscaldamento in stanza � acceso',[]).
explainer(risc_acceso_temp_est_min(_Ts,_Istance,_Camera,medio_alta),1,' Riscaldamento acceso, temperatura esterna minore di medio alta',[]).
explainer(risc_spento_temp_est_min(_Ts,_Istance,_Camera,alta),1,' Riscaldamento acceso, temperatura esterna minore di alta',[]).
explainer(risc_spento_temp_est_min(_Ts,_Istance,_Camera,medio_bassa),1,' Riscaldamento acceso, temperatura esterna minore di medio bassa',[]).
explainer(riscaldamento(_Ts,_Istance,_Camera,liv1),1,' Riscaldamento acceso a livello 1',[]).
explainer(riscaldamento(_Ts,_Istance,_Camera,liv2),1,' Riscaldamento acceso a livello 2',[]).
explainer(riscaldamento(_Ts,_Istance,_Camera,liv3),1,' Riscaldamento acceso a livello 3',[]).
explainer(riscaldamento(_Ts,_Istance,_Camera,acceso),1,' Riscaldamento acceso',[]).
explainer(luce(_Ts,_Istance,cucina,spenta),1,' Luce in cucina spenta',[]).
explainer(luce(_Ts,_Istance,soggiorno,spenta),1,' Luce in soggiorno spenta',[]).
explainer(luce(_Ts,_Istance,camera2,spenta),1,' Luce in camera 2 spenta ',[]).
explainer(luce(_Ts,_Istance,camera1,spenta),1,' Luce in camera 1 spenta',[]).
explainer(luce(_Ts,_Istance,camera3,spenta),1,' Luce in camera 3 spenta',[]).
explainer(luce(_Ts,_Istance,bagno,spenta),1,' Luce in bagno spenta ',[]).
explainer(finestra(_Ts,_Istance,cucina,chiusa),1,' Finestra cucina chiusa',[]).
explainer(finestra(_Ts,_Istance,soggiorno,chiusa),1,' Finestra soggiorno chiusa',[]).
explainer(finestra(_Ts,_Istance,camera1,chiusa),1,' Finestra camera 1 chiusa',[]).
explainer(finestra(_Ts,_Istance,camera2,chiusa),1,' Finestra camera 2 chiusa',[]).
explainer(finestra(_Ts,_Istance,camera3,chiusa),1,' Finestra camera 3 chiusa',[]).
explainer(finestra(_Ts,_Istance,bagno,chiusa),1,' Finestra bagno chiusa',[]).
explainer(tapparella(_Ts,_Istance,cucina,chiusa),1,' Tapparella in cucina chiusa',[]).
explainer(tapparella(_Ts,_Istance,soggiorno,chiusa),1,' Tapparella in soggiorno chiusa',[]).
explainer(tapparella(_Ts,_Istance,camera1,chiusa),1,' Tapparella in camera 1 chiusa',[]).
explainer(tapparella(_Ts,_Istance,camera2,chiusa),1,' Tapparella in camera 2 chiusa',[]).
explainer(tapparella(_Ts,_Istance,camera3,chiusa),1,' Tapparella in camera 3 chiusa',[]).
explainer(tapparella(_Ts,_Istance,bagno,chiusa),1,' Tapparella in bagno chiusa',[]).
explainer(condizionatore(_Ts,_Istance,cucina,spento),1,' Condizionatore in cucina spento',[]).
explainer(condizionatore(_Ts,_Istance,soggiorno,spento),1,' Condizionatore in soggiorno spento',[]).
explainer(condizionatore(_Ts,_Istance,camera1,spento),1,' Condizionatore in camera 1 spento',[]).
explainer(riscaldamento(_Ts,_Istance,camera2,spento),1,' Condizionatore in camera 2 spento',[]).
explainer(riscaldamento(_Ts,_Istance,camera3,spento),1,' Condizionatore in camera 3 spento',[]).
explainer(riscaldamento(_Ts,_Istance,bagno,spento),1,' Condizionatore in bagno spento',[]).
explainer(allarme_on(_Ts,_Istance),1,' l allarme � attivo',[]).
explainer(antifurto_volumetrico_on(_Ts,_Istance),1,' antifurto volumetrico � attivo',[]).
explainer(acqua_chiusa(_Ts,_Istance),1,' la valvola dell acqua � chiusa',[]).
explainer(gas_chiuso(_Ts,_Istance),1,' la valvola dell gas � chiusa',[]).
explainer(tapparella(_Ts,_Istance,_Camera,chiusa),1,' la tapparella � chiusa',[]).
explainer(finestra(_Ts,_Istance,_Camera,chiusa),1,' la finestra � chiusa',[]).
explainer(luce(_Ts,_Istance,_Camera,spenta),1,' la luce � spenta',[]).
explainer(riscaldamento(_Ts,_Istance,_Camera,spento),1,' il riscaldamento � spento',[]).
explainer(condizionatore(_Ts,_Istance,_Camera,spento),1,' il condizionatore � spento',[]).
explainer(sirena_on(_Ts,_Istance,intruso),1,' � scattata la sirena perch� � stato rilevato un intruso',[]).
explainer(antifurto_perimetrale_off(_Ts,_Istance),1,' l antifurto perimetrale � disattivato',[]).
explainer(acqua_aperta(_Ts,_Istance),1,' la valvola dell acqua � aperta',[]).
explainer(buongiorno_casa(_Ts,_Istance),1,' � stata avviata la procedura di buongiorno casa',[]).
explainer(camera_mattiniero_dormiglione(camera3),1,' in camera ci sono un utente mattiniero e uno dormiglione.',[]).
explainer(camera_mattiniero(_Camera),1,' in camera c � un utente mattiniero',[]).
explainer(buonanotte_camera(_Ts,_Istance,_,_),1,' � stata avviata la procedura di buonanotte',[]).
explainer(allagamento(_Ts,_Istance),1,' � stato rilevato un allagamento',[]).
explainer(acqua_chiusa(_Ts,_Istance),1,' La valvola dell acqua � stata chiusa',[]).
explainer(incendio(_Ts,_Istance),1,' � stato rilevato un incendio',[]).
explainer(gas_chiuso(_Ts,_Istance),1,' La valvola del gas � stata chiusa',[]).
explainer(fuga_gas(_Ts,_Istance),1,' � stata rilevata una fuga di gas',[]).
explainer(sirena_on(_Ts,_Istance,_),1,' La sirena � attiva per segnalare un pericolo',[]).



/****************************************************************************************** 
 KITCHEN
  Explainer Labianca Mario
*******************************************************************************************/

explainer(soggetto1(_,_),1,'Subject of simulation',[]).
explainer(utente(_,_),1,'Utente',[]).
explainer(is_present_kitchen(_,_),1,'User is present in kitchen',[]).
explainer(is_present_kitchen_out(_,_),1,'User is not present in kitchen',[]).
explainer(go_in(_,_),1,'User is coming at home',[]).
explainer(go_out(_,_),1,'User is leaving home',[]).
explainer(season_winter(_),1,'is Winter',[]).
explainer(season_spring(_),1,'is Spring',[]).
explainer(season_summer(_),1,'is Summer',[]).
explainer(season_autumn(_),1,'is Fall',[]).
explainer(month_january(_),1,'the month is January',[]).
explainer(month_february(_),1,'the month is February',[]).
explainer(month_march(_),1,'the month is March',[]).
explainer(month_april(_),1,'the month is April',[]).
explainer(month_may(_),1,'the month is May',[]).
explainer(month_june(_),1,'the month is June',[]).
explainer(month_july(_),1,'the month is July',[]).
explainer(month_august(_),1,'the month is August',[]).
explainer(month_september(_),1,'the month is September',[]).
explainer(month_october(_),1,'the month is October',[]).
explainer(month_november(_),1,'the month is November',[]).
explainer(month_december(_),1,'the month is December',[]).
explainer(season_cold(_),1,'The season is cold',[]).
explainer(season_warm(_),1,'The season is warm',[]).
explainer(is_night_pm(_),1,'Nigh (past midnight)',[]).
explainer(is_morning(_),1,'Morning',[]).
explainer(is_afternoon(_),1,'Afternoon',[]).
explainer(is_evening(_),1,'Evening',[]).
explainer(is_night_am(_),1,'Night (ante midnigh)',[]).
explainer(time_0(_,_),1,'Time: 0',[]).
explainer(time_1(_,_),1,'Time: 1',[]).
explainer(time_2(_,_),1,'Time: 2',[]).
explainer(time_3(_,_),1,'Time: 3',[]).
explainer(time_4(_,_),1,'Time: 4',[]).
explainer(time_5(_,_),1,'Time: 5',[]).
explainer(time_6(_,_),1,'Time: 6',[]).
explainer(time_7(_,_),1,'Time: 7',[]).
explainer(time_8(_,_),1,'Time: 8',[]).
explainer(time_9(_,_),1,'Time: 9',[]).
explainer(time_10(_,_),1,'Time:10 ',[]).
explainer(time_11(_,_),1,'Time: 11',[]).
explainer(time_12(_,_),1,'Time: 12',[]).
explainer(time_13(_,_),1,'Time: 13',[]).
explainer(time_14(_,_),1,'Time: 14',[]).
explainer(time_15(_,_),1,'Time: 15',[]).
explainer(time_16(_,_),1,'Time: 16',[]).
explainer(time_17(_,_),1,'Time: 17',[]).
explainer(time_18(_,_),1,'Time: 18',[]).
explainer(time_19(_,_),1,'Time: 19',[]).
explainer(time_20(_,_),1,'Time: 20',[]).
explainer(time_21(_,_),1,'Time: 21',[]).
explainer(time_22(_,_),1,'Time: 22',[]).
explainer(time_23(_,_),1,'Time: 23',[]).
explainer(time_breakfast_yes(_,_),1,'Time of breakfast',[]).
explainer(time_lunch_yes(_,_),1,'Time of lunch',[]).
explainer(time_dinner_yes(_,_),1,'Time of dinner',[]).
explainer(time_break_yes(_,_),1,'Time of break',[]).
explainer(time_breakfast_no(_,_),1,'Not the time of breakfast',[]).
explainer(time_lunch_no(_,_),1,'Not the time of lunch',[]).
explainer(time_dinner_no(_,_),1,'Not the time of dinner',[]).
explainer(time_break_no(_,_),1,'Not the time of break',[]).
explainer(ext_humidity_v0_20(_,_),1,'the external humidity is between 0% and 20%',[]).
explainer(ext_humidity_v20_30(_,_),1,'the external humidity is between 20% and 30%',[]).
explainer(ext_humidity_v30_40(_,_),1,'the external humidity is between 30% and 40%',[]).
explainer(ext_humidity_v40_50(_,_),1,'the external humidity is between 40% and 50%',[]).
explainer(ext_humidity_v50_60(_,_),1,'the external humidity is between 50% and 60%',[]).
explainer(ext_humidity_v60_70(_,_),1,'the external humidity is between 60% and 70%',[]).
explainer(ext_humidity_v70_80(_,_),1,'the external humidity is between 70% and 80%',[]).
explainer(ext_humidity_v80_90(_,_),1,'the external humidity is between 80% and 90%',[]).
explainer(ext_humidity_v90_100(_,_),1,'the external humidity is between 90% and 100%',[]).
explainer(int_humidity_v0_20(_,_),1,'the internal humidity is between 0% and 20%',[]).
explainer(int_humidity_v20_30(_,_),1,'the internal humidity is between 20% and 30%',[]).
explainer(int_humidity_v30_40(_,_),1,'the internal humidity is between 30% and 40%',[]).
explainer(int_humidity_v40_50(_,_),1,'the internal humidity is between 40% and 50%',[]).
explainer(int_humidity_v50_60(_,_),1,'the internal humidity is between 50% and 60%',[]).
explainer(int_humidity_v60_70(_,_),1,'the internal humidity is between 60% and 70%',[]).
explainer(int_humidity_v70_80(_,_),1,'the internal humidity is between 70% and 80%',[]).
explainer(int_humidity_v80_90(_,_),1,'the internal humidity is between 80% and 90%',[]).
explainer(int_humidity_v90_100(_,_),1,'the internal humidity is between 90% and 100%',[]).
explainer(external_temp_vBelowMinus10(_,_),1,'the external temperature is below -10 �C',[]).
explainer(external_temp_vMinus10_0(_,_),1,'la temperatura esterna è compresa tra -10°C e 0°C',[]).
explainer(external_temp_v0_10(_,_),1,'the external temperature is between 0 �C and 10 �C',[]).
explainer(external_temp_v10_20(_,_),1,'the external temperature is between 10 �C and 20 �C',[]).
explainer(external_temp_v20_30(_,_),1,'the external temperature is between 20 �C and 30 �C',[]).
explainer(external_temp_v30_40(_,_),1,'the external temperature is between 30 �C and 40 �C',[]).
explainer(external_temp_vPlus40(_,_),1,'the external temperature is more than 40 �C',[]).
explainer(internal_temp_v0_5(_,_),1,'la temperatura interna è compresa tra 0°C e 5°C',[]).
explainer(internal_temp_v5_10(_,_),1,'the internal temperature is between 5 �C and 10 �C',[]).
explainer(internal_temp_v10_20(_,_),1,'the internal temperature is between 10 �C and 20 �C',[]).
explainer(internal_temp_v20_30(_,_),1,'the internal temperature is between 20 �C and 30 �C',[]).
explainer(internal_temp_v30_40(_,_),1,'the internal temperature is between 30 �C and 40 �C',[]).
explainer(internal_temp_vPlus40(_,_),1,'the internal temperature is more than 40 �C',[]).
explainer(humidier_inside_low(_,_),1,'the humidity level is higher inside than outside (the difference is less than 20%)',[]).
explainer(humidier_inside_middle(_,_),1,'the humidity level is higher inside than outside (the difference is between 20% and 40%)',[]).
explainer(humidier_inside_high(_,_),1,'the humidity level is higher inside than outside (the difference is more than 40%)',[]).
explainer(humidier_outside_low(_,_),1,'the humidity level is higher outside than inside (the difference is less than 20%)',[]).
explainer(humidier_outside_middle(_,_),1,'the humidity level is higher outside than inside (the difference is between 20% and 40%)',[]).
explainer(humidier_outside_high(_,_),1,'the humidity level is higher outside than inside (the difference is more than 40%)',[]).
explainer(humidier_equal(_,_),1,'the humidity level inside and outside is equal',[]).
explainer(int_humidity_accettable_yes(_,_),1,'the internal humidity level is accettable',[]).
explainer(int_humidity_accettable_no_low(_,_),1,'the internal humidity level is not accettable because it is low',[]).
explainer(int_humidity_accettable_no_high(_,_),1,'the internal humidity level is not accettable because it is high',[]).
explainer(warmer_inside_low(_,_),1,'the temperature is higher inside than outside (the difference is less than 20 �C)',[]).
explainer(warmer_inside_middle(_,_),1,'the temperature is higher inside than outside (the difference is between 20 �C and 40 �C)',[]).
explainer(warmer_inside_high(_,_),1,'the temperature is higher inside than outside (the difference is more than 40 �C)',[]).
explainer(warmer_outside_low(_,_),1,'the temperature is higher outside than inside (the difference is less than 20 �C)',[]).
explainer(warmer_outside_middle(_,_),1,'the temperature is higher outside than inside (the difference is between 20 �C and 40 �C)',[]).
explainer(warmer_outside_high(_,_),1,'the temperature is higher outside than inside (the difference is more than 40 �C)',[]).
explainer(warmer_equal(_,_),1,'the temperature level inside and outside is equal',[]).
explainer(int_temperature_accettable_yes(_,_),1,'the internal temperature is accettable',[]).
explainer(int_temperature_accettable_no_low(_,_),1,'the internal temperature is not accettable because it is cold',[]).
explainer(int_temperature_accettable_no_hot(_,_),1,'the internal temperature is not accettable because it is hot',[]).
explainer(wind_calmo(_,_),1,'Wind: calmo',[]).
explainer(wind_bava_di_vento(_,_),1,'Wind: bava di vento',[]).
explainer(wind_brezza_leggera(_,_),1,'Wind: brezza leggera',[]).
explainer(wind_brezza(_,_),1,'Wind: brezza',[]).
explainer(wind_brezza_vivace(_,_),1,'Wind: brezza vivace',[]).
explainer(wind_brezza_tesa(_,_),1,'Wind: brezza tesa',[]).
explainer(wind_vento_fresco(_,_),1,'Wind: vento fresco',[]).
explainer(wind_vento_forte(_,_),1,'Wind: vento forte',[]).
explainer(wind_burrasca_moderata(_,_),1,'Wind: burrasca moderata',[]).
explainer(wind_burrasca_forte(_,_),1,'Wind: burrasca forte',[]).
explainer(wind_fortunale(_,_),1,'Wind: fortunale',[]).
explainer(wind_tempesta(_,_),1,'Wind: tempesta',[]).
explainer(wind_uragano(_,_),1,'Wind: uragano',[]).
explainer(wind_acceptance_no_low(_,_),1,'the wind is not accettable because is low',[]).
explainer(wind_acceptance_yes(_,_),1,'the wind is accettable',[]).
explainer(wind_acceptance_no_high(_,_),1,'the wind is not accettable because is high',[]).
explainer(tot_lux_v0_100(_,_),1,'Total brightness outside is between 0 lux and 100 lux',[]).
explainer(tot_lux_v100_200(_,_),1,'Total brightness outside is between 100 lux and 200 lux',[]).
explainer(tot_lux_v200_300(_,_),1,'Total brightness outside is between 200 lux and 300 lux',[]).
explainer(tot_lux_v300_400(_,_),1,'Total brightness outside is between 300 lux and 400 lux',[]).
explainer(tot_lux_v400_500(_,_),1,'Total brightness outside is between 400 lux and 500 lux',[]).
explainer(tot_lux_v500_600(_,_),1,'Total brightness outside is between 500 lux and 600 lux',[]).
explainer(tot_lux_v600_800(_,_),1,'Total brightness outside is between 600 lux and 800 lux',[]).
explainer(tot_lux_v800_1000(_,_),1,'Total brightness outside is between 800 lux and 1000 lux',[]).
explainer(tot_lux_blank(_,_),1,'the lux level inside is blank',[]).
explainer(tot_lux_low(_,_),1,'the lux level inside is low',[]).
explainer(tot_lux_medium(_,_),1,'the lux level inside is medium',[]).
explainer(tot_lux_high(_,_),1,'the lux level insideis high',[]).
explainer(lux_setting_300(_,_),1,'Lighting setting: 300lux',[]).
explainer(lux_setting_200(_,_),1,'Lighting setting: 200lux',[]).
explainer(lux_setting_100(_,_),1,'Lighting setting: 100lux',[]).
explainer(lux_setting_0(_,_),1,'Lighting setting: 0lux',[]).
explainer(lighting_choice_300(_,_),1,'Lighting: status 300lux',[]).
explainer(lighting_choice_200(_,_),1,'Lighting: status 200lux',[]).
explainer(lighting_choice_100(_,_),1,'Lighting: status 100lux',[]).
explainer(lighting_choice_off(_,_),1,'Lighting: status Off',[]).
explainer(action_lighting_lux300(_,_),1,'Turning 300lux Lighting',[]).
explainer(action_lighting_lux200(_,_),1,'Turning 200lux Lighting',[]).
explainer(action_lighting_lux100(_,_),1,'Turning 100lux Lighting',[]).
explainer(action_lighting_off(_,_),1,'Turning off Lighting',[]).
explainer(radiator_choice_max(_,_),1,'Radiator: status Max',[]).
explainer(radiator_choice_middle(_,_),1,'Radiator: status Middle',[]).
explainer(radiator_choice_low(_,_),1,'Radiator: status Low',[]).
explainer(radiator_choice_off(_,_),1,'Radiator: status Off',[]).
explainer(action_radiator_max(_,_),1,'Turning max Radiator',[]).
explainer(action_radiator_middle(_,_),1,'Turning middle Radiator',[]).
explainer(action_radiator_low(_,_),1,'Turning low Radiator',[]).
explainer(action_radiator_off(_,_),1,'Turning off Radiator',[]).
explainer(air_conditioner_choice_off(_,_),1,'Air Conditioner: status Off',[]).
explainer(air_conditioner_choice_deumidifier(_,_),1,'Air Conditioner: status Deumidifier',[]).
explainer(air_conditioner_choice_low(_,_),1,'Air Conditioner: status Low',[]).
explainer(air_conditioner_choice_middle(_,_),1,'Air Conditioner: status Middle',[]).
explainer(air_conditioner_choice_max(_,_),1,'Air Conditioner: status Max',[]).
explainer(action_air_conditioner_off(_,_),1,'Turning off Air Conditioner',[]).
explainer(action_air_conditioner_deumidifier(_,_),1,'Turning deumidifier Air Conditioner',[]).
explainer(action_air_conditioner_low(_,_),1,'Turning low Air Conditioner',[]).
explainer(action_air_conditioner_middle(_,_),1,'Turning middle Air Conditioner',[]).
explainer(action_air_conditioner_max(_,_),1,'Turning max Air Conditioner',[]).
explainer(condition_window_open(_,_),1,'Condition to opening window',[]).
explainer(condition_window_close(_,_),1,'Condition to closing window',[]).
explainer(window_choice_open(_,_),1,'Window: status Open',[]).
explainer(window_choice_close(_,_),1,'Window: status Close',[]).
explainer(action_window_open(_,_),1,'Opening Window',[]).
explainer(action_window_close(_,_),1,'Closing Window',[]).
explainer(pick_food_to_cook(_,_),1,'Taked food to cook',[]).
explainer(pick_food_to_breakfast(_,_),1,'Taked food to breakfast',[]).
explainer(pick_food_to_defrost(_,_),1,'Taked food to defrost',[]).
explainer(pick_food_to_break(_,_),1,'Taked food to break',[]).
explainer(pick_food_to_heat(_,_),1,'Taked food to heat',[]).
explainer(action_pick_food_to_cook(_,_),1,'Taking the food to cook',[]).
explainer(action_pick_food_to_breakfast(_,_),1,'Taking the food to breakfast',[]).
explainer(action_pick_food_to_defrost(_,_),1,'Taking the food to defrost',[]).
explainer(action_pick_food_to_break(_,_),1,'Taking the food to break',[]).
explainer(action_pick_food_to_heat(_,_),1,'Taking the food to heat',[]).
explainer(action_put_away_food_to_cook(_,_),1,'Putting away the food to cook',[]).
explainer(action_put_away_food_to_breakfast(_,_),1,'Putting away the food to breakfast',[]).
explainer(action_put_away_food_to_defrost(_,_),1,'Putting away the food to defrost',[]).
explainer(action_put_away_food_to_break(_,_),1,'Putting away the food to break',[]).
explainer(action_put_away_food_to_heat(_,_),1,'Putting away the food to heat',[]).
explainer(pick_item_to_cook(_,_),1,'Taked item for cook',[]).
explainer(pick_item_to_breakfast(_,_),1,'Taked item for breakfast',[]).
explainer(pick_item_to_break(_,_),1,'Taked item for break',[]).
explainer(pick_item_to_oven(_,_),1,'Taked item for oven',[]).
explainer(pick_item_to_microwave_oven(_,_),1,'Taked the item for microwave oven',[]).
explainer(action_pick_item_to_cook(_,_),1,'Taking the item for cook',[]).
explainer(action_pick_item_to_breakfast(_,_),1,'Taking the item for breakfast',[]).
explainer(action_pick_item_to_break(_,_),1,'Taking the item for break',[]).
explainer(action_pick_item_to_oven(_,_),1,'Taking the item for oven',[]).
explainer(action_pick_item_to_microwave_oven(_,_),1,'Taking the the item for microwave oven',[]).
explainer(action_put_away_item_to_cook(_,_),1,'Putting away the item for cook',[]).
explainer(action_put_away_item_to_breakfast(_,_),1,'Putting away the item for breakfast',[]).
explainer(action_put_away_item_to_break(_,_),1,'Putting away the item for break',[]).
explainer(action_put_away_item_to_oven(_,_),1,'Putting away the item for oven',[]).
explainer(action_put_away_item_to_microwave_oven(_,_),1,'Putting away the item for microwave oven',[]).
explainer(pick_tomato(_,_),1,'Taked tomato',[]).
explainer(pick_pasta(_,_),1,'Taked pasta',[]).
explainer(pick_meat(_,_),1,'Taked meat',[]).
explainer(pick_egg(_,_),1,'Taked egg',[]).
explainer(pick_milk(_,_),1,'Taked milk',[]).
explainer(pick_tea_pocket(_,_),1,'Taked tea pocket',[]).
explainer(pick_biscuit(_,_),1,'Taked biscuit',[]).
explainer(pick_sliced_bread(_,_),1,'Taked sliced bread',[]).
explainer(pick_frozen_food(_,_),1,'Taked frozen food',[]).
explainer(pick_coffee(_,_),1,'Taked coffee',[]).
explainer(pick_chips(_,_),1,'Taked chips',[]).
explainer(pick_canned_food(_,_),1,'Taked canned food',[]).
explainer(action_pick_tomato(_,_),1,'Taking the tomato',[]).
explainer(action_pick_pasta(_,_),1,'Taking the pasta',[]).
explainer(action_pick_meat(_,_),1,'Taking the meat',[]).
explainer(action_pick_egg(_,_),1,'Taking the egg',[]).
explainer(action_pick_milk(_,_),1,'Taking the milk',[]).
explainer(action_pick_coffee(_,_),1,'Taking the coffee',[]).
explainer(action_pick_tea_pocket(_,_),1,'Taking the tea pocket',[]).
explainer(action_pick_biscuit(_,_),1,'Taking the biscuit',[]).
explainer(action_pick_sliced_bread(_,_),1,'Taking the sliced food',[]).
explainer(action_pick_frozen_food(_,_),1,'Taking the frozen food',[]).
explainer(action_pick_chips(_,_),1,'Taking the chips',[]).
explainer(action_pick_canned_food(_,_),1,'Taking the canned food',[]).
explainer(action_put_away_tomato(_,_),1,'Putting away the tomato',[]).
explainer(action_put_away_pasta(_,_),1,'Putting away the pasta',[]).
explainer(action_put_away_meat(_,_),1,'Putting away the meat',[]).
explainer(action_put_away_egg(_,_),1,'Putting away the egg',[]).
explainer(action_put_away_milk(_,_),1,'Putting away the milk',[]).
explainer(action_put_away_tea_pocket(_,_),1,'Putting away the tea pocket',[]).
explainer(action_put_away_biscuit(_,_),1,'Putting away the biscuit',[]).
explainer(action_put_away_sliced_bread(_,_),1,'Putting away the slice bread',[]).
explainer(action_put_away_frozen_food(_,_),1,'Putting away the frozen food',[]).
explainer(action_put_away_coffee(_,_),1,'Putting away the coffee',[]).
explainer(action_put_away_chips(_,_),1,'Putting away the chips',[]).
explainer(action_put_away_canned_food(_,_),1,'Putting away the canned food',[]).
explainer(pick_pot(_,_),1,'Taked pot',[]).
explainer(pick_pan(_,_),1,'Taked pan',[]).
explainer(pick_cup(_,_),1,'Taked cup',[]).
explainer(pick_coffee_cup(_,_),1,'Taked coffe cup',[]).
explainer(pick_baking_pan(_,_),1,'Taked baking pan',[]).
explainer(pick_microwave_pan(_,_),1,'Taked microwave pan',[]).
explainer(action_pick_pot(_,_),1,'Taking the pot',[]).
explainer(action_pick_pan(_,_),1,'Taking the pan',[]).
explainer(action_pick_cup(_,_),1,'Taking the cup',[]).
explainer(action_pick_coffee_cup(_,_),1,'Taking the coffee cup',[]).
explainer(action_pick_baking_pan(_,_),1,'Taking the baking pan',[]).
explainer(action_pick_microwave_pan(_,_),1,'Taking the microwave oven',[]).
explainer(action_put_away_pot(_,_),1,'Putting away the pot',[]).
explainer(action_put_away_pan(_,_),1,'Putting away the pan',[]).
explainer(action_put_away_cup(_,_),1,'Putting away the cup',[]).
explainer(action_put_away_coffee_cup(_,_),1,'Putting away the coffe cup',[]).
explainer(action_put_away_baking_pan(_,_),1,'Putting away the baking pan',[]).
explainer(action_put_away_microwave_pan(_,_),1,'Putting away the microwave pan',[]).
explainer(action_coffee_machine_on(_,_),1,'Turning on the Coffee Machine',[]).
explainer(action_coffee_machine_off(_,_),1,'Turning off the Coffee Machine',[]).
explainer(coffee_machine_choice_on(_,_),1,'Coffee Machine: status On',[]).
explainer(coffee_machine_choice_off(_,_),1,'Coffee Machine: status Off',[]).
explainer(action_tea_boiler_on(_,_),1,'Turning on the Tea Boiler',[]).
explainer(action_tea_boiler_off(_,_),1,'Turning off the Tea Boiler',[]).
explainer(tea_boiler_choice_on(_,_),1,'Tea Boiler: status On',[]).
explainer(tea_boiler_choice_off(_,_),1,'Tea Boiler: status Off',[]).
explainer(action_toaster_on(_,_),1,'Turning on the Toaster',[]).
explainer(action_toaster_off(_,_),1,'Turning off the Toaster',[]).
explainer(toaster_choice_on(_,_),1,'Toaster: status On',[]).
explainer(toaster_choice_off(_,_),1,'Toaster: status Off',[]).
explainer(action_cooker_on(_,_),1,'Turning on the Cooker',[]).
explainer(action_cooker_off(_,_),1,'Turning off the Cooker',[]).
explainer(cooker_choice_on(_,_),1,'Cooker: status On',[]).
explainer(cooker_choice_off(_,_),1,'Cooker: status Off',[]).
explainer(action_oven_on(_,_),1,'Turning on the Oven',[]).
explainer(action_oven_off(_,_),1,'Turning off the Oven',[]).
explainer(oven_choice_on(_,_),1,'Oven: status On',[]).
explainer(oven_choice_off(_,_),1,'Oven: status Off',[]).
explainer(action_microwave_oven_defrost(_,_),1,'Turning defrost the Microwave Oven.',[]).
explainer(action_microwave_oven_heat(_,_),1,'Turning heat the Microwave Oven.',[]).
explainer(action_microwave_oven_off(_,_),1,'Turning off the Microwave Oven.',[]).
explainer(microwave_oven_choice_defrost(_,_),1,'Microwave Oven: status Defrost.',[]).
explainer(microwave_oven_choice_heat(_,_),1,'Microwave Oven: status Heat.',[]).
explainer(microwave_oven_choice_off(_,_),1,'Microwave Oven: status Off.',[]).
explainer(action_television_on(_,_),1,'Turning on the Television.',[]).
explainer(action_television_off(_,_),1,'Turning off the Television.',[]).
explainer(television_choice_on(_,_),1,'Television: status On.',[]).
explainer(television_choice_off(_,_),1,'Television: status Off.',[]).
explainer(action_radio_on(_,_),1,'Turning on the Radio.',[]).
explainer(action_radio_off(_,_),1,'Turning off the Radio.',[]).
explainer(radio_choice_on(_,_),1,'Radio: status On.',[]).
explainer(radio_choice_off(_,_),1,'Radio: status Off.',[]).

explainer(mult_G(G),0,'Radio: status Off.',[G]).
explainer(numero(G),0,'Radio_1: status Off.',[G]).
explainer(numero1(G),0,'Radio_2: status Off.',[G]).
explainer(testa(_X),1,'La testa.',[]).
explainer(corpo(_X),0,'il corpo.',[]).

%explain persona

explainer(sorriso(_TIMESTAMP,Persona,Stato),1,Persona+ 'ha un sorriso di '+Stato,[]).
explainer(felice(_,Persona),1,Persona+ 'Ë felice',[]).
explainer(persona(Persona),1,Persona+ 'Ë una persona',[]).
explainer(ruolo_meeting(_,_,Persona,oratore),1,Persona + ' e\' oratore',[]).
explainer(ruolo_meeting(_,_,Persona,moderatore),1,Persona + ' e\' moderatore',[Persona]).
explainer(ruolo_meeting(_,_,Persona,partecipante),1,Persona + ' e\' partecipante',[Persona]).
explainer(ruolo_meeting(_,_,Persona,staff),1,Persona + ' e\' staff',[Persona]).
explainer(ruolo_meeting(_,_,Persona,verbalizzatore),1,Persona + ' e\' verbalizzatore',[Persona]).
explainer(parla(_,Persona),1,'Sta parlando '+Persona,[]).
explainer(voce(_, Persona, bassa),1,Persona +' ha la voce bassa',[]).
explainer(voce(_, Persona, normale),1,Persona +' ha la voce normale',[]).
explainer(voce(_, Persona, alta),1,Persona +' ha la voce alta',[]).
explainer(eta(Persona,Anni),1,Persona+' ha '+Anni+' ',[]).
explainer(bambino(Persona),1,Persona+' Ë un bambino',[]).
explainer(oratore_noioso(Persona),1,'L\'oratore che sta parlando Ë noioso ',[Persona]).
explainer(tono(_, Persona, statico),1,'Il tono di '+Persona+' e\' statico',[]).
explainer(voce(_, Persona, statica),1,'La voce di '+Persona+' e\' statica',[]).
explainer(disgusto(_,Persona),1, 'La persona '+Persona+' e\' disgustata',[]).
explainer(sudato(_,Persona,Val),1, 'La persona '+Persona+' e\' '+Val+' sudata',[]).
explainer(rabbia(_,Persona),1, 'La persona '+Persona+' e\' arrabbiata',[]).
explainer(trema(_,Persona),1, 'La persona '+Persona+' sta tremando',[]).
explainer(mani(_,Persona,Stato),1, 'La persona '+Persona+' ha le mani '+Stato,[]).
explainer(spalle(_,Persona,Stato),1, 'La persona '+Persona+' ha le mani '+Stato,[]).
explainer(persone_tremanti(_, _,Persone,NumPers),1, 'Ci sono '+NumPers+' persone tremanti ',[Persone]).
explainer(prega(_,Persona),1,Persona+' sta pregando ',[]).
explainer(mani(_,Persona,Stato),1,Persona+' ha le mani '+Stato,[]).

%clima
explainer(temperatura(_,Luogo,Valore),1, 'La temperatura nel luogo '+Luogo+' e\' '+Valore+' gradi ',[]).



%explain oggetto microfono
explainer(microfono(IdMicrofono),1,'E\' presente un microfono ',[IdMicrofono]).


%explain proiettore
explainer(proiettore(IdProiettore),1,'E\' presente un proiettore ',[IdProiettore]).


%explain tenda
explainer(tenda(Idtenda),1,'E\' presente una tenda',[Idtenda]).

%explain luce
explainer(luce(IdLuce),1,'E\' presente una luce ',[IdLuce]).

%explain sala
explainer(posti_insufficienti(_TIMESTAMP,Meeting,_Sala),1,'Posti non sufficienti per i partecipanti al Meeting : '+Meeting,[]).

%explain finestra/e
explainer(finestre(_TIMESTAMP,_Meeting,FinestreChiuse,NfinChiuse,chiuse),1,'Ci sono '+NfinChiuse+' finestre chiuse ',[FinestreChiuse]).
explainer(finestre(IdFinestra),1,IdFinestra+' Ë una finestra',[]).

%explain tempo
explainer(is_morning(_),1,'E\' mattina',[]).
explainer(is_night(_),1,'E\' sera',[]).

%stato oggetti
explainer(stato(_TIMESTAMP,Oggetto,Val),1,Oggetto+' Ë '+Val,[]).

%posizione oggetti
explainer(posizione(_,Luogo,Oggetto),1,Oggetto+' si trova in/presso '+Luogo,[]).


%explain meetengo generali

explainer(meeting(Meeting),1,Meeting+' Ë un meeting',[]).
explainer(tipologia(Meeting,Tipo),1,Meeting+' Ë un meeting di tipo '+Tipo,[]).
%explainer(num_partecipanti(Meeting,Num),1,'Al meeting '+Meeting+' partecipano '+Num+' persone',[]).

%explain meetengo - confusione

explainer(confusione_in_sala(_,_),1,'Si avverte confusione',[]).
explainer(chiacchiericcio(_,_,_,_),1,'rilevato chiacchiericcio',[]).
explainer(oratore_assente(_,_),1,'oratore assente',[]).
explainer(meeting_confusionale(_),1,'Meeting confusionale',[]).
explainer(difficolta_comprensione(_,_),1,'Si avverte una difficolta nella comprensione',[]).
explainer(volume_troppo_basso(_,_),1,'Alzare il volume del microfono',[]).
explainer(poca_visibilita_proiettore(_,_,tende,_,_),1,'Le tende aperte non fanno vedere bene il proiettore',[]).
explainer(poca_visibilita_proiettore(_,_,luci,_,_),1,'Le luci accese non fanno vedere bene il proiettore',[]).
explainer(abbassa_volume(_,_,IdMicrofono),1,'Il volume del microfono '+IdMicrofono+' Ë troppo alto',[]).
explainer(chiasso_bambini(_,_Nbambini),1,'Ci sono bambini in sala ',[]).
explainer(tende(_,_,TendeAperte,Ntnde,aperte),1,'Ci sono '+Ntnde+' tende aperte ',[TendeAperte]).
explainer(luci(_,_,LuciAccese,Nluci,accese),1,'Ci sono '+Nluci+' luci accese ',[LuciAccese]).

%explain meetengo - noia
explainer(oratori_non_in_sala(_,_),1,'Non sono presenti oratori in sala',[]).
explainer(pausa_necessaria(_TIMESTAMP,_Meeting,NumInSala,Num),1,'E\' necessaria una pausa in quanto in sala ci sono '+NumInSala+' su '+Num+' persone',[]).

%explain meetengo - disprezzo
explainer(aria_viziata(_, _),1,'Aria viziata in sala',[]).
explainer(disgustati(_, _,_ ,NumPers),1,'Ci sono'+NumPers+' persone disgustate in sala',[]).
explainer(sudati(_, _,_ ,NumPers),1,'Ci sono '+NumPers+' persone sudate in sala',[]).

%explain rabbia
explainer(persone_incomunicabili(_, _,PersoneRabbia,NumRabbia),1,'Si avverte una situazione di incomunicabilita in quanto '+NumRabbia+' persone sono arrabbiate',[PersoneRabbia]).
explainer(persone_malumore(_TIMESTAMP,_Meeting,PersMalum,NumMalum),1,NumMalum+ ' sono di cattivo umore',[PersMalum]).
explainer(persone_arrabbiate(_, _,Perc),1,'Il '+Perc+'% di persone prova rabbia in sala ',[]).

%meetengo disagio 
explainer(freddo_sala(_, _,_,_),1,'C\'e\' freddo in sala ',[]).
explainer(persone_a_disagio(_, _,Perc),1,'Il '+Perc+'% di persone prova disagio in sala ',[]).

explainer(congiunzione_precede_verbo(_Sentence,Cong,Verb),1,'La congiunzione '+Cong+' precede il verbo '+Verb, [] ).
explainer(frase_condizionale_congiuntivo(_Sentence,_Vcond,_Vcong),1,'La frase principale contiene un verbo condizionale, la subordinata un congiuntivo', [] ).
explainer(verbo_precede_cong(_Sentence,Verb,Cong),1,'Il verbo '+Verb+' precede la congiunzione '+Cong, [] ).
explainer(frase_principale_sub(_Sentence,_Cong),1,'Presenza di una subordinata', [] ).
explainer(frase_principale_coord(_Sentence,_TC),1,'Presenza di una coordinata', [] ).

explainer(frase_princ_emotiva(_Sentence,E),1,'La principale contiene lessico emotivo: '+E, [] ).
explainer(frase_coord_emotiva(_Sentence,E),1,'La coordinata contiene lessico emotivo: '+E, [] ).
explainer(frase_sub_emotiva(_Sentence,E),1,'La subordinata contiene lessico emotivo: '+E, [] ).
explainer(neg_emozione_princ(N),1,'Nega lessico emotivo: '+N, [] ).
explainer(componente_princ(_Sentence,Term,P),1,'Polarit� componente della frase principale: '+P+' determinata dal termine: '+Term, [] ).
explainer(precede(N,P),1,'Il componente determinato da '+N+'precede quello determinato da '+P, [] ).
explainer(valuta_frase_princ(_Sentence,P),1,'Polarit� complessiva della principale: '+P, [] ).

%meetengo positivo
explainer(persone_felici(_,_,PersoneFelici,NumFelici),1,'Sono presenti '+NumFelici+' persone felici',[PersoneFelici]).
explainer(persone_sincere(_,_,Persone,Num),1,'Sono presenti '+Num+' persone che dimostrano sincerita\'',[Persone]).
explainer(persone_serene(_TIMESTAMP,_Meeting,Perc),1,'Il '+Perc+'% di persone prova serenita\' in sala ',[]).

explainer(prosodia_emotiva(_Sentence,disgusto),1,'Prosodia emotiva disgusto', [] ).
explainer(prosodia_emotiva(_Sentence,paura),1,'Prosodia emotiva paura', [] ).
explainer(prosodia_emotiva(_Sentence,tristezza),1,'Prosodia emotiva tristezza', [] ).
explainer(prosodia_emotiva(_Sentence,rabbia),1,'Prosodia emotiva rabbia', [] ).
explainer(prosodia_emotiva(_Sentence,sorpresa),1,'Prosodia emotiva sorpresa', [] ).
explainer(prosodia_emotiva(_Sentence,gioia),1,'Prosodia emotiva gioia', [] ).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% EXPLAINER TABLE RECOGNITION %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

explainer(stroke(_N,_N_X0,_N_Y0,_M_X1,_M_Y1),0,'linea input',[]). %rule 10
explainer(stroke_H(_N,_X0,_Y0,_X1,_Y1),1,'linea orizzontale',[]). %rule 40
explainer(stroke_V(_N,_X0,_Y0,_X1,_Y1),1,'linea verticale',[]). %rule 50
explainer(stroke_U(_N,X0,Y0,X1,Y1),0,'linea analizzata: X0:'+ X0+' ,Y0:'+Y0+' ,X1:'+X1+' ,Y1:'+Y1,[]). %rule 50
explainer(table_stroke(_N,_N_X0, _N_Y0, _N_X1, _N_Y1),0,'linea di una tabella',[]).  %rule 60
explainer(table_block(_M,_M_X0,_M_Y0,_M_X1,_M_Y1),0,'blocco di una tabella',[]).  %rule 70
explainer(block(_M,_M_X0,_M_Y0,_M_X1,_M_Y1),0,'blocco input',[]).  %rule 70
explainer(table,1,'è stata creata una tabella',[]).  %rule 80


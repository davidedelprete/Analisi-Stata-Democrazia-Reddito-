version 19.5

*Affinché l'esecuzione del file avvenga senza errori, è necessaria l'installazione, attraverso la scrittura del comando "ssc install _________" nella command line, dei seguenti comandi:
*outreg2;
*spmap. 

*Pulizia della memoria e import del data set:

clear

import excel using IncomeDemocracyTorVergata, sheet("Data") firstrow

*Comunicazione della natura panel del data set al software:

xtset code year

*Risposta al punto b.i. Ottenimento di statistiche descrittive generali sulla variabile dem_ind:

summarize dem_ind, detail

*Risposta al punto b.ii. Statistiche descrittive inerenti gli Stati Uniti:

list dem_ind if country == "United States" & year == 2000
summarize dem_ind if country == "United States"

*Risposta al punto b.iii. Statistiche descrittive inerenti la Libia: 

list dem_ind if country == "Libya" & year == 2000
summarize dem_ind if country == "Libya"

*Risposta al punto b.iv: 

egen avg_dem = mean(dem_ind), by (country)
egen tag = tag(country)

*Cinque paesi con un Democracy Index medio maggiore di 0.95:

preserve 
keep if tag == 1 
keep if avg_dem > 0.95
list country avg_dem in 1/5
restore

*Cinque paesi con un Democracy Index medio minore di 0.10:

preserve
keep if tag == 1
keep if avg_dem < 0.10
list country avg_dem in 1/5
restore

*Cinque paesi con un Democracy Index medio compreso tra 0.3 e 0.7:

preserve
keep if tag == 1
keep if avg_dem >= 0.3
keep if avg_dem <= 0.7
list country avg_dem in 1/5
restore

*Creazione label per una miglior comprensione della tabella finale:

label variable log_gdppc "Log PIL pro capite"
label variable log_pop "Log popolazione"
label variable educ "Anni educazione"
label variable age_1 "%Pop.età 0-14"
label variable age_2 "%Pop.età 15-29"
label variable age_3 "%Pop.età 30-44"
label variable age_4 "%Pop.età 45-59"

*Risposta al punto c. Regressione OLS con clustered standard errors:

reg dem_ind log_gdppc, vce(cluster code)
local fv : display %9.3f e(F)
local pval : display %9.3f e(p)

outreg2 using "regressioni.doc", replace word label keep(log_gdppc) title("L'EFFETTO DELLA RICCHEZZA SULLA RICHIESTA DI DEMOCRAZIA", "{\i Analisi empirica della relazione tra il PIL pro capite e indice di democrazia:}", "{\i Dalle stime OLS ai modelli panel con effetti fissi e controlli socio-demografici}") ctitle("OLS CE") dec(3) ///
    nor2 noobs adds("Osservazioni", e(N), "R^2", e(r2), "R^2 Agg.", e(r2_a)) ///
    addtext(FE Stato, NO, FE Tempo, NO, Clustered SE, SI, Controlli, NO, Test F, "`fv'", "P-value F", "`pval'")


*Risposta al punto c.iii. Regressione OLS senza clustered standard errors:

reg dem_ind log_gdppc, r
local fv : display %9.3f e(F)
local pval : display %9.3f e(p)

outreg2 using "regressioni.doc", append word label keep(log_gdppc) ctitle("OLS SE") dec(3) ///
    nor2 noobs adds("Osservazioni", e(N), "R^2", e(r2), "R^2 Agg.", e(r2_a)) ///
    addtext(FE Stato, NO, FE Tempo, NO, Clustered SE, NO, Controlli, NO, Test F, "`fv'", "P-value F", "`pval'")
	
*Risposta al punto d.ii. Regressione con effetti fissi di paese:

quietly reg dem_ind log_gdppc i.code, vce(cluster code)
local r2_lsdv = e(r2)
local ar2_lsdv = e(r2_a)
xtreg dem_ind log_gdppc, fe vce(cluster code)
local fv : display %9.3f e(F)
local pval : display %9.3f e(p)

outreg2 using "regressioni.doc", append word label keep(log_gdppc) ctitle("FCE") dec(3) ///
    nor2 noobs adds("Osservazioni", e(N), "R^2", `r2_lsdv', "R^2 Agg.", `ar2_lsdv') ///
    addtext(FE Stato, SI, FE Tempo, NO, Clustered SE, SI, Controlli, NO, Test F, "`fv'", "P-value F", "`pval'")


*Risposta al punto d.iii. Regressione con effetti fissi di paese senza Azerbaijan:

quietly reg dem_ind log_gdppc i.code if country != "Azerbaijan", vce(cluster code)
local r2_lsdv = e(r2)
local ar2_lsdv = e(r2_a)
xtreg dem_ind log_gdppc if country != "Azerbaijan", fe vce(cluster code)
local fv : display %9.3f e(F)
local pval : display %9.3f e(p)

outreg2 using "regressioni.doc", append word label keep(log_gdppc) ctitle("FCE/AZ") dec(3) ///
    nor2 noobs adds("Osservazioni", e(N), "R^2", `r2_lsdv', "R^2 Agg.", `ar2_lsdv') ///
    addtext(FE Stato, SI, FE Tempo, NO, Clustered SE, SI, Controlli, NO, Test F, "`fv'", "P-value F", "`pval'")

*Risposta al punto d.v. Regressione con effetti fissi di tempo e di paese:

quietly reg dem_ind log_gdppc i.year i.code, vce(cluster code)
local r2_lsdv = e(r2)
local ar2_lsdv = e(r2_a)
xtreg dem_ind log_gdppc i.year, fe vce(cluster code)
local fv : display %9.3f e(F)
local pval : display %9.3f e(p)

outreg2 using "regressioni.doc", append word label keep(log_gdppc) ctitle("FCTE") dec(3) ///
    nor2 noobs adds("Osservazioni", e(N), "R^2", `r2_lsdv', "R^2 Agg.", `ar2_lsdv') ///
    addtext(FE Stato, SI, FE Tempo, SI, Clustered SE, SI, Controlli, NO, Test F, "`fv'", "P-value F", "`pval'")


*Risposta al punto d.vi. Regressioni con effetti fissi di tempo, paese e variabili demografiche:

*Regressione con age_median:

quietly reg dem_ind log_gdppc log_pop educ age_median i.year i.code, vce(cluster code)
local r2_lsdv = e(r2)
local ar2_lsdv = e(r2_a)
xtreg dem_ind log_gdppc log_pop educ age_median i.year, fe vce(cluster code)
test log_pop educ age_median
local fv : display %9.3f e(F)
local pval : display %9.3f e(p)

outreg2 using "regressioni.doc", append word label keep(log_gdppc log_pop educ age_median) ctitle("FCTE D1") dec(3) ///
    nor2 noobs adds("Osservazioni", e(N), "R^2", `r2_lsdv', "R^2 Agg.", `ar2_lsdv') ///
    addtext(FE Stato, SI, FE Tempo, SI, Clustered SE, SI, Controlli, SI, Test F, "`fv'", "P-value F", "`pval'")
	
*Regressione con age_1, age_2, age_3, age_4:

quietly reg dem_ind log_gdppc log_pop educ age_1 age_2 age_3 age_4 i.year i.code, vce(cluster code)
local r2_lsdv = e(r2)
local ar2_lsdv = e(r2_a)
xtreg dem_ind log_gdppc log_pop educ age_1 age_2 age_3 age_4 i.year, fe vce(cluster code)
test log_pop educ age_1 age_2 age_3 age_4
local fv : display %9.3f e(F)
local pval : display %9.3f e(p)

outreg2 using "regressioni.doc", append word label keep(log_gdppc log_pop educ age_1 age_2 age_3 age_4) ctitle("FCTE D2") dec(3) ///
    nor2 noobs adds("Osservazioni", e(N), "R^2", `r2_lsdv', "R^2 Agg.", `ar2_lsdv') ///
    addtext(FE Stato, SI, FE Tempo, SI, Clustered SE, SI, Controlli, SI, Test F, "`fv'", "P-value F", "`pval'")

*Creazione di una mappa rappresentante la distribuzione del dem_ind a livello globale nell'anno 2000:

*Preparazione file mappa:

spshape2dta ne_110m_admin_0_countries, replace

*Caricamento dati e filtro per anno 2000:

import excel "IncomeDemocracyTorVergata.xlsx", sheet("Data") firstrow clear
keep if year == 2000
drop if missing(dem_ind)

*Armonizzazione nomi per il merge:

rename country NAME
replace NAME = "United States of America" if NAME == "United States of America" | NAME == "United States"
replace NAME = "Dem. Rep. Congo" if NAME == "Congo, Dem. Rep."
replace NAME = "Congo" if NAME == "Congo, Rep."
replace NAME = "Russia" if NAME == "Russian Federation" | NAME == "Russia"
replace NAME = "South Korea" if NAME == "Korea, Rep."
replace NAME = "North Korea" if NAME == "Korea, Dem. Rep."
replace NAME = "Egypt" if NAME == "Egypt, Arab Rep."
replace NAME = "Iran" if NAME == "Iran, Islamic Rep."
replace NAME = "Venezuela" if NAME == "Venezuela, RB"
replace NAME = "Syria" if NAME == "Syrian Arab Republic"
replace NAME = "Laos" if NAME == "Lao PDR"
replace NAME = "Yemen" if NAME == "Yemen, Rep."
replace NAME = "Ivory Coast" if NAME == "Cote d'Ivoire"
replace NAME = "Pakistan" if NAME == "Pakistan-post-1972"
replace NAME = "Ethiopia" if NAME == "Ethiopia 1993-"
replace NAME = "Central African Rep." if NAME == "Central African Republic"
format dem_ind %9.2f

*Unione dei dati con la mappa:

merge 1:1 NAME using ne_110m_admin_0_countries

*Disegno della mappa:

spmap dem_ind using ne_110m_admin_0_countries_shp, id(_ID) fcolor(Greens) clnumber(5) title("Indice di Democrazia - Anno 2000") subtitle("Questa mappa rappresenta la distribuzione dell'indice di democrazia a livello mondiale nell'anno 2000") legend(size(small) position(6))

*Esportazione della mappa e salvataggio:

graph export "mappademocrazia.png", replace

# Democrazia e Reddito

## Obiettivo

Indagare empiricamente se la democrazia e la libertà politica possano essere assimilate a un bene normale nel senso economico del termine, ossia se un aumento del reddito pro capite sia associato a un incremento dell’indice di democrazia.  
L’analisi verifica in particolare se tale relazione permanga dopo aver controllato per differenze strutturali tra paesi e per fattori comuni che variano nel tempo.

## Strumenti e Metodologia

Le stime sono condotte con il software Stata su un pannello di osservazioni riferite a circa 195 paesi e a un orizzonte temporale di circa quaranta anni, con rilevazioni a intervalli quinquennali (campione non bilanciato, tratto dal dataset "Income_Democracy"). Si stimano modelli OLS in forma linear-log (variabile dipendente: indice di democrazia; variabile principale: logaritmo del PIL pro capite), con errori standard robusti clusterizzati a livello di paese al fine di tenere conto della correlazione seriale all’interno delle unità cross-sectional. Si procede quindi all’introduzione progressiva di effetti fissi di Stato e di effetti fissi temporali, nonché di regressori socio-demografici aggiuntivi (popolazione, istruzione, struttura per età), come illustrato nel documento di progetto.

## Evidenze Empiriche

- Nelle regressioni iniziali priva di effetti fissi, il coefficiente del logaritmo del PIL pro capite risulta positivo e statisticamente significativo; l’entità dell’effetto economico sul valore dell’indice di democrazia resta tuttavia limitata rispetto al suo intervallo di variazione tra zero e uno.
- Con l’inclusione degli effetti fissi di Stato il coefficiente si riduce sensibilmente pur restando in parte significativo; aggiungendo anche gli effetti fissi temporali la stima si attenua ulteriormente e non risulta statisticamente distinguibile da zero al livello convenzionale, suggerendo che una quota rilevante della correlazione osservata tra reddito e democrazia rifletta fattori strutturali persistenti e componenti congiunturali comuni.
- L’introduzione dei controlli socio-demografici conferma l’assenza di un ruolo statisticamente netto del PIL pro capite nel sottocampione con informazioni complete: nel complesso, la domanda di libertà politica appare plasmata anche da fattori culturali, istituzionali e di contesto, coerentemente con l’interpretazione proposta nel lavoro originale.

## Report Completo

Per l'analisi metodologica completa, il framework teorico e le tabelle di regressione dettagliate, consultare il file "Analisi_Democrazia_Reddito.pdf" presente in questa repository.

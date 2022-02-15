# Percolation Stats App

Web app to visualize Percolation statistics from the simulator build [here](https://github.com/RiccardoMPesce/Percolation-Theory-Simulation).

## Come usare la web app

### Prerequisiti

Occorre installare __RStudio__ ed aprire questa repository (aprendo la cartella dove questo progetto è stato clonato).

### Fuunzionamento

Aprire il file `app.R` e premere il pulsante in alto a destra __Run App__.
Verrà aperta la web app all'interno di una finestra, ma premendo l'opportuno link è possibile aprire tale web app nel browser.

Aperta l'applicazione, si possono navigare le due pagine principali: __Analysis__ e __Custom Threshold Analysis__. Entrambe le pagine permettono di definire l'indirizzo e la porta della REST API (l'app conoscerà il path dell'API dove ottenere i risultati di simulazione). La prima pagina, __Analysis__, mostra la distribuzione del campione di dati appena ottenuto. E' possibile scegliere la dimensione di percolazione e la dimensione del campione.

__Aumentando la dimensione di uno o dell'altro si incorrono in tempi più lunghi di simulazione e l'app potrebbe congelarsi__.

La seconda pagina, __Custom Threshold Analysis__, ci permette di fissare una soglia di percolazione e simulare la proporzione di campioni in cui il sistema lattice percola. Tale soglia va inserita come numero decimale da 0 ad 1 nel campo custom threshold.

Seguire la sintassi utilizzata nel testo segnaposto per evitare problemi quando si definiscono server e porta.
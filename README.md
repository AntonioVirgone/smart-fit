TODO

1. Cambiare il nome in SFAthlete (SmartFitAthlete)
2. Integrare notifiche push
3. Integrare api attivazione utente con codice
4. Modificare la home perchè nella prossime versioni l'atleta potrà avere più schede workout attive. Quindi va trovato un modo per mostrare il workout attivo (o l'ultimo associato) e mostrare anche gli altri.
5. Aggiungere una view per mostrare il piano alimentare (funzionalità da implementare da zero come nuova evolutiva)

## Struttura del progetto

- `SmartFit/App`: entry point dell'app (SwiftUI App + AppDelegate).
- `SmartFit/Core`: modelli, view model, servizi di rete/locali, manager e utility condivise.
- `SmartFit/Views`: viste organizzate per feature (Authentication, Workout, History, ecc.).
- `SmartFit/Components`: componenti UI riutilizzabili.
- `SmartFit/Resources/Data`: asset JSON caricati localmente (`workoutData*.json`).

## Configurazione API

`ApiService` legge l'endpoint di backend dalla variabile d'ambiente `SMARTFIT_API_BASE_URL`. In assenza della variabile utilizza il valore di default già presente nel codice.

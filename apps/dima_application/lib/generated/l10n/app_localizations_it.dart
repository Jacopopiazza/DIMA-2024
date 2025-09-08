import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Italian (`it`).
class AppLocalizationsIt extends AppLocalizations {
  AppLocalizationsIt([String locale = 'it']) : super(locale);

  @override
  String get settingsTitle => 'Impostazioni';

  @override
  String get proPlanTitle => 'Piano PRO';

  @override
  String get unlockPremiumFeatures => 'Sblocca le funzionalità premium:';

  @override
  String get expertMealPlanningValidation => 'Validazione esperta della pianificazione dei pasti';

  @override
  String get personalNutritionistChat => 'Chat personale con nutrizionista nell\'app';

  @override
  String get subscribeToPro => 'Iscriviti a PRO';

  @override
  String get deleteAccount => 'Elimina Account';

  @override
  String get changePreferences => 'Modifica Preferenze';

  @override
  String get clearCache => 'Svuota Cache';

  @override
  String get confirmClearCacheTitle => 'Conferma Svuotamento Cache';

  @override
  String get confirmClearCacheMessage => 'Sei sicuro di voler eliminare tutti i dati memorizzati localmente nella cache? Potrebbe essere necessario scaricare nuovamente i piani alimentari e altre informazioni.';

  @override
  String get clear => 'Svuota';

  @override
  String get cancel => 'Annulla';

  @override
  String get cacheClearedSuccessfully => 'Cache svuotata con successo.';

  @override
  String get errorClearingCache => 'Errore durante lo svuotamento della cache.';

  @override
  String get confirmSignOutTitle => 'Conferma Uscita';

  @override
  String get confirmSignOutMessage => 'Sei sicuro di voler uscire?';

  @override
  String get confirmDeleteAccountTitle => 'Conferma Eliminazione Account';

  @override
  String get confirmDeleteAccountMessage => 'ATTENZIONE: Questa azione è irreversibile ed eliminerà permanentemente il tuo account e tutti i dati associati. Sei assolutamente sicuro di voler procedere?';

  @override
  String get accountDeletedSuccessfully => 'Account eliminato con successo';

  @override
  String get errorDeletingAccount => 'Errore durante l\'eliminazione dell\'account. Riprova.';

  @override
  String get errorDeleteAccountRequiresRecentLogin => 'L\'eliminazione dell\'account richiede un accesso recente. Effettua nuovamente l\'accesso.';

  @override
  String get saveChanges => 'Salva Modifiche';

  @override
  String get preferencesSavedSuccess => 'Preferenze salvate con successo.';

  @override
  String get errorSavingPreferences => 'Errore nel salvataggio delle preferenze.';

  @override
  String get errorLoadingPreferences => 'Errore nel caricamento delle preferenze.';

  @override
  String get pleaseCorrectErrors => 'Per favore, correggi gli errori nel modulo.';

  @override
  String get retry => 'Riprova';

  @override
  String get basicInfo => 'Informazioni Base';

  @override
  String get weightKg => 'Peso (kg)';

  @override
  String get heightCm => 'Altezza (cm)';

  @override
  String get targetCalories => 'Calorie Giornaliere Target';

  @override
  String get invalidNumberFormat => 'Inserisci un numero valido.';

  @override
  String get caloriesOutOfRange => 'Le calorie devono essere comprese tra 500 e 10000.';

  @override
  String get dietaryNeeds => 'Esigenze Alimentari';

  @override
  String mealsPerDay(int count) {
    return '$count pasti al giorno';
  }

  @override
  String get dietaryRestrictions => 'Restrizioni dietetiche';

  @override
  String get dietaryRestrictionsHint => 'es. Vegetariano, Vegano, Low-Carb';

  @override
  String get allergies => 'Allergie';

  @override
  String get lifestyle => 'Stile di Vita';

  @override
  String get exerciseFrequency => 'Frequenza Esercizio';

  @override
  String get otherPreferences => 'Altre Preferenze';

  @override
  String get additionalNotes => 'Note Aggiuntive';

  @override
  String get additionalNotesHint => 'Altri gusti, preferenze o obiettivi?';

  @override
  String get appVersion => 'Versione App';

  @override
  String get allergenCELERY => 'Sedano';

  @override
  String get allergenCRUSTACEANS => 'Crostacei';

  @override
  String get allergenEGGS => 'Uova';

  @override
  String get allergenFISH => 'Pesce';

  @override
  String get allergenGLUTEN_CEREALS => 'Cereali contenenti glutine';

  @override
  String get allergenLUPIN => 'Lupini';

  @override
  String get allergenMILK => 'Latte';

  @override
  String get allergenMOLLUSCS => 'Molluschi';

  @override
  String get allergenMUSTARD => 'Senape';

  @override
  String get allergenNUTS => 'Frutta a guscio';

  @override
  String get allergenPEANUTS => 'Arachidi';

  @override
  String get allergenSESAME_SEEDS => 'Semi di sesamo';

  @override
  String get allergenSOYBEANS => 'Soia';

  @override
  String get allergenSULPHITES => 'Solfiti';

  @override
  String get exerciseFrequencyEVERY_DAY => 'Ogni giorno';

  @override
  String get exerciseFrequencyFIVE_TIMES_A_WEEK => 'Cinque volte a settimana';

  @override
  String get exerciseFrequencyFOUR_TIMES_A_WEEK => 'Quattro volte a settimana';

  @override
  String get exerciseFrequencyNONE => 'Nessuno';

  @override
  String get exerciseFrequencyNOT_SPECIFIED => 'Non specificato';

  @override
  String get exerciseFrequencyONCE_A_WEEK => 'Una volta a settimana';

  @override
  String get exerciseFrequencySIX_TIMES_A_WEEK => 'Sei volte a settimana';

  @override
  String get exerciseFrequencyTHREE_TIMES_A_WEEK => 'Tre volte a settimana';

  @override
  String get exerciseFrequencyTWICE_A_WEEK => 'Due volte a settimana';

  @override
  String get energy => 'Energia';

  @override
  String get ingredients => 'Ingredienti';

  @override
  String get recipe => 'Ricetta';

  @override
  String get noRecipe => 'Ricetta non disponibile';

  @override
  String get mealCompleted => 'Già mangiato';

  @override
  String get mealToBeCompleted => 'Segna come mangiato';

  @override
  String get back => 'Indietro';

  @override
  String get today => 'Oggi';

  @override
  String get mealPlans => 'Piani Pasto';

  @override
  String get settings => 'Impostazioni';

  @override
  String get profileInfoNotAvailable => 'Informazioni profilo non disponibili';

  @override
  String get notSpecified => 'Non specificato';

  @override
  String get noExercise => 'Nessun esercizio';

  @override
  String get onceWeek => 'Una volta a settimana';

  @override
  String get twiceWeek => 'Due volte a settimana';

  @override
  String get threeTimes => '3 volte a settimana';

  @override
  String get fourTimes => '4 volte a settimana';

  @override
  String get fiveTimes => '5 volte a settimana';

  @override
  String get sixTimes => '6 volte a settimana';

  @override
  String get everyDay => 'Ogni giorno';

  @override
  String get weightRange => 'Il peso deve essere tra 30 e 300 kg';

  @override
  String get heightRange => 'L\'altezza deve essere tra 50 e 250 cm';

  @override
  String get completeProfileFirst => 'Completa Prima il Profilo';

  @override
  String get mealPlanGenStarted => 'Generazione piano alimentare avviata! Riceverai una notifica quando sarà pronto.';

  @override
  String get failedToStartGeneration => 'Impossibile avviare la generazione del piano alimentare';

  @override
  String get createMealPlan => 'Crea Piano Alimentare';

  @override
  String get loadingPreferences => 'Caricamento preferenze...';

  @override
  String get somethingWentWrong => 'Qualcosa è andato storto';

  @override
  String get unableToLoadPreferences => 'Impossibile caricare le tue preferenze';

  @override
  String get personalizedMealPlan => 'Piano Alimentare Personalizzato';

  @override
  String get personalizedDescription => 'Creeremo un piano alimentare settimanale personalizzato basato sulle tue preferenze, esigenze dietetiche e stile di vita.';

  @override
  String get profileIncomplete => 'Profilo Incompleto';

  @override
  String get completeProfile => 'Completa Profilo';

  @override
  String get completeProfileMustDo => 'Devi completare il tuo profilo prima di generare un piano alimentare';

  @override
  String get noProfileDetailsFound => 'Nessun Dettaglio Profilo Trovato';

  @override
  String get noProfileDescription => 'Per il piano alimentare più personalizzato, configura il tuo profilo con peso, altezza, preferenze dietetiche e allergie.';

  @override
  String get orContinueDefault => 'O continua con le preferenze predefinite qui sotto';

  @override
  String get profileDetailsFound => 'Dettagli Profilo Trovati';

  @override
  String get customPreferences => 'Preferenze Personalizzate';

  @override
  String get usingCustomPreferences => 'Usando preferenze personalizzate per questo piano alimentare';

  @override
  String get usingProfilePreferences => 'Usando le preferenze del tuo profilo';

  @override
  String get physicalDetails => 'Dettagli Fisici';

  @override
  String get weight => 'Peso';

  @override
  String get weightHelper => 'Consentito: 30–300 kg';

  @override
  String get height => 'Altezza';

  @override
  String get heightHelper => 'Consentito: 50–250 cm';

  @override
  String get mealPreferences => 'Preferenze Pasti';

  @override
  String get dailyMeals => 'Pasti Giornalieri';

  @override
  String get dietaryInformation => 'Informazioni Dietetiche';

  @override
  String get additionalPreferences => 'Preferenze Aggiuntive';

  @override
  String get additionalPreferencesHint => 'Altre preferenze o requisiti alimentari';

  @override
  String get creatingMealPlan => 'Creazione Piano Alimentare...';

  @override
  String get generateCustomPreferences => 'Genera con Preferenze Personalizzate';

  @override
  String mealsDropdown(int count) {
    return '$count pasti';
  }

  @override
  String get generatePersonalizedPlan => 'Genera Piano Personalizzato';

  @override
  String get selectAllergies => 'Seleziona eventuali allergie che hai:';

  @override
  String get helloWorld => 'Ciao Mondo!';

  @override
  String get signedIn => 'Loggato!';

  @override
  String get userRole => 'Utente';

  @override
  String get nutritionistRole => 'Nutrizionista';

  @override
  String get signUpDropdownText => 'Registrati come';

  @override
  String get socialSignUpNotice => 'La registrazione con un account social crea automaticamente un account utente normale. I nutrizionisti devono prima registrarsi con l\'email. Se un utente successivamente accede con un account social collegato alla stessa email, gli account verranno uniti automaticamente.';

  @override
  String get maleGender => 'Maschio';

  @override
  String get femaleGender => 'Femmina';

  @override
  String get otherGender => 'Altro';

  @override
  String get newMealPlanAvailable => 'Nuovo piano alimentare disponibile!';

  @override
  String get mealPlanGenerationFailed => 'Generazione piano alimentare fallita: ';

  @override
  String get unknownError => 'Errore sconosciuto';

  @override
  String get loadingYourMealPlans => 'Caricamento dei tuoi piani alimentari...';

  @override
  String get newPlan => 'Nuovo Piano';

  @override
  String get noMealPlansYet => 'Nessun Piano Alimentare';

  @override
  String get createFirstMealPlan => 'Crea il tuo primo piano alimentare personalizzato\nper iniziare un\'alimentazione sana';

  @override
  String get pullDownToRefresh => 'Trascina in basso per aggiornare';

  @override
  String get connectionProblem => 'Problema di Connessione';

  @override
  String get unableToLoadPlansWithConnection => 'Impossibile caricare i tuoi piani alimentari.\nControlla la connessione internet e riprova.';

  @override
  String get unableToLoadPlans => 'Impossibile caricare i tuoi piani alimentari';

  @override
  String get tryAgain => 'Riprova';

  @override
  String get active => 'ATTIVO';

  @override
  String get setActive => 'Imposta Attivo';

  @override
  String get delete => 'Elimina';

  @override
  String get generating => 'Generazione';

  @override
  String get failed => 'Fallito';

  @override
  String get validated => 'Convalidato';

  @override
  String get pendingValidation => 'In Attesa di Convalida';

  @override
  String get rejected => 'Respinto';

  @override
  String get notValidated => 'Non convalidato';

  @override
  String get pleaseRetryLater => 'Riprova più tardi';

  @override
  String get modelOverloadedMessage => 'Il modello è sovraccarico. Richiedi un nuovo piano alimentare più tardi.';

  @override
  String get setActivePlan => 'Imposta Piano Attivo';

  @override
  String makeActivePlanQuestion(Object planName) {
    return 'Rendere \"$planName\" il tuo piano alimentare attivo?';
  }

  @override
  String get deleteMealPlan => 'Elimina Piano Alimentare';

  @override
  String deletePlanConfirmation(Object planName) {
    return 'Sei sicuro di voler eliminare \"$planName\"?';
  }

  @override
  String get unnamedPlan => 'Piano Senza Nome';

  @override
  String planId(Object planId) {
    return 'ID Piano: $planId';
  }

  @override
  String get viewPlan => 'Visualizza Piano';

  @override
  String get editName => 'Modifica Nome';

  @override
  String get requestValidation => 'Richiedi Convalida';

  @override
  String get seeDetailedMealPlan => 'Visualizza piano alimentare dettagliato';

  @override
  String get changePlanName => 'Cambia il nome del piano';

  @override
  String get getNutritionistApproval => 'Ottieni approvazione nutrizionista';

  @override
  String get proFeature => 'Funzione Pro';

  @override
  String get pro => 'PRO';

  @override
  String get activeMealPlanUpdated => 'Piano alimentare attivo aggiornato!';

  @override
  String get failedToSetActiveMealPlan => 'Impossibile impostare piano alimentare attivo';

  @override
  String get mealPlanDeletedSuccessfully => 'Piano alimentare eliminato con successo';

  @override
  String get failedToDeleteMealPlan => 'Impossibile eliminare il piano alimentare';

  @override
  String get actionFailed => 'Azione fallita: ';

  @override
  String get modifyPlanName => 'Modifica Nome Piano';

  @override
  String get enterNewPlanName => 'Inserisci nuovo nome piano';

  @override
  String get planNameCannotBeEmpty => 'Il nome del piano non può essere vuoto';

  @override
  String get planNameMinLength => 'Il nome del piano deve essere almeno di 2 caratteri';

  @override
  String get planNameMaxLength => 'Il nome del piano deve essere inferiore a 50 caratteri';

  @override
  String get validName => 'Nome valido';

  @override
  String get save => 'Salva';

  @override
  String get failedToUpdatePlanName => 'Impossibile aggiornare il nome del piano: ';

  @override
  String get requestNutritionistValidation => 'Richiedi Convalida Nutrizionista';

  @override
  String selectNutritionistToReview(Object planName) {
    return 'Seleziona un nutrizionista per rivedere il tuo piano alimentare \"$planName\":';
  }

  @override
  String get errorLoadingNutritionists => 'Errore nel caricamento dei nutrizionisti: ';

  @override
  String get pleaseSelectNutritionist => 'Seleziona un nutrizionista';

  @override
  String get nutritionistNotAvailable => 'Il nutrizionista selezionato non è disponibile per la convalida';

  @override
  String get validationRequestSent => 'Richiesta di convalida inviata con successo!';

  @override
  String get failedToSendValidationRequest => 'Impossibile inviare la richiesta di convalida';

  @override
  String get errorSendingValidationRequest => 'Errore nell\'invio della richiesta di convalida: ';

  @override
  String get available => 'Disponibile';

  @override
  String get unavailable => 'Non disponibile';

  @override
  String get noNutritionistsAvailable => 'Nessun nutrizionista disponibile al momento.';

  @override
  String get requestValidationButton => 'Richiedi Convalida';

  @override
  String get failedToLoadMealPlan => 'Impossibile caricare il piano alimentare: ';

  @override
  String get loadingYourMealPlan => 'Caricamento del tuo piano alimentare...';

  @override
  String get connectionProblemView => 'Problema di Connessione';

  @override
  String get oopsSomethingWentWrong => 'Ops! Qualcosa è andato storto';

  @override
  String get checkInternetConnection => 'Controlla la tua connessione internet e riprova. Assicurati di essere connesso al Wi-Fi o ai dati cellulari.';

  @override
  String get encounterErrorLoadingPlan => 'Abbiamo riscontrato un errore nel caricamento del tuo piano alimentare. Potrebbe essere un problema temporaneo.';

  @override
  String get reconnect => 'Riconnetti';

  @override
  String get mealPlanNotFound => 'Piano Alimentare Non Trovato';

  @override
  String get mealPlanMightDeleted => 'Questo piano alimentare potrebbe essere stato eliminato o non è più disponibile. Prova ad aggiornare o torna indietro per selezionare un altro piano.';

  @override
  String get planInformation => 'Informazioni Piano';

  @override
  String get viewPlanDetails => 'Visualizza dettagli piano';

  @override
  String get planName => 'Nome Piano';

  @override
  String get planIdLabel => 'ID Piano';

  @override
  String get generated => 'Generato';

  @override
  String get status => 'Stato';

  @override
  String get validation => 'Convalida';

  @override
  String get nutritionist => 'Nutrizionista';

  @override
  String get user => 'Utente';

  @override
  String get errorDetails => 'Dettagli Errore';

  @override
  String get weeklyMealPlan => 'Piano Alimentare Settimanale';

  @override
  String get noMealPlanDataAvailable => 'Nessun dato del piano alimentare disponibile';

  @override
  String get sevenDayMealScheduleReadOnly => 'Piano alimentare di 7 giorni';

  @override
  String mealsCount(int count) {
    return '$count pasti';
  }

  @override
  String get noDailyPlanData => 'Nessun dato di piano giornaliero trovato per questo piano alimentare.';

  @override
  String get monday => 'Lunedì';

  @override
  String get tuesday => 'Martedì';

  @override
  String get wednesday => 'Mercoledì';

  @override
  String get thursday => 'Giovedì';

  @override
  String get friday => 'Venerdì';

  @override
  String get saturday => 'Sabato';

  @override
  String get sunday => 'Domenica';

  @override
  String get noMealsScheduled => 'Nessun pasto programmato per questo giorno';

  @override
  String get unnamedMeal => 'Pasto senza nome';

  @override
  String get recipeName => 'Nome Ricetta';

  @override
  String get instructions => 'Istruzioni';

  @override
  String get nutritionInformation => 'Informazioni Nutrizionali';

  @override
  String get calories => 'Calorie';

  @override
  String get protein => 'Proteine';

  @override
  String get carbs => 'Carboidrati';

  @override
  String get fat => 'Grassi';

  @override
  String get chatWithNutritionist => 'Chatta con il Nutrizionista';

  @override
  String get showLess => 'Mostra meno';

  @override
  String get readMore => 'Leggi di più';

  @override
  String get statusActive => 'Attivo';

  @override
  String get statusGenerated => 'Generato';

  @override
  String get statusArchived => 'Archiviato';

  @override
  String get statusFailed => 'Fallito';

  @override
  String get statusInProgress => 'In Corso';

  @override
  String get statusPending => 'In Attesa';

  @override
  String get statusUnknown => 'Sconosciuto';

  @override
  String get validationValidated => 'Convalidato';

  @override
  String get validationPendingReview => 'In Revisione';

  @override
  String get validationRejected => 'Respinto';

  @override
  String get validationNotValidated => 'Non Convalidato';

  @override
  String get yesterday => 'Ieri';

  @override
  String get typeYourMessage => 'Scrivi il tuo messaggio...';

  @override
  String get patient => 'Paziente';

  @override
  String get upgrade => 'Aggiorna';

  @override
  String get failedToLoadOlderMessages => 'Impossibile caricare messaggi precedenti: ';

  @override
  String get loading => 'Caricamento...';

  @override
  String get error => 'Errore';

  @override
  String get message => 'Messaggio...';

  @override
  String get pullDownToLoadOlder => 'Trascina in basso per caricare messaggi precedenti';

  @override
  String get loadingMessages => 'Caricamento messaggi...';

  @override
  String get failedToLoadChat => 'Impossibile caricare la chat';

  @override
  String get startTheConversation => 'Inizia la conversazione';

  @override
  String get sendMessageToBegin => 'Invia un messaggio per iniziare a chattare.';

  @override
  String messagesCount(int count) {
    return '$count messaggi';
  }

  @override
  String isTyping(String name) {
    return '$name sta scrivendo...';
  }

  @override
  String get upgradeToPro => 'Aggiorna a PRO';

  @override
  String get chooseYourProPlan => 'Scegli il tuo piano PRO:';

  @override
  String get monthly => 'Mensile';

  @override
  String get yearly => 'Annuale';

  @override
  String get lifetime => 'A vita';

  @override
  String get monthlyPrice => '9,99€/mese';

  @override
  String get yearlyPrice => '99€/anno';

  @override
  String get lifetimePrice => '299€';

  @override
  String get monthlyDescription => 'Ideale per provare';

  @override
  String get yearlyDescription => 'Risparmia il 17% (2 mesi gratis)';

  @override
  String get lifetimeDescription => 'Pagamento unico';

  @override
  String get subscribe => 'Iscriviti';

  @override
  String get subscriptionFeatureComingSoon => 'Funzionalità di abbonamento presto disponibile!';

  @override
  String get confirmDelete => 'Conferma Eliminazione';

  @override
  String get confirmDeleteMessage => 'Sei sicuro di voler eliminare il tuo account?';

  @override
  String get mealNameBREAKFAST => 'Colazione';

  @override
  String get mealNameDINNER => 'Cena';

  @override
  String get mealNameLUNCH => 'Pranzo';

  @override
  String get mealNameSNACK_MORNING => 'Snack (Mattina)';

  @override
  String get mealNameSNACK_AFTERNOON => 'Snack (Pomeriggio)';

  @override
  String get mealNameSNACK_EVENING => 'Snack (Dopo cena)';

  @override
  String get todayProgress => 'Progressi di oggi';

  @override
  String get fats => 'Grassi';

  @override
  String get proteins => 'Proteine';

  @override
  String get todaysMeals => 'Ricette odierne';

  @override
  String get showingStaleData => 'Mostrando dati obsoleti.';

  @override
  String get networkUnavailableCachedData => 'Rete non disponibile. Mostrando dati memorizzati.';

  @override
  String get refreshFailedPreviousData => 'Aggiornamento fallito. Mostrando dati precedenti.';

  @override
  String get failedToLoadDataCheckConnection => 'Caricamento dati fallito. Controlla la connessione.';

  @override
  String get refreshFailedNoMealsScheduled => 'Aggiornamento fallito. Nessun pasto programmato.';

  @override
  String get errorMealDataMissing => 'Errore: Dati del pasto mancanti.';

  @override
  String get noMealsForToday => 'Nessun Pasto Per Oggi';

  @override
  String currentMealPlanNoMealsScheduled(String dayName) {
    return 'Il tuo piano alimentare attuale non ha pasti programmati per $dayName.';
  }

  @override
  String get refreshNow => 'Aggiorna Ora';

  @override
  String get failedToLoadData => 'Caricamento Dati Fallito';

  @override
  String get retryAction => 'Riprova';

  @override
  String get mealPlanReady => 'Piano Alimentare Pronto!';

  @override
  String get generationFailed => 'Generazione Fallita';

  @override
  String get mealPlanReadyDescription => 'Il tuo piano alimentare è pronto!';

  @override
  String get generationFailedDescription => 'C\'è stato un errore nella generazione del tuo piano alimentare. Riprova più tardi.';

  @override
  String get loadingSettings => 'Caricamento impostazioni...';

  @override
  String get unableToLoadSettings => 'Impossibile caricare le impostazioni';

  @override
  String get notSignedIn => 'Non autenticato';

  @override
  String get pleaseSignInToAccessSettings => 'Effettua l\'accesso per accedere alle tue impostazioni';

  @override
  String get signIn => 'Accedi';

  @override
  String get accountSettings => 'Impostazioni Account';

  @override
  String get manageYourProfilePreferencesAndSecurity => 'Gestisci il tuo profilo, le preferenze e le impostazioni di sicurezza dell\'account.';

  @override
  String get loadingSubscription => 'Caricamento abbonamento...';

  @override
  String get loadingProfile => 'Caricamento profilo...';

  @override
  String get profileUnavailable => 'Profilo Non Disponibile';

  @override
  String get personalDataCurrentlyUnavailable => 'I dati personali sono attualmente non disponibili. Prova ad aggiornare o riprova più tardi.';

  @override
  String get preferencesUnavailable => 'Preferenze Non Disponibili';

  @override
  String get preferencesDataCurrentlyUnavailable => 'Le tue preferenze e i dati delle impostazioni sono attualmente non disponibili. Prova ad aggiornare o riprova più tardi.';

  @override
  String get subscriptionStatusUnavailable => 'Stato Abbonamento Non Disponibile';

  @override
  String get subscriptionStatusCurrentlyUnavailable => 'Il tuo stato dell\'abbonamento è attualmente non disponibile. Prova ad aggiornare o riprova più tardi.';

  @override
  String get userProfile => 'Profilo Utente';

  @override
  String get unsaved => 'Non salvato';

  @override
  String get givenName => 'Nome';

  @override
  String get familyName => 'Cognome';

  @override
  String get givenNameRequired => 'Il nome è obbligatorio';

  @override
  String get familyNameRequired => 'Il cognome è obbligatorio';

  @override
  String get nameFieldsReadOnly => 'I campi del nome sono gestiti dal tuo provider di autenticazione e non possono essere modificati qui.';

  @override
  String get gender => 'Sesso';

  @override
  String get male => 'Maschio';

  @override
  String get female => 'Femmina';

  @override
  String get other => 'Altro';

  @override
  String get birthdate => 'Data di nascita';

  @override
  String get selectDate => 'Seleziona data';

  @override
  String get saving => 'Salvataggio...';

  @override
  String get profileUpdatedSuccessfully => 'Profilo aggiornato con successo!';

  @override
  String get failedToUpdateProfile => 'Impossibile aggiornare il profilo. Riprova.';

  @override
  String get errorUpdatingProfile => 'Errore nell\'aggiornamento del profilo';

  @override
  String get generationPreferences => 'Preferenze di Generazione';

  @override
  String get weightAllowed => 'Consentito: 30–300 kg';

  @override
  String get weightMustBeBetween => 'Il peso deve essere tra 30 e 300 kg';

  @override
  String get heightAllowed => 'Consentito: 50–250 cm';

  @override
  String get heightMustBeBetween => 'L\'altezza deve essere tra 50 e 250 cm';

  @override
  String get onceAWeek => 'Una volta a settimana';

  @override
  String get twiceAWeek => 'Due volte a settimana';

  @override
  String get anySpecificDietaryRestriction => 'Qualsiasi restrizione dietetica specifica';

  @override
  String get dietaryPreferences => 'Preferenze dietetiche';

  @override
  String get anySpecificDietaryPreference => 'Qualsiasi preferenza dietetica specifica o note';

  @override
  String get weightIsRequired => 'Il peso è obbligatorio';

  @override
  String get heightIsRequired => 'L\'altezza è obbligatoria';

  @override
  String get pleaseEnterValidWeight => 'Inserisci un peso valido';

  @override
  String get pleaseEnterValidHeight => 'Inserisci un\'altezza valida';

  @override
  String get profileUpdatedSuccessfullyShort => 'Profilo aggiornato con successo';

  @override
  String get failedToUpdateProfileShort => 'Impossibile aggiornare il profilo';

  @override
  String get changePassword => 'Cambia Password';

  @override
  String get updateYourAccountPassword => 'Aggiorna la password del tuo account';

  @override
  String get currentPassword => 'Password Attuale';

  @override
  String get pleaseEnterCurrentPassword => 'Inserisci la tua password attuale';

  @override
  String get newPassword => 'Nuova Password';

  @override
  String get pleaseEnterNewPassword => 'Inserisci una nuova password';

  @override
  String get passwordMustBeAtLeast8Characters => 'La password deve essere di almeno 8 caratteri';

  @override
  String get passwordMustContainUppercase => 'La password deve contenere maiuscole, minuscole e numeri';

  @override
  String get confirmNewPassword => 'Conferma Nuova Password';

  @override
  String get pleaseConfirmNewPassword => 'Conferma la tua nuova password';

  @override
  String get passwordsDoNotMatch => 'Le password non corrispondono';

  @override
  String get passwordRequirements => 'Requisiti Password:';

  @override
  String get atLeast8Characters => 'Almeno 8 caratteri';

  @override
  String get uppercaseLetter => 'Lettera maiuscola (A-Z)';

  @override
  String get lowercaseLetter => 'Lettera minuscola (a-z)';

  @override
  String get number => 'Numero (0-9)';

  @override
  String get changingPassword => 'Cambiando Password...';

  @override
  String get changePasswordButton => 'Cambia Password';

  @override
  String get passwordChangedSuccessfully => 'Password cambiata con successo';

  @override
  String get failedToChangePassword => 'Impossibile cambiare la password';

  @override
  String get tooShort => 'Troppo corta';

  @override
  String get weak => 'Debole';

  @override
  String get fair => 'Discreta';

  @override
  String get good => 'Buona';

  @override
  String get strong => 'Forte';

  @override
  String get proPlan => 'Piano PRO';

  @override
  String get activeSubscription => 'Abbonamento attivo';

  @override
  String get upgradeToUnlockPremiumFeatures => 'Aggiorna per sbloccare le funzionalità premium';

  @override
  String currentStatus(Object status) {
    return 'Stato Attuale: $status';
  }

  @override
  String get youHaveAccessTo => 'Hai accesso a:';

  @override
  String get personalNutritionistChatInApp => 'Chat personale con nutrizionista nell\'app';

  @override
  String get unsubscribeFromPro => 'Cancella Abbonamento PRO';

  @override
  String get successfullySubscribedToPro => 'Iscritto con successo a PRO!';

  @override
  String get failedToSubscribe => 'Impossibile iscriversi. Riprova.';

  @override
  String get errorSubscribing => 'Errore durante l\'iscrizione';

  @override
  String get successfullyUnsubscribedToFree => 'Cancellato con successo e tornato a GRATUITO!';

  @override
  String get failedToUnsubscribe => 'Impossibile cancellare l\'abbonamento. Riprova.';

  @override
  String get errorUnsubscribing => 'Errore durante la cancellazione';

  @override
  String get quickActions => 'Azioni Rapide';

  @override
  String get refreshData => 'Aggiorna Dati';

  @override
  String get clearCacheAndReload => 'Svuota cache e ricarica le tue informazioni';

  @override
  String get signOut => 'Disconnetti';

  @override
  String get signOutOfYourAccount => 'Disconnetti dal tuo account';

  @override
  String get dataRefreshedSuccessfully => 'Dati aggiornati con successo';

  @override
  String get areYouSureSignOut => 'Sei sicuro di voler disconnetterti dal tuo account?';

  @override
  String get dangerZone => 'Zona Pericolosa';

  @override
  String get irreversibleAndDestructiveActions => 'Azioni irreversibili e distruttive';

  @override
  String get criticalWarning => 'Avviso Critico';

  @override
  String get actionsArePermanent => 'Le azioni qui sotto sono permanenti e non possono essere annullate. Tutti i tuoi dati, inclusi piani pasto, preferenze e informazioni dell\'account verranno eliminati definitivamente.';

  @override
  String get deletingAccount => 'Eliminazione Account...';

  @override
  String get deleteMyAccount => 'Elimina Il Mio Account';

  @override
  String get thisActionWillPermanentlyDelete => 'Questa azione eliminerà permanentemente il tuo account e tutti i dati associati. Questa operazione non può essere annullata.';

  @override
  String get allYourMealPlansWillBeRemoved => 'Tutti i tuoi piani pasto, preferenze e dati personali verranno rimossi definitivamente.';

  @override
  String get failedToDeleteAccount => 'Impossibile eliminare l\'account';

  @override
  String get signUp => 'Crea account';

  @override
  String get confirm => 'Conferma';

  @override
  String get continueLabel => 'Continua';

  @override
  String get submit => 'Invia';

  @override
  String get sendCode => 'Invia codice';

  @override
  String get lostCode => 'Hai perso il codice?';

  @override
  String get noAccount => 'Non hai un account?';

  @override
  String get haveAccount => 'Hai già un account?';

  @override
  String get forgotPassword => 'Hai dimenticato la password?';

  @override
  String get confirmResetPassword => 'Reimposta password';

  @override
  String get verify => 'Verifica';

  @override
  String get skip => 'Salta';

  @override
  String get copyKey => 'Copia chiave';

  @override
  String backTo(String previousStep) {
    String _temp0 = intl.Intl.selectLogic(
      previousStep,
      {
        'signUp': 'Registrati',
        'signIn': 'Accedi',
        'confirmSignUp': 'Conferma registrazione',
        'confirmSignInMfa': 'Conferma accesso',
        'confirmSignInNewPassword': 'Conferma accesso',
        'sendCode': 'Invia codice',
        'resetPassword': 'Reimposta password',
        'verifyUser': 'Verifica utente',
        'confirmVerifyUser': 'Conferma verifica utente',
        'other': 'ERRORE',
      },
    );
    return 'Torna a $_temp0';
  }

  @override
  String signInWith(String provider) {
    String _temp0 = intl.Intl.selectLogic(
      provider,
      {
        'google': 'Google',
        'facebook': 'Facebook',
        'amazon': 'Amazon',
        'apple': 'Apple',
        'other': 'ERRORE',
      },
    );
    return 'Accedi con $_temp0';
  }

  @override
  String get selectDialCode => 'Seleziona il prefisso telefonico del tuo paese';

  @override
  String get noDialCodeSearchResults => 'Nessun risultato di ricerca corrisponde ai tuoi criteri';

  @override
  String get af => 'Afghanistan';

  @override
  String get ax => 'Isole Åland';

  @override
  String get al => 'Albania';

  @override
  String get dz => 'Algeria';

  @override
  String get as1 => 'Samoa Americane';

  @override
  String get ad => 'Andorra';

  @override
  String get ao => 'Angola';

  @override
  String get ai => 'Anguilla';

  @override
  String get aq => 'Antartide';

  @override
  String get ag => 'Antigua e Barbuda';

  @override
  String get ar => 'Argentina';

  @override
  String get am => 'Armenia';

  @override
  String get aw => 'Aruba';

  @override
  String get au => 'Australia';

  @override
  String get at => 'Austria';

  @override
  String get az => 'Azerbaigian';

  @override
  String get bs => 'Bahamas';

  @override
  String get bh => 'Bahrain';

  @override
  String get bd => 'Bangladesh';

  @override
  String get bb => 'Barbados';

  @override
  String get by => 'Bielorussia';

  @override
  String get be => 'Belgio';

  @override
  String get bz => 'Belize';

  @override
  String get bj => 'Benin';

  @override
  String get bm => 'Bermuda';

  @override
  String get bt => 'Bhutan';

  @override
  String get bo => 'Bolivia (Stato Plurinazionale di)';

  @override
  String get bq => 'Bonaire, Sint Eustatius e Saba';

  @override
  String get ba => 'Bosnia ed Erzegovina';

  @override
  String get bw => 'Botswana';

  @override
  String get br => 'Brasile';

  @override
  String get io => 'Territorio Britannico dell\'Oceano Indiano';

  @override
  String get bn => 'Brunei';

  @override
  String get bg => 'Bulgaria';

  @override
  String get bf => 'Burkina Faso';

  @override
  String get bi => 'Burundi';

  @override
  String get kh => 'Cambogia';

  @override
  String get cm => 'Camerun';

  @override
  String get ca => 'Canada';

  @override
  String get cv => 'Capo Verde';

  @override
  String get ky => 'Isole Cayman';

  @override
  String get cf => 'Repubblica Centrafricana';

  @override
  String get td => 'Ciad';

  @override
  String get cl => 'Cile';

  @override
  String get cn => 'Cina';

  @override
  String get cx => 'Isola di Natale';

  @override
  String get cc => 'Isole Cocos (Keeling)';

  @override
  String get co => 'Colombia';

  @override
  String get km => 'Comore';

  @override
  String get cg => 'Congo';

  @override
  String get cd => 'Repubblica Democratica del Congo';

  @override
  String get ck => 'Isole Cook';

  @override
  String get cr => 'Costa Rica';

  @override
  String get ci => 'Costa d\'Avorio';

  @override
  String get hr => 'Croazia';

  @override
  String get cu => 'Cuba';

  @override
  String get cy => 'Cipro';

  @override
  String get cz => 'Repubblica Ceca';

  @override
  String get dk => 'Danimarca';

  @override
  String get dj => 'Gibuti';

  @override
  String get dm => 'Dominica';

  @override
  String get do1 => 'Repubblica Dominicana';

  @override
  String get ec => 'Ecuador';

  @override
  String get eg => 'Egitto';

  @override
  String get sv => 'El Salvador';

  @override
  String get gq => 'Guinea Equatoriale';

  @override
  String get er => 'Eritrea';

  @override
  String get ee => 'Estonia';

  @override
  String get sz => 'Eswatini';

  @override
  String get et => 'Etiopia';

  @override
  String get fk => 'Isole Falkland (Malvine)';

  @override
  String get fo => 'Isole Fær Øer';

  @override
  String get fj => 'Fiji';

  @override
  String get fi => 'Finlandia';

  @override
  String get fr => 'Francia';

  @override
  String get gf => 'Guyana Francese';

  @override
  String get pf => 'Polinesia Francese';

  @override
  String get ga => 'Gabon';

  @override
  String get gm => 'Gambia';

  @override
  String get ge => 'Georgia';

  @override
  String get de => 'Germania';

  @override
  String get gh => 'Ghana';

  @override
  String get gi => 'Gibilterra';

  @override
  String get gr => 'Grecia';

  @override
  String get gl => 'Groenlandia';

  @override
  String get gd => 'Grenada';

  @override
  String get gp => 'Guadalupa';

  @override
  String get gu => 'Guam';

  @override
  String get gt => 'Guatemala';

  @override
  String get gg => 'Guernsey';

  @override
  String get gn => 'Guinea';

  @override
  String get gw => 'Guinea-Bissau';

  @override
  String get gy => 'Guyana';

  @override
  String get ht => 'Haiti';

  @override
  String get va => 'Città del Vaticano';

  @override
  String get hn => 'Honduras';

  @override
  String get hk => 'Hong Kong';

  @override
  String get hu => 'Ungheria';

  @override
  String get is1 => 'Islanda';

  @override
  String get in1 => 'India';

  @override
  String get id => 'Indonesia';

  @override
  String get ir => 'Iran';

  @override
  String get iq => 'Iraq';

  @override
  String get ie => 'Irlanda';

  @override
  String get im => 'Isola di Man';

  @override
  String get il => 'Israele';

  @override
  String get it => 'Italia';

  @override
  String get jm => 'Giamaica';

  @override
  String get jp => 'Giappone';

  @override
  String get je => 'Jersey';

  @override
  String get jo => 'Giordania';

  @override
  String get kz => 'Kazakistan';

  @override
  String get ke => 'Kenya';

  @override
  String get ki => 'Kiribati';

  @override
  String get kp => 'Corea del Nord';

  @override
  String get kr => 'Corea del Sud';

  @override
  String get xk => 'Kosovo';

  @override
  String get kw => 'Kuwait';

  @override
  String get kg => 'Kirghizistan';

  @override
  String get la => 'Laos';

  @override
  String get lv => 'Lettonia';

  @override
  String get lb => 'Libano';

  @override
  String get ls => 'Lesotho';

  @override
  String get lr => 'Liberia';

  @override
  String get ly => 'Libia';

  @override
  String get li => 'Liechtenstein';

  @override
  String get lt => 'Lituania';

  @override
  String get lu => 'Lussemburgo';

  @override
  String get mo => 'Macao';

  @override
  String get mk => 'Macedonia del Nord';

  @override
  String get mg => 'Madagascar';

  @override
  String get mw => 'Malawi';

  @override
  String get my => 'Malaysia';

  @override
  String get mv => 'Maldive';

  @override
  String get ml => 'Mali';

  @override
  String get mt => 'Malta';

  @override
  String get mh => 'Isole Marshall';

  @override
  String get mq => 'Martinica';

  @override
  String get mr => 'Mauritania';

  @override
  String get mu => 'Mauritius';

  @override
  String get yt => 'Mayotte';

  @override
  String get mx => 'Messico';

  @override
  String get fm => 'Micronesia';

  @override
  String get md => 'Moldavia';

  @override
  String get mc => 'Monaco';

  @override
  String get mn => 'Mongolia';

  @override
  String get me => 'Montenegro';

  @override
  String get ms => 'Montserrat';

  @override
  String get ma => 'Marocco';

  @override
  String get mz => 'Mozambico';

  @override
  String get mm => 'Myanmar';

  @override
  String get na => 'Namibia';

  @override
  String get nr => 'Nauru';

  @override
  String get np => 'Nepal';

  @override
  String get nl => 'Paesi Bassi';

  @override
  String get nc => 'Nuova Caledonia';

  @override
  String get nz => 'Nuova Zelanda';

  @override
  String get ni => 'Nicaragua';

  @override
  String get ne => 'Niger';

  @override
  String get ng => 'Nigeria';

  @override
  String get nu => 'Niue';

  @override
  String get nf => 'Isola Norfolk';

  @override
  String get mp => 'Isole Marianne Settentrionali';

  @override
  String get no => 'Norvegia';

  @override
  String get om => 'Oman';

  @override
  String get pk => 'Pakistan';

  @override
  String get pw => 'Palau';

  @override
  String get ps => 'Palestina';

  @override
  String get pa => 'Panama';

  @override
  String get pg => 'Papua Nuova Guinea';

  @override
  String get py => 'Paraguay';

  @override
  String get pe => 'Perù';

  @override
  String get ph => 'Filippine';

  @override
  String get pn => 'Pitcairn';

  @override
  String get pl => 'Polonia';

  @override
  String get pt => 'Portogallo';

  @override
  String get pr => 'Porto Rico';

  @override
  String get qa => 'Qatar';

  @override
  String get re => 'Riunione';

  @override
  String get ro => 'Romania';

  @override
  String get ru => 'Russia';

  @override
  String get rw => 'Ruanda';

  @override
  String get bl => 'Saint Barthélemy';

  @override
  String get sh => 'Sant\'Elena, Ascensione e Tristan da Cunha';

  @override
  String get kn => 'Saint Kitts e Nevis';

  @override
  String get lc => 'Saint Lucia';

  @override
  String get mf => 'Saint Martin (parte francese)';

  @override
  String get pm => 'Saint Pierre e Miquelon';

  @override
  String get vc => 'Saint Vincent e Grenadine';

  @override
  String get ws => 'Samoa';

  @override
  String get sm => 'San Marino';

  @override
  String get st => 'São Tomé e Príncipe';

  @override
  String get sa => 'Arabia Saudita';

  @override
  String get sn => 'Senegal';

  @override
  String get rs => 'Serbia';

  @override
  String get sc => 'Seychelles';

  @override
  String get sl => 'Sierra Leone';

  @override
  String get sg => 'Singapore';

  @override
  String get sk => 'Slovacchia';

  @override
  String get si => 'Slovenia';

  @override
  String get sb => 'Isole Salomone';

  @override
  String get so => 'Somalia';

  @override
  String get za => 'Sudafrica';

  @override
  String get gs => 'Georgia del Sud e Isole Sandwich Meridionali';

  @override
  String get ss => 'Sudan del Sud';

  @override
  String get es => 'Spagna';

  @override
  String get lk => 'Sri Lanka';

  @override
  String get sd => 'Sudan';

  @override
  String get sr => 'Suriname';

  @override
  String get sj => 'Svalbard e Jan Mayen';

  @override
  String get se => 'Svezia';

  @override
  String get ch => 'Svizzera';

  @override
  String get sy => 'Siria';

  @override
  String get tw => 'Taiwan';

  @override
  String get tj => 'Tagikistan';

  @override
  String get tz => 'Tanzania';

  @override
  String get th => 'Thailandia';

  @override
  String get tl => 'Timor-Leste';

  @override
  String get tg => 'Togo';

  @override
  String get tk => 'Tokelau';

  @override
  String get to => 'Tonga';

  @override
  String get tt => 'Trinidad e Tobago';

  @override
  String get tn => 'Tunisia';

  @override
  String get tr => 'Turchia';

  @override
  String get tm => 'Turkmenistan';

  @override
  String get tc => 'Isole Turks e Caicos';

  @override
  String get tv => 'Tuvalu';

  @override
  String get ug => 'Uganda';

  @override
  String get ua => 'Ucraina';

  @override
  String get ae => 'Emirati Arabi Uniti';

  @override
  String get gb => 'Regno Unito';

  @override
  String get um => 'Isole Minori degli Stati Uniti';

  @override
  String get us => 'Stati Uniti';

  @override
  String get uy => 'Uruguay';

  @override
  String get uz => 'Uzbekistan';

  @override
  String get vu => 'Vanuatu';

  @override
  String get ve => 'Venezuela';

  @override
  String get vn => 'Vietnam';

  @override
  String get vg => 'Isole Vergini Britanniche';

  @override
  String get vi => 'Isole Vergini Americane';

  @override
  String get wf => 'Wallis e Futuna';

  @override
  String get ye => 'Yemen';

  @override
  String get zm => 'Zambia';

  @override
  String get zw => 'Zimbabwe';

  @override
  String get username => 'Nome utente';

  @override
  String get password => 'Password';

  @override
  String get email => 'Email';

  @override
  String get phoneNumber => 'Numero di Telefono';

  @override
  String get verificationCode => 'Codice di Verifica';

  @override
  String get address => 'Indirizzo';

  @override
  String get middleName => 'Secondo Nome';

  @override
  String genders(String gender) {
    String _temp0 = intl.Intl.selectLogic(
      gender,
      {
        'male': 'maschio',
        'female': 'femmina',
        'other': 'altro',
      },
    );
    return '$_temp0';
  }

  @override
  String get name => 'Nome';

  @override
  String get nickname => 'Soprannome';

  @override
  String or(String a, String b) {
    return '$a o $b';
  }

  @override
  String get preferredUsername => 'Nome Utente Preferito';

  @override
  String warnEmpty(String attribute) {
    return 'Il campo $attribute non può essere vuoto.';
  }

  @override
  String warnInvalidFormat(String attributeType) {
    return 'Formato $attributeType non valido.';
  }

  @override
  String promptFill(String attribute) {
    return 'Inserisci il tuo $attribute';
  }

  @override
  String promptRefill(String attribute) {
    return 'Re-inserisci il tuo $attribute';
  }

  @override
  String confirmAttribute(String attribute) {
    return 'Conferma $attribute';
  }

  @override
  String get usernameRequirements => 'Il nome utente deve contenere solo caratteri alfanumerici e simboli.';

  @override
  String get passwordRequirementsPreamble => 'La password deve includere:';

  @override
  String passwordRequirementsCharacterType(String characterType) {
    String _temp0 = intl.Intl.selectLogic(
      characterType,
      {
        'requiresUppercase': 'maiuscole',
        'requiresLowercase': 'minuscole',
        'requiresNumbers': 'numeri',
        'requiresSymbols': 'simboli',
        'other': '',
      },
    );
    return ' $_temp0';
  }

  @override
  String passwordRequirementsAtLeast(int numCharacters, String characterType) {
    String _temp0 = intl.Intl.pluralLogic(
      numCharacters,
      locale: localeName,
      other: '$numCharacters caratteri $characterType',
      one: '1 carattere $characterType',
    );
    return 'almeno $_temp0';
  }

  @override
  String get rememberDevice => 'Ricorda Dispositivo?';

  @override
  String get usernameType => 'Accedi usando:';

  @override
  String optional(String fieldTitle) {
    return '$fieldTitle (opzionale)';
  }

  @override
  String get customChallenge => 'Codice di Conferma';

  @override
  String get selectSms => 'Messaggio di Testo (SMS)';

  @override
  String get selectTotp => 'App Autenticatore (TOTP)';

  @override
  String get totpCodePrompt => 'Inserisci il codice dalla tua app Autenticatore registrata';

  @override
  String get selectEmail => 'Email';

  @override
  String codeSent(String destination) {
    return 'Un codice di conferma è stato inviato a $destination.';
  }

  @override
  String get codeSentUnknown => 'Un codice di conferma è stato inviato.';

  @override
  String get copySucceeded => 'Copiato negli appunti!';

  @override
  String get copyFailed => 'Copia negli appunti fallita.';

  @override
  String get totpStep1Title => 'Passo 1: Scarica un\'app Autenticatore';

  @override
  String get totpStep2Title => 'Passo 2: Scansiona il codice QR';

  @override
  String get totpStep3Title => 'Passo 3: Verifica il tuo codice';

  @override
  String get totpStep1Body => 'Le app autenticatore generano codici monouso che possono essere utilizzati per verificare la tua identità';

  @override
  String get totpStep2Body => 'Apri l\'app Autenticatore e scansiona il codice QR o inserisci la chiave per ottenere il tuo codice di verifica';

  @override
  String get totpStep3Body => 'Inserisci il codice a 6 cifre dalla tua app Autenticatore';

  @override
  String get confirmSignUp => 'Inserisci il tuo codice di conferma';

  @override
  String get confirmSignInMfa => 'Inserisci il tuo codice di accesso';

  @override
  String get confirmSignInCustomAuth => 'Inserisci il tuo codice di accesso';

  @override
  String get confirmSignInNewPassword => 'Cambia la tua password per accedere';

  @override
  String get continueSignInWithMfaSelection => 'Seleziona il tuo metodo di Autenticazione a Due Fattori preferito';

  @override
  String get continueSignInWithTotpSetup => 'Abilita Autenticazione a Due Fattori';

  @override
  String get confirmSignInWithTotpMfaCode => 'Inserisci il tuo codice monouso';

  @override
  String get resetPassword => 'Invia Codice';

  @override
  String get verifyUser => 'Il recupero dell\'account richiede informazioni di contatto verificate';
}

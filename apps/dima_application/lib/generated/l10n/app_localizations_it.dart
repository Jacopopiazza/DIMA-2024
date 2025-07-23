import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Italian (`it`).
class AppLocalizationsIt extends AppLocalizations {
  AppLocalizationsIt([String locale = 'it']) : super(locale);

  @override
  String get settingsTitle => 'Impostazioni';

  @override
  String get changePreferences => 'Modifica Preferenze';

  @override
  String get clearCache => 'Svuota Cache';

  @override
  String get signOut => 'Esci';

  @override
  String get deleteAccount => 'Elimina Account';

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
  String get accountDeletedSuccessfully => 'Account eliminato con successo.';

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
  String get mealsPerDay => 'Pasti al Giorno';

  @override
  String get dietaryRestrictions => 'Restrizioni Alimentari';

  @override
  String get dietaryRestrictionsHint => 'es. Vegetariano, Vegano, Low-Carb';

  @override
  String get allergies => 'Allergie';

  @override
  String get lifestyle => 'Stile di Vita';

  @override
  String get exerciseFrequency => 'Frequenza Esercizio Fisico';

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
  String get calories => 'Calorie';

  @override
  String get carbs => 'Carboidrati';

  @override
  String get fats => 'Grassi';

  @override
  String get proteins => 'Proteine';

  @override
  String get todaysMeals => 'Ricette odierne';

  @override
  String get signIn => 'Accedi';

  @override
  String get signUp => 'Crea account';

  @override
  String get confirm => 'Conferma';

  @override
  String get continueLabel => 'Continua';

  @override
  String get submit => 'Invia';

  @override
  String get changePassword => 'Cambia password';

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
  String get selectDialCode => 'Select your country dial code';

  @override
  String get noDialCodeSearchResults => 'No search results match your criteria';

  @override
  String get af => 'Afghanistan';

  @override
  String get ax => 'Aland Islands';

  @override
  String get al => 'Albania';

  @override
  String get dz => 'Algeria';

  @override
  String get as1 => 'American Samoa';

  @override
  String get ad => 'Andorra';

  @override
  String get ao => 'Angola';

  @override
  String get ai => 'Anguilla';

  @override
  String get aq => 'Antarctica';

  @override
  String get ag => 'Antigua and Barbuda';

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
  String get az => 'Azerbaijan';

  @override
  String get bs => 'Bahamas';

  @override
  String get bh => 'Bahrain';

  @override
  String get bd => 'Bangladesh';

  @override
  String get bb => 'Barbados';

  @override
  String get by => 'Belarus';

  @override
  String get be => 'Belgium';

  @override
  String get bz => 'Belize';

  @override
  String get bj => 'Benin';

  @override
  String get bm => 'Bermuda';

  @override
  String get bt => 'Bhutan';

  @override
  String get bo => 'Bolivia (Plurinational State of)';

  @override
  String get bq => 'Bonaire, Sint Eustatius and Saba';

  @override
  String get ba => 'Bosnia and Herzegovina';

  @override
  String get bw => 'Botswana';

  @override
  String get br => 'Brazil';

  @override
  String get io => 'British Indian Ocean Territory';

  @override
  String get bn => 'Brunei';

  @override
  String get bg => 'Bulgaria';

  @override
  String get bf => 'Burkina Faso';

  @override
  String get bi => 'Burundi';

  @override
  String get kh => 'Cambodia';

  @override
  String get cm => 'Cameroon';

  @override
  String get ca => 'Canada';

  @override
  String get cv => 'Cape Verde';

  @override
  String get ky => 'Cayman Islands';

  @override
  String get cf => 'Central African Republic';

  @override
  String get td => 'Chad';

  @override
  String get cl => 'Chile';

  @override
  String get cn => 'China';

  @override
  String get cx => 'Christmas Island';

  @override
  String get cc => 'Cocos (Keeling) Islands';

  @override
  String get co => 'Colombia';

  @override
  String get km => 'Comoros';

  @override
  String get cg => 'Congo (Republic of)';

  @override
  String get cd => 'Congo (Democratic Republic of)';

  @override
  String get ck => 'Cook Islands';

  @override
  String get cr => 'Costa Rica';

  @override
  String get ci => 'Côte d\'Ivoire';

  @override
  String get hr => 'Croatia';

  @override
  String get cu => 'Cuba';

  @override
  String get cy => 'Cyprus';

  @override
  String get cz => 'Czech Republic';

  @override
  String get dk => 'Denmark';

  @override
  String get dj => 'Djibouti';

  @override
  String get dm => 'Dominica';

  @override
  String get do1 => 'Dominican Republic';

  @override
  String get ec => 'Ecuador';

  @override
  String get eg => 'Egypt';

  @override
  String get sv => 'El Salvador';

  @override
  String get gq => 'Equatorial Guinea';

  @override
  String get er => 'Eritrea';

  @override
  String get ee => 'Estonia';

  @override
  String get sz => 'Eswatini';

  @override
  String get et => 'Ethiopia';

  @override
  String get fk => 'Falkland Islands (Malvinas)';

  @override
  String get fo => 'Faroe Islands';

  @override
  String get fj => 'Fiji';

  @override
  String get fi => 'Finland';

  @override
  String get fr => 'France';

  @override
  String get gf => 'French Guiana';

  @override
  String get pf => 'French Polynesia';

  @override
  String get ga => 'Gabon';

  @override
  String get gm => 'Gambia';

  @override
  String get ge => 'Georgia';

  @override
  String get de => 'Germany';

  @override
  String get gh => 'Ghana';

  @override
  String get gi => 'Gibraltar';

  @override
  String get gr => 'Greece';

  @override
  String get gl => 'Greenland';

  @override
  String get gd => 'Grenada';

  @override
  String get gp => 'Guadeloupe';

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
  String get va => 'Holy See (Vatican City State)';

  @override
  String get hn => 'Honduras';

  @override
  String get hk => 'Hong Kong';

  @override
  String get hu => 'Hungary';

  @override
  String get is1 => 'Iceland';

  @override
  String get in1 => 'India';

  @override
  String get id => 'Indonesia';

  @override
  String get ir => 'Iran (Islamic Republic of)';

  @override
  String get iq => 'Iraq';

  @override
  String get ie => 'Ireland';

  @override
  String get im => 'Isle of Man';

  @override
  String get il => 'Israel';

  @override
  String get it => 'Italy';

  @override
  String get jm => 'Jamaica';

  @override
  String get jp => 'Japan';

  @override
  String get je => 'Jersey';

  @override
  String get jo => 'Jordan';

  @override
  String get kz => 'Kazakhstan';

  @override
  String get ke => 'Kenya';

  @override
  String get ki => 'Kiribati';

  @override
  String get kp => 'Korea (Democratic People\'s Republic of)';

  @override
  String get kr => 'Korea (Republic of)';

  @override
  String get xk => 'Kosovo';

  @override
  String get kw => 'Kuwait';

  @override
  String get kg => 'Kyrgyzstan';

  @override
  String get la => 'Laos';

  @override
  String get lv => 'Latvia';

  @override
  String get lb => 'Lebanon';

  @override
  String get ls => 'Lesotho';

  @override
  String get lr => 'Liberia';

  @override
  String get ly => 'Libya';

  @override
  String get li => 'Liechtenstein';

  @override
  String get lt => 'Lithuania';

  @override
  String get lu => 'Luxembourg';

  @override
  String get mo => 'Macao';

  @override
  String get mk => 'Macedonia';

  @override
  String get mg => 'Madagascar';

  @override
  String get mw => 'Malawi';

  @override
  String get my => 'Malaysia';

  @override
  String get mv => 'Maldives';

  @override
  String get ml => 'Mali';

  @override
  String get mt => 'Malta';

  @override
  String get mh => 'Marshall Islands';

  @override
  String get mq => 'Martinique';

  @override
  String get mr => 'Mauritania';

  @override
  String get mu => 'Mauritius';

  @override
  String get yt => 'Mayotte';

  @override
  String get mx => 'Mexico';

  @override
  String get fm => 'Micronesia (Federated States of)';

  @override
  String get md => 'Moldova';

  @override
  String get mc => 'Monaco';

  @override
  String get mn => 'Mongolia';

  @override
  String get me => 'Montenegro';

  @override
  String get ms => 'Montserrat';

  @override
  String get ma => 'Morocco';

  @override
  String get mz => 'Mozambique';

  @override
  String get mm => 'Myanmar';

  @override
  String get na => 'Namibia';

  @override
  String get nr => 'Nauru';

  @override
  String get np => 'Nepal';

  @override
  String get nl => 'Netherlands';

  @override
  String get nc => 'New Caledonia';

  @override
  String get nz => 'New Zealand';

  @override
  String get ni => 'Nicaragua';

  @override
  String get ne => 'Niger';

  @override
  String get ng => 'Nigeria';

  @override
  String get nu => 'Niue';

  @override
  String get nf => 'Norfolk Island';

  @override
  String get mp => 'Northern Mariana Islands';

  @override
  String get no => 'Norway';

  @override
  String get om => 'Oman';

  @override
  String get pk => 'Pakistan';

  @override
  String get pw => 'Palau';

  @override
  String get ps => 'Palestine (State of)';

  @override
  String get pa => 'Panama';

  @override
  String get pg => 'Papua New Guinea';

  @override
  String get py => 'Paraguay';

  @override
  String get pe => 'Peru';

  @override
  String get ph => 'Philippines';

  @override
  String get pn => 'Pitcairn';

  @override
  String get pl => 'Poland';

  @override
  String get pt => 'Portugal';

  @override
  String get pr => 'Puerto Rico';

  @override
  String get qa => 'Qatar';

  @override
  String get re => 'Reunion';

  @override
  String get ro => 'Romania';

  @override
  String get ru => 'Russia';

  @override
  String get rw => 'Rwanda';

  @override
  String get bl => 'Saint Barthelemy';

  @override
  String get sh => 'Saint Helena, Ascension and Tristan Da Cunha';

  @override
  String get kn => 'Saint Kitts and Nevis';

  @override
  String get lc => 'Saint Lucia';

  @override
  String get mf => 'Saint Martin';

  @override
  String get pm => 'Saint Pierre and Miquelon';

  @override
  String get vc => 'Saint Vincent and the Grenadines';

  @override
  String get ws => 'Samoa';

  @override
  String get sm => 'San Marino';

  @override
  String get st => 'Sao Tome and Principe';

  @override
  String get sa => 'Saudi Arabia';

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
  String get sk => 'Slovakia';

  @override
  String get si => 'Slovenia';

  @override
  String get sb => 'Solomon Islands';

  @override
  String get so => 'Somalia';

  @override
  String get za => 'South Africa';

  @override
  String get gs => 'South Georgia and the South Sandwich Islands';

  @override
  String get ss => 'South Sudan';

  @override
  String get es => 'Spain';

  @override
  String get lk => 'Sri Lanka';

  @override
  String get sd => 'Sudan';

  @override
  String get sr => 'Suriname';

  @override
  String get sj => 'Svalbard and Jan Mayen';

  @override
  String get se => 'Sweden';

  @override
  String get ch => 'Switzerland';

  @override
  String get sy => 'Syrian Arab Republic';

  @override
  String get tw => 'Taiwan';

  @override
  String get tj => 'Tajikistan';

  @override
  String get tz => 'Tanzania (United Republic of)';

  @override
  String get th => 'Thailand';

  @override
  String get tl => 'Timor-Leste (East Timor)';

  @override
  String get tg => 'Togo';

  @override
  String get tk => 'Tokelau';

  @override
  String get to => 'Tonga';

  @override
  String get tt => 'Trinidad and Tobago';

  @override
  String get tn => 'Tunisia';

  @override
  String get tr => 'Turkey';

  @override
  String get tm => 'Turkmenistan';

  @override
  String get tc => 'Turks and Caicos Islands';

  @override
  String get tv => 'Tuvalu';

  @override
  String get ug => 'Uganda';

  @override
  String get ua => 'Ukraine';

  @override
  String get ae => 'United Arab Emirates';

  @override
  String get gb => 'United Kingdom';

  @override
  String get um => 'United States Minor Outlying Islands';

  @override
  String get us => 'United States';

  @override
  String get uy => 'Uruguay';

  @override
  String get uz => 'Uzbekistan';

  @override
  String get vu => 'Vanuatu';

  @override
  String get ve => 'Venezuela (Bolivarian Republic of)';

  @override
  String get vn => 'Vietnam';

  @override
  String get vg => 'Virgin Islands (British)';

  @override
  String get vi => 'Virgin Islands (US)';

  @override
  String get wf => 'Wallis and Futuna';

  @override
  String get ye => 'Yemen';

  @override
  String get zm => 'Zambia';

  @override
  String get zw => 'Zimbabwe';

  @override
  String get username => 'Username';

  @override
  String get password => 'Password';

  @override
  String get newPassword => 'New Password';

  @override
  String get email => 'Email';

  @override
  String get phoneNumber => 'Phone Number';

  @override
  String get verificationCode => 'Verification Code';

  @override
  String get address => 'Address';

  @override
  String get birthdate => 'Birthdate';

  @override
  String get familyName => 'Family Name';

  @override
  String get middleName => 'Middle Name';

  @override
  String get gender => 'Gender';

  @override
  String genders(String gender) {
    String _temp0 = intl.Intl.selectLogic(
      gender,
      {
        'male': 'male',
        'female': 'female',
        'other': 'other',
      },
    );
    return '$_temp0';
  }

  @override
  String get givenName => 'Given Name';

  @override
  String get name => 'Name';

  @override
  String get nickname => 'Nickname';

  @override
  String or(String a, String b) {
    return '$a or $b';
  }

  @override
  String get preferredUsername => 'Preferred Username';

  @override
  String warnEmpty(String attribute) {
    return '$attribute field must not be blank.';
  }

  @override
  String warnInvalidFormat(String attributeType) {
    return 'Invalid $attributeType format.';
  }

  @override
  String promptFill(String attribute) {
    return 'Enter your $attribute';
  }

  @override
  String promptRefill(String attribute) {
    return 'Re-enter your $attribute';
  }

  @override
  String confirmAttribute(String attribute) {
    return 'Confirm $attribute';
  }

  @override
  String get usernameRequirements => 'Username must only contain alphanumeric characters and symbols.';

  @override
  String get passwordRequirementsPreamble => 'Password must include:';

  @override
  String passwordRequirementsCharacterType(String characterType) {
    String _temp0 = intl.Intl.selectLogic(
      characterType,
      {
        'requiresUppercase': 'uppercase',
        'requiresLowercase': 'lowercase',
        'requiresNumbers': 'number',
        'requiresSymbols': 'symbol',
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
      other: '$numCharacters$characterType characters',
      one: '1$characterType character',
    );
    return 'at least $_temp0';
  }

  @override
  String get passwordsDoNotMatch => 'Passwords do not match.';

  @override
  String get rememberDevice => 'Remember Device?';

  @override
  String get usernameType => 'Log in using:';

  @override
  String optional(String fieldTitle) {
    return '$fieldTitle (optional)';
  }

  @override
  String get customChallenge => 'Confirmation Code';

  @override
  String get selectSms => 'Text Message (SMS)';

  @override
  String get selectTotp => 'Authenticator App (TOTP)';

  @override
  String get totpCodePrompt => 'Please enter the code from your registered Authenticator app';

  @override
  String get selectEmail => 'Email';

  @override
  String codeSent(String destination) {
    return 'A confirmation code has been sent to $destination.';
  }

  @override
  String get codeSentUnknown => 'A confirmation code has been sent.';

  @override
  String get copySucceeded => 'Copied to clipboard!';

  @override
  String get copyFailed => 'Copy to clipboard failed.';

  @override
  String get totpStep1Title => 'Step 1: Download an Authenticator app';

  @override
  String get totpStep2Title => 'Step 2: Scan the QR code';

  @override
  String get totpStep3Title => 'Step 3: Verify your code';

  @override
  String get totpStep1Body => 'Authenticator apps generate one-time codes that can be used to verify your identity';

  @override
  String get totpStep2Body => 'Open then Authenticator app and scan the QR code or enter the key to get your verification code';

  @override
  String get totpStep3Body => 'Enter the 6 digit code from your Authenticator app';

  @override
  String get confirmSignUp => 'Enter your confirmation code';

  @override
  String get confirmSignInMfa => 'Enter your sign in code';

  @override
  String get confirmSignInCustomAuth => 'Enter your sign in code';

  @override
  String get confirmSignInNewPassword => 'Change your password to sign in';

  @override
  String get continueSignInWithMfaSelection => 'Select your preferred Two-Factor Auth method';

  @override
  String get continueSignInWithTotpSetup => 'Enable Two-Factor Auth';

  @override
  String get confirmSignInWithTotpMfaCode => 'Enter your one-time passcode';

  @override
  String get resetPassword => 'Send Code';

  @override
  String get verifyUser => 'Account recovery requires verified contact information';

  @override
  String get editMeal => 'Edit meal';

  @override
  String get shareMeal => 'Share meal';

  @override
  String get switchMealPlan => 'Switch Meal Plan';

  @override
  String get noOtherMealPlans => 'No other meal plans available.';

  @override
  String get unnamedPlan => 'Unnamed Plan';

  @override
  String get switchingPlan => 'Switching plan...';

  @override
  String get switchedToPlan => 'Switched to plan';

  @override
  String get failedToSwitchPlan => 'Failed to switch plan';

  @override
  String get errorLoadingPlans => 'Error loading plans';

  @override
  String get moreOptions => 'More options';
}

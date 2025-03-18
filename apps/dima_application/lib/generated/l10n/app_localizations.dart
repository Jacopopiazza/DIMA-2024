import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_it.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('it')
  ];

  /// The conventional newborn programmer greeting
  ///
  /// In en, this message translates to:
  /// **'Hello World!'**
  String get helloWorld;

  /// Logged in message
  ///
  /// In en, this message translates to:
  /// **'Logged in!'**
  String get signedIn;

  /// UserTypeEnum DisplayValue for User
  ///
  /// In en, this message translates to:
  /// **'User'**
  String get userRole;

  /// UserTypeEnum DisplayValue for Nutritionist
  ///
  /// In en, this message translates to:
  /// **'Nutritionist'**
  String get nutritionistRole;

  /// Sign Up Dropdown Description for user role selection
  ///
  /// In en, this message translates to:
  /// **'Register as'**
  String get signUpDropdownText;

  /// Notice for users signing up with social accounts
  ///
  /// In en, this message translates to:
  /// **'Signing up with a social account automatically creates a regular user account. Nutritionists must first sign up with email. If a user later logs in with a social account linked to the same email, the accounts will be merged automatically.'**
  String get socialSignUpNotice;

  /// Label of the button to sign in the user.
  ///
  /// In en, this message translates to:
  /// **'Sign In'**
  String get signIn;

  /// Label of the button to sign up the user.
  ///
  /// In en, this message translates to:
  /// **'Create Account'**
  String get signUp;

  /// Label of button to confirm an action
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// Label of button to continue to the next action
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continueLabel;

  /// Label of button to submit a form
  ///
  /// In en, this message translates to:
  /// **'Submit'**
  String get submit;

  /// Label of button to change a password
  ///
  /// In en, this message translates to:
  /// **'Change Password'**
  String get changePassword;

  /// Label of button to send a verification code to the user's device
  ///
  /// In en, this message translates to:
  /// **'Send Code'**
  String get sendCode;

  /// Label of button prompting user if they've not received or have misplaced a verification code we sent
  ///
  /// In en, this message translates to:
  /// **'Lost your code?'**
  String get lostCode;

  /// Hint text for the 'Go to Sign Up' button
  ///
  /// In en, this message translates to:
  /// **'No account?'**
  String get noAccount;

  /// Hint text for the 'Go to Sign In' button
  ///
  /// In en, this message translates to:
  /// **'Have an account?'**
  String get haveAccount;

  /// Hint text for the 'Reset Password' button
  ///
  /// In en, this message translates to:
  /// **'Forgot your password?'**
  String get forgotPassword;

  /// Label of button to confirm the reset of a user's password
  ///
  /// In en, this message translates to:
  /// **'Reset Password'**
  String get confirmResetPassword;

  /// Label of button to verify a user's attribute, such as their email or phone number
  ///
  /// In en, this message translates to:
  /// **'Verify'**
  String get verify;

  /// Label of button to skip the current step or action.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get skip;

  /// Label of button to copy a value.
  ///
  /// In en, this message translates to:
  /// **'Copy Key'**
  String get copyKey;

  /// Label of button to sign out the user
  ///
  /// In en, this message translates to:
  /// **'Sign Out'**
  String get signOut;

  /// Label of button to return to the previous step
  ///
  /// In en, this message translates to:
  /// **'Back to {previousStep, select, signUp{Sign Up} signIn{Sign In} confirmSignUp{Confirm Sign-up} confirmSignInMfa{Confirm Sign-in} confirmSignInNewPassword{Confirm Sign-in} sendCode{Send Code} resetPassword{Reset Password} verifyUser{Verify User} confirmVerifyUser{Confirm Verify User} other{ERROR}}'**
  String backTo(String previousStep);

  /// Label of button to sign in with a social provider
  ///
  /// In en, this message translates to:
  /// **'Sign In with {provider, select, google{Google} facebook{Facebook} amazon{Amazon} apple{Apple} other{ERROR}}'**
  String signInWith(String provider);

  /// Title of select dial code modal
  ///
  /// In en, this message translates to:
  /// **'Select your country dial code'**
  String get selectDialCode;

  /// Text displayed when dial code lookup has no search results
  ///
  /// In en, this message translates to:
  /// **'No search results match your criteria'**
  String get noDialCodeSearchResults;

  /// Display name for Afghanistan
  ///
  /// In en, this message translates to:
  /// **'Afghanistan'**
  String get af;

  /// Display name for Aland Islands
  ///
  /// In en, this message translates to:
  /// **'Aland Islands'**
  String get ax;

  /// Display name for Albania
  ///
  /// In en, this message translates to:
  /// **'Albania'**
  String get al;

  /// Display name for Algeria
  ///
  /// In en, this message translates to:
  /// **'Algeria'**
  String get dz;

  /// Display name for American Samoa
  ///
  /// In en, this message translates to:
  /// **'American Samoa'**
  String get as1;

  /// Display name for Andorra
  ///
  /// In en, this message translates to:
  /// **'Andorra'**
  String get ad;

  /// Display name for Angola
  ///
  /// In en, this message translates to:
  /// **'Angola'**
  String get ao;

  /// Display name for Anguilla
  ///
  /// In en, this message translates to:
  /// **'Anguilla'**
  String get ai;

  /// Display name for Antarctica
  ///
  /// In en, this message translates to:
  /// **'Antarctica'**
  String get aq;

  /// Display name for Antigua and Barbuda
  ///
  /// In en, this message translates to:
  /// **'Antigua and Barbuda'**
  String get ag;

  /// Display name for Argentina
  ///
  /// In en, this message translates to:
  /// **'Argentina'**
  String get ar;

  /// Display name for Armenia
  ///
  /// In en, this message translates to:
  /// **'Armenia'**
  String get am;

  /// Display name for Aruba
  ///
  /// In en, this message translates to:
  /// **'Aruba'**
  String get aw;

  /// Display name for Australia
  ///
  /// In en, this message translates to:
  /// **'Australia'**
  String get au;

  /// Display name for Austria
  ///
  /// In en, this message translates to:
  /// **'Austria'**
  String get at;

  /// Display name for Azerbaijan
  ///
  /// In en, this message translates to:
  /// **'Azerbaijan'**
  String get az;

  /// Display name for Bahamas
  ///
  /// In en, this message translates to:
  /// **'Bahamas'**
  String get bs;

  /// Display name for Bahrain
  ///
  /// In en, this message translates to:
  /// **'Bahrain'**
  String get bh;

  /// Display name for Bangladesh
  ///
  /// In en, this message translates to:
  /// **'Bangladesh'**
  String get bd;

  /// Display name for Barbados
  ///
  /// In en, this message translates to:
  /// **'Barbados'**
  String get bb;

  /// Display name for Belarus
  ///
  /// In en, this message translates to:
  /// **'Belarus'**
  String get by;

  /// Display name for Belgium
  ///
  /// In en, this message translates to:
  /// **'Belgium'**
  String get be;

  /// Display name for Belize
  ///
  /// In en, this message translates to:
  /// **'Belize'**
  String get bz;

  /// Display name for Benin
  ///
  /// In en, this message translates to:
  /// **'Benin'**
  String get bj;

  /// Display name for Bermuda
  ///
  /// In en, this message translates to:
  /// **'Bermuda'**
  String get bm;

  /// Display name for Bhutan
  ///
  /// In en, this message translates to:
  /// **'Bhutan'**
  String get bt;

  /// Display name for Bolivia (Plurinational State of)
  ///
  /// In en, this message translates to:
  /// **'Bolivia (Plurinational State of)'**
  String get bo;

  /// Display name for Bonaire, Sint Eustatius and Saba
  ///
  /// In en, this message translates to:
  /// **'Bonaire, Sint Eustatius and Saba'**
  String get bq;

  /// Display name for Bosnia and Herzegovina
  ///
  /// In en, this message translates to:
  /// **'Bosnia and Herzegovina'**
  String get ba;

  /// Display name for Botswana
  ///
  /// In en, this message translates to:
  /// **'Botswana'**
  String get bw;

  /// Display name for Brazil
  ///
  /// In en, this message translates to:
  /// **'Brazil'**
  String get br;

  /// Display name for British Indian Ocean Territory
  ///
  /// In en, this message translates to:
  /// **'British Indian Ocean Territory'**
  String get io;

  /// Display name for Brunei
  ///
  /// In en, this message translates to:
  /// **'Brunei'**
  String get bn;

  /// Display name for Bulgaria
  ///
  /// In en, this message translates to:
  /// **'Bulgaria'**
  String get bg;

  /// Display name for Burkina Faso
  ///
  /// In en, this message translates to:
  /// **'Burkina Faso'**
  String get bf;

  /// Display name for Burundi
  ///
  /// In en, this message translates to:
  /// **'Burundi'**
  String get bi;

  /// Display name for Cambodia
  ///
  /// In en, this message translates to:
  /// **'Cambodia'**
  String get kh;

  /// Display name for Cameroon
  ///
  /// In en, this message translates to:
  /// **'Cameroon'**
  String get cm;

  /// Display name for Canada
  ///
  /// In en, this message translates to:
  /// **'Canada'**
  String get ca;

  /// Display name for Cape Verde
  ///
  /// In en, this message translates to:
  /// **'Cape Verde'**
  String get cv;

  /// Display name for Cayman Islands
  ///
  /// In en, this message translates to:
  /// **'Cayman Islands'**
  String get ky;

  /// Display name for Central African Republic
  ///
  /// In en, this message translates to:
  /// **'Central African Republic'**
  String get cf;

  /// Display name for Chad
  ///
  /// In en, this message translates to:
  /// **'Chad'**
  String get td;

  /// Display name for Chile
  ///
  /// In en, this message translates to:
  /// **'Chile'**
  String get cl;

  /// Display name for China
  ///
  /// In en, this message translates to:
  /// **'China'**
  String get cn;

  /// Display name for Christmas Island
  ///
  /// In en, this message translates to:
  /// **'Christmas Island'**
  String get cx;

  /// Display name for Cocos (Keeling) Islands
  ///
  /// In en, this message translates to:
  /// **'Cocos (Keeling) Islands'**
  String get cc;

  /// Display name for Colombia
  ///
  /// In en, this message translates to:
  /// **'Colombia'**
  String get co;

  /// Display name for Comoros
  ///
  /// In en, this message translates to:
  /// **'Comoros'**
  String get km;

  /// Display name for Congo (Republic of)
  ///
  /// In en, this message translates to:
  /// **'Congo (Republic of)'**
  String get cg;

  /// Display name for Congo (Democratic Republic of)
  ///
  /// In en, this message translates to:
  /// **'Congo (Democratic Republic of)'**
  String get cd;

  /// Display name for Cook Islands
  ///
  /// In en, this message translates to:
  /// **'Cook Islands'**
  String get ck;

  /// Display name for Costa Rica
  ///
  /// In en, this message translates to:
  /// **'Costa Rica'**
  String get cr;

  /// Display name for Côte d'Ivoire
  ///
  /// In en, this message translates to:
  /// **'Côte d\'Ivoire'**
  String get ci;

  /// Display name for Croatia
  ///
  /// In en, this message translates to:
  /// **'Croatia'**
  String get hr;

  /// Display name for Cuba
  ///
  /// In en, this message translates to:
  /// **'Cuba'**
  String get cu;

  /// Display name for Cyprus
  ///
  /// In en, this message translates to:
  /// **'Cyprus'**
  String get cy;

  /// Display name for Czech Republic
  ///
  /// In en, this message translates to:
  /// **'Czech Republic'**
  String get cz;

  /// Display name for Denmark
  ///
  /// In en, this message translates to:
  /// **'Denmark'**
  String get dk;

  /// Display name for Djibouti
  ///
  /// In en, this message translates to:
  /// **'Djibouti'**
  String get dj;

  /// Display name for Dominica
  ///
  /// In en, this message translates to:
  /// **'Dominica'**
  String get dm;

  /// Display name for Dominican Republic
  ///
  /// In en, this message translates to:
  /// **'Dominican Republic'**
  String get do1;

  /// Display name for Ecuador
  ///
  /// In en, this message translates to:
  /// **'Ecuador'**
  String get ec;

  /// Display name for Egypt
  ///
  /// In en, this message translates to:
  /// **'Egypt'**
  String get eg;

  /// Display name for El Salvador
  ///
  /// In en, this message translates to:
  /// **'El Salvador'**
  String get sv;

  /// Display name for Equatorial Guinea
  ///
  /// In en, this message translates to:
  /// **'Equatorial Guinea'**
  String get gq;

  /// Display name for Eritrea
  ///
  /// In en, this message translates to:
  /// **'Eritrea'**
  String get er;

  /// Display name for Estonia
  ///
  /// In en, this message translates to:
  /// **'Estonia'**
  String get ee;

  /// Display name for Eswatini
  ///
  /// In en, this message translates to:
  /// **'Eswatini'**
  String get sz;

  /// Display name for Ethiopia
  ///
  /// In en, this message translates to:
  /// **'Ethiopia'**
  String get et;

  /// Display name for Falkland Islands (Malvinas)
  ///
  /// In en, this message translates to:
  /// **'Falkland Islands (Malvinas)'**
  String get fk;

  /// Display name for Faroe Islands
  ///
  /// In en, this message translates to:
  /// **'Faroe Islands'**
  String get fo;

  /// Display name for Fiji
  ///
  /// In en, this message translates to:
  /// **'Fiji'**
  String get fj;

  /// Display name for Finland
  ///
  /// In en, this message translates to:
  /// **'Finland'**
  String get fi;

  /// Display name for France
  ///
  /// In en, this message translates to:
  /// **'France'**
  String get fr;

  /// Display name for French Guiana
  ///
  /// In en, this message translates to:
  /// **'French Guiana'**
  String get gf;

  /// Display name for French Polynesia
  ///
  /// In en, this message translates to:
  /// **'French Polynesia'**
  String get pf;

  /// Display name for Gabon
  ///
  /// In en, this message translates to:
  /// **'Gabon'**
  String get ga;

  /// Display name for Gambia
  ///
  /// In en, this message translates to:
  /// **'Gambia'**
  String get gm;

  /// Display name for Georgia
  ///
  /// In en, this message translates to:
  /// **'Georgia'**
  String get ge;

  /// Display name for Germany
  ///
  /// In en, this message translates to:
  /// **'Germany'**
  String get de;

  /// Display name for Ghana
  ///
  /// In en, this message translates to:
  /// **'Ghana'**
  String get gh;

  /// Display name for Gibraltar
  ///
  /// In en, this message translates to:
  /// **'Gibraltar'**
  String get gi;

  /// Display name for Greece
  ///
  /// In en, this message translates to:
  /// **'Greece'**
  String get gr;

  /// Display name for Greenland
  ///
  /// In en, this message translates to:
  /// **'Greenland'**
  String get gl;

  /// Display name for Grenada
  ///
  /// In en, this message translates to:
  /// **'Grenada'**
  String get gd;

  /// Display name for Guadeloupe
  ///
  /// In en, this message translates to:
  /// **'Guadeloupe'**
  String get gp;

  /// Display name for Guam
  ///
  /// In en, this message translates to:
  /// **'Guam'**
  String get gu;

  /// Display name for Guatemala
  ///
  /// In en, this message translates to:
  /// **'Guatemala'**
  String get gt;

  /// Display name for Guernsey
  ///
  /// In en, this message translates to:
  /// **'Guernsey'**
  String get gg;

  /// Display name for Guinea
  ///
  /// In en, this message translates to:
  /// **'Guinea'**
  String get gn;

  /// Display name for Guinea-Bissau
  ///
  /// In en, this message translates to:
  /// **'Guinea-Bissau'**
  String get gw;

  /// Display name for Guyana
  ///
  /// In en, this message translates to:
  /// **'Guyana'**
  String get gy;

  /// Display name for Haiti
  ///
  /// In en, this message translates to:
  /// **'Haiti'**
  String get ht;

  /// Display name for Holy See (Vatican City State)
  ///
  /// In en, this message translates to:
  /// **'Holy See (Vatican City State)'**
  String get va;

  /// Display name for Honduras
  ///
  /// In en, this message translates to:
  /// **'Honduras'**
  String get hn;

  /// Display name for Hong Kong
  ///
  /// In en, this message translates to:
  /// **'Hong Kong'**
  String get hk;

  /// Display name for Hungary
  ///
  /// In en, this message translates to:
  /// **'Hungary'**
  String get hu;

  /// Display name for Iceland
  ///
  /// In en, this message translates to:
  /// **'Iceland'**
  String get is1;

  /// Display name for India
  ///
  /// In en, this message translates to:
  /// **'India'**
  String get in1;

  /// Display name for Indonesia
  ///
  /// In en, this message translates to:
  /// **'Indonesia'**
  String get id;

  /// Display name for Iran (Islamic Republic of)
  ///
  /// In en, this message translates to:
  /// **'Iran (Islamic Republic of)'**
  String get ir;

  /// Display name for Iraq
  ///
  /// In en, this message translates to:
  /// **'Iraq'**
  String get iq;

  /// Display name for Ireland
  ///
  /// In en, this message translates to:
  /// **'Ireland'**
  String get ie;

  /// Display name for Isle of Man
  ///
  /// In en, this message translates to:
  /// **'Isle of Man'**
  String get im;

  /// Display name for Israel
  ///
  /// In en, this message translates to:
  /// **'Israel'**
  String get il;

  /// Display name for Italy
  ///
  /// In en, this message translates to:
  /// **'Italy'**
  String get it;

  /// Display name for Jamaica
  ///
  /// In en, this message translates to:
  /// **'Jamaica'**
  String get jm;

  /// Display name for Japan
  ///
  /// In en, this message translates to:
  /// **'Japan'**
  String get jp;

  /// Display name for Jersey
  ///
  /// In en, this message translates to:
  /// **'Jersey'**
  String get je;

  /// Display name for Jordan
  ///
  /// In en, this message translates to:
  /// **'Jordan'**
  String get jo;

  /// Display name for Kazakhstan
  ///
  /// In en, this message translates to:
  /// **'Kazakhstan'**
  String get kz;

  /// Display name for Kenya
  ///
  /// In en, this message translates to:
  /// **'Kenya'**
  String get ke;

  /// Display name for Kiribati
  ///
  /// In en, this message translates to:
  /// **'Kiribati'**
  String get ki;

  /// Display name for Korea (Democratic People's Republic of)
  ///
  /// In en, this message translates to:
  /// **'Korea (Democratic People\'s Republic of)'**
  String get kp;

  /// Display name for Korea (Republic of)
  ///
  /// In en, this message translates to:
  /// **'Korea (Republic of)'**
  String get kr;

  /// Display name for Kosovo
  ///
  /// In en, this message translates to:
  /// **'Kosovo'**
  String get xk;

  /// Display name for Kuwait
  ///
  /// In en, this message translates to:
  /// **'Kuwait'**
  String get kw;

  /// Display name for Kyrgyzstan
  ///
  /// In en, this message translates to:
  /// **'Kyrgyzstan'**
  String get kg;

  /// Display name for Laos
  ///
  /// In en, this message translates to:
  /// **'Laos'**
  String get la;

  /// Display name for Latvia
  ///
  /// In en, this message translates to:
  /// **'Latvia'**
  String get lv;

  /// Display name for Lebanon
  ///
  /// In en, this message translates to:
  /// **'Lebanon'**
  String get lb;

  /// Display name for Lesotho
  ///
  /// In en, this message translates to:
  /// **'Lesotho'**
  String get ls;

  /// Display name for Liberia
  ///
  /// In en, this message translates to:
  /// **'Liberia'**
  String get lr;

  /// Display name for Libya
  ///
  /// In en, this message translates to:
  /// **'Libya'**
  String get ly;

  /// Display name for Liechtenstein
  ///
  /// In en, this message translates to:
  /// **'Liechtenstein'**
  String get li;

  /// Display name for Lithuania
  ///
  /// In en, this message translates to:
  /// **'Lithuania'**
  String get lt;

  /// Display name for Luxembourg
  ///
  /// In en, this message translates to:
  /// **'Luxembourg'**
  String get lu;

  /// Display name for Macao
  ///
  /// In en, this message translates to:
  /// **'Macao'**
  String get mo;

  /// Display name for Macedonia
  ///
  /// In en, this message translates to:
  /// **'Macedonia'**
  String get mk;

  /// Display name for Madagascar
  ///
  /// In en, this message translates to:
  /// **'Madagascar'**
  String get mg;

  /// Display name for Malawi
  ///
  /// In en, this message translates to:
  /// **'Malawi'**
  String get mw;

  /// Display name for Malaysia
  ///
  /// In en, this message translates to:
  /// **'Malaysia'**
  String get my;

  /// Display name for Maldives
  ///
  /// In en, this message translates to:
  /// **'Maldives'**
  String get mv;

  /// Display name for Mali
  ///
  /// In en, this message translates to:
  /// **'Mali'**
  String get ml;

  /// Display name for Malta
  ///
  /// In en, this message translates to:
  /// **'Malta'**
  String get mt;

  /// Display name for Marshall Islands
  ///
  /// In en, this message translates to:
  /// **'Marshall Islands'**
  String get mh;

  /// Display name for Martinique
  ///
  /// In en, this message translates to:
  /// **'Martinique'**
  String get mq;

  /// Display name for Mauritania
  ///
  /// In en, this message translates to:
  /// **'Mauritania'**
  String get mr;

  /// Display name for Mauritius
  ///
  /// In en, this message translates to:
  /// **'Mauritius'**
  String get mu;

  /// Display name for Mayotte
  ///
  /// In en, this message translates to:
  /// **'Mayotte'**
  String get yt;

  /// Display name for Mexico
  ///
  /// In en, this message translates to:
  /// **'Mexico'**
  String get mx;

  /// Display name for Micronesia (Federated States of)
  ///
  /// In en, this message translates to:
  /// **'Micronesia (Federated States of)'**
  String get fm;

  /// Display name for Moldova
  ///
  /// In en, this message translates to:
  /// **'Moldova'**
  String get md;

  /// Display name for Monaco
  ///
  /// In en, this message translates to:
  /// **'Monaco'**
  String get mc;

  /// Display name for Mongolia
  ///
  /// In en, this message translates to:
  /// **'Mongolia'**
  String get mn;

  /// Display name for Montenegro
  ///
  /// In en, this message translates to:
  /// **'Montenegro'**
  String get me;

  /// Display name for Montserrat
  ///
  /// In en, this message translates to:
  /// **'Montserrat'**
  String get ms;

  /// Display name for Morocco
  ///
  /// In en, this message translates to:
  /// **'Morocco'**
  String get ma;

  /// Display name for Mozambique
  ///
  /// In en, this message translates to:
  /// **'Mozambique'**
  String get mz;

  /// Display name for Myanmar
  ///
  /// In en, this message translates to:
  /// **'Myanmar'**
  String get mm;

  /// Display name for Namibia
  ///
  /// In en, this message translates to:
  /// **'Namibia'**
  String get na;

  /// Display name for Nauru
  ///
  /// In en, this message translates to:
  /// **'Nauru'**
  String get nr;

  /// Display name for Nepal
  ///
  /// In en, this message translates to:
  /// **'Nepal'**
  String get np;

  /// Display name for Netherlands
  ///
  /// In en, this message translates to:
  /// **'Netherlands'**
  String get nl;

  /// Display name for New Caledonia
  ///
  /// In en, this message translates to:
  /// **'New Caledonia'**
  String get nc;

  /// Display name for New Zealand
  ///
  /// In en, this message translates to:
  /// **'New Zealand'**
  String get nz;

  /// Display name for Nicaragua
  ///
  /// In en, this message translates to:
  /// **'Nicaragua'**
  String get ni;

  /// Display name for Niger
  ///
  /// In en, this message translates to:
  /// **'Niger'**
  String get ne;

  /// Display name for Nigeria
  ///
  /// In en, this message translates to:
  /// **'Nigeria'**
  String get ng;

  /// Display name for Niue
  ///
  /// In en, this message translates to:
  /// **'Niue'**
  String get nu;

  /// Display name for Norfolk Island
  ///
  /// In en, this message translates to:
  /// **'Norfolk Island'**
  String get nf;

  /// Display name for Northern Mariana Islands
  ///
  /// In en, this message translates to:
  /// **'Northern Mariana Islands'**
  String get mp;

  /// Display name for Norway
  ///
  /// In en, this message translates to:
  /// **'Norway'**
  String get no;

  /// Display name for Oman
  ///
  /// In en, this message translates to:
  /// **'Oman'**
  String get om;

  /// Display name for Pakistan
  ///
  /// In en, this message translates to:
  /// **'Pakistan'**
  String get pk;

  /// Display name for Palau
  ///
  /// In en, this message translates to:
  /// **'Palau'**
  String get pw;

  /// Display name for Palestine (State of)
  ///
  /// In en, this message translates to:
  /// **'Palestine (State of)'**
  String get ps;

  /// Display name for Panama
  ///
  /// In en, this message translates to:
  /// **'Panama'**
  String get pa;

  /// Display name for Papua New Guinea
  ///
  /// In en, this message translates to:
  /// **'Papua New Guinea'**
  String get pg;

  /// Display name for Paraguay
  ///
  /// In en, this message translates to:
  /// **'Paraguay'**
  String get py;

  /// Display name for Peru
  ///
  /// In en, this message translates to:
  /// **'Peru'**
  String get pe;

  /// Display name for Philippines
  ///
  /// In en, this message translates to:
  /// **'Philippines'**
  String get ph;

  /// Display name for Pitcairn
  ///
  /// In en, this message translates to:
  /// **'Pitcairn'**
  String get pn;

  /// Display name for Poland
  ///
  /// In en, this message translates to:
  /// **'Poland'**
  String get pl;

  /// Display name for Portugal
  ///
  /// In en, this message translates to:
  /// **'Portugal'**
  String get pt;

  /// Display name for Puerto Rico
  ///
  /// In en, this message translates to:
  /// **'Puerto Rico'**
  String get pr;

  /// Display name for Qatar
  ///
  /// In en, this message translates to:
  /// **'Qatar'**
  String get qa;

  /// Display name for Reunion
  ///
  /// In en, this message translates to:
  /// **'Reunion'**
  String get re;

  /// Display name for Romania
  ///
  /// In en, this message translates to:
  /// **'Romania'**
  String get ro;

  /// Display name for Russia
  ///
  /// In en, this message translates to:
  /// **'Russia'**
  String get ru;

  /// Display name for Rwanda
  ///
  /// In en, this message translates to:
  /// **'Rwanda'**
  String get rw;

  /// Display name for Saint Barthelemy
  ///
  /// In en, this message translates to:
  /// **'Saint Barthelemy'**
  String get bl;

  /// Display name for Saint Helena, Ascension and Tristan Da Cunha
  ///
  /// In en, this message translates to:
  /// **'Saint Helena, Ascension and Tristan Da Cunha'**
  String get sh;

  /// Display name for Saint Kitts and Nevis
  ///
  /// In en, this message translates to:
  /// **'Saint Kitts and Nevis'**
  String get kn;

  /// Display name for Saint Lucia
  ///
  /// In en, this message translates to:
  /// **'Saint Lucia'**
  String get lc;

  /// Display name for Saint Martin
  ///
  /// In en, this message translates to:
  /// **'Saint Martin'**
  String get mf;

  /// Display name for Saint Pierre and Miquelon
  ///
  /// In en, this message translates to:
  /// **'Saint Pierre and Miquelon'**
  String get pm;

  /// Display name for Saint Vincent and the Grenadines
  ///
  /// In en, this message translates to:
  /// **'Saint Vincent and the Grenadines'**
  String get vc;

  /// Display name for Samoa
  ///
  /// In en, this message translates to:
  /// **'Samoa'**
  String get ws;

  /// Display name for San Marino
  ///
  /// In en, this message translates to:
  /// **'San Marino'**
  String get sm;

  /// Display name for Sao Tome and Principe
  ///
  /// In en, this message translates to:
  /// **'Sao Tome and Principe'**
  String get st;

  /// Display name for Saudi Arabia
  ///
  /// In en, this message translates to:
  /// **'Saudi Arabia'**
  String get sa;

  /// Display name for Senegal
  ///
  /// In en, this message translates to:
  /// **'Senegal'**
  String get sn;

  /// Display name for Serbia
  ///
  /// In en, this message translates to:
  /// **'Serbia'**
  String get rs;

  /// Display name for Seychelles
  ///
  /// In en, this message translates to:
  /// **'Seychelles'**
  String get sc;

  /// Display name for Sierra Leone
  ///
  /// In en, this message translates to:
  /// **'Sierra Leone'**
  String get sl;

  /// Display name for Singapore
  ///
  /// In en, this message translates to:
  /// **'Singapore'**
  String get sg;

  /// Display name for Slovakia
  ///
  /// In en, this message translates to:
  /// **'Slovakia'**
  String get sk;

  /// Display name for Slovenia
  ///
  /// In en, this message translates to:
  /// **'Slovenia'**
  String get si;

  /// Display name for Solomon Islands
  ///
  /// In en, this message translates to:
  /// **'Solomon Islands'**
  String get sb;

  /// Display name for Somalia
  ///
  /// In en, this message translates to:
  /// **'Somalia'**
  String get so;

  /// Display name for South Africa
  ///
  /// In en, this message translates to:
  /// **'South Africa'**
  String get za;

  /// Display name for South Georgia and the South Sandwich Islands
  ///
  /// In en, this message translates to:
  /// **'South Georgia and the South Sandwich Islands'**
  String get gs;

  /// Display name for South Sudan
  ///
  /// In en, this message translates to:
  /// **'South Sudan'**
  String get ss;

  /// Display name for Spain
  ///
  /// In en, this message translates to:
  /// **'Spain'**
  String get es;

  /// Display name for Sri Lanka
  ///
  /// In en, this message translates to:
  /// **'Sri Lanka'**
  String get lk;

  /// Display name for Sudan
  ///
  /// In en, this message translates to:
  /// **'Sudan'**
  String get sd;

  /// Display name for Suriname
  ///
  /// In en, this message translates to:
  /// **'Suriname'**
  String get sr;

  /// Display name for Svalbard and Jan Mayen
  ///
  /// In en, this message translates to:
  /// **'Svalbard and Jan Mayen'**
  String get sj;

  /// Display name for Sweden
  ///
  /// In en, this message translates to:
  /// **'Sweden'**
  String get se;

  /// Display name for Switzerland
  ///
  /// In en, this message translates to:
  /// **'Switzerland'**
  String get ch;

  /// Display name for Syrian Arab Republic
  ///
  /// In en, this message translates to:
  /// **'Syrian Arab Republic'**
  String get sy;

  /// Display name for Taiwan
  ///
  /// In en, this message translates to:
  /// **'Taiwan'**
  String get tw;

  /// Display name for Tajikistan
  ///
  /// In en, this message translates to:
  /// **'Tajikistan'**
  String get tj;

  /// Display name for Tanzania (United Republic of)
  ///
  /// In en, this message translates to:
  /// **'Tanzania (United Republic of)'**
  String get tz;

  /// Display name for Thailand
  ///
  /// In en, this message translates to:
  /// **'Thailand'**
  String get th;

  /// Display name for Timor-Leste (East Timor)
  ///
  /// In en, this message translates to:
  /// **'Timor-Leste (East Timor)'**
  String get tl;

  /// Display name for Togo
  ///
  /// In en, this message translates to:
  /// **'Togo'**
  String get tg;

  /// Display name for Tokelau
  ///
  /// In en, this message translates to:
  /// **'Tokelau'**
  String get tk;

  /// Display name for Tonga
  ///
  /// In en, this message translates to:
  /// **'Tonga'**
  String get to;

  /// Display name for Trinidad and Tobago
  ///
  /// In en, this message translates to:
  /// **'Trinidad and Tobago'**
  String get tt;

  /// Display name for Tunisia
  ///
  /// In en, this message translates to:
  /// **'Tunisia'**
  String get tn;

  /// Display name for Turkey
  ///
  /// In en, this message translates to:
  /// **'Turkey'**
  String get tr;

  /// Display name for Turkmenistan
  ///
  /// In en, this message translates to:
  /// **'Turkmenistan'**
  String get tm;

  /// Display name for Turks and Caicos Islands
  ///
  /// In en, this message translates to:
  /// **'Turks and Caicos Islands'**
  String get tc;

  /// Display name for Tuvalu
  ///
  /// In en, this message translates to:
  /// **'Tuvalu'**
  String get tv;

  /// Display name for Uganda
  ///
  /// In en, this message translates to:
  /// **'Uganda'**
  String get ug;

  /// Display name for Ukraine
  ///
  /// In en, this message translates to:
  /// **'Ukraine'**
  String get ua;

  /// Display name for United Arab Emirates
  ///
  /// In en, this message translates to:
  /// **'United Arab Emirates'**
  String get ae;

  /// Display name for United Kingdom
  ///
  /// In en, this message translates to:
  /// **'United Kingdom'**
  String get gb;

  /// Display name for United States Minor Outlying Islands
  ///
  /// In en, this message translates to:
  /// **'United States Minor Outlying Islands'**
  String get um;

  /// Display name for United States
  ///
  /// In en, this message translates to:
  /// **'United States'**
  String get us;

  /// Display name for Uruguay
  ///
  /// In en, this message translates to:
  /// **'Uruguay'**
  String get uy;

  /// Display name for Uzbekistan
  ///
  /// In en, this message translates to:
  /// **'Uzbekistan'**
  String get uz;

  /// Display name for Vanuatu
  ///
  /// In en, this message translates to:
  /// **'Vanuatu'**
  String get vu;

  /// Display name for Venezuela (Bolivarian Republic of)
  ///
  /// In en, this message translates to:
  /// **'Venezuela (Bolivarian Republic of)'**
  String get ve;

  /// Display name for Vietnam
  ///
  /// In en, this message translates to:
  /// **'Vietnam'**
  String get vn;

  /// Display name for Virgin Islands (British)
  ///
  /// In en, this message translates to:
  /// **'Virgin Islands (British)'**
  String get vg;

  /// Display name for Virgin Islands (US)
  ///
  /// In en, this message translates to:
  /// **'Virgin Islands (US)'**
  String get vi;

  /// Display name for Wallis and Futuna
  ///
  /// In en, this message translates to:
  /// **'Wallis and Futuna'**
  String get wf;

  /// Display name for Yemen
  ///
  /// In en, this message translates to:
  /// **'Yemen'**
  String get ye;

  /// Display name for Zambia
  ///
  /// In en, this message translates to:
  /// **'Zambia'**
  String get zm;

  /// Display name for Zimbabwe
  ///
  /// In en, this message translates to:
  /// **'Zimbabwe'**
  String get zw;

  /// User's chosen username.
  ///
  /// In en, this message translates to:
  /// **'Username'**
  String get username;

  /// User's chosen password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// User's chosen new password.
  ///
  /// In en, this message translates to:
  /// **'New Password'**
  String get newPassword;

  /// User's preferred e-mail address.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// User's preferred telephone number.
  ///
  /// In en, this message translates to:
  /// **'Phone Number'**
  String get phoneNumber;

  /// The code sent to the user's phone number or email address for verification.
  ///
  /// In en, this message translates to:
  /// **'Verification Code'**
  String get verificationCode;

  /// User's preferred postal address.
  ///
  /// In en, this message translates to:
  /// **'Address'**
  String get address;

  /// User's birthday, represented as an ISO 8601:2004 [ISO8601‑2004] YYYY-MM-DD format.
  ///
  /// In en, this message translates to:
  /// **'Birthdate'**
  String get birthdate;

  /// Surname(s) or last name(s) of the user.
  ///
  /// In en, this message translates to:
  /// **'Family Name'**
  String get familyName;

  /// Middle name(s) of the user.
  ///
  /// In en, this message translates to:
  /// **'Middle Name'**
  String get middleName;

  /// User's gender.
  ///
  /// In en, this message translates to:
  /// **'Gender'**
  String get gender;

  /// No description provided for @genders.
  ///
  /// In en, this message translates to:
  /// **'{gender, select, male{male} female{female} other{other}}'**
  String genders(String gender);

  /// Given name(s) or first name(s) of the user.
  ///
  /// In en, this message translates to:
  /// **'Given Name'**
  String get givenName;

  /// User's full name in displayable form including all name parts, possibly including titles and suffixes, ordered according to the user's locale and preferences.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get name;

  /// Casual name of the user that may or may not be the same as their given name.
  ///
  /// In en, this message translates to:
  /// **'Nickname'**
  String get nickname;

  /// One or the other
  ///
  /// In en, this message translates to:
  /// **'{a} or {b}'**
  String or(String a, String b);

  /// Shorthand name by which the user wishes to be referred to.
  ///
  /// In en, this message translates to:
  /// **'Preferred Username'**
  String get preferredUsername;

  /// Warning for a required field was left empty, displayed as an error to the user.
  ///
  /// In en, this message translates to:
  /// **'{attribute} field must not be blank.'**
  String warnEmpty(String attribute);

  /// Warning for field that has failed format validation.
  ///
  /// In en, this message translates to:
  /// **'Invalid {attributeType} format.'**
  String warnInvalidFormat(String attributeType);

  /// Prompt to fill an optional or required input field, used as the placeholder for text fields.
  ///
  /// In en, this message translates to:
  /// **'Enter your {attribute}'**
  String promptFill(String attribute);

  /// Prompt to refill an optional or required input field, used as the placeholder for text fields.
  ///
  /// In en, this message translates to:
  /// **'Re-enter your {attribute}'**
  String promptRefill(String attribute);

  /// Title to re-enter an optional or required input field, used as the label for text fields.
  ///
  /// In en, this message translates to:
  /// **'Confirm {attribute}'**
  String confirmAttribute(String attribute);

  /// Warning for when username requirements are not met.
  ///
  /// In en, this message translates to:
  /// **'Username must only contain alphanumeric characters and symbols.'**
  String get usernameRequirements;

  /// Preamble to list of unment password requirements.
  ///
  /// In en, this message translates to:
  /// **'Password must include:'**
  String get passwordRequirementsPreamble;

  /// Character(s) in a password.
  ///
  /// In en, this message translates to:
  /// **' {characterType, select, requiresUppercase{uppercase} requiresLowercase{lowercase} requiresNumbers{number} requiresSymbols{symbol} other{}}'**
  String passwordRequirementsCharacterType(String characterType);

  /// Password uppercase character requirement, displayed as a bullet point in list of unmet requirements.
  ///
  /// In en, this message translates to:
  /// **'at least {numCharacters, plural, =1{1{characterType} character} other{{numCharacters}{characterType} characters}}'**
  String passwordRequirementsAtLeast(int numCharacters, String characterType);

  /// Message for conflicting password and confirm password fields.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match.'**
  String get passwordsDoNotMatch;

  /// Label for the checkbox to remember the user's device in Cognito.
  ///
  /// In en, this message translates to:
  /// **'Remember Device?'**
  String get rememberDevice;

  /// Label for the toggle buttons to select email or phone number as username when both are available.
  ///
  /// In en, this message translates to:
  /// **'Log in using:'**
  String get usernameType;

  /// Indicator for a field which is not required to be filled
  ///
  /// In en, this message translates to:
  /// **'{fieldTitle} (optional)'**
  String optional(String fieldTitle);

  /// The answer to the custom auth challenge
  ///
  /// In en, this message translates to:
  /// **'Confirmation Code'**
  String get customChallenge;

  /// Label for the radio button to select SMS as the user's chosen MFA method..
  ///
  /// In en, this message translates to:
  /// **'Text Message (SMS)'**
  String get selectSms;

  /// Label for the radio button to select TOTP as the user's chosen MFA method.
  ///
  /// In en, this message translates to:
  /// **'Authenticator App (TOTP)'**
  String get selectTotp;

  /// The instructional text for submitting a TOTP pass code
  ///
  /// In en, this message translates to:
  /// **'Please enter the code from your registered Authenticator app'**
  String get totpCodePrompt;

  /// Label for the radio button to select email as the user's chosen MFA method.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get selectEmail;

  /// The message that is displayed after a new confirmation code is sent via Email/SMS.
  ///
  /// In en, this message translates to:
  /// **'A confirmation code has been sent to {destination}.'**
  String codeSent(String destination);

  /// The message that is displayed after a new confirmation code is sent via an unknown delivery medium
  ///
  /// In en, this message translates to:
  /// **'A confirmation code has been sent.'**
  String get codeSentUnknown;

  /// The message that is displayed after a value was copied to the clipboard
  ///
  /// In en, this message translates to:
  /// **'Copied to clipboard!'**
  String get copySucceeded;

  /// The message that is displayed after a value failed to copy to the clipboard
  ///
  /// In en, this message translates to:
  /// **'Copy to clipboard failed.'**
  String get copyFailed;

  /// The title for the first step of TOTP setup
  ///
  /// In en, this message translates to:
  /// **'Step 1: Download an Authenticator app'**
  String get totpStep1Title;

  /// The title for the second step of TOTP setup
  ///
  /// In en, this message translates to:
  /// **'Step 2: Scan the QR code'**
  String get totpStep2Title;

  /// The title for the third step of TOTP setup
  ///
  /// In en, this message translates to:
  /// **'Step 3: Verify your code'**
  String get totpStep3Title;

  /// The body text for step one of TOTP setup
  ///
  /// In en, this message translates to:
  /// **'Authenticator apps generate one-time codes that can be used to verify your identity'**
  String get totpStep1Body;

  /// The body text for step two of TOTP setup
  ///
  /// In en, this message translates to:
  /// **'Open then Authenticator app and scan the QR code or enter the key to get your verification code'**
  String get totpStep2Body;

  /// The body text for step three of TOTP setup
  ///
  /// In en, this message translates to:
  /// **'Enter the 6 digit code from your Authenticator app'**
  String get totpStep3Body;

  /// Title of the Confirm Sign Up step and form
  ///
  /// In en, this message translates to:
  /// **'Enter your confirmation code'**
  String get confirmSignUp;

  /// Title of the Confirm Sign In with MFA step and form
  ///
  /// In en, this message translates to:
  /// **'Enter your sign in code'**
  String get confirmSignInMfa;

  /// Title of the Confirm Sign In with Custom Auth step and form
  ///
  /// In en, this message translates to:
  /// **'Enter your sign in code'**
  String get confirmSignInCustomAuth;

  /// Title of the Confirm Sign In with New Password step and form
  ///
  /// In en, this message translates to:
  /// **'Change your password to sign in'**
  String get confirmSignInNewPassword;

  /// Title of the SignIn with MFA selection step and form
  ///
  /// In en, this message translates to:
  /// **'Select your preferred Two-Factor Auth method'**
  String get continueSignInWithMfaSelection;

  /// Title of the SignIn with TOTP setup step and form
  ///
  /// In en, this message translates to:
  /// **'Enable Two-Factor Auth'**
  String get continueSignInWithTotpSetup;

  /// Title of the Confirm Sign In with Totp MFA Code step and form
  ///
  /// In en, this message translates to:
  /// **'Enter your one-time passcode'**
  String get confirmSignInWithTotpMfaCode;

  /// Title of the Reset Password step and form
  ///
  /// In en, this message translates to:
  /// **'Send Code'**
  String get resetPassword;

  /// Title of the Verify and Confirm Verify User s and forms
  ///
  /// In en, this message translates to:
  /// **'Account recovery requires verified contact information'**
  String get verifyUser;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['en', 'it'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en': return AppLocalizationsEn();
    case 'it': return AppLocalizationsIt();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}

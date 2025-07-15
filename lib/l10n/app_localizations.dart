import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_pt.dart';

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
    Locale('es'),
    Locale('pt')
  ];

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @forgot_your_password.
  ///
  /// In en, this message translates to:
  /// **'Forgot your password?'**
  String get forgot_your_password;

  /// No description provided for @register.
  ///
  /// In en, this message translates to:
  /// **'Register'**
  String get register;

  /// No description provided for @logged_in_successfully.
  ///
  /// In en, this message translates to:
  /// **'Logged in successfully!'**
  String get logged_in_successfully;

  /// No description provided for @warning.
  ///
  /// In en, this message translates to:
  /// **'Warning'**
  String get warning;

  /// No description provided for @yes.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get yes;

  /// No description provided for @no.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get no;

  /// No description provided for @account.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get account;

  /// No description provided for @account_creation.
  ///
  /// In en, this message translates to:
  /// **'Account creation'**
  String get account_creation;

  /// No description provided for @last_sign_in.
  ///
  /// In en, this message translates to:
  /// **'Last sign in'**
  String get last_sign_in;

  /// No description provided for @exit.
  ///
  /// In en, this message translates to:
  /// **'Exit'**
  String get exit;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @transport_type_car.
  ///
  /// In en, this message translates to:
  /// **'Car'**
  String get transport_type_car;

  /// No description provided for @transport_type_bike.
  ///
  /// In en, this message translates to:
  /// **'Bike'**
  String get transport_type_bike;

  /// No description provided for @transport_type_bus.
  ///
  /// In en, this message translates to:
  /// **'Bus'**
  String get transport_type_bus;

  /// No description provided for @transport_type_plane.
  ///
  /// In en, this message translates to:
  /// **'Plane'**
  String get transport_type_plane;

  /// No description provided for @transport_type_cruise.
  ///
  /// In en, this message translates to:
  /// **'Cruise'**
  String get transport_type_cruise;

  /// No description provided for @experience_cultural_immersion.
  ///
  /// In en, this message translates to:
  /// **'Cultural Immersion'**
  String get experience_cultural_immersion;

  /// No description provided for @experience_alternative_cuisines.
  ///
  /// In en, this message translates to:
  /// **'Alternative Cuisines'**
  String get experience_alternative_cuisines;

  /// No description provided for @experience_historical_places.
  ///
  /// In en, this message translates to:
  /// **'Visit Historical Places'**
  String get experience_historical_places;

  /// No description provided for @experience_visit_local_establishments.
  ///
  /// In en, this message translates to:
  /// **'Visit Local Establishments (Bars, Restaurants, Parks, etc.)'**
  String get experience_visit_local_establishments;

  /// No description provided for @experience_contact_with_nature.
  ///
  /// In en, this message translates to:
  /// **'Contact With Nature'**
  String get experience_contact_with_nature;

  /// No description provided for @title_home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get title_home;

  /// No description provided for @title_register_travel.
  ///
  /// In en, this message translates to:
  /// **'Register Travel'**
  String get title_register_travel;

  /// No description provided for @title_settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get title_settings;

  /// No description provided for @travel_title_label.
  ///
  /// In en, this message translates to:
  /// **'Travel Title'**
  String get travel_title_label;

  /// No description provided for @transport_type_label.
  ///
  /// In en, this message translates to:
  /// **'Transport Type'**
  String get transport_type_label;

  /// No description provided for @experiences_label.
  ///
  /// In en, this message translates to:
  /// **'Experiences'**
  String get experiences_label;

  /// No description provided for @select_dates_label.
  ///
  /// In en, this message translates to:
  /// **'Select dates'**
  String get select_dates_label;

  /// No description provided for @travel_start_date_label.
  ///
  /// In en, this message translates to:
  /// **'Travel Start Date'**
  String get travel_start_date_label;

  /// No description provided for @travel_end_date_label.
  ///
  /// In en, this message translates to:
  /// **'Travel End Date'**
  String get travel_end_date_label;

  /// No description provided for @err_invalid_date_snackbar.
  ///
  /// In en, this message translates to:
  /// **'You must select a start date first!'**
  String get err_invalid_date_snackbar;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['en', 'es', 'pt'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en': return AppLocalizationsEn();
    case 'es': return AppLocalizationsEs();
    case 'pt': return AppLocalizationsPt();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}

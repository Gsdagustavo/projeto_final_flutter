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

  /// No description provided for @insert_your_email.
  ///
  /// In en, this message translates to:
  /// **'Insert your email'**
  String get insert_your_email;

  /// No description provided for @send_recovery_code.
  ///
  /// In en, this message translates to:
  /// **'Send recovery code'**
  String get send_recovery_code;

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

  /// No description provided for @account_created_successfully.
  ///
  /// In en, this message translates to:
  /// **'Account created successfully!'**
  String get account_created_successfully;

  /// No description provided for @register_login.
  ///
  /// In en, this message translates to:
  /// **'Would you want to login?'**
  String get register_login;

  /// No description provided for @recovery_code_sent_to.
  ///
  /// In en, this message translates to:
  /// **'Recovery code sent to'**
  String get recovery_code_sent_to;

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

  /// No description provided for @travel_stop_type_start.
  ///
  /// In en, this message translates to:
  /// **'Start'**
  String get travel_stop_type_start;

  /// No description provided for @travel_stop_type_stop.
  ///
  /// In en, this message translates to:
  /// **'Stop'**
  String get travel_stop_type_stop;

  /// No description provided for @travel_stop_type_end.
  ///
  /// In en, this message translates to:
  /// **'End'**
  String get travel_stop_type_end;

  /// No description provided for @experience.
  ///
  /// In en, this message translates to:
  /// **'Experience'**
  String get experience;

  /// No description provided for @experiences.
  ///
  /// In en, this message translates to:
  /// **'Experiences'**
  String get experiences;

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

  /// No description provided for @my_travels.
  ///
  /// In en, this message translates to:
  /// **'My Travels'**
  String get my_travels;

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

  /// No description provided for @title_map_select_travel_stops.
  ///
  /// In en, this message translates to:
  /// **'Select Travel Stops'**
  String get title_map_select_travel_stops;

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

  /// No description provided for @participants.
  ///
  /// In en, this message translates to:
  /// **'Participants'**
  String get participants;

  /// No description provided for @no_participants_on_the_list.
  ///
  /// In en, this message translates to:
  /// **'No participants on the list'**
  String get no_participants_on_the_list;

  /// No description provided for @register_participant.
  ///
  /// In en, this message translates to:
  /// **'Register participant'**
  String get register_participant;

  /// No description provided for @name.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get name;

  /// No description provided for @age.
  ///
  /// In en, this message translates to:
  /// **'Age'**
  String get age;

  /// No description provided for @participant_registered.
  ///
  /// In en, this message translates to:
  /// **'Participant registered'**
  String get participant_registered;

  /// No description provided for @remove_participant_confirmation.
  ///
  /// In en, this message translates to:
  /// **'Would you really want to remove the participant?'**
  String get remove_participant_confirmation;

  /// No description provided for @remove_participant.
  ///
  /// In en, this message translates to:
  /// **'Remove participant'**
  String get remove_participant;

  /// No description provided for @participant_removed.
  ///
  /// In en, this message translates to:
  /// **'Participant removed'**
  String get participant_removed;

  /// No description provided for @travel_map.
  ///
  /// In en, this message translates to:
  /// **'Travel Map'**
  String get travel_map;

  /// No description provided for @add_stops_for_your_travel.
  ///
  /// In en, this message translates to:
  /// **'Add Stops for Your Travel'**
  String get add_stops_for_your_travel;

  /// No description provided for @invalid_travel_data.
  ///
  /// In en, this message translates to:
  /// **'Invalid Travel Data'**
  String get invalid_travel_data;

  /// No description provided for @travel_registered_successfully.
  ///
  /// In en, this message translates to:
  /// **'Your Travel was successfully registered!'**
  String get travel_registered_successfully;

  /// No description provided for @travel_stop.
  ///
  /// In en, this message translates to:
  /// **'Travel Stop'**
  String get travel_stop;

  /// No description provided for @travel_start_location.
  ///
  /// In en, this message translates to:
  /// **'Travel Start Location'**
  String get travel_start_location;

  /// No description provided for @travel_end_location.
  ///
  /// In en, this message translates to:
  /// **'Travel End Location'**
  String get travel_end_location;

  /// No description provided for @register_stop.
  ///
  /// In en, this message translates to:
  /// **'Register Stop'**
  String get register_stop;

  /// No description provided for @stop_registered_successfully.
  ///
  /// In en, this message translates to:
  /// **'Stop registered successfully!'**
  String get stop_registered_successfully;

  /// No description provided for @err_register_stop.
  ///
  /// In en, this message translates to:
  /// **'An error occurred while trying to register the stop'**
  String get err_register_stop;

  /// No description provided for @update_stop.
  ///
  /// In en, this message translates to:
  /// **'Update Stop'**
  String get update_stop;

  /// No description provided for @stop_updated_successfully.
  ///
  /// In en, this message translates to:
  /// **'Stop updated successfully!'**
  String get stop_updated_successfully;

  /// No description provided for @arrive_date.
  ///
  /// In en, this message translates to:
  /// **'ArriveDate'**
  String get arrive_date;

  /// No description provided for @leave_date.
  ///
  /// In en, this message translates to:
  /// **'Leave Date'**
  String get leave_date;

  /// No description provided for @err_you_must_select_arrive_date_first.
  ///
  /// In en, this message translates to:
  /// **'You must select the Arrive Date first!'**
  String get err_you_must_select_arrive_date_first;

  /// No description provided for @finish.
  ///
  /// In en, this message translates to:
  /// **'Finish'**
  String get finish;

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

  /// No description provided for @warning.
  ///
  /// In en, this message translates to:
  /// **'Warning'**
  String get warning;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @remove.
  ///
  /// In en, this message translates to:
  /// **'Remove'**
  String get remove;

  /// No description provided for @unknown_error.
  ///
  /// In en, this message translates to:
  /// **'Unknown error'**
  String get unknown_error;
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

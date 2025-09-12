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

  /// No description provided for @language_en.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get language_en;

  /// No description provided for @language_pt.
  ///
  /// In en, this message translates to:
  /// **'Português'**
  String get language_pt;

  /// No description provided for @language_es.
  ///
  /// In en, this message translates to:
  /// **'Español'**
  String get language_es;

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

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

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
  /// **'Recovery code sent to {email}'**
  String recovery_code_sent_to(Object email);

  /// No description provided for @invalid_email.
  ///
  /// In en, this message translates to:
  /// **'Invalid email'**
  String get invalid_email;

  /// No description provided for @invalid_password.
  ///
  /// In en, this message translates to:
  /// **'Invalid password'**
  String get invalid_password;

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

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// No description provided for @logout_confirmation.
  ///
  /// In en, this message translates to:
  /// **'Do you really want to logout?'**
  String get logout_confirmation;

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
  /// **'Visit Local Establishments'**
  String get experience_visit_local_establishments;

  /// No description provided for @experience_contact_with_nature.
  ///
  /// In en, this message translates to:
  /// **'Contact With Nature'**
  String get experience_contact_with_nature;

  /// No description provided for @experience_social_events.
  ///
  /// In en, this message translates to:
  /// **'Social Events'**
  String get experience_social_events;

  /// No description provided for @other.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get other;

  /// No description provided for @upcoming.
  ///
  /// In en, this message translates to:
  /// **'Upcoming'**
  String get upcoming;

  /// No description provided for @ongoing.
  ///
  /// In en, this message translates to:
  /// **'Ongoing'**
  String get ongoing;

  /// No description provided for @finished.
  ///
  /// In en, this message translates to:
  /// **'Finished'**
  String get finished;

  /// No description provided for @invalid_title.
  ///
  /// In en, this message translates to:
  /// **'Invalid travel title'**
  String get invalid_title;

  /// No description provided for @not_enough_stops.
  ///
  /// In en, this message translates to:
  /// **'Travel must contain at least 2 stops'**
  String get not_enough_stops;

  /// No description provided for @no_participants.
  ///
  /// In en, this message translates to:
  /// **'Travel must contain at least 1 participant'**
  String get no_participants;

  /// No description provided for @invalid_participant_data.
  ///
  /// In en, this message translates to:
  /// **'Invalid participant data'**
  String get invalid_participant_data;

  /// No description provided for @invalid_stop_dates.
  ///
  /// In en, this message translates to:
  /// **'Invalid stops dates'**
  String get invalid_stop_dates;

  /// No description provided for @my_travels.
  ///
  /// In en, this message translates to:
  /// **'My Travels'**
  String get my_travels;

  /// No description provided for @start_travel.
  ///
  /// In en, this message translates to:
  /// **'Start Travel'**
  String get start_travel;

  /// No description provided for @start_travel_confirmation.
  ///
  /// In en, this message translates to:
  /// **'Start Travel {travel}?'**
  String start_travel_confirmation(Object travel);

  /// No description provided for @travel_started_successfully.
  ///
  /// In en, this message translates to:
  /// **'Travel Started Successfully!'**
  String get travel_started_successfully;

  /// No description provided for @travel_has_already_started.
  ///
  /// In en, this message translates to:
  /// **'This travel has already been started'**
  String get travel_has_already_started;

  /// No description provided for @finish_travel.
  ///
  /// In en, this message translates to:
  /// **'Finish Travel'**
  String get finish_travel;

  /// No description provided for @finish_travel_confirmation.
  ///
  /// In en, this message translates to:
  /// **'Finish Travel {travel}?'**
  String finish_travel_confirmation(Object travel);

  /// No description provided for @travel_already_finished.
  ///
  /// In en, this message translates to:
  /// **'This travel has already been finished'**
  String get travel_already_finished;

  /// No description provided for @travel_finished_successfully.
  ///
  /// In en, this message translates to:
  /// **'Travel Finished Successfully!'**
  String get travel_finished_successfully;

  /// No description provided for @travel_not_started_yet.
  ///
  /// In en, this message translates to:
  /// **'This travel has not started yet'**
  String get travel_not_started_yet;

  /// No description provided for @delete_travel.
  ///
  /// In en, this message translates to:
  /// **'Delete Travel'**
  String get delete_travel;

  /// No description provided for @delete_travel_confirmation.
  ///
  /// In en, this message translates to:
  /// **'Do you really want to delete the travel {travel}?'**
  String delete_travel_confirmation(Object travel);

  /// No description provided for @travel_deleted_successfully.
  ///
  /// In en, this message translates to:
  /// **'Travel Deleted Successfully!'**
  String get travel_deleted_successfully;

  /// No description provided for @view_travel_route.
  ///
  /// In en, this message translates to:
  /// **'View Travel Route'**
  String get view_travel_route;

  /// No description provided for @stop.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{{count} Stop} other{{count} Stops}}'**
  String stop(num count);

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

  /// No description provided for @travel_details.
  ///
  /// In en, this message translates to:
  /// **'Travel Details'**
  String get travel_details;

  /// No description provided for @enter_travel_title.
  ///
  /// In en, this message translates to:
  /// **'Enter travel title...'**
  String get enter_travel_title;

  /// No description provided for @invalid_travel_title.
  ///
  /// In en, this message translates to:
  /// **'Invalid travel title'**
  String get invalid_travel_title;

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

  /// No description provided for @dates_label.
  ///
  /// In en, this message translates to:
  /// **'Dates'**
  String get dates_label;

  /// No description provided for @select_dates_label.
  ///
  /// In en, this message translates to:
  /// **'Select dates'**
  String get select_dates_label;

  /// No description provided for @start_date.
  ///
  /// In en, this message translates to:
  /// **'Start Date'**
  String get start_date;

  /// No description provided for @end_date.
  ///
  /// In en, this message translates to:
  /// **'End Date'**
  String get end_date;

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

  /// No description provided for @err_invalid_participant_name.
  ///
  /// In en, this message translates to:
  /// **'Invalid participant name'**
  String get err_invalid_participant_name;

  /// No description provided for @err_invalid_participant_age.
  ///
  /// In en, this message translates to:
  /// **'Invalid participant age'**
  String get err_invalid_participant_age;

  /// No description provided for @err_invalid_participant_data.
  ///
  /// In en, this message translates to:
  /// **'Invalid participant data'**
  String get err_invalid_participant_data;

  /// No description provided for @no_participants_registered.
  ///
  /// In en, this message translates to:
  /// **'No participants registered'**
  String get no_participants_registered;

  /// No description provided for @add_participant.
  ///
  /// In en, this message translates to:
  /// **'Add participant'**
  String get add_participant;

  /// No description provided for @update_participant.
  ///
  /// In en, this message translates to:
  /// **'Update participant'**
  String get update_participant;

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

  /// No description provided for @participant_added.
  ///
  /// In en, this message translates to:
  /// **'Participant added!'**
  String get participant_added;

  /// No description provided for @remove_participant.
  ///
  /// In en, this message translates to:
  /// **'Remove participant'**
  String get remove_participant;

  /// No description provided for @remove_participant_confirmation.
  ///
  /// In en, this message translates to:
  /// **'Would you really want to remove the participant {participant}?'**
  String remove_participant_confirmation(Object participant);

  /// No description provided for @participant_removed.
  ///
  /// In en, this message translates to:
  /// **'Participant {participant} removed successfully!'**
  String participant_removed(Object participant);

  /// No description provided for @participant_updated.
  ///
  /// In en, this message translates to:
  /// **'Participant updated'**
  String get participant_updated;

  /// No description provided for @err_could_not_add_participant.
  ///
  /// In en, this message translates to:
  /// **'Could not add participant'**
  String get err_could_not_add_participant;

  /// No description provided for @remove_stop.
  ///
  /// In en, this message translates to:
  /// **'Remove Travel Stop'**
  String get remove_stop;

  /// No description provided for @stop_added.
  ///
  /// In en, this message translates to:
  /// **'Travel Stop added successfully!'**
  String get stop_added;

  /// No description provided for @travel_stop_removed.
  ///
  /// In en, this message translates to:
  /// **'Travel Stop removed successfully!'**
  String get travel_stop_removed;

  /// No description provided for @err_invalid_leave_date.
  ///
  /// In en, this message translates to:
  /// **'Invalid leave date'**
  String get err_invalid_leave_date;

  /// No description provided for @add_stop.
  ///
  /// In en, this message translates to:
  /// **'Add Travel Stop'**
  String get add_stop;

  /// No description provided for @remove_stop_confirmation.
  ///
  /// In en, this message translates to:
  /// **'Do you really want to remove this stop?'**
  String get remove_stop_confirmation;

  /// No description provided for @planned_experiences.
  ///
  /// In en, this message translates to:
  /// **'Planned Experiences'**
  String get planned_experiences;

  /// No description provided for @err_register_travel_generic.
  ///
  /// In en, this message translates to:
  /// **'An error occurred while registering the travel'**
  String get err_register_travel_generic;

  /// No description provided for @long_press_to_add_stops.
  ///
  /// In en, this message translates to:
  /// **'Long press to add stops'**
  String get long_press_to_add_stops;

  /// No description provided for @travel_map.
  ///
  /// In en, this message translates to:
  /// **'Travel Map'**
  String get travel_map;

  /// No description provided for @open_map.
  ///
  /// In en, this message translates to:
  /// **'Open Map'**
  String get open_map;

  /// No description provided for @route_planning.
  ///
  /// In en, this message translates to:
  /// **'Route Planning'**
  String get route_planning;

  /// No description provided for @route_planning_label.
  ///
  /// In en, this message translates to:
  /// **'Plan your travel route and stops'**
  String get route_planning_label;

  /// No description provided for @registered_stops.
  ///
  /// In en, this message translates to:
  /// **'Registered Stops'**
  String get registered_stops;

  /// No description provided for @no_stops_registered.
  ///
  /// In en, this message translates to:
  /// **'No stops registered yet. Use the map to plan your route across different cities and countries'**
  String get no_stops_registered;

  /// No description provided for @use_the_map_add_waypoints.
  ///
  /// In en, this message translates to:
  /// **'Use the map to modify your route or to add more stops'**
  String get use_the_map_add_waypoints;

  /// No description provided for @travel_photos.
  ///
  /// In en, this message translates to:
  /// **'Travel Photos'**
  String get travel_photos;

  /// No description provided for @add_travel_photos.
  ///
  /// In en, this message translates to:
  /// **'Add Travel Photos'**
  String get add_travel_photos;

  /// No description provided for @tap_select_photos.
  ///
  /// In en, this message translates to:
  /// **'Tap to select photos'**
  String get tap_select_photos;

  /// No description provided for @photos_selected.
  ///
  /// In en, this message translates to:
  /// **'photos selected'**
  String get photos_selected;

  /// No description provided for @choose_photos.
  ///
  /// In en, this message translates to:
  /// **'Choose Photos'**
  String get choose_photos;

  /// No description provided for @add_photos_label.
  ///
  /// In en, this message translates to:
  /// **'Add photos to make your travel more memorable and visually appealing'**
  String get add_photos_label;

  /// No description provided for @travel_photo_added.
  ///
  /// In en, this message translates to:
  /// **'Travel photo added'**
  String get travel_photo_added;

  /// No description provided for @could_not_add_travel_photo.
  ///
  /// In en, this message translates to:
  /// **'Could not add travel photo'**
  String get could_not_add_travel_photo;

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

  /// No description provided for @search_for_places.
  ///
  /// In en, this message translates to:
  /// **'Search for places'**
  String get search_for_places;

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
  /// **'Arrive Date'**
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

  /// No description provided for @err_pdf_generation.
  ///
  /// In en, this message translates to:
  /// **'An unexpected error occurred while trying to generate the Travel PDF'**
  String get err_pdf_generation;

  /// No description provided for @duration.
  ///
  /// In en, this message translates to:
  /// **'Duration'**
  String get duration;

  /// No description provided for @days.
  ///
  /// In en, this message translates to:
  /// **'days'**
  String get days;

  /// No description provided for @transport.
  ///
  /// In en, this message translates to:
  /// **'Transport'**
  String get transport;

  /// No description provided for @countries.
  ///
  /// In en, this message translates to:
  /// **'Countries'**
  String get countries;

  /// No description provided for @travel_dates.
  ///
  /// In en, this message translates to:
  /// **'Travel Dates'**
  String get travel_dates;

  /// No description provided for @start.
  ///
  /// In en, this message translates to:
  /// **'Start'**
  String get start;

  /// No description provided for @end.
  ///
  /// In en, this message translates to:
  /// **'End'**
  String get end;

  /// No description provided for @travel_route.
  ///
  /// In en, this message translates to:
  /// **'Travel Route'**
  String get travel_route;

  /// No description provided for @travel_title_updated.
  ///
  /// In en, this message translates to:
  /// **'Travel title updated'**
  String get travel_title_updated;

  /// No description provided for @travel_title.
  ///
  /// In en, this message translates to:
  /// **'Travel Title'**
  String get travel_title;

  /// No description provided for @review.
  ///
  /// In en, this message translates to:
  /// **'Review'**
  String get review;

  /// No description provided for @reviews.
  ///
  /// In en, this message translates to:
  /// **'Reviews'**
  String get reviews;

  /// No description provided for @detail_review.
  ///
  /// In en, this message translates to:
  /// **'Detail Review'**
  String get detail_review;

  /// No description provided for @give_a_review.
  ///
  /// In en, this message translates to:
  /// **'Give a Review'**
  String get give_a_review;

  /// No description provided for @send_review.
  ///
  /// In en, this message translates to:
  /// **'Send Review'**
  String get send_review;

  /// No description provided for @add_photo.
  ///
  /// In en, this message translates to:
  /// **'Add Photo'**
  String get add_photo;

  /// No description provided for @no_reviews.
  ///
  /// In en, this message translates to:
  /// **'No reviews yet!'**
  String get no_reviews;

  /// No description provided for @based_on_reviews.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{Based on 1 review} other{Based on {count} reviews}}'**
  String based_on_reviews(num count);

  /// No description provided for @error_review.
  ///
  /// In en, this message translates to:
  /// **'An error has occurred while registering the review'**
  String get error_review;

  /// No description provided for @remove_review.
  ///
  /// In en, this message translates to:
  /// **'Remove review'**
  String get remove_review;

  /// No description provided for @remove_review_confirmation.
  ///
  /// In en, this message translates to:
  /// **'Do you really want to remove this review?'**
  String get remove_review_confirmation;

  /// No description provided for @err_invalid_review_data.
  ///
  /// In en, this message translates to:
  /// **'Invalid review data'**
  String get err_invalid_review_data;

  /// No description provided for @err_invalid_review_author.
  ///
  /// In en, this message translates to:
  /// **'Invalid review author'**
  String get err_invalid_review_author;

  /// No description provided for @review_registered.
  ///
  /// In en, this message translates to:
  /// **'Review registered successfully!'**
  String get review_registered;

  /// No description provided for @share_your_travel.
  ///
  /// In en, this message translates to:
  /// **'Share your travel'**
  String get share_your_travel;

  /// No description provided for @delete_review.
  ///
  /// In en, this message translates to:
  /// **'Delete Review'**
  String get delete_review;

  /// No description provided for @delete_review_confirmation.
  ///
  /// In en, this message translates to:
  /// **'Do you really want to delete this review?'**
  String get delete_review_confirmation;

  /// No description provided for @review_deleted_successfully.
  ///
  /// In en, this message translates to:
  /// **'Review Deleted Successfully!'**
  String get review_deleted_successfully;

  /// No description provided for @review_requires_content.
  ///
  /// In en, this message translates to:
  /// **'You must add at least one image or write a description before submitting your review. Reviews cannot be empty.'**
  String get review_requires_content;

  /// No description provided for @success.
  ///
  /// In en, this message translates to:
  /// **'Success!'**
  String get success;

  /// No description provided for @great.
  ///
  /// In en, this message translates to:
  /// **'Great!'**
  String get great;

  /// No description provided for @error_occurred.
  ///
  /// In en, this message translates to:
  /// **'Error Occurred'**
  String get error_occurred;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @sign_out_question.
  ///
  /// In en, this message translates to:
  /// **'Sign Out?'**
  String get sign_out_question;

  /// No description provided for @sign_out_confirmation.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to sign out? You\'ll need to sign in again to access your travels'**
  String get sign_out_confirmation;

  /// No description provided for @sign_out.
  ///
  /// In en, this message translates to:
  /// **'Sign Out'**
  String get sign_out;

  /// No description provided for @stay_signed_in.
  ///
  /// In en, this message translates to:
  /// **'Stay Signed In'**
  String get stay_signed_in;

  /// No description provided for @no_internet.
  ///
  /// In en, this message translates to:
  /// **'No Internet Connection'**
  String get no_internet;

  /// No description provided for @no_internet_message.
  ///
  /// In en, this message translates to:
  /// **'You\'re currently offline. Some features may not be available until you reconnect to the internet'**
  String get no_internet_message;

  /// No description provided for @try_again.
  ///
  /// In en, this message translates to:
  /// **'Try Again'**
  String get try_again;

  /// No description provided for @continue_offline.
  ///
  /// In en, this message translates to:
  /// **'Continue Offline'**
  String get continue_offline;

  /// No description provided for @travel_phrase_intro.
  ///
  /// In en, this message translates to:
  /// **'A journey is not measured in miles, but in moments.'**
  String get travel_phrase_intro;

  /// No description provided for @travel_phrase_body.
  ///
  /// In en, this message translates to:
  /// **'Each page of this booklet holds more than landscapes: it holds spontaneous smiles, unexpected discoveries, conversations that touched the soul, and silences that spoke louder than words.'**
  String get travel_phrase_body;

  /// No description provided for @document_generated_timestamp.
  ///
  /// In en, this message translates to:
  /// **'Document generated on {time}'**
  String document_generated_timestamp(Object time);

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

  /// No description provided for @ok.
  ///
  /// In en, this message translates to:
  /// **'Ok'**
  String get ok;

  /// No description provided for @continue_label.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continue_label;

  /// No description provided for @add.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get add;

  /// No description provided for @remove.
  ///
  /// In en, this message translates to:
  /// **'Remove'**
  String get remove;

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

  /// No description provided for @error.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get error;

  /// No description provided for @unknown_error.
  ///
  /// In en, this message translates to:
  /// **'Unknown error'**
  String get unknown_error;

  /// No description provided for @search.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get search;
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

// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get language_en => 'English';

  @override
  String get language_pt => 'Portuguese';

  @override
  String get language_es => 'Spanish';

  @override
  String get login => 'Login';

  @override
  String get password => 'Password';

  @override
  String get forgot_your_password => 'Forgot your password?';

  @override
  String get insert_your_email => 'Insert your email';

  @override
  String get send_recovery_code => 'Send recovery code';

  @override
  String get email => 'Email';

  @override
  String get register => 'Register';

  @override
  String get logged_in_successfully => 'Logged in successfully!';

  @override
  String get account_created_successfully => 'Account created successfully!';

  @override
  String get register_login => 'Would you want to login?';

  @override
  String recovery_code_sent_to(Object email) {
    return 'Recovery code sent to $email';
  }

  @override
  String get invalid_email => 'Invalid email';

  @override
  String get invalid_password => 'Invalid password';

  @override
  String get account => 'Account';

  @override
  String get account_creation => 'Account creation';

  @override
  String get last_sign_in => 'Last sign in';

  @override
  String get logout => 'Logout';

  @override
  String get logout_confirmation => 'Do you really want to logout?';

  @override
  String get language => 'Language';

  @override
  String get transport_type_car => 'Car';

  @override
  String get transport_type_bike => 'Bike';

  @override
  String get transport_type_bus => 'Bus';

  @override
  String get transport_type_plane => 'Plane';

  @override
  String get transport_type_cruise => 'Cruise';

  @override
  String get travel_stop_type_start => 'Start';

  @override
  String get travel_stop_type_stop => 'Stop';

  @override
  String get travel_stop_type_end => 'End';

  @override
  String get experience => 'Experience';

  @override
  String get experiences => 'Experiences';

  @override
  String get experience_cultural_immersion => 'Cultural Immersion';

  @override
  String get experience_alternative_cuisines => 'Alternative Cuisines';

  @override
  String get experience_historical_places => 'Visit Historical Places';

  @override
  String get experience_visit_local_establishments => 'Visit Local Establishments (Bars, Restaurants, Parks, etc.)';

  @override
  String get experience_contact_with_nature => 'Contact With Nature';

  @override
  String get experience_social_events => 'Social Events';

  @override
  String get other => 'Other';

  @override
  String get upcoming => 'Upcoming';

  @override
  String get ongoing => 'Ongoing';

  @override
  String get finished => 'Finished';

  @override
  String get my_travels => 'My Travels';

  @override
  String get start_travel => 'Start Travel';

  @override
  String get finish_travel => 'Finish Travel';

  @override
  String get finish_travel_confirm => 'Finish Travel?';

  @override
  String get delete_travel => 'Delete Travel';

  @override
  String delete_travel_confirmation(Object travel) {
    return 'Do you really want to delete the travel $travel?';
  }

  @override
  String get travel_deleted => 'Travel deleted successfully';

  @override
  String get view_travel_route => 'View Travel Route';

  @override
  String stop(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Stops',
      one: '$count Stop',
    );
    return '$_temp0';
  }

  @override
  String get title_home => 'Home';

  @override
  String get title_register_travel => 'Register Travel';

  @override
  String get title_settings => 'Settings';

  @override
  String get title_map_select_travel_stops => 'Select Travel Stops';

  @override
  String get travel_title_label => 'Travel Title';

  @override
  String get travel_details => 'Travel Details';

  @override
  String get enter_travel_title => 'Enter travel title...';

  @override
  String get invalid_travel_title => 'Invalid travel title';

  @override
  String get transport_type_label => 'Transport Type';

  @override
  String get experiences_label => 'Experiences';

  @override
  String get dates_label => 'Dates';

  @override
  String get select_dates_label => 'Select dates';

  @override
  String get start_date => 'Start Date';

  @override
  String get end_date => 'End Date';

  @override
  String get err_invalid_date_snackbar => 'You must select a start date first!';

  @override
  String get participants => 'Participants';

  @override
  String get err_invalid_participant_name => 'Invalid participant name';

  @override
  String get err_invalid_participant_age => 'Invalid participant age';

  @override
  String get err_invalid_participant_data => 'Invalid participant data';

  @override
  String get no_participants_on_the_list => 'No participants on the list';

  @override
  String get add_participant => 'Add participant';

  @override
  String get update_participant => 'Update participant';

  @override
  String get name => 'Name';

  @override
  String get age => 'Age';

  @override
  String get participant_added => 'Participant added!';

  @override
  String get remove_participant_confirmation => 'Would you really want to remove the participant';

  @override
  String get remove_participant => 'Remove participant';

  @override
  String get participant_removed => 'Participant removed';

  @override
  String get participant_updated => 'Participant updated';

  @override
  String get err_could_not_add_participant => 'Could not add participant';

  @override
  String get travel_map => 'Travel Map';

  @override
  String get open_map => 'Open Map';

  @override
  String get route_planning => 'Route Planning';

  @override
  String get route_planning_label => 'Plan your travel route and stops';

  @override
  String get registered_stops => 'Registered Stops';

  @override
  String get no_stops_registered => 'No stops registered yet. Use the map to plan your route across different cities and countries';

  @override
  String get use_the_map_add_waypoints => 'Use the map to modify your route or to add more stops';

  @override
  String get travel_photos => 'Travel Photos';

  @override
  String get add_travel_photos => 'Add Travel Photos';

  @override
  String get tap_select_photos => 'Tap to select photos';

  @override
  String get photos_selected => 'photos selected';

  @override
  String get choose_photos => 'Choose Photos';

  @override
  String get add_photos_label => 'Add photos to make your travel more memorable and visually appealing';

  @override
  String get invalid_travel_data => 'Invalid Travel Data';

  @override
  String get travel_registered_successfully => 'Your Travel was successfully registered!';

  @override
  String get travel_stop => 'Travel Stop';

  @override
  String get search_for_places => 'Search for places';

  @override
  String get travel_start_location => 'Travel Start Location';

  @override
  String get travel_end_location => 'Travel End Location';

  @override
  String get register_stop => 'Register Stop';

  @override
  String get stop_registered_successfully => 'Stop registered successfully!';

  @override
  String get err_register_stop => 'An error occurred while trying to register the stop';

  @override
  String get update_stop => 'Update Stop';

  @override
  String get stop_updated_successfully => 'Stop updated successfully!';

  @override
  String get arrive_date => 'Arrive Date';

  @override
  String get leave_date => 'Leave Date';

  @override
  String get err_you_must_select_arrive_date_first => 'You must select the Arrive Date first!';

  @override
  String get finish => 'Finish';

  @override
  String get duration => 'Duration';

  @override
  String get days => 'days';

  @override
  String get transport => 'Transport';

  @override
  String get countries => 'Countries';

  @override
  String get travel_dates => 'Travel Dates';

  @override
  String get start => 'Start';

  @override
  String get end => 'End';

  @override
  String get travel_route => 'Travel Route';

  @override
  String get travel_title_updated => 'Travel title updated';

  @override
  String get travel_title => 'Travel Title';

  @override
  String get review => 'Review';

  @override
  String get reviews => 'Reviews';

  @override
  String get detail_review => 'Detail Review';

  @override
  String get give_a_review => 'Give a Review';

  @override
  String get send_review => 'Send Review';

  @override
  String get add_photo => 'Add Photo';

  @override
  String get no_reviews => 'No reviews yet!';

  @override
  String based_on_reviews(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Based on $count reviews',
      one: 'Based on 1 review',
    );
    return '$_temp0';
  }

  @override
  String get error_review => 'An error has occurred while registering the review';

  @override
  String get remove_review => 'Remove review';

  @override
  String get remove_review_confirmation => 'Do you really want to remove this review?';

  @override
  String get err_invalid_review_data => 'Invalid review data';

  @override
  String get err_invalid_review_author => 'Invalid review author';

  @override
  String get review_registered => 'Review registered successfully!';

  @override
  String get yes => 'Yes';

  @override
  String get no => 'No';

  @override
  String get add => 'Add';

  @override
  String get remove => 'Remove';

  @override
  String get warning => 'Warning';

  @override
  String get cancel => 'Cancel';

  @override
  String get unknown_error => 'Unknown error';
}

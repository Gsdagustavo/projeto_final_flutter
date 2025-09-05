import 'package:intl/intl.dart';

/// Extension methods for the [DateTime] class
extension DateExtensions on DateTime {
  /// Returns a string representing the formatted date, in the MMM d format
  String getMonthDay(String locale) {
    final formatter = DateFormat('MMM d', locale);
    final formatted = formatter.format(this);
    return formatted[0].toUpperCase() + formatted.substring(1);
  }

  /// Returns a string representing the formatted date, in the EE, dd, MMMM
  /// format
  String getFormattedDate(String locale) {
    final formatter = DateFormat('EE, dd MMMM', locale);
    final formatted = formatter.format(this);
    return formatted[0].toUpperCase() + formatted.substring(1);
  }

  /// Returns a string representing the formatted date, in the EE, dd MMMM yyyy
  /// format
  String getFormattedDateWithYear(String locale) {
    final formatter = DateFormat('EE, dd MMMM yyyy', locale);
    final formatted = formatter.format(this);
    return formatted[0].toUpperCase() + formatted.substring(1);
  }

  /// Returns a string representing the formatted date, in the EEEE, dd MMMM
  /// yyyy format
  String getFullDate(String locale) {
    final formatter = DateFormat('EEEE, dd MMMM, yyyy', locale);
    final formatted = formatter.format(this);
    return formatted[0].toUpperCase() + formatted.substring(1);
  }
}

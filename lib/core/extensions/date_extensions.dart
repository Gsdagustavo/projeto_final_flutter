import 'package:intl/intl.dart';

extension DateExtensions on DateTime {
  String getMonthDay(String locale) {
    final formatter = DateFormat('MMM d', locale);
    final formatted = formatter.format(this);
    return formatted[0].toUpperCase() + formatted.substring(1);
  }

  String getFormattedDate(String locale) {
    final formatter = DateFormat('EE, dd MMMM', locale);
    final formatted = formatter.format(this);
    return formatted[0].toUpperCase() + formatted.substring(1);
  }

  String getFormattedDateWithYear(String locale) {
    final formatter = DateFormat('EE, dd MMMM yyyy', locale);
    final formatted = formatter.format(this);
    return formatted[0].toUpperCase() + formatted.substring(1);
  }
}

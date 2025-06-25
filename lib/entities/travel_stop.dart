class TravelStop {
  final String cityName;
  final double latitude;
  final double longitude;
  final DateTime arriveDate;
  final DateTime leaveDate;
  final Duration stayingTime;
  final String activities;

  TravelStop({
    required this.cityName,
    required this.latitude,
    required this.longitude,
    required this.arriveDate,
    required this.leaveDate,
    required this.stayingTime,
    required this.activities,
  });
}

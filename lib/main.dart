import 'package:flutter/cupertino.dart';
import 'package:projeto_final_flutter/ui/util/enums_extensions.dart';
import 'package:projeto_final_flutter/ui/widgets/my_app.dart';

import 'entities/enums.dart';
import 'entities/participant.dart';
import 'entities/travel.dart';
import 'entities/travel_stop.dart';

final travel = Travel(
  travelTitle: 'Exploração no Sul do Brasil',
  participants: [
    Participant(
      name: 'Gustavo Daniel',
      age: 16,
      profilePictureUrl: 'https://example.com/gustavo.jpg',
    ),
    Participant(name: 'Ana Clara', age: 17, profilePictureUrl: null),
  ],
  startTime: DateTime(2025, 7, 10),
  endTime: DateTime(2025, 7, 20),
  transportType: TransportType.plane,
  experiences: [Experience.cultureImmersion, Experience.visitHistoricalPlaces],
  stops: [
    TravelStop(
      cityName: 'Porto Alegre',
      latitude: -30.0346,
      longitude: -51.2177,
      arriveDate: DateTime(2025, 7, 10, 15),
      leaveDate: DateTime(2025, 7, 13, 10),
      stayingTime: Duration(days: 2, hours: 19),
      // total: 67h
      experiences: [
        Experience.visitLocalEstablishments,
        Experience.alternativeCuisines,
      ],
    ),
    TravelStop(
      cityName: 'Gramado',
      latitude: -29.3799,
      longitude: -50.8731,
      arriveDate: DateTime(2025, 7, 13, 14),
      leaveDate: DateTime(2025, 7, 16, 12),
      stayingTime: Duration(days: 2, hours: 22),
      // total: 70h
      experiences: [Experience.contactWithNature, Experience.cultureImmersion],
    ),
    TravelStop(
      cityName: 'Florianópolis',
      latitude: -27.5954,
      longitude: -48.5480,
      arriveDate: DateTime(2025, 7, 16, 18),
      leaveDate: DateTime(2025, 7, 20, 10),
      stayingTime: Duration(days: 3, hours: 16),
      // total: 88h
      experiences: [Experience.visitHistoricalPlaces],
    ),
  ],
);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // final db = await DBConnection().getDatabase();
  //
  // // await TravelTableController().insert(travel);
  // final res = await TravelTableController().select();
  // debugPrint(res.toString());
  //
  // final res2 = await db.rawQuery('select * from ${ParticipantsTravelTable.tableName}');
  // debugPrint(res2.toString());

  final transports = TransportType.values;

  for (final t in transports) {
    debugPrint(EnumFormatUtils.getFormattedString(t.name));
  }

  final exp = Experience.values;

  for (final e in exp) {
    debugPrint(EnumFormatUtils.getFormattedString(e.name));
  }

  runApp(const MyApp());
}

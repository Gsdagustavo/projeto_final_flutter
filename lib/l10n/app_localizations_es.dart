// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get transport_type_car => 'Auto';

  @override
  String get transport_type_bike => 'Bicicleta';

  @override
  String get transport_type_bus => 'Autobús';

  @override
  String get transport_type_plane => 'Avión';

  @override
  String get transport_type_cruise => 'Crucero';

  @override
  String get experience_cultural_immersion => 'Inmersión Cultural';

  @override
  String get experience_alternative_cuisines => 'Cocinas Alternativas';

  @override
  String get experience_historical_places => 'Visitar Lugares Históricos';

  @override
  String get experience_visit_local_establishments => 'Visitar Establecimientos Locales (Bares, Restaurantes, Parques, etc.)';

  @override
  String get experience_contact_with_nature => 'Contacto con la Naturaleza';

  @override
  String get title_home => 'Inicio';

  @override
  String get title_register_travel => 'Registrar Viagen';

  @override
  String get title_settings => 'Ajustes';

  @override
  String get travel_title_label => 'Título del viaje';

  @override
  String get transport_type_label => 'Tipo de transporte';

  @override
  String get experiences_label => 'Experiencias';

  @override
  String get travel_start_date_label => 'Selecciona la fecha de inicio del viaje';

  @override
  String get travel_end_date_label => 'Selecciona la fecha de fin del viaje';

  @override
  String get err_invalid_date_snackbar => '¡Primero debes seleccionar una fecha de inicio!';
}

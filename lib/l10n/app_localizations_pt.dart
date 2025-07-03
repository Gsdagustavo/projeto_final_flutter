// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class AppLocalizationsPt extends AppLocalizations {
  AppLocalizationsPt([String locale = 'pt']) : super(locale);

  @override
  String get transport_type_car => 'Carro';

  @override
  String get transport_type_bike => 'Moto';

  @override
  String get transport_type_bus => 'Ônibus';

  @override
  String get transport_type_plane => 'Avião';

  @override
  String get transport_type_cruise => 'Cruzeiro';

  @override
  String get experience_cultural_immersion => 'Imersão Cultural';

  @override
  String get experience_alternative_cuisines => 'Culinárias Alternativas';

  @override
  String get experience_historical_places => 'Visitar Locais Históricos';

  @override
  String get experience_visit_local_establishments => 'Visitar Estabelecimentos Locais (Bares, Restaurantes, Parques, etc.)';

  @override
  String get experience_contact_with_nature => 'Contato com a Natureza';

  @override
  String get title_home => 'Início';

  @override
  String get title_register_travel => 'Registrar Viagem';

  @override
  String get title_settings => 'Ajustes';

  @override
  String get travel_title_label => 'Título da viagem';

  @override
  String get transport_type_label => 'Tipo de transporte';

  @override
  String get experiences_label => 'Experiências';

  @override
  String get travel_start_date_label => 'Selecione a data de início da viagem';

  @override
  String get travel_end_date_label => 'Selecione a data de término da viagem';

  @override
  String get err_invalid_date_snackbar => 'Você deve selecionar a data de início primeiro!';
}

// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get language_en => 'Inglés';

  @override
  String get language_pt => 'Portugués';

  @override
  String get language_es => 'Español';

  @override
  String get login => 'Iniciar sesión';

  @override
  String get password => 'Contraseña';

  @override
  String get forgot_your_password => '¿Olvidaste tu contraseña?';

  @override
  String get insert_your_email => 'Ingresa tu email';

  @override
  String get send_recovery_code => 'Enviar código de recuperación';

  @override
  String get email => 'Correo electrónico';

  @override
  String get register => 'Registrarse';

  @override
  String get logged_in_successfully => '¡Inicio de sesión exitoso!';

  @override
  String get account_created_successfully => '¡Cuenta creada con éxito!';

  @override
  String get register_login => '¿Deseas iniciar sesión?';

  @override
  String recovery_code_sent_to(Object email) {
    return 'Código de recuperación enviado a $email';
  }

  @override
  String get invalid_email => 'Correo electrónico inválido';

  @override
  String get invalid_password => 'Contraseña inválida';

  @override
  String get account => 'Cuenta';

  @override
  String get account_creation => 'Creación de cuenta';

  @override
  String get last_sign_in => 'Último inicio de sesión';

  @override
  String get logout => 'Salir';

  @override
  String get logout_confirmation => '¿Realmente quieres cerrar sesión?';

  @override
  String get language => 'Idioma';

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
  String get travel_stop_type_start => 'Inicio';

  @override
  String get travel_stop_type_stop => 'Parada';

  @override
  String get travel_stop_type_end => 'Fin';

  @override
  String get experience => 'Experiencia';

  @override
  String get experiences => 'Experiencias';

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
  String get experience_social_events => 'Eventos sociales';

  @override
  String get other => 'Otro';

  @override
  String get upcoming => 'Próximo';

  @override
  String get ongoing => 'En curso';

  @override
  String get finished => 'Finalizado';

  @override
  String get my_travels => 'Mis viajes';

  @override
  String get start_travel => 'Iniciar viaje';

  @override
  String start_travel_confirmation(Object travel) {
    return '¿Iniciar viaje $travel?';
  }

  @override
  String travel_has_already_started(Object travel) {
    return 'El viaje $travel ya ha comenzado';
  }

  @override
  String get finish_travel => 'Finalizar viaje';

  @override
  String finish_travel_confirmation(Object travel) {
    return '¿Finalizar viaje $travel?';
  }

  @override
  String travel_has_already_finished(Object travel) {
    return 'El viaje $travel ya ha terminado';
  }

  @override
  String travel_not_stated_yet(Object travel) {
    return 'The Travel $travel has not started yet';
  }

  @override
  String get delete_travel => 'Eliminar viaje';

  @override
  String delete_travel_confirmation(Object travel) {
    return '¿Realmente desea eliminar el viaje $travel?';
  }

  @override
  String get travel_deleted => 'Viaje eliminado con éxito';

  @override
  String get view_travel_route => 'Ver ruta del viaje';

  @override
  String stop(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count paradas',
      one: '$count parada',
    );
    return '$_temp0';
  }

  @override
  String get title_home => 'Inicio';

  @override
  String get title_register_travel => 'Registrar Viaje';

  @override
  String get title_settings => 'Configuración';

  @override
  String get title_map_select_travel_stops => 'Seleccionar Paradas';

  @override
  String get travel_title_label => 'Título del Viaje';

  @override
  String get travel_details => 'Detalles del viaje';

  @override
  String get enter_travel_title => 'Ingrese el título del viaje...';

  @override
  String get invalid_travel_title => 'Título de viaje inválido';

  @override
  String get transport_type_label => 'Tipo de Transporte';

  @override
  String get experiences_label => 'Experiencias';

  @override
  String get dates_label => 'Fechas';

  @override
  String get select_dates_label => 'Seleccionar fechas';

  @override
  String get start_date => 'Fecha de Inicio del Viaje';

  @override
  String get end_date => 'Fecha de Fin del Viaje';

  @override
  String get err_invalid_date_snackbar => '¡Debes seleccionar una fecha de inicio primero!';

  @override
  String get participants => 'Participantes';

  @override
  String get err_invalid_participant_name => 'Nombre de participante inválido';

  @override
  String get err_invalid_participant_age => 'Edad de participante inválida';

  @override
  String get err_invalid_participant_data => 'Datos de participante inválidos';

  @override
  String get no_participants_on_the_list => 'No hay participantes en la lista';

  @override
  String get add_participant => 'Agregar participante';

  @override
  String get update_participant => 'Actualizar participante';

  @override
  String get name => 'Nombre';

  @override
  String get age => 'Edad';

  @override
  String get participant_added => 'Participante agregado!';

  @override
  String get remove_participant_confirmation => '¿Realmente deseas eliminar al participante';

  @override
  String get remove_participant => 'Eliminar participante';

  @override
  String get participant_removed => 'Participante eliminado';

  @override
  String get participant_updated => 'Participante actualizado';

  @override
  String get err_could_not_add_participant => 'No se pudo agregar participante';

  @override
  String get remove_stop => 'Eliminar parada';

  @override
  String get stop_added => '¡Parada agregada con éxito!';

  @override
  String get err_invalid_leave_date => 'Fecha de salida inválida';

  @override
  String get add_stop => 'Agregar parada';

  @override
  String get remove_stop_confirmation => '¿Realmente desea eliminar esta parada?';

  @override
  String get planned_experiences => 'Experiencias planificadas';

  @override
  String get err_register_travel_generic => 'Ocurrió un error al registrar el viaje';

  @override
  String get long_press_to_add_stops => 'Mantén presionado para agregar paradas';

  @override
  String get travel_map => 'Mapa del Viaje';

  @override
  String get open_map => 'Abrir Mapa';

  @override
  String get route_planning => 'Planificación de Ruta';

  @override
  String get route_planning_label => 'Planifica la ruta y las paradas de tu viaje';

  @override
  String get registered_stops => 'Paradas Registradas';

  @override
  String get no_stops_registered => 'No hay paradas registradas aún. Usa el mapa para planificar tu ruta entre diferentes ciudades y países';

  @override
  String get use_the_map_add_waypoints => 'Usa el mapa para modificar tu ruta o agregar más paradas';

  @override
  String get travel_photos => 'Fotos del Viaje';

  @override
  String get add_travel_photos => 'Agregar Fotos del Viaje';

  @override
  String get tap_select_photos => 'Toca para seleccionar fotos';

  @override
  String get photos_selected => 'fotos seleccionadas';

  @override
  String get choose_photos => 'Elegir Fotos';

  @override
  String get add_photos_label => 'Agrega fotos para hacer tu viaje más memorable y visualmente atractivo';

  @override
  String get invalid_travel_data => '¡Datos de viaje no válidos!';

  @override
  String get travel_registered_successfully => 'Viaje registrado con éxito';

  @override
  String get travel_stop => 'Parada del viaje';

  @override
  String get search_for_places => 'Procurar lugares';

  @override
  String get travel_start_location => 'Ubicación de inicio del viaje';

  @override
  String get travel_end_location => 'Ubicación final del viaje';

  @override
  String get register_stop => 'Registrar parada';

  @override
  String get stop_registered_successfully => '¡Parada registrada con éxito!';

  @override
  String get err_register_stop => 'Ocurrió un error al intentar registrar la parada';

  @override
  String get update_stop => 'Actualizar parada';

  @override
  String get stop_updated_successfully => '¡Parada actualizada con éxito!';

  @override
  String get arrive_date => 'Fecha de llegada';

  @override
  String get leave_date => 'Fecha de salida';

  @override
  String get err_you_must_select_arrive_date_first => '¡Debes seleccionar primero la fecha de llegada!';

  @override
  String get finish => 'Finalizar';

  @override
  String get duration => 'Duración';

  @override
  String get days => 'días';

  @override
  String get transport => 'Transporte';

  @override
  String get countries => 'Países';

  @override
  String get travel_dates => 'Fechas del Viaje';

  @override
  String get start => 'Inicio';

  @override
  String get end => 'Fin';

  @override
  String get travel_route => 'Ruta del Viaje';

  @override
  String get travel_title_updated => 'Título del viaje actualizado';

  @override
  String get travel_title => 'Título del Viaje';

  @override
  String get review => 'Reseña';

  @override
  String get reviews => 'Reseñas';

  @override
  String get detail_review => 'Detalle de la Reseña';

  @override
  String get give_a_review => 'Dejar una Reseña';

  @override
  String get send_review => 'Enviar Reseña';

  @override
  String get add_photo => 'Agregar Foto';

  @override
  String get no_reviews => '¡Aún no hay reseñas!';

  @override
  String based_on_reviews(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Basado en $count reseñas',
      one: 'Basado en 1 reseña',
    );
    return '$_temp0';
  }

  @override
  String get error_review => 'Se ha producido un error al registrar la reseña';

  @override
  String get remove_review => 'Eliminar reseña';

  @override
  String get remove_review_confirmation => '¿Realmente deseas eliminar esta reseña?';

  @override
  String get err_invalid_review_data => 'Datos de la reseña inválidos';

  @override
  String get err_invalid_review_author => 'Autor de la reseña inválido';

  @override
  String get review_registered => '¡Reseña registrada con éxito!';

  @override
  String get yes => 'Sí';

  @override
  String get no => 'No';

  @override
  String get add => 'Agregar';

  @override
  String get remove => 'Eliminar';

  @override
  String get warning => 'Advertencia';

  @override
  String get cancel => 'Cancelar';

  @override
  String get error => 'Erro';

  @override
  String get unknown_error => 'Error desconocido';
}

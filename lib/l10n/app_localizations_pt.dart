// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class AppLocalizationsPt extends AppLocalizations {
  AppLocalizationsPt([String locale = 'pt']) : super(locale);

  @override
  String get language_en => 'Inglês';

  @override
  String get language_pt => 'Português';

  @override
  String get language_es => 'Espanhol';

  @override
  String get login => 'Entrar';

  @override
  String get password => 'Senha';

  @override
  String get forgot_your_password => 'Esqueceu sua senha?';

  @override
  String get insert_your_email => 'Insira seu email';

  @override
  String get send_recovery_code => 'Enviar código de recuperação';

  @override
  String get email => 'Email';

  @override
  String get register => 'Registrar';

  @override
  String get logged_in_successfully => 'Login realizado com sucesso!';

  @override
  String get account_created_successfully => 'Conta criada com sucesso!';

  @override
  String get register_login => 'Deseja fazer login?';

  @override
  String recovery_code_sent_to(Object email) {
    return 'Código de recuperação enviado para $email';
  }

  @override
  String get invalid_email => 'Email inválido';

  @override
  String get invalid_password => 'Senha inválida';

  @override
  String get account => 'Conta';

  @override
  String get account_creation => 'Criação da conta';

  @override
  String get last_sign_in => 'Último login';

  @override
  String get logout => 'Sair';

  @override
  String get logout_confirmation => 'Você realmente quer sair?';

  @override
  String get language => 'Idioma';

  @override
  String get transport_type_car => 'Carro';

  @override
  String get transport_type_bike => 'Bicicleta';

  @override
  String get transport_type_bus => 'Ônibus';

  @override
  String get transport_type_plane => 'Avião';

  @override
  String get transport_type_cruise => 'Navio de cruzeiro';

  @override
  String get travel_stop_type_start => 'Início';

  @override
  String get travel_stop_type_stop => 'Parada';

  @override
  String get travel_stop_type_end => 'Fim';

  @override
  String get experience => 'Experiência';

  @override
  String get experiences => 'Experiências';

  @override
  String get experience_cultural_immersion => 'Imersão Cultural';

  @override
  String get experience_alternative_cuisines => 'Culinárias Alternativas';

  @override
  String get experience_historical_places => 'Visitar Lugares Históricos';

  @override
  String get experience_visit_local_establishments =>
      'Visitar Estabelecimentos Locais (Bares, Restaurantes, Parques, etc.)';

  @override
  String get experience_contact_with_nature => 'Contato com a Natureza';

  @override
  String get experience_social_events => 'Eventos sociais';

  @override
  String get other => 'Outro';

  @override
  String get upcoming => 'Futura';

  @override
  String get ongoing => 'Em andamento';

  @override
  String get finished => 'Concluída';

  @override
  String get my_travels => 'Minhas Viagens';

  @override
  String get start_travel => 'Iniciar viagem';

  @override
  String start_travel_confirmation(Object travel) {
    return 'Iniciar viagem $travel?';
  }

  @override
  String travel_has_already_started(Object travel) {
    return 'A viagem $travel já foi iniciada';
  }

  @override
  String get finish_travel => 'Finalizar viagem';

  @override
  String finish_travel_confirmation(Object travel) {
    return 'Finalizar viagem $travel?';
  }

  @override
  String travel_has_already_finished(Object travel) {
    return 'A viagem $travel já foi finalizada';
  }

  @override
  String travel_not_stated_yet(Object travel) {
    return 'The Travel $travel has not started yet';
  }

  @override
  String get delete_travel => 'Excluir viagem';

  @override
  String delete_travel_confirmation(Object travel) {
    return 'Você realmente deseja excluir a viagem $travel?';
  }

  @override
  String get travel_deleted => 'Viagem excluída com sucesso';

  @override
  String get view_travel_route => 'Ver rota da viagem';

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
  String get title_home => 'Início';

  @override
  String get title_register_travel => 'Registrar Viagem';

  @override
  String get title_settings => 'Configurações';

  @override
  String get title_map_select_travel_stops => 'Selecionar Paradas';

  @override
  String get travel_title_label => 'Título da Viagem';

  @override
  String get travel_details => 'Detalhes da viagem';

  @override
  String get enter_travel_title => 'Insira o título da viagem...';

  @override
  String get invalid_travel_title => 'Título da viagem inválido';

  @override
  String get transport_type_label => 'Tipo de Transporte';

  @override
  String get experiences_label => 'Experiências';

  @override
  String get dates_label => 'Datas';

  @override
  String get select_dates_label => 'Selecionar datas';

  @override
  String get start_date => 'Data de Início da Viagem';

  @override
  String get end_date => 'Data de Término da Viagem';

  @override
  String get err_invalid_date_snackbar =>
      'Você deve selecionar uma data de início primeiro!';

  @override
  String get participants => 'Participantes';

  @override
  String get err_invalid_participant_name => 'Nome do participante inválido';

  @override
  String get err_invalid_participant_age => 'Idade do participante inválida';

  @override
  String get err_invalid_participant_data => 'Dados de participante inválidos';

  @override
  String get no_participants_on_the_list => 'Nenhum participante na lista';

  @override
  String get add_participant => 'Adicionar participante';

  @override
  String get update_participant => 'Atualizar participante';

  @override
  String get name => 'Nome';

  @override
  String get age => 'Idade';

  @override
  String get participant_added => 'Participante adicionado!';

  @override
  String get remove_participant_confirmation =>
      'Você realmente deseja remover o participante';

  @override
  String get remove_participant => 'Remover participante';

  @override
  String get participant_removed => 'Participante removido';

  @override
  String get participant_updated => 'Participante atualizado';

  @override
  String get err_could_not_add_participant =>
      'Não foi possível adicionar o participante';

  @override
  String get remove_stop => 'Remove Travel Stop';

  @override
  String get stop_added => 'Travel Stop added successfully!';

  @override
  String get err_invalid_leave_date => 'Invalid leave date';

  @override
  String get add_stop => 'Add Travel Stop';

  @override
  String get remove_stop_confirmation =>
      'Do you really want to remove this stop?';

  @override
  String get planned_experiences => 'Planned Experiences';

  @override
  String get err_register_travel_generic =>
      'An error occurred while registering the travel';

  @override
  String get long_press_to_add_stops =>
      'Pressione e segure para adicionar paradas';

  @override
  String get travel_map => 'Mapa da Viagem';

  @override
  String get open_map => 'Abrir Mapa';

  @override
  String get route_planning => 'Planejamento de Rota';

  @override
  String get route_planning_label => 'Planeje sua rota de viagem e paradas';

  @override
  String get registered_stops => 'Paradas Registradas';

  @override
  String get no_stops_registered =>
      'Nenhuma parada registrada ainda. Use o mapa para planejar sua rota entre diferentes cidades e países';

  @override
  String get use_the_map_add_waypoints =>
      'Use o mapa para modificar sua rota ou adicionar mais paradas';

  @override
  String get travel_photos => 'Fotos da Viagem';

  @override
  String get add_travel_photos => 'Adicionar Fotos da Viagem';

  @override
  String get tap_select_photos => 'Toque para selecionar fotos';

  @override
  String get photos_selected => 'fotos selecionadas';

  @override
  String get choose_photos => 'Escolher Fotos';

  @override
  String get add_photos_label =>
      'Adicione fotos para tornar sua viagem mais memorável e visualmente atraente';

  @override
  String get invalid_travel_data => 'A viagem contém dados inválidos';

  @override
  String get travel_registered_successfully => 'Viagem registrada com sucesso';

  @override
  String get travel_stop => 'Parada da Viagem';

  @override
  String get search_for_places => 'Procurar lugares';

  @override
  String get travel_start_location => 'Local de Início da Viagem';

  @override
  String get travel_end_location => 'Local de Término da Viagem';

  @override
  String get register_stop => 'Registrar Parada';

  @override
  String get stop_registered_successfully => 'Parada registrada com sucesso!';

  @override
  String get err_register_stop =>
      'Ocorreu um erro ao tentar registrar a parada';

  @override
  String get update_stop => 'Atualizar Parada';

  @override
  String get stop_updated_successfully => 'Parada atualizada com sucesso!';

  @override
  String get arrive_date => 'Data de Chegada';

  @override
  String get leave_date => 'Data de Saída';

  @override
  String get err_you_must_select_arrive_date_first =>
      'Você deve selecionar a data de chegada primeiro!';

  @override
  String get finish => 'Finalizar';

  @override
  String get duration => 'Duração';

  @override
  String get days => 'dias';

  @override
  String get transport => 'Transporte';

  @override
  String get countries => 'Países';

  @override
  String get travel_dates => 'Datas da Viagem';

  @override
  String get start => 'Início';

  @override
  String get end => 'Fim';

  @override
  String get travel_route => 'Rota da Viagem';

  @override
  String get travel_title_updated => 'Título da viagem atualizado';

  @override
  String get travel_title => 'Título da Viagem';

  @override
  String get review => 'Avaliação';

  @override
  String get reviews => 'Avaliações';

  @override
  String get detail_review => 'Detalhar Avaliação';

  @override
  String get give_a_review => 'Fazer uma Avaliação';

  @override
  String get send_review => 'Enviar Avaliação';

  @override
  String get add_photo => 'Adicionar Foto';

  @override
  String get no_reviews => 'Ainda não há avaliações!';

  @override
  String based_on_reviews(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Baseado em $count avaliações',
      one: 'Baseado em 1 avaliação',
    );
    return '$_temp0';
  }

  @override
  String get error_review => 'Ocorreu um erro ao registrar a avaliação';

  @override
  String get remove_review => 'Remover avaliação';

  @override
  String get remove_review_confirmation =>
      'Você realmente quer remover esta avaliação?';

  @override
  String get err_invalid_review_data => 'Dados da avaliação inválidos';

  @override
  String get err_invalid_review_author => 'Autor da avaliação inválido';

  @override
  String get review_registered => 'Avaliação registrada com sucesso!';

  @override
  String get yes => 'Sim';

  @override
  String get no => 'Não';

  @override
  String get add => 'Adicionar';

  @override
  String get remove => 'Remover';

  @override
  String get warning => 'Aviso';

  @override
  String get cancel => 'Cancelar';

  @override
  String get error => 'Erro';

  @override
  String get unknown_error => 'Erro desconhecido';
}

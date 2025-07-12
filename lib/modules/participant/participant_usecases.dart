import '../../domain/entities/participant.dart';
import 'participant_repository.dart';

abstract class ParticipantUseCases {
  Future<void> registerParticipant(Participant participant, int travelId);

  Future<List<Participant>> getAllParticipants();

  Future<List<Participant>> getParticipantsByTravelId(int travelId);
}

class ParticipantUseCasesImpl implements ParticipantUseCases {
  final ParticipantRepositoryImpl _participantRepository;

  ParticipantUseCasesImpl(this._participantRepository);

  @override
  Future<void> registerParticipant(Participant participant, int travelId) {
    // TODO: implement registerParticipant
    throw UnimplementedError();
  }

  @override
  Future<List<Participant>> getAllParticipants() async {
    return await _participantRepository.getAllParticipants();
  }

  @override
  Future<List<Participant>> getParticipantsByTravelId(int travelId) async {
    await _participantRepository.getParticipantsByTravelId(travelId);
    return [];
  }
}

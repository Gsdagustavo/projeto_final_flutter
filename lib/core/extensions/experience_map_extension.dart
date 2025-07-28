import '../../domain/entities/enums.dart';

extension ExperiencesMapExtension on Map<Experience, bool> {
  List<Experience> toExperiencesList() {
    return entries
        .where((element) => element.value == true)
        .map((e) => e.key)
        .toList();
  }
}

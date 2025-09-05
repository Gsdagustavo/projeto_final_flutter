import '../../domain/entities/enums.dart';

/// Extension methods for the [Map<Experience, bool>] data structure
extension ExperiencesMapExtension on Map<Experience, bool> {
  /// Returns a list version of all selected experiences
  List<Experience> toExperiencesList() {
    return entries
        .where((element) => element.value == true)
        .map((e) => e.key)
        .toList();
  }
}

extension StringInitialExension on String {
  String getUppercaseInitial() => this[0].toUpperCase();
}

extension StringCapitalizationExtension on String {
  /// Returns a capitalized and spaced version the given text
  String getFormattedString() {
    var result = '';
    var idx = 0;

    for (final letter in split('')) {
      // means it is the first letter
      if (idx == 0) {
        result += letter.toUpperCase();
        idx++;
        continue;
      }

      // means it is another word
      if (letter.toUpperCase() == letter) {
        result += ' ';
        result += letter;
        idx += 2;
        continue;
      }

      if (result.isNotEmpty) {
        // the letter is in the middle of the word
        result += letter;
        idx++;
        continue;
      }
    }

    return result;
  }
}
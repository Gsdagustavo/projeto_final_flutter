/// This extension contains some util methods on [String] class
extension StringFormatExtension on String {
  /// Returns the uppercase first letter of a string
  String get uppercaseInitial => this[0].toUpperCase();

  /// Returns a capitalized and spaced version the given text
  String get capitalizedAndSpaced {
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

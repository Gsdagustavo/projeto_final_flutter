abstract class StringFormatUtils {
  static String getStringInitial(String text) {
    if (text.isEmpty) return '';

    return text[0].toUpperCase();
  }
}

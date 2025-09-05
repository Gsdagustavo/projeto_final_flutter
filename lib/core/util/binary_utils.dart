/// Extension methods for the [bool] class
extension BoolExtension on bool {
  /// Returns the [integer] representation of the [boolean]
  /// (false == 0, true == 1)
  int toInt() {
    return this ? 1 : 0;
  }
}

/// Extension methods for the [int] class
extension IntExtension on int {
  /// Returns the [boolean] representation of the [integer]
  /// (0 == false, 1 == true)
  bool toBool() {
    return this == 1;
  }
}

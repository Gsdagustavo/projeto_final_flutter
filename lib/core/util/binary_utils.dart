extension BoolExtension on bool {
  int toInt() {
    return this ? 1 : 0;
  }
}

extension IntExtension on int {
  bool toBool() {
    return this == 1;
  }
}

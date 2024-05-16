extension MapExtension on Map<String, dynamic> {
  /// Checks if partial key exists
  bool containsPartialKey(String value) {
    final index = keys.toList().indexWhere((k) => k.contains(value));
    return index >= 0;
  }

  /// Gets the value from a partial key
  String getValue(String value) {
    return keys.toList().firstWhere((k) => k.contains(value));
  }
}

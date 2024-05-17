class BaseItem {
  final int id;
  final String name;

  BaseItem({required this.id, required this.name});

  @override
  String toString() {
    return name;
  }

  bool get isEmpty => id == 0 && name.isEmpty;
}

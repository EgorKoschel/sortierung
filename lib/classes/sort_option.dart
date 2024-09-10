class SortOption {
  final String sortName;
  final String sortKey;
  final Function(List<int>) sortFunction;
  bool isChecked;

  SortOption({
    required this.sortName,
    required this.sortKey,
    required this.sortFunction,
    this.isChecked = false,
  });
}

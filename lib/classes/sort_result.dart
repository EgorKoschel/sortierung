class SortResult {
  final String sortName;
  Duration? duration;
  List<int>? sortedList;
  int? rank;
  int? maxRank;

  SortResult({
    required this.sortName,
    this.duration,
    this.sortedList,
    this.rank,
    this.maxRank,
  });
}

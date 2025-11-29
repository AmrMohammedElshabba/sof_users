class ReputationItem {
  final String type;
  final int change;
  final int creationDate;   // raw timestamp from API
  final int? postId;

  ReputationItem({
    required this.type,
    required this.change,
    required this.creationDate,
    this.postId,
  });

  DateTime get dateTime =>
      DateTime.fromMillisecondsSinceEpoch(creationDate * 1000);

  String get formattedDate {
    final dt = dateTime;
    return "${dt.year}-${dt.month.toString().padLeft(2, '0')}-${dt.day.toString().padLeft(2, '0')}  "
        "${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}";
  }

  factory ReputationItem.fromJson(Map<String, dynamic> json) {
    return ReputationItem(
      type: json['reputation_history_type'] ?? '',
      change: (json['reputation_change'] ?? 0) as int,
      creationDate: (json['creation_date'] ?? 0) as int,
      postId: json['post_id'],
    );
  }
}

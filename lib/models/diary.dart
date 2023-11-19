class Diary {
  final String? id;
  DateTime dateTime;
  String content;

  Diary({
    this.id,
    required this.dateTime,
    required this.content,
  });

  Diary copyWith({
    String? id,
    DateTime? dateTime,
    String? content,
  }) {
    return Diary(
      dateTime: dateTime ?? this.dateTime,
      content: content ?? this.content,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'dateTime': dateTime.toIso8601String(),
      'content': content,
    };
  }

  static Diary fromJson(Map<String, dynamic> json) {
    return Diary(
      dateTime: DateTime.parse(json['dateTime']),
      content: json['content'],
    );
  }
}

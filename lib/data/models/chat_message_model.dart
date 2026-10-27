/// A single chat message.
class ChatMessageModel {
  final String id;
  final String text;
  final String time; // e.g. "9:30 AM"
  final DateTime? _createdAt;
  final bool isMine; // true = sent by current user (right side, green)

  const ChatMessageModel({
    required this.id,
    required this.text,
    required this.time,
    required DateTime createdAt,
    required this.isMine,
  }) : _createdAt = createdAt;

  DateTime get createdAt =>
      _createdAt ?? DateTime.fromMillisecondsSinceEpoch(0);

  factory ChatMessageModel.fromMap(
    Map<String, dynamic> map,
    String currentUserId,
  ) {
    final createdAt = _parseCreatedAt(map['created_at']);
    final hour = createdAt.hour > 12
        ? createdAt.hour - 12
        : createdAt.hour == 0
        ? 12
        : createdAt.hour;
    final minute = createdAt.minute.toString().padLeft(2, '0');
    final period = createdAt.hour >= 12 ? 'PM' : 'AM';

    return ChatMessageModel(
      id: map['id'] as String? ?? '',
      text: map['body'] as String? ?? '',
      time: '$hour:$minute $period',
      createdAt: createdAt,
      isMine: map['sender_id'] == currentUserId,
    );
  }

  static DateTime _parseCreatedAt(dynamic value) {
    if (value is DateTime) return value.toLocal();
    if (value is String) {
      return DateTime.tryParse(value)?.toLocal() ?? DateTime.now();
    }
    return DateTime.now();
  }
}

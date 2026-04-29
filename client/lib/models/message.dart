class Message {
  final String id;
  final String senderId;
  final String receiverId;
  final String originalText;
  final String? translatedText;
  final String sourceLang;
  final String targetLang;
  final DateTime createdAt;

  Message({
    required this.id,
    required this.senderId,
    required this.receiverId,
    required this.originalText,
    this.translatedText,
    required this.sourceLang,
    required this.targetLang,
    required this.createdAt,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      id: json['id'],
      senderId: json['sender_id'],
      receiverId: json['receiver_id'],
      originalText: json['original_text'],
      translatedText: json['translated_text'],
      sourceLang: json['source_lang'],
      targetLang: json['target_lang'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'sender_id': senderId,
      'receiver_id': receiverId,
      'original_text': originalText,
      'translated_text': translatedText,
      'source_lang': sourceLang,
      'target_lang': targetLang,
      'created_at': createdAt.toIso8601String(),
    };
  }
}

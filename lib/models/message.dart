class Message {
  final int? id;
  final String text;
  final String sender;
  final String receiver;
  final DateTime createdAt;
  final DateTime? deliveredAt;
  final DateTime? readAt;

  Message(
      {this.id,
      required this.text,
      required this.sender,
      required this.receiver,
      required this.createdAt,
      this.deliveredAt,
      this.readAt});

  factory Message.fromMap(Map<String, dynamic> json) {
    return Message(
      id: json['id'],
      text: json['text'],
      sender: json['sender'],
      receiver: json['receiver'],
      createdAt: DateTime.parse(json['created_at']),
      deliveredAt: json['delivered_at'] != null
          ? DateTime.parse(json['delivered_at'])
          : null,
      readAt: json['read_at'] != null ? DateTime.parse(json['read_at']) : null,
    );
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'text': text,
        'sender': sender,
        'receiver': receiver,
        'created_at': createdAt.toIso8601String(),
        'delivered_at': deliveredAt?.toIso8601String(),
        'read_at': readAt?.toIso8601String()
      };
}

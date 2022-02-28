class Message {
  final int? id;
  final String text;
  final String sender;
  final String receiver;
  final DateTime? createdAt;

  Message(
      {this.id,
      required this.text,
      required this.sender,
      required this.receiver,
      this.createdAt});

  factory Message.fromMap(Map<String, dynamic> json) {
    return Message(
      id: json['id'],
      text: json['text'],
      sender: json['sender'],
      receiver: json['receiver'],
    );
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'text': text,
        'sender': sender,
        'receiver': receiver,
        'created_at': createdAt,
      };
}

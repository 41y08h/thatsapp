// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Message {
  final int? id;
  final String text;
  final String sender;
  final String receiver;
  final DateTime createdAt;
  final DateTime? deliveredAt;
  final DateTime? readAt;
  Message({
    this.id,
    required this.text,
    required this.sender,
    required this.receiver,
    required this.createdAt,
    this.deliveredAt,
    this.readAt,
  });

  Message copyWith({
    int? id,
    String? text,
    String? sender,
    String? receiver,
    DateTime? createdAt,
    DateTime? deliveredAt,
    DateTime? readAt,
  }) {
    return Message(
      id: id ?? this.id,
      text: text ?? this.text,
      sender: sender ?? this.sender,
      receiver: receiver ?? this.receiver,
      createdAt: createdAt ?? this.createdAt,
      deliveredAt: deliveredAt ?? this.deliveredAt,
      readAt: readAt ?? this.readAt,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'text': text,
      'sender': sender,
      'receiver': receiver,
      'created_at': createdAt.toIso8601String(),
      'delivered_at': deliveredAt?.toIso8601String(),
      'read_at': readAt?.toIso8601String(),
    };
  }

  factory Message.fromMap(Map<String, dynamic> map) {
    return Message(
      id: map['id'] != null ? map['id'] as int : null,
      text: map['text'] as String,
      sender: map['sender'] as String,
      receiver: map['receiver'] as String,
      createdAt: DateTime.parse(map['created_at'] ?? ""),
      deliveredAt: DateTime.tryParse(map['delivered_at'] ?? ""),
      readAt: DateTime.tryParse(map['read_at'] ?? ""),
    );
  }

  String toJson() => json.encode(toMap());

  factory Message.fromJson(String source) =>
      Message.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Message(id: $id, text: $text, sender: $sender, receiver: $receiver, createdAt: $createdAt, deliveredAt: $deliveredAt, readAt: $readAt)';
  }

  @override
  bool operator ==(covariant Message other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.text == text &&
        other.sender == sender &&
        other.receiver == receiver &&
        other.createdAt == createdAt &&
        other.deliveredAt == deliveredAt &&
        other.readAt == readAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        text.hashCode ^
        sender.hashCode ^
        receiver.hashCode ^
        createdAt.hashCode ^
        deliveredAt.hashCode ^
        readAt.hashCode;
  }
}

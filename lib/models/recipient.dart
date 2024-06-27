// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Recipient {
  final String name;
  final String username;
  Recipient({
    required this.name,
    required this.username,
  });

  Recipient copyWith({
    String? name,
    String? username,
  }) {
    return Recipient(
      name: name ?? this.name,
      username: username ?? this.username,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'username': username,
    };
  }

  factory Recipient.fromMap(Map<String, dynamic> map) {
    return Recipient(
      name: map['name'] as String,
      username: map['username'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Recipient.fromJson(String source) =>
      Recipient.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'Recipient(name: $name, username: $username)';

  @override
  bool operator ==(covariant Recipient other) {
    if (identical(this, other)) return true;

    return other.name == name && other.username == username;
  }

  @override
  int get hashCode => name.hashCode ^ username.hashCode;
}

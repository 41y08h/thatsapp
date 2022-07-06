class Recipient {
  final String name;
  final String username;
  Recipient({required this.name, required this.username});

  factory Recipient.fromMap(Map<String, dynamic> map) {
    return Recipient(
      name: map['name'] as String,
      username: map['username'] as String,
    );
  }
}

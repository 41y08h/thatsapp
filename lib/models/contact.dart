class Contact {
  final String name;
  final String username;

  Contact({
    required this.name,
    required this.username,
  });

  factory Contact.fromMap(Map<String, dynamic> json) {
    return Contact(
      name: json["name"],
      username: json["username"],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "name": name,
      "username": username,
    };
  }
}

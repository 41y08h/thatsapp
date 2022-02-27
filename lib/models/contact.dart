class Contact {
  final String username;
  final String name;

  Contact(this.username, this.name);

  factory Contact.fromMap(Map<String, dynamic> json) =>
      Contact(json["username"], json["name"]);

  Map<String, dynamic> toMap() => {"username": username, "name": name};
}

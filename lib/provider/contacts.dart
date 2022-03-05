import 'package:flutter/cupertino.dart';
import 'package:thatsapp/database.dart';
import 'package:thatsapp/models/contact.dart';

class ContactsProvider with ChangeNotifier {
  List<Contact> _contacts = [];
  List<Contact> get contacts => _contacts;

  Future<List<Contact>> fetch() async {
    final db = await DatabaseConnection().database;
    final contacts = await db.query('Contact');
    _contacts = contacts.map(Contact.fromMap).toList();

    notifyListeners();
    return _contacts;
  }

  Future<void> addContact(Contact contact) async {
    final db = await DatabaseConnection().database;
    await db.insert('Contact', {
      'name': contact.name,
      'username': contact.username,
    });

    _contacts.add(contact);
    notifyListeners();
  }
}

import 'package:flutter/cupertino.dart';
import 'package:thatsapp/database.dart';
import 'package:thatsapp/models/contact.dart';

class ContactsProvider extends ChangeNotifier {
  List<Contact> _contacts = [];
  List<Contact> get contacts => _contacts;

  Future<List<Contact>> getContacts() async {
    final db = await DatabaseConnection().database;
    final contacts = await db.query('Contact');
    _contacts = contacts.map((contact) => Contact.fromMap(contact)).toList();

    notifyListeners();

    return _contacts;
  }

  Future<void> addContact(Contact contact) async {
    final db = await DatabaseConnection().database;
    _contacts.add(contact);

    await db.insert('Contact', {
      'name': contact.name,
      'username': contact.username,
    });

    notifyListeners();
  }
}

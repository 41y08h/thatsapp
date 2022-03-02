import 'package:flutter/material.dart';
import 'package:thatsapp/database.dart';
import 'package:thatsapp/models/message.dart';
import 'package:provider/provider.dart';
import 'package:thatsapp/provider/auth.dart';
import 'package:thatsapp/provider/contacts.dart';
import 'package:collection/collection.dart';

class MessagesProvider extends ChangeNotifier {
  List<Message> _messages = [];
  List<String> _chats = [];

  List<Message> get messages => _messages;
  List<String> get chats => _chats;

  Future<List<Message>> getMessages() async {
    _messages = await DatabaseConnection().getMessages();

    return _messages;
  }

  void addMessage(Message message) async {
    final database = await DatabaseConnection().database;
    await database.insert(
      'Message',
      message.toMap(),
    );

    messages.add(message);

    notifyListeners();
  }

  Future<List<String>> getChats(BuildContext context) async {
    final auth = context.watch<AuthProvider>();
    final contacts = context.watch<ContactsProvider>().contacts;

    final recipients = await DatabaseConnection()
        .getRecipients(auth.currentUser?.username as String);

    final chats = recipients.map((recipient) {
      final contact = contacts.firstWhereOrNull(
        (contact) => contact.username == recipient,
      );

      return contact != null ? contact.name : recipient;
    }).toList();

    _chats = chats;
    notifyListeners();

    return chats;
  }
}

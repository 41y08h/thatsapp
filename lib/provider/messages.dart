import 'package:flutter/material.dart';
import 'package:thatsapp/database.dart';
import 'package:thatsapp/models/message.dart';
import 'package:collection/collection.dart';
import 'package:thatsapp/models/contact.dart';

class Chat {
  final String alias;
  final String recipient;
  Chat({required this.alias, required this.recipient});
}

class MessagesProvider extends ChangeNotifier {
  List<Chat> _conversations = [];

  List<Message> get messages => _messages;
  List<Chat> get conversations => _conversations;

  Future<int> addMessage(Message message) async {
    final database = await DatabaseConnection().database;
    int insertedId = await database.insert('Message', message.toMap());

    messages.add(message);

    notifyListeners();
    return insertedId;
  }

  Future<List<Chat>> getChats(List<Contact> contacts, String username) async {
    final recipients = await DatabaseConnection().getRecipients(username);

    final chats = recipients.map((recipient) {
      final contact = contacts.firstWhereOrNull(
        (contact) => contact.username == recipient,
      );

      return Chat(
        alias: contact == null ? recipient : contact.name,
        recipient: recipient,
      );
    }).toList();

    _chats = chats;
    notifyListeners();

    return chats;
  }
}

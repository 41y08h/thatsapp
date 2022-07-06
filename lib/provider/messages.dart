import 'package:flutter/material.dart';
import 'package:thatsapp/database.dart';
import 'package:thatsapp/models/message.dart';
import 'package:provider/provider.dart';
import 'package:thatsapp/provider/auth.dart';
import 'package:collection/collection.dart';
import 'package:thatsapp/models/contact.dart';

class Chat {
  final String alias;
  final String recipient;
  Chat({required this.alias, required this.recipient});
}

class MessagesProvider extends ChangeNotifier {
  List<Message> _messages = [];
  List<Chat> _chats = [];

  List<Message> get messages => _messages;
  List<Chat> get chats => _chats;

  Future<List<Message>> getMessages() async {
    _messages = await DatabaseConnection().getMessages();

    return _messages;
  }

  Future<int> addMessage(Message message) async {
    final database = await DatabaseConnection().database;
    int insertedId = await database.insert('Message', message.toMap());

    messages.add(message);

    notifyListeners();
    return insertedId;
  }
}

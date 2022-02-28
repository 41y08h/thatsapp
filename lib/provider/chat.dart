import 'package:flutter/material.dart';
import 'package:thatsapp/database.dart';
import 'package:thatsapp/models/message.dart';

class ChatProvider extends ChangeNotifier {
  List<Message> _messages = [];
  List<Message> get messages => _messages;
  bool isLoading = true;

  Future<void> loadMessages() async {
    _messages = await DatabaseConnection().getMessages();
    isLoading = false;
  }

  addMessage(Message message) async {
    final database = await DatabaseConnection().database;
    await database.insert(
      'Message',
      message.toMap(),
    );

    await loadMessages();
    notifyListeners();
  }
}

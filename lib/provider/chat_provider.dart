import 'package:flutter/material.dart';

class Message {
  final String text;
  final String sender;
  final String receiver;

  Message(this.text, {required this.sender, required this.receiver});
}

class ChatProvider extends ChangeNotifier {
  List<Message> _messages = [];
  List<Message> get messages => _messages;

  addMessage(Message message) {
    _messages.add(message);
    notifyListeners();
  }
}

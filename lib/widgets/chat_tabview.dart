import 'package:flutter/material.dart';
import 'package:thatsapp/models/contact.dart';
import 'package:thatsapp/provider/messages.dart';
import 'package:thatsapp/screens/chat.dart';
import 'package:thatsapp/utils/chat_screen_arguments.dart';

class ChatTabView extends StatefulWidget {
  final List<Contact> contacts;
  final List<Chat> chats;
  const ChatTabView({Key? key, required this.contacts, required this.chats})
      : super(key: key);

  @override
  _ChatTabViewState createState() => _ChatTabViewState();
}

class _ChatTabViewState extends State<ChatTabView> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemBuilder: (context, index) {
        final chat = widget.chats[index];

        return ListTile(
          title: Text(chat.alias),
          onTap: () {
            Navigator.of(context).pushNamed(
              ChatScreen.routeName,
              arguments: ChatScreenArguments(
                username: chat.recipient,
                name: chat.alias,
              ),
            );
          },
        );
      },
      itemCount: widget.chats.length,
    );
  }
}

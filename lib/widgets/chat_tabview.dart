import 'package:flutter/material.dart';
import 'package:thatsapp/database.dart';
import 'package:thatsapp/models/message.dart';
import 'package:thatsapp/provider/auth.dart';
import 'package:thatsapp/provider/contacts.dart';
import 'package:thatsapp/provider/messages.dart';
import 'package:provider/provider.dart';
import 'package:collection/collection.dart';

class ChatTabView extends StatefulWidget {
  const ChatTabView({Key? key}) : super(key: key);

  @override
  _ChatTabViewState createState() => _ChatTabViewState();
}

class _ChatTabViewState extends State<ChatTabView> {
  @override
  Widget build(BuildContext context) {
    final chats = context.watch<MessagesProvider>().chats;
    final getChats = context.watch<MessagesProvider>().getChats;

    return Container(
      child: FutureBuilder(
          future: getChats(context),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }

            return ListView.builder(
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(chats[index]),
                );
              },
              itemCount: chats.length,
            );
          }),
    );
  }
}

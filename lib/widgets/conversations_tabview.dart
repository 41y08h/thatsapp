import 'package:flutter/material.dart';
import 'package:thatsapp/screens/chat.dart';
import 'package:thatsapp/utils/chat_screen_arguments.dart';
import 'package:thatsapp/utils/conversation.dart';

class ConversationsTabView extends StatelessWidget {
  final List<Conversation> conversations;
  const ConversationsTabView({Key? key, required this.conversations})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemBuilder: (context, index) {
        final conversation = conversations[index];

        return ListTile(
          title: Text(conversation.name),
          onTap: () {
            Navigator.of(context).pushNamed(
              ChatScreen.routeName,
              arguments: ChatScreenArguments(
                username: conversation.recipient,
                name: conversation.name,
              ),
            );
          },
        );
      },
      itemCount: conversations.length,
    );
  }
}

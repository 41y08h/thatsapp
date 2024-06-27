import 'package:flutter/material.dart';
import 'package:thatsapp/screens/chat.dart';
import 'package:thatsapp/models/recipient.dart';

class ConversationsTabView extends StatelessWidget {
  final List<Recipient> recipients;
  const ConversationsTabView({Key? key, required this.recipients})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemBuilder: (context, index) {
        final conversation = recipients[index];

        return ListTile(
          title: Text(conversation.name),
          onTap: () {
            Navigator.of(context).pushNamed(
              ChatScreen.routeName,
              arguments: Recipient(
                username: conversation.username,
                name: conversation.name,
              ),
            );
          },
        );
      },
      itemCount: recipients.length,
    );
  }
}

import 'package:flutter/material.dart';
import 'package:thatsapp/models/message.dart';
import 'package:thatsapp/provider/auth.dart';
import 'package:provider/provider.dart';

class MessageTile extends StatelessWidget {
  final Message message;
  final bool isSentByUser;
  const MessageTile(
      {Key? key, required this.message, required this.isSentByUser})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(18),
      decoration: BoxDecoration(
          color: Colors.yellow.shade500,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(isSentByUser ? 15 : 0),
              topRight: Radius.circular(isSentByUser ? 0 : 15),
              bottomLeft: Radius.circular(15),
              bottomRight: Radius.circular(15))),
      child: Text(message.text),
    );
  }
}

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
    return LayoutBuilder(builder: (context, constraints) {
      return Container(
        padding: EdgeInsets.all(14),
        decoration: BoxDecoration(
            color: isSentByUser ? Color(0xffD9FDD3) : Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(isSentByUser ? 10 : 0),
              topRight: Radius.circular(isSentByUser ? 0 : 10),
              bottomLeft: Radius.circular(10),
              bottomRight: Radius.circular(10),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.13),
                blurRadius: 0.3,
                offset: const Offset(0, 1), // changes position of shadow
              ),
            ]),
        child: Text(message.text),
        constraints: BoxConstraints(maxWidth: constraints.maxWidth * 0.7),
      );
    });
  }
}

import 'package:flutter/material.dart';
import 'package:thatsapp/models/message.dart';
import 'package:intl/intl.dart';

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
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
            color: isSentByUser ? const Color(0xffD9FDD3) : Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(isSentByUser ? 10 : 0),
              topRight: Radius.circular(isSentByUser ? 0 : 10),
              bottomLeft: const Radius.circular(10),
              bottomRight: const Radius.circular(10),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.13),
                blurRadius: 0.3,
                offset: const Offset(0, 1), // changes position of shadow
              ),
            ]),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(message.text),
            const SizedBox(height: 5),
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Text(
                DateFormat('hh:mm a').format(message.createdAt).toLowerCase(),
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ),
            Visibility(
                child: Icon(
                    message.deliveredAt == null ? Icons.done : Icons.done_all),
                visible: isSentByUser),
          ],
        ),
        constraints: BoxConstraints(maxWidth: constraints.maxWidth * 0.7),
      );
    });
  }
}

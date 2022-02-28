import 'package:flutter/material.dart';

class ChatTabView extends StatefulWidget {
  const ChatTabView({Key? key}) : super(key: key);

  @override
  _ChatTabViewState createState() => _ChatTabViewState();
}

class _ChatTabViewState extends State<ChatTabView> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text('Chat'),
    );
  }
}

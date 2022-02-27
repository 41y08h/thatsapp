import 'package:flutter/material.dart';
import 'package:thatsapp/utils/chat_screen_arguments.dart';
import 'package:thatsapp/ws/socket.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  SocketConnection socketConnection = SocketConnection();
  TextEditingController messageController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)?.settings.arguments as ChatScreenArguments;
    return Scaffold(
      appBar: AppBar(
        // Show the username argument in the title
        title: Text('Chat with ${args.username}'),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: ListView.builder(
              itemCount: 20,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text('Message ${index + 1}'),
                );
              },
            ),
          ),
          // Add a button to send a message
          Container(
            child: Row(
              children: <Widget>[
                Expanded(
                  child: TextField(
                    controller: messageController,
                    decoration: InputDecoration(
                      hintText: 'Type a message',
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () {
                    socketConnection.socket.emit(
                      "send-message",
                      {"text": messageController.text, "sendTo": args.username},
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

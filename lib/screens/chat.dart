import 'package:flutter/material.dart';
import 'package:thatsapp/provider/chat.dart';
import 'package:thatsapp/ws/socket.dart';
import 'package:provider/provider.dart';

class ChatScreen extends StatefulWidget {
  static const routeName = 'chat';
  const ChatScreen({Key? key}) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  SocketConnection socketConnection = SocketConnection();
  TextEditingController messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final chat = context.watch<ChatProvider>();

    // Get messages where sender is current user

    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, String>;
    return Scaffold(
      appBar: AppBar(
        // Show the username argument in the title
        title: Text('${args['name']}'),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
              child: chat.isLoading
                  ? Center(child: CircularProgressIndicator())
                  : ListView.builder(
                      itemCount: chat.messages.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(chat.messages[index].text),
                        );
                      },
                    )),
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
                    socketConnection.socket?.emit(
                      "send-message",
                      {
                        "text": messageController.text,
                        "sendTo": args['username']
                      },
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

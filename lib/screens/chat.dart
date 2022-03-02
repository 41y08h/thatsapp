import 'package:flutter/material.dart';
import 'package:thatsapp/models/message.dart';
import 'package:thatsapp/provider/auth.dart';
import 'package:thatsapp/provider/messages.dart';
import 'package:thatsapp/utils/chat_screen_arguments.dart';
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
    final args =
        ModalRoute.of(context)?.settings.arguments as ChatScreenArguments;
    final chat = context.watch<MessagesProvider>();
    final auth = context.watch<AuthProvider>();

    final messages = chat.messages.where((message) {
      bool isSecondPersonInvolved =
          message.sender == args.username || message.receiver == args.username;
      bool isFirstPersonInvolved =
          message.sender == auth.currentUser?.username ||
              message.receiver == auth.currentUser?.username;

      return isFirstPersonInvolved && isSecondPersonInvolved;
    }).toList();

    void onSendMessage() {
      final message = Message(
        text: messageController.text,
        sender: auth.currentUser?.username as String,
        receiver: args.username,
      );

      socketConnection.socket?.emit(
        "send-message",
        {
          "sendTo": message.receiver,
          "text": message.text,
        },
      );

      messageController.clear();
      chat.addMessage(message);
    }

    return Scaffold(
      appBar: AppBar(
        // Show the username argument in the title
        title: Text(args.name),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: FutureBuilder(
                future: chat.getMessages(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  return ListView.builder(
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(messages[index].text),
                      );
                    },
                  );
                }),
          ),
          // Add a button to send a message
          Row(
            children: <Widget>[
              Expanded(
                child: TextField(
                  controller: messageController,
                  decoration: const InputDecoration(
                    hintText: 'Type a message',
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.send),
                onPressed: onSendMessage,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

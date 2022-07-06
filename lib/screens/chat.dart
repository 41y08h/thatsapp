import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:thatsapp/database.dart';
import 'package:thatsapp/models/message.dart';
import 'package:thatsapp/provider/auth.dart';
import 'package:thatsapp/utils/recipient.dart';
import 'package:thatsapp/utils/user.dart';
import 'package:thatsapp/widgets/message_tile.dart';
import 'package:thatsapp/socket.dart';
import 'package:provider/provider.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter_requery/flutter_requery.dart';

class ChatScreen extends StatefulWidget {
  static const routeName = 'chat';
  const ChatScreen({Key? key}) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  bool isEmojiPickerOpen = false;
  FocusNode inputNode = FocusNode();

  void dismissKeyboard() {
    SystemChannels.textInput.invokeMethod('TextInput.hide');
  }

  void focusInput() {
    inputNode.requestFocus();
  }

  void closeEmojiPicker() {
    setState(() {
      isEmojiPickerOpen = false;
    });
  }

  void openEmojiPicker() {
    setState(() {
      isEmojiPickerOpen = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final recipient = ModalRoute.of(context)?.settings.arguments as Recipient;
    final currentUser = context.read<AuthProvider>().currentUser as User;

    void onSendMessage(String text) async {
      final message = Message(
        text: text,
        sender: currentUser.username,
        receiver: recipient.username,
        createdAt: DateTime.now(),
      );
      int id = await DatabaseConnection().insertMessage(message);

      final socket = await SocketConnection().socket;
      socket.emit(
        "send-message",
        {
          "id": id,
          "sendTo": message.receiver,
          "text": message.text,
          "createdAt": message.createdAt.toIso8601String()
        },
      );
    }

    return Scaffold(
      appBar: AppBar(
        // Show the username argument in the title
        title: Text(recipient.name),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: Query<List<Message>>(
              ["messages", recipient.username],
              future: () => DatabaseConnection()
                  .getChatMessages(currentUser.username, recipient.username),
              builder: (context, response) {
                print("gge");
                if (response.error != null) {
                  return Center(
                    child: Text("Error: ${response.error}"),
                  );
                }

                if (response.loading) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }

                if (response.data == null) {
                  return Center(
                    child: Text("No messages"),
                  );
                }

                print("gge");

                final messages = response.data as List<Message>;
                return Padding(
                  padding: const EdgeInsets.all(8),
                  child: ListView.separated(
                    reverse: true,
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      final message = messages.reversed.toList()[index];
                      final isSentByUser =
                          message.sender == currentUser.username;

                      return Align(
                        alignment: isSentByUser
                            ? Alignment.topRight
                            : Alignment.topLeft,
                        child: MessageTile(
                          isSentByUser: isSentByUser,
                          message: message,
                        ),
                      );
                    },
                    separatorBuilder: (context, index) {
                      return SizedBox(height: 4);
                    },
                  ),
                );
              },
            ),
          ),
          // Add a button to send a message
          MessageKeyboard(
            onSend: onSendMessage,
          ),
        ],
      ),
    );
  }
}

class MessageKeyboard extends StatefulWidget {
  final void Function(String message) onSend;
  const MessageKeyboard({Key? key, required this.onSend}) : super(key: key);

  @override
  State<MessageKeyboard> createState() => _MessageKeyboardState();
}

class _MessageKeyboardState extends State<MessageKeyboard> {
  TextEditingController textController = TextEditingController();
  bool isEmojiPickerOpen = false;

  void onEmojiButtonPressed() {
    setState(() {
      isEmojiPickerOpen = true;
    });
    SystemChannels.textInput.invokeMethod('TextInput.hide');
  }

  void onKeyboardButtonPressed() {
    setState(() {
      isEmojiPickerOpen = false;
    });
    SystemChannels.textInput.invokeMethod('TextInput.show');
  }

  void onTextFieldTapped() {}

  void onEmojiSelected(String emoji) {}

  void onBackspacePressed() {}

  void onSendMessage() {
    widget.onSend(textController.text);
    textController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          IconTheme(
            data: IconThemeData(color: Colors.grey.shade600),
            child: Container(
              color: Colors.grey.shade200,
              padding:
                  const EdgeInsets.symmetric(horizontal: 8.0, vertical: 14),
              child: Row(
                children: <Widget>[
                  isEmojiPickerOpen
                      ? IconButton(
                          onPressed: onKeyboardButtonPressed,
                          icon: Icon(Icons.keyboard))
                      : IconButton(
                          onPressed: onEmojiButtonPressed,
                          icon: Icon(Icons.insert_emoticon)),
                  Expanded(
                    child: TextField(
                      onTap: onTextFieldTapped,
                      controller: textController,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 10.0,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide(
                            width: 0,
                            style: BorderStyle.none,
                          ),
                        ),
                        filled: true,
                        hintText: 'Type a message',
                        fillColor: Colors.white,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.send),
                    onPressed: onSendMessage,
                  ),
                ],
              ),
            ),
          ),
          isEmojiPickerOpen
              ? Expanded(
                  child: EmojiPicker(
                    onEmojiSelected: (category, emoji) {
                      onEmojiSelected(emoji.emoji);
                    },
                    onBackspacePressed: onBackspacePressed,
                  ),
                )
              : SizedBox(),
        ],
      ),
    );
  }
}

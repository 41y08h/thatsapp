import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:thatsapp/models/message.dart';
import 'package:thatsapp/provider/auth.dart';
import 'package:thatsapp/provider/messages.dart';
import 'package:thatsapp/utils/chat_screen_arguments.dart';
import 'package:thatsapp/widgets/message_tile.dart';
import 'package:thatsapp/ws/socket.dart';
import 'package:provider/provider.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';

class ChatScreen extends StatefulWidget {
  static const routeName = 'chat';
  const ChatScreen({Key? key}) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  SocketConnection socketConnection = SocketConnection();
  TextEditingController messageController = TextEditingController();
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

  void onEmojiSelected(Emoji emoji) {
    // get cursor position from text field
    final int cursorPos = messageController.selection.baseOffset;
    // insert emoji to the text field at the cursor position
    messageController.text = messageController.text.substring(0, cursorPos) +
        emoji.emoji +
        messageController.text.substring(cursorPos);

    messageController.selection = TextSelection.fromPosition(
      TextPosition(offset: cursorPos + emoji.emoji.length),
    );
  }

  void onBackspacePressed() {
    messageController
      ..text = messageController.text.characters.skipLast(1).toString()
      ..selection = TextSelection.fromPosition(
          TextPosition(offset: messageController.text.length));
  }

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
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: NetworkImage(
                'https://user-images.githubusercontent.com/15075759/28719144-86dc0f70-73b1-11e7-911d-60d70fcded21.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
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

                    return Padding(
                      padding: const EdgeInsets.all(8),
                      child: ListView.separated(
                        reverse: true,
                        itemCount: messages.length,
                        itemBuilder: (context, index) {
                          final message = messages.reversed.toList()[index];
                          final isSentByUser =
                              message.sender == auth.currentUser?.username;

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
                  }),
            ),
            // Add a button to send a message
            IconTheme(
              data: IconThemeData(color: Colors.grey.shade600),
              child: Container(
                color: Colors.grey.shade200,
                padding:
                    const EdgeInsets.symmetric(horizontal: 8.0, vertical: 14),
                child: Row(
                  children: <Widget>[
                    IconButton(
                      icon: Icon(
                        isEmojiPickerOpen
                            ? Icons.keyboard
                            : Icons.emoji_emotions,
                      ),
                      onPressed: () {
                        if (isEmojiPickerOpen) {
                          closeEmojiPicker();
                          focusInput();
                        } else {
                          dismissKeyboard();
                          openEmojiPicker();
                        }
                      },
                    ),
                    Expanded(
                      child: TextField(
                        onTap: () {
                          closeEmojiPicker();
                        },
                        autofocus: true,
                        focusNode: inputNode,
                        controller: messageController,
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
            Visibility(
              child: Expanded(
                child: EmojiPicker(
                  onEmojiSelected: (category, emoji) {
                    onEmojiSelected(emoji);
                  },
                  onBackspacePressed: onBackspacePressed,
                ),
              ),
              visible: isEmojiPickerOpen,
            ),
          ],
        ),
      ),
    );
  }
}

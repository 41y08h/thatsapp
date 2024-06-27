import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:fquery/fquery.dart';
import 'package:thatsapp/database.dart';
import 'package:thatsapp/hooks/use_auth.dart';
import 'package:thatsapp/models/message.dart';
import 'package:thatsapp/models/recipient.dart';
import 'package:thatsapp/widgets/message_tile.dart';
import 'package:thatsapp/socket.dart';

class ChatScreen extends StatefulHookWidget {
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
    final auth = useAuth();
    final client = useQueryClient();

    void onSendMessage(String text) async {
      final message = Message(
        text: text,
        sender: auth.currentUser!.username,
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
      client.invalidateQueries(['messages', recipient.username]);
    }

    return Scaffold(
      appBar: AppBar(title: Text(recipient.name)),
      body: Column(
        children: [
          Expanded(
            child: QueryBuilder<List<Message>, Error>(
              ["messages", recipient.username],
              () => DatabaseConnection().getChatMessages(
                  auth.currentUser!.username, recipient.username),
              builder: (context, query) {
                if (query.isError) {
                  return Center(
                    child: Text("Error: ${query.error}"),
                  );
                }

                if (query.isLoading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                if (query.data == null) {
                  return const Center(
                    child: Text("No messages"),
                  );
                }

                final messages = query.data as List<Message>;
                return Padding(
                  padding: const EdgeInsets.all(8),
                  child: ListView.separated(
                    reverse: true,
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      final message = messages.reversed.toList()[index];
                      final isSentByUser =
                          message.sender == auth.currentUser!.username;

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
                      return const SizedBox(height: 4);
                    },
                  ),
                );
              },
            ),
          ),
          MessageKeyboard(onSend: onSendMessage),
        ],
      ),
    );
  }
}

class MessageKeyboard extends HookWidget {
  final void Function(String message) onSend;
  const MessageKeyboard({Key? key, required this.onSend}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textController = useTextEditingController();

    void onSendMessage() {
      onSend(textController.text);
      textController.clear();
    }

    return Column(
      children: [
        IconTheme(
          data: IconThemeData(color: Colors.grey.shade600),
          child: Container(
            color: Colors.grey.shade200,
            padding: const EdgeInsets.only(left: 14.0, top: 16, bottom: 16),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    onTap: () {},
                    controller: textController,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 10.0,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: const BorderSide(
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
      ],
    );
  }
}

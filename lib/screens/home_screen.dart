import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:thatsapp/provider/chat_provider.dart';
import 'package:thatsapp/screens/chat_screen.dart';
import 'package:thatsapp/utils/chat_screen_arguments.dart';
import 'package:thatsapp/widgets/contacts_tabview.dart';
import 'package:thatsapp/ws/socket.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  SocketConnection socketConnection = SocketConnection();
  var textController = TextEditingController();
  var usernameController = TextEditingController();
  List<String> chats = [];

  @override
  void initState() {
    super.initState();

    socketConnection.initialize();
    registerSocketEvents();
  }

  void registerSocketEvents() async {
    await socketConnection.ensureInitalized();
    socketConnection.socket?.on("message", (data) {
      final message = Message(data['text'],
          sender: data['sender'], receiver: data['receiver']);

      context.read<ChatProvider>().addMessage(message);
    });
  }

  void onSendButtonPressed() {
    socketConnection.socket?.emit("send-message", {
      "text": textController.text,
      "sendTo": usernameController.text,
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text("ThatsApp"),
          elevation: 0,
          bottom: TabBar(
            tabs: [
              Tab(icon: Icon(Icons.chat)),
              Tab(icon: Icon(Icons.group)),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            Center(child: Text("Group")),
            ContactsTabView(),
          ],
        ),
      ),
    );
  }
}

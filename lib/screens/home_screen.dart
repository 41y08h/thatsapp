import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:thatsapp/models/message.dart';
import 'package:thatsapp/provider/chat_provider.dart';
import 'package:thatsapp/screens/chat_screen.dart';
import 'package:thatsapp/utils/chat_screen_arguments.dart';
import 'package:thatsapp/widgets/contacts_tabview.dart';
import 'package:thatsapp/ws/socket.dart';

class HomeScreen extends StatefulWidget {
  static const String routeName = 'home';
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  SocketConnection socketConnection = SocketConnection();
  var textController = TextEditingController();
  var usernameController = TextEditingController();
  List<String> chats = [];

  @override
  void initState() {
    super.initState();

    socketConnection.initialize();
    registerSocketEvents();
    loadMessages();
  }

  void loadMessages() {
    context.read<ChatProvider>().loadMessages();
  }

  void registerSocketEvents() async {
    await socketConnection.ensureInitalized();
    socketConnection.socket?.on("message", (data) {
      context.read<ChatProvider>().addMessage(Message.fromMap(data));
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

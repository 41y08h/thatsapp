// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:thatsapp/models/message.dart';
import 'package:thatsapp/provider/messages.dart';
import 'package:thatsapp/widgets/chat_tabview.dart';
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
  }

  void registerSocketEvents() async {
    await socketConnection.ensureInitalized();
    socketConnection.socket?.on("message", (data) {
      context.read<MessagesProvider>().addMessage(Message.fromMap(data));
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
            tabs: const [
              Tab(icon: Icon(Icons.chat)),
              Tab(icon: Icon(Icons.group)),
            ],
          ),
        ),
        body: TabBarView(
          children: const [
            ChatTabView(),
            ContactsTabView(),
          ],
        ),
      ),
    );
  }
}

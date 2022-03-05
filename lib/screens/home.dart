import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:thatsapp/database.dart';
import 'package:thatsapp/models/contact.dart';
import 'package:thatsapp/models/message.dart';
import 'package:thatsapp/provider/auth.dart';
import 'package:thatsapp/provider/contacts.dart';
import 'package:thatsapp/utils/conversation.dart';
import 'package:thatsapp/utils/user.dart';
import 'package:thatsapp/widgets/contacts_tabview.dart';
import 'package:thatsapp/socket.dart';
import 'package:collection/collection.dart';
import 'package:thatsapp/widgets/conversations_tabview.dart';

class HomeScreen extends StatefulWidget {
  static const String routeName = 'home';
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Conversation> conversations = [];
  late final Future<List<Conversation>> fConversations = fetchConversations();
  late final Future<List<Contact>> fContacts =
      context.read<ContactsProvider>().fetch();

  @override
  void initState() {
    super.initState();
    SocketConnection().initialize();
    registerWebsocketEvents();
  }

  void registerWebsocketEvents() async {
    final socket = await SocketConnection().socket;

    socket.on("message", wsOnMessage);
    socket.on("delivery-receipt", wsOnDeliveryReceipt);
  }

  void wsOnMessage(dynamic data) async {
    final message = Message.fromMap(data);
    int messageId = await DatabaseConnection().insertMessage(data);

    final socket = await SocketConnection().socket;
    socket.emit("delivery-receipt", {
      'messageId': messageId,
      'receiptFor': message.sender,
    });
  }

  void wsOnDeliveryReceipt(dynamic data) async {
    final messageId = data['messageId'];
    final receiptFrom = data['receiptFrom'];
    DatabaseConnection().updateMessageDeliveryTime(messageId, receiptFrom);
  }

  Future<List<Conversation>> fetchConversations() async {
    final contacts = await fContacts;
    final currentUser = context.read<AuthProvider>().currentUser as User;

    final recipients =
        await DatabaseConnection().getRecipients(currentUser.username);

    final conversations = recipients.map((recipient) {
      final contact = contacts.firstWhereOrNull(
        (contact) => contact.username == recipient,
      );

      // If the recipient is not in contacts, show their username
      return Conversation(
        name: contact == null ? recipient : contact.name,
        recipient: recipient,
      );
    }).toList();

    this.conversations = conversations;
    return conversations;
  }

  @override
  void dispose() {
    SocketConnection().socket.then((socket) => socket.dispose());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final contacts = context.watch<ContactsProvider>().contacts;

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("ThatsApp"),
          bottom: const TabBar(
            tabs: [
              Tab(icon: Icon(Icons.chat)),
              Tab(icon: Icon(Icons.group)),
            ],
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: () {},
            ),
          ],
        ),
        body: TabBarView(
          children: [
            FutureBuilder(
              future: fConversations,
              builder: (context, AsyncSnapshot<List<Conversation>> snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return ConversationsTabView(conversations: conversations);
                } else {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
              },
            ),
            FutureBuilder(
              future: fContacts,
              builder: (context, AsyncSnapshot<List<Contact>> snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return ContactsTabView(contacts: contacts);
                } else {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
              },
            )
          ],
        ),
      ),
    );
  }
}

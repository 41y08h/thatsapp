import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:thatsapp/database.dart';
import 'package:thatsapp/models/contact.dart';
import 'package:thatsapp/models/message.dart';
import 'package:thatsapp/provider/auth.dart';
import 'package:thatsapp/screens/login.dart';
import 'package:thatsapp/utils/recipient.dart';
import 'package:thatsapp/utils/user.dart';
import 'package:thatsapp/widgets/contacts_tabview.dart';
import 'package:thatsapp/socket.dart';
import 'package:thatsapp/widgets/conversations_tabview.dart';
import 'package:flutter_requery/flutter_requery.dart';

class HomeScreen extends StatefulWidget {
  static const String routeName = 'home';
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Future<List<Recipient>> fetchRecipients() async {
    final currentUser = context.read<AuthProvider>().currentUser as User;
    return DatabaseConnection().getRecipients(currentUser.username);
  }

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
    queryCache.invalidateQueries(['messages', message.sender]);

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

  @override
  void dispose() {
    SocketConnection().socket.then((socket) => socket.dispose());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
              onPressed: () {
                queryCache.invalidateQueries("recipients");
              },
            ),
            IconButton(
              onPressed: () {
                // Navigate to login page
                Navigator.of(context).pushNamed(LoginScreen.routeName);
              },
              icon: Icon(Icons.login),
            ),
          ],
        ),
        body: TabBarView(
          children: [
            Query<List<Recipient>>("recipients", future: fetchRecipients,
                builder: (context, response) {
              if (response.error != null) {
                return Center(
                  child: Text("Error :("),
                );
              }
              if (response.loading) {
                return SizedBox();
              }
              return ConversationsTabView(
                  recipients: response.data as List<Recipient>);
            }),
            Query<List<Contact>>(
              "contacts",
              future: DatabaseConnection().getContacts,
              builder: (context, response) {
                if (response.error != null) {
                  return Center(
                    child: Text("Error :("),
                  );
                }
                if (response.loading) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
                return ContactsTabView(
                    contacts: response.data as List<Contact>);
              },
            )
          ],
        ),
      ),
    );
  }
}

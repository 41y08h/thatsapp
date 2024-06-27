import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:fquery/fquery.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:thatsapp/database.dart';
import 'package:thatsapp/hooks/use_auth.dart';
import 'package:thatsapp/models/contact.dart';
import 'package:thatsapp/models/message.dart';
import 'package:thatsapp/screens/login.dart';
import 'package:thatsapp/models/recipient.dart';
import 'package:thatsapp/widgets/add_contact_dialog.dart';
import 'package:thatsapp/widgets/contacts_tabview.dart';
import 'package:thatsapp/socket.dart';
import 'package:thatsapp/widgets/conversations_tabview.dart';
import 'package:flutter_requery/flutter_requery.dart';

class HomeScreen extends StatefulHookWidget {
  static const String routeName = 'home';
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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
    final auth = useAuth();
    final tabController = useTabController(initialLength: 2);
    final tabIndex = useState(0);

    Future<List<Recipient>> fetchRecipients() async {
      return DatabaseConnection().getRecipients(auth.currentUser!.username);
    }

    useEffect(() {
      tabController.addListener(() {
        tabIndex.value = tabController.index;
      });
      return null;
    });

    void onAddContactButtonPressed() {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (BuildContext context) {
          return const AddContactDialog();
        },
      );
    }

    return Scaffold(
      floatingActionButton: tabIndex.value == 1
          ? Padding(
              padding: const EdgeInsets.all(12.0),
              child: SizedBox(
                height: 50,
                width: 50,
                child: ElevatedButton(
                  style: ButtonStyle(
                    padding: const WidgetStatePropertyAll(EdgeInsets.all(12)),
                    backgroundColor: const WidgetStatePropertyAll(
                        Color.fromRGBO(37, 211, 102, 1)),
                    shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14.0),
                      ),
                    ),
                  ),
                  onPressed: onAddContactButtonPressed,
                  child: const Icon(
                    Icons.add_sharp,
                    size: 24,
                    color: Colors.white,
                  ),
                ),
              ),
            )
          : null,
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(7, 94, 84, 1),
        foregroundColor: Colors.white,
        title: const Text("ThatsApp"),
        bottom: TabBar(
          controller: tabController,
          tabs: const [
            Tab(
                icon: Icon(
              Icons.chat,
              color: Colors.white,
            )),
            Tab(icon: Icon(Icons.group, color: Colors.white)),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {},
          ),
          IconButton(
            onPressed: () async {
              // Navigate to login page
              final prefs = await SharedPreferences.getInstance();
              prefs.remove("token");
              Navigator.of(context).pushNamedAndRemoveUntil(
                  LoginScreen.routeName, (route) => false);
            },
            icon: const Icon(Icons.login),
          ),
        ],
      ),
      body: TabBarView(
        controller: tabController,
        children: [
          QueryBuilder<List<Recipient>, Error>(
            const ["recipients"],
            fetchRecipients,
            builder: (context, response) {
              if (response.error != null) {
                return const Center(
                  child: Text("Error :( "),
                );
              }
              if (response.isLoading) {
                return const SizedBox();
              }
              return ConversationsTabView(
                recipients: response.data as List<Recipient>,
              );
            },
          ),
          QueryBuilder<List<Contact>, Error>(
            const ["contacts"],
            DatabaseConnection().getContacts,
            builder: (context, query) {
              if (query.isError) {
                return const Center(
                  child: Text("Error :("),
                );
              }
              if (query.isLoading) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              return ContactsTabView(contacts: query.data as List<Contact>);
            },
          )
        ],
      ),
    );
  }
}

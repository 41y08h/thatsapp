import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late IO.Socket socket;
  var textController = TextEditingController();
  var usernameController = TextEditingController();
  List<String> chats = [];

  @override
  void initState() {
    super.initState();
    connectWebSockets();
    loadSavedChats();
  }

  void loadSavedChats() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var chats = prefs.getStringList('chats') ?? [];
    setState(() {
      this.chats = chats;
    });
  }

  void connectWebSockets() async {
    // Get token from local storage
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    socket = IO.io(
      "http://192.168.0.104:5000",
      IO.OptionBuilder().setTransports(['websocket']).setExtraHeaders(
        {'Authorization': 'Bearer $token'},
      ).build(),
    );

    socket.on('message', (data) {
      // Show snackbar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("message received-  " + data["text"]),
        ),
      );
    });
  }

  void onSendButtonPressed() {
    socket.emit("send-message", {
      "text": textController.text,
      "sendTo": usernameController.text,
    });
  }

  void onAddButtonPressed() {
    // Show bottom sheet
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return AddChatDialog(
          onSubmit: (username) async {
            // Add username to list
            setState(() {
              chats.add(username);
            });
            // Save username to local storage
            final prefs = await SharedPreferences.getInstance();
            prefs.setStringList('chats', chats);
            Navigator.of(context).pop();
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("ThatsApp"),
        elevation: 0,
      ),
      body: Center(
        child: ListView.builder(
          itemBuilder: (context, index) {
            return ListTile(
              onTap: () {},
              title: Text(chats[index]),
            );
          },
          itemCount: chats.length,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: onAddButtonPressed,
        child: Icon(Icons.add),
      ),
    );
  }
}

class AddChatDialog extends StatefulWidget {
  final Function(String) onSubmit;
  const AddChatDialog({
    Key? key,
    required this.onSubmit,
  }) : super(key: key);

  @override
  State<AddChatDialog> createState() => _AddChatDialogState();
}

class _AddChatDialogState extends State<AddChatDialog> {
  TextEditingController usernameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: MediaQuery.of(context).viewInsets,
      child: Column(
        children: [
          TextField(
            autofocus: true,
            controller: usernameController,
            decoration: InputDecoration(
              labelText: "Username",
            ),
          ),
          TextButton(
            onPressed: () {
              widget.onSubmit(usernameController.text);
            },
            child: Text("Add"),
          ),
        ],
      ),
    );
  }
}

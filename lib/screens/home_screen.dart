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

  @override
  void initState() {
    super.initState();
    connectWebSockets();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: TextField(
                controller: usernameController,
                decoration: InputDecoration(
                  hintText: 'Username',
                ),
              ),
            ),
          ),
          TextField(
            controller: textController,
            decoration: InputDecoration(
              hintText: 'Enter message',
            ),
            onSubmitted: (value) {
              socket.emit('message', [value]);
            },
          ),
          IconButton(
            icon: Icon(Icons.send),
            onPressed: onSendButtonPressed,
          ),
        ],
      ),
    );
  }
}

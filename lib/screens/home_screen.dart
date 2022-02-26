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

  @override
  void initState() {
    super.initState();
    connectWebSockets();
  }

  void connectWebSockets() async {
    // Get token from local storage
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    print(token);

    socket = IO.io(
      "http://192.168.0.104:5000",
      IO.OptionBuilder().setTransports(['websocket']).setExtraHeaders(
        {'Authorization': 'Bearer $token'},
      ).build(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text("Hey"),
      ),
    );
  }
}

import 'package:shared_preferences/shared_preferences.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketConnection {
  static final SocketConnection _instance = SocketConnection._internal();

  factory SocketConnection() {
    return _instance;
  }

  SocketConnection._internal();

  late IO.Socket socket;

  Future<void> initalize() async {
    // Get token from storage
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    socket = IO.io(
      "http://192.168.0.104:5000",
      IO.OptionBuilder().setTransports(['websocket']).setExtraHeaders(
        {'Authorization': 'Bearer $token'},
      ).build(),
    );
  }
}

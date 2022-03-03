import 'package:shared_preferences/shared_preferences.dart';
// ignore: library_prefixes
import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketConnection {
  static final SocketConnection _instance = SocketConnection._internal();

  factory SocketConnection() {
    return _instance;
  }

  SocketConnection._internal();

  IO.Socket? socket;

  Future<void> initialize() async {
    // Get token from storage
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    socket = IO.io(
      "http://192.168.0.101:5000",
      IO.OptionBuilder().setTransports(['websocket']).setExtraHeaders(
        {'Authorization': 'Bearer $token'},
      ).build(),
    );
  }

  Future<void> ensureInitalized() async {
    if (socket == null) {
      await initialize();
    }
  }
}

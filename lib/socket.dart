import 'dart:io';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;

const kWebsocketsApiUrl = "http://192.168.1.6:5000";

class SocketConnection {
  static final SocketConnection _instance = SocketConnection._();
  SocketConnection._();

  factory SocketConnection() {
    return _instance;
  }

  io.Socket? _socket;
  Future<io.Socket> get socket async => _socket ??= await initialize();

  Future<io.Socket> initialize() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("token");

    final options =
        io.OptionBuilder().setTransports(['websocket']).setExtraHeaders(
      {
        HttpHeaders.authorizationHeader: 'Bearer $token',
      },
    ).build();

    return io.io(kWebsocketsApiUrl, options);
  }
}

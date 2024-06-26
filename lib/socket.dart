import 'dart:io';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

const kWebsocketsApiUrl = "http://192.168.1.6:5000";

class SocketConnection {
  static final SocketConnection _instance = SocketConnection._();
  SocketConnection._();

  factory SocketConnection() {
    return _instance;
  }

  IO.Socket? _socket;
  Future<IO.Socket> get socket async => _socket ??= await initialize();

  Future<IO.Socket> initialize() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("token");

    final options =
        IO.OptionBuilder().setTransports(['websocket']).setExtraHeaders(
      {
        HttpHeaders.authorizationHeader: 'Bearer $token',
      },
    ).build();

    return IO.io(kWebsocketsApiUrl, options);
  }
}

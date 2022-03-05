import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:thatsapp/provider/auth.dart';

const kWebsocketsApiUrl = "http://192.168.0.101:5000";

class SocketConnection {
  static final SocketConnection _instance = SocketConnection._();
  SocketConnection._();

  factory SocketConnection() {
    return _instance;
  }

  IO.Socket? _socket;
  Future<IO.Socket> get socket async => _socket ??= await initialize();

  Future<IO.Socket> initialize() async {
    final token = await AuthProvider.getToken();

    final options =
        IO.OptionBuilder().setTransports(['websocket']).setExtraHeaders(
      {'Authorization': 'Bearer $token'},
    ).build();

    return IO.io(kWebsocketsApiUrl, options);
  }
}

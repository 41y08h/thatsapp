import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:thatsapp/utils/user.dart';

class AuthProvider extends ChangeNotifier {
  User? currentUser;

  static Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("token", token);
  }

  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("token");
  }

  static User _decodeUserFromToken(String token) {
    final decoded = JwtDecoder.decode(token);
    print(decoded);
    return User.fromMap(decoded);
  }

  void logout() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove("token");
  }

  Future<User?> verifyAuth() async {
    // No token found ~ Unauthenticated
    final token = await getToken();
    if (token == null) {
      print("token null");
      return null;
    }

    try {
      // Parse token from user
      return _decodeUserFromToken(token);
    } catch (error) {
      // Malformed token ~ unauthenticated
      return null;
    }
  }
}

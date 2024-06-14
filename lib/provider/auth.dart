import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:thatsapp/utils/api.dart';
import 'package:thatsapp/utils/user.dart';

class AuthResponseData {
  final String token;
  final User user;

  AuthResponseData({
    required this.token,
    required this.user,
  });

  factory AuthResponseData.fromJson(Map<String, dynamic> json) {
    return AuthResponseData(
      token: json['token'],
      user: User.fromJson(json['user']),
    );
  }
}

enum AuthType {
  login,
  register,
}

class AuthProvider extends ChangeNotifier {
  bool isAuthenticating = false;
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
    return User.fromJson(decoded);
  }

  Future<void> authenticate(
    AuthType type, {
    required String username,
    required String password,
  }) async {
    isAuthenticating = true;
    notifyListeners();

    try {
      final path = type == AuthType.login ? '/auth/login' : '/auth/register';
      final response = await dio.post(
        path,
        data: {
          'username': username,
          'password': password,
        },
      );

      // Save token and update current user
      final data = AuthResponseData.fromJson(response.data);
      saveToken(data.token);
      currentUser = data.user;

      notifyListeners();
    } on DioError catch (e) {
      throw ApiError.fromJson(e.response?.data);
    }
  }

  Future<bool> verifyAuth() async {
    // No token found ~ Unauthenticated
    final token = await getToken();
    if (token == null) {
      return false;
    }

    try {
      // Parse token from user
      currentUser = _decodeUserFromToken(token);
    } catch (error) {
      // Malformed token ~ unauthenticated
      return false;
    }

    return true; // Verified
  }

  void logout() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove("token");
  }
}

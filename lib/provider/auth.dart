import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';

class User {
  final int id;
  final String username;
  User({
    required this.id,
    required this.username,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      username: json['username'],
    );
  }
}

class AuthResponseData {
  final String token;
  final User user;

  AuthResponseData({required this.token, required this.user});

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

class ApiError implements Exception {
  final String message;
  final int code;

  ApiError({required this.message, required this.code});

  factory ApiError.fromJson(Map<String, dynamic> json) {
    return ApiError(
      message: json['error']['message'],
      code: json['error']['code'],
    );
  }

  @override
  String toString() {
    return message;
  }
}

class AuthProvider extends ChangeNotifier {
  bool isAuthenticating = false;
  User? currentUser;

  Future<void> authenticate(AuthType type,
      {required String username, required String password}) async {
    isAuthenticating = true;
    notifyListeners();

    try {
      final response = await Dio().post(
        "http://192.168.0.101:5000/auth/${type == AuthType.login ? 'login' : 'register'}",
        data: {
          'username': username,
          'password': password,
        },
      );

      final AuthResponseData data = AuthResponseData.fromJson(response.data);

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString("token", data.token);

      currentUser = data.user;

      notifyListeners();
    } on DioError catch (e) {
      throw ApiError.fromJson(e.response?.data);
    }
  }

  Future<bool> verifyAuth() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("token");

    if (token == null) {
      return false;
    }

    final decoded = JwtDecoder.decode(token);
    currentUser = User.fromJson(decoded);
    notifyListeners();

    return true;
  }
}

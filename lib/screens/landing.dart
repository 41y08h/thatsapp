import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:fquery/fquery.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:thatsapp/screens/home.dart';
import 'package:thatsapp/screens/login.dart';
import 'package:thatsapp/utils/user.dart';

class LandingScreen extends HookWidget {
  static const routeName = '/';
  const LandingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    User _decodeUserFromToken(String token) {
      final decoded = JwtDecoder.decode(token);
      return User.fromMap(decoded);
    }

    Future<String?> getToken() async {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString("token");
    }

    Future<User?> verifyAndGetUser() async {
      // No token found ~ Unauthenticated
      final token = await getToken();
      if (token == null) {
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

    final currentUserQuery = useQuery(['currentUser'], verifyAndGetUser);

    if (currentUserQuery.isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    bool isAuthenticated = currentUserQuery.data == null ? false : true;
    return isAuthenticated ? const HomeScreen() : const LoginScreen();
  }
}

import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:thatsapp/provider/auth.dart';
import 'package:thatsapp/provider/chat_provider.dart';
import 'package:thatsapp/screens/chat_screen.dart';
import 'package:thatsapp/screens/home_screen.dart';
import 'package:thatsapp/screens/login_screen.dart';
import 'package:thatsapp/screens/signup_screen.dart';

void main() async {
  // Check if user is already logged in
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  final token = prefs.getString('token');
  bool isAuthenticated = token != null;

  if (token != null) {
    final decodedToken = JwtDecoder.decode(token);
    print(decodedToken['username']);
  }

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ChatProvider()),
        ChangeNotifierProvider(create: (_) => AuthProvider()),
      ],
      child: MaterialApp(
        title: "ThatsApp",
        theme: ThemeData(
          pageTransitionsTheme: const PageTransitionsTheme(builders: {
            TargetPlatform.android: CupertinoPageTransitionsBuilder(),
            TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
          }),
        ),
        initialRoute: isAuthenticated ? "login" : "signup",
        routes: {
          "login": (context) => const LoginScreen(),
          "signup": (context) => const SignupScreen(),
          "home": (context) => const HomeScreen(),
          "chat": (context) => const ChatScreen(),
        },
      ),
    ),
  );
}

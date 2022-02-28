import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';
import 'package:thatsapp/provider/auth.dart';
import 'package:thatsapp/provider/chat_provider.dart';
import 'package:thatsapp/screens/chat_screen.dart';
import 'package:thatsapp/screens/home_screen.dart';
import 'package:thatsapp/screens/landing.dart';
import 'package:thatsapp/screens/login_screen.dart';
import 'package:thatsapp/screens/signup_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(MultiProvider(
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
      initialRoute: LandingScreen.routeName,
      routes: {
        LandingScreen.routeName: (context) => const LandingScreen(),
        "login": (context) => const LoginScreen(),
        "signup": (context) => const SignupScreen(),
        "home": (context) => const HomeScreen(),
        "chat": (context) => const ChatScreen(),
      },
    ),
  ));
}

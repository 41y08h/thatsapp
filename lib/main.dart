import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:thatsapp/provider/auth.dart';
import 'package:thatsapp/provider/contacts2.dart';
import 'package:thatsapp/provider/messages.dart';
import 'package:thatsapp/provider/contacts.dart';
import 'package:thatsapp/screens/chat.dart';
import 'package:thatsapp/screens/home.dart';
import 'package:thatsapp/screens/landing.dart';
import 'package:thatsapp/screens/login.dart';
import 'package:thatsapp/screens/signup.dart';
import 'package:thatsapp/utils/globals.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await App.init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => MessagesProvider()),
        ChangeNotifierProvider(create: (_) => ContactsProvider()),
        ChangeNotifierProvider(create: (_) => Contacts2Provider()),
      ],
      child: MaterialApp(
        title: "ThatsApp",
        theme: ThemeData(
          primarySwatch: Colors.green,
          appBarTheme: const AppBarTheme(elevation: 0),
          pageTransitionsTheme: const PageTransitionsTheme(builders: {
            TargetPlatform.android: CupertinoPageTransitionsBuilder(),
            TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
          }),
        ),
        initialRoute: LandingScreen.routeName,
        routes: {
          LandingScreen.routeName: (context) => const LandingScreen(),
          LoginScreen.routeName: (context) => const LoginScreen(),
          SignupScreen.routeName: (context) => const SignupScreen(),
          HomeScreen.routeName: (context) => const HomeScreen(),
          ChatScreen.routeName: (context) => const ChatScreen(),
        },
      ),
    );
  }
}

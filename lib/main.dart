import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fquery/fquery.dart';
import 'package:provider/provider.dart';
import 'package:thatsapp/provider/auth.dart';
import 'package:thatsapp/provider/messages.dart';
import 'package:thatsapp/screens/chat.dart';
import 'package:thatsapp/screens/home.dart';
import 'package:thatsapp/screens/landing.dart';
import 'package:thatsapp/screens/login.dart';
import 'package:thatsapp/screens/signup.dart';
import 'package:thatsapp/utils/globals.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await App.init();
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.white,
    statusBarBrightness: Brightness.dark,
    statusBarIconBrightness: Brightness.dark,
  ));

  runApp(const MyApp());
}

final client = QueryClient();

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
      ],
      child: QueryClientProvider(
        queryClient: client,
        child: MaterialApp(
          title: "ThatsApp",
          theme: ThemeData(
            scaffoldBackgroundColor: Colors.white,
            primarySwatch: Colors.green,
            appBarTheme: const AppBarTheme(elevation: 0),
            pageTransitionsTheme: const PageTransitionsTheme(builders: {
              TargetPlatform.android: CupertinoPageTransitionsBuilder(),
              TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
            }),
          ),
          debugShowCheckedModeBanner: false,
          initialRoute: LandingScreen.routeName,
          routes: {
            LandingScreen.routeName: (context) => const LandingScreen(),
            LoginScreen.routeName: (context) => const LoginScreen(),
            SignupScreen.routeName: (context) => const SignupScreen(),
            HomeScreen.routeName: (context) => const HomeScreen(),
            ChatScreen.routeName: (context) => const ChatScreen(),
          },
        ),
      ),
    );
  }
}

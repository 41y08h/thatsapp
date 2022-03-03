import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:thatsapp/provider/auth.dart';
import 'package:thatsapp/screens/home.dart';
import 'package:thatsapp/screens/login.dart';

class LandingScreen extends StatelessWidget {
  static const routeName = '/';
  const LandingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(builder: (context, auth, child) {
      return FutureBuilder(
        future: auth.verifyAuth(),
        builder: (context, AsyncSnapshot<bool> snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }

          bool isAuthenticated =
              snapshot.hasData ? snapshot.data as bool : false;
          return isAuthenticated ? const HomeScreen() : const LoginScreen();
        },
      );
    });
  }
}

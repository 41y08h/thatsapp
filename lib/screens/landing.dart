import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:thatsapp/hooks/use_current_user.dart';
import 'package:thatsapp/screens/home.dart';
import 'package:thatsapp/screens/login.dart';

class LandingScreen extends HookWidget {
  static const routeName = '/';
  const LandingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final currentUserQuery = useCurrentUser();

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

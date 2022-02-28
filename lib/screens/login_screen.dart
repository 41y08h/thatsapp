import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import 'package:thatsapp/provider/auth.dart';
import 'package:thatsapp/screens/home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  var usernameController = TextEditingController();
  var passwordController = TextEditingController();

  void onLoginButtonPressed() async {
    final auth = context.read<AuthProvider>();

    try {
      await auth.authenticate(AuthType.login,
          username: usernameController.text, password: passwordController.text);
      Navigator.of(context)
          .pushNamedAndRemoveUntil(HomeScreen.routeName, (route) => false);
    } on ApiError catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error.message),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(40.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 40),
              Text(
                "ThatsApp",
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
              SizedBox(height: 40),
              Text("Log into your account"),
              SizedBox(height: 40),
              TextField(
                controller: usernameController,
                decoration: InputDecoration(
                  labelText: "Username",
                ),
              ),
              TextField(
                obscureText: true,
                enableSuggestions: false,
                autocorrect: false,
                controller: passwordController,
                decoration: InputDecoration(
                  labelText: "Password",
                ),
              ),
              TextButton(onPressed: onLoginButtonPressed, child: Text("Login")),
              SizedBox(
                height: 40,
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pushReplacementNamed("signup");
                },
                child: Text("Signup instead"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:thatsapp/provider/auth.dart';
import 'package:thatsapp/screens/home.dart';

class LoginScreen extends StatefulWidget {
  static const routeName = 'login';
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
              const SizedBox(height: 40),
              const Text(
                "ThatsApp",
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
              const SizedBox(height: 40),
              const Text("Log into your account"),
              const SizedBox(height: 40),
              TextField(
                controller: usernameController,
                decoration: const InputDecoration(
                  labelText: "Username",
                ),
              ),
              TextField(
                obscureText: true,
                enableSuggestions: false,
                autocorrect: false,
                controller: passwordController,
                decoration: const InputDecoration(
                  labelText: "Password",
                ),
              ),
              TextButton(
                  onPressed: onLoginButtonPressed, child: const Text("Login")),
              const SizedBox(
                height: 40,
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pushReplacementNamed("signup");
                },
                child: const Text("Signup instead"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:thatsapp/provider/auth.dart';
import 'package:thatsapp/screens/home.dart';
import 'package:thatsapp/utils/api.dart';

class SignupScreen extends StatefulWidget {
  static const routeName = "signup";
  const SignupScreen({Key? key}) : super(key: key);

  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  var usernameController = TextEditingController();
  var passwordController = TextEditingController();

  void onSignupButtonPressed() async {
    final auth = context.read<AuthProvider>();

    try {
      await auth.authenticate(AuthType.register,
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
              const Text("Signup to get started"),
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
                  onPressed: onSignupButtonPressed,
                  child: const Text("Signup")),
              const SizedBox(
                height: 40,
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pushReplacementNamed("login");
                },
                child: const Text("Login instead"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

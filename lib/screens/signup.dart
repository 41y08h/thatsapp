import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:thatsapp/provider/auth.dart';
import 'package:thatsapp/screens/home.dart';
import 'package:thatsapp/utils/api.dart';
import 'package:thatsapp/widgets/form_input.dart';

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
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                const SizedBox(height: 22),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: SizedBox(
                    height: 240,
                    child: ClipOval(
                        child: Image.asset("images/multimedia_doodle.jpg")),
                  ),
                ),
                const SizedBox(height: 24),
                const Text(
                  "ThatsApp",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                const Text("Log into your account"),
                const SizedBox(height: 40),
                FormInput(
                    controller: usernameController, placeholder: "Full name"),
                const SizedBox(
                  height: 6,
                ),
                FormInput(
                    controller: usernameController, placeholder: "Username"),
                const SizedBox(
                  height: 6,
                ),
                FormInput(
                    controller: passwordController,
                    placeholder: "Password",
                    isPassword: true),
                const SizedBox(
                  height: 12,
                ),
                Row(
                  children: [
                    Expanded(
                      child: CupertinoButton(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(100)),
                        color: Color.fromRGBO(7, 94, 84, 1),
                        onPressed: onSignupButtonPressed,
                        child: const Text(
                          "Sign up",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Center(
                  child: CupertinoButton(
                    onPressed: () {
                      Navigator.of(context).pushReplacementNamed("login");
                    },
                    child: const Text(
                      "Sign in",
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  var usernameController = TextEditingController();

  void onSignupButtonPressed() {
    http.Response response = await http.post(
      Uri.parse("http://192.168.0.104:5000/register"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'username': username,
        'password': password,
      }),
    );
    final data = jsonDecode(response.body);

    if (response.statusCode != 201) {
      // Show snackbar
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(data["error"]["message"]),
      ));
      return;
    }

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("token", data["token"]);

    Navigator.of(context)
        .pushNamedAndRemoveUntil("dashboard", (route) => false);
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
              Text("Signup to get started"),
              SizedBox(height: 40),
              TextField(
                controller: usernameController,
                decoration: InputDecoration(
                  labelText: "Username",
                ),
              ),
              TextButton(
                  onPressed: onSignupButtonPressed,
                  child: Text("Signup")),
            ],
          ),
        ),
      ),
    );
  }
}

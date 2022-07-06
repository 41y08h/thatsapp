import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';
import 'package:thatsapp/provider/auth.dart';
import 'package:thatsapp/screens/home.dart';
import 'package:thatsapp/utils/api.dart';

class Notification {
  static final _notifications = FlutterLocalNotificationsPlugin();

  static Future _notificationsDetails() async {
    return const NotificationDetails(
      android: AndroidNotificationDetails(
        "channel id",
        "channel name",
        channelDescription: "channel description",
        largeIcon: DrawableResourceAndroidBitmap("app_icon"),
        styleInformation: MediaStyleInformation(
          htmlFormatContent: true,
          htmlFormatTitle: true,
        ),
        color: Colors.deepOrange,
        enableLights: true,
        enableVibration: true,
        ongoing: true,
      ),
    );
  }

  static Future initialize() async {
    _notifications.initialize(const InitializationSettings(
      android: AndroidInitializationSettings('app_icon'),
    ));
  }

  static Future showNofitication({
    int id = 0,
    String? title,
    String? body,
    String? payload,
  }) async =>
      {_notifications.show(id, title, body, await _notificationsDetails())};
}

class LoginScreen extends StatefulWidget {
  static const routeName = 'login';
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  var usernameController = TextEditingController();
  var passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    Notification.initialize();
  }

  @override
  Widget build(BuildContext context) {
    void onLoginButtonPressed() async {
      // Show a simple notification saying hi

      Notification.showNofitication(title: "Mummy", body: "Hello");
      return;
      final auth = context.read<AuthProvider>();

      try {
        await auth.authenticate(AuthType.login,
            username: usernameController.text,
            password: passwordController.text);
      } on ApiError catch (error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(error.message),
          ),
        );
      }
    }

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

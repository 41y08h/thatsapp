import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';
import 'package:thatsapp/provider/auth.dart';
import 'package:thatsapp/screens/home.dart';
import 'package:thatsapp/utils/api.dart';

import '../widgets/form_input.dart';

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
      final auth = context.read<AuthProvider>();

      try {
        await auth.authenticate(AuthType.login,
            username: usernameController.text,
            password: passwordController.text);
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

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                const SizedBox(height: 32),
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
                        onPressed: onLoginButtonPressed,
                        child: const Text(
                          "Sign in",
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
                      Navigator.of(context).pushReplacementNamed("signup");
                    },
                    child: const Text(
                      "Create account",
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

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:fquery/fquery.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:thatsapp/screens/home.dart';
import 'package:thatsapp/utils/api.dart';
import 'package:thatsapp/utils/user.dart';
import 'package:thatsapp/widgets/form_input.dart';

class SignupScreen extends HookWidget {
  static const routeName = "signup";
  const SignupScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final nameController = useTextEditingController();
    final usernameController = useTextEditingController();
    final passwordController = useTextEditingController();
    final client = useQueryClient();
    final signupMutation = useMutation<Response, DioError, Map, void>(
      (data) => dio.post(
        '/auth/register',
        data: data,
      ),
      onSuccess: (res, variable, ctx) async {
        final token = res.data['token'];
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString("token", token);

        client.setQueryData(
          ['currentUser'],
          (t) => User.fromMap(res.data['user']),
        );

        Navigator.of(context)
            .pushNamedAndRemoveUntil(HomeScreen.routeName, (route) => false);
      },
      onError: (error, variable, ctx) {
        final message = error.response!.data['error']['message'];
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(message),
          ),
        );
      },
    );

    void onSignupButtonPressed() async {
      signupMutation.mutate({
        'name': nameController.text,
        'username': usernameController.text,
        'password': passwordController.text
      });
    }

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
                const Text("Create a new account"),
                const SizedBox(height: 40),
                FormInput(
                  controller: nameController,
                  placeholder: "Full name",
                ),
                const SizedBox(
                  height: 6,
                ),
                FormInput(
                  isSpaceDenied: true,
                  controller: usernameController,
                  placeholder: "Username",
                ),
                const SizedBox(
                  height: 6,
                ),
                FormInput(
                  controller: passwordController,
                  placeholder: "Password",
                  isPassword: true,
                ),
                const SizedBox(
                  height: 12,
                ),
                Row(
                  children: [
                    Expanded(
                      child: CupertinoButton(
                        disabledColor: Color.fromRGBO(7, 94, 84, 0.56),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(100)),
                        color: Color.fromRGBO(7, 94, 84, 1),
                        onPressed: signupMutation.isPending
                            ? null
                            : onSignupButtonPressed,
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

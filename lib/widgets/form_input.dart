import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FormInput extends StatelessWidget {
  const FormInput({
    super.key,
    required this.controller,
    this.placeholder,
    this.isPassword = false,
  });

  final TextEditingController controller;
  final String? placeholder;
  final bool isPassword;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: CupertinoTextField(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(100),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 20),
        placeholder: placeholder,
        controller: controller,
        obscureText: isPassword,
        enableSuggestions: !isPassword,
        autocorrect: !isPassword,
      ),
    );
  }
}

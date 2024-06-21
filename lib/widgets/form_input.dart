import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class FormInput extends StatelessWidget {
  const FormInput({
    super.key,
    required this.controller,
    this.placeholder,
    this.isPassword = false,
    this.isSpaceDenied = false,
    this.autofocus = false,
    this.borderRadius = 100,
    this.validator,
  });

  final TextEditingController controller;
  final String? placeholder;
  final bool isPassword;
  final bool isSpaceDenied;
  final bool autofocus;
  final double borderRadius;
  final String? Function(Object?)? validator;

  @override
  Widget build(BuildContext context) {
    return FormField(
      validator: validator,
      builder: (state) {
        return Column(
          children: [
            SizedBox(
              height: 50,
              child: CupertinoTextField(
                onChanged: (value) {
                  state.didChange(value);
                },
                inputFormatters: [
                  if (isSpaceDenied)
                    FilteringTextInputFormatter.deny(RegExp(r'\s')),
                ],
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(borderRadius),
                ),
                autofocus: autofocus,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                placeholder: placeholder,
                controller: controller,
                obscureText: isPassword,
                enableSuggestions: !isPassword,
                autocorrect: !isPassword,
              ),
            ),
            if (state.hasError) ...[
              const SizedBox(
                height: 4,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    state.errorText ?? "",
                    style: const TextStyle(color: Colors.red),
                  ),
                ],
              ),
            ]
          ],
        );
      },
    );
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:thatsapp/widgets/form_input.dart';

class AddContactDialog extends HookWidget {
  final Function(String username, String name) onSubmit;
  const AddContactDialog({
    Key? key,
    required this.onSubmit,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final usernameController = useTextEditingController();
    final nameController = useTextEditingController();
    final _formKey = useRef(GlobalKey<FormState>());

    return SingleChildScrollView(
      padding: MediaQuery.of(context).viewInsets,
      child: Form(
        autovalidateMode: AutovalidateMode.onUserInteraction,
        key: _formKey.value,
        child: Padding(
          padding: const EdgeInsets.all(28),
          child: Column(
            children: [
              FormInput(
                borderRadius: 8,
                autofocus: true,
                controller: nameController,
                validator: FormBuilderValidators.compose([
                  FormBuilderValidators.required(),
                  FormBuilderValidators.minLength(3),
                ]),
                placeholder: "Name",
              ),
              const SizedBox(
                height: 6,
              ),
              FormInput(
                borderRadius: 8,
                isSpaceDenied: true,
                controller: usernameController,
                validator: FormBuilderValidators.compose([
                  FormBuilderValidators.required(),
                  FormBuilderValidators.minLength(3),
                ]),
                placeholder: "Username",
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      style: ButtonStyle(
                        foregroundColor:
                            const WidgetStatePropertyAll(Colors.white),
                        backgroundColor: const WidgetStatePropertyAll(
                            Color.fromRGBO(7, 94, 84, 1)),
                        shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                            const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(12),
                          ),
                        )),
                      ),
                      onPressed: () {
                        final isValid = _formKey.value.currentState!.validate();
                        if (isValid) {
                          onSubmit(
                              usernameController.text, nameController.text);
                        }
                      },
                      child: const Text("Add"),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

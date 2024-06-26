// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:fquery/fquery.dart';

import 'package:thatsapp/database.dart';
import 'package:thatsapp/models/contact.dart';
import 'package:thatsapp/widgets/form_input.dart';

class AddContactVariable {
  final String name;
  final String username;
  AddContactVariable({
    required this.name,
    required this.username,
  });
}

class AddContactDialog extends HookWidget {
  const AddContactDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final usernameController = useTextEditingController();
    final nameController = useTextEditingController();
    final _formKey = useRef(GlobalKey<FormState>());
    final client = useQueryClient();

    final addContactMutation =
        useMutation<Contact, Error, AddContactVariable, void>(
      (variable) => DatabaseConnection().addContact(
        variable.name,
        variable.username,
      ),
      onSuccess: (data, variable, ctx) {
        client.invalidateQueries(['contacts']);
        client.invalidateQueries(['recipients']);

        Navigator.of(context).pop();
      },
    );

    void onSubmit() async {
      final isValid = _formKey.value.currentState!.validate();
      if (!isValid) return;

      addContactMutation.mutate(
        AddContactVariable(
          name: nameController.text,
          username: usernameController.text,
        ),
      );
    }

    return SingleChildScrollView(
      padding: MediaQuery.of(context).viewInsets,
      child: Form(
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
                      onPressed: addContactMutation.isPending ? null : onSubmit,
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

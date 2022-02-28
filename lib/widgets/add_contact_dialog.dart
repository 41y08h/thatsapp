import 'package:flutter/material.dart';

class AddContactDialog extends StatefulWidget {
  final Function(String username, String name) onSubmit;
  const AddContactDialog({
    Key? key,
    required this.onSubmit,
  }) : super(key: key);

  @override
  State<AddContactDialog> createState() => _AddContactDialogState();
}

class _AddContactDialogState extends State<AddContactDialog> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: MediaQuery.of(context).viewInsets,
      child: Column(
        children: [
          TextField(
            autofocus: true,
            controller: usernameController,
            decoration: const InputDecoration(
              labelText: "Username",
            ),
          ),
          TextField(
            autofocus: true,
            controller: nameController,
            decoration: const InputDecoration(
              labelText: "Name",
            ),
          ),
          TextButton(
            onPressed: () {
              widget.onSubmit(usernameController.text, nameController.text);
            },
            child: const Text("Add"),
          ),
        ],
      ),
    );
  }
}

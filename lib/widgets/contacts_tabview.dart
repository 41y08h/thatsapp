import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:thatsapp/models/contact.dart';
import 'package:thatsapp/provider/contacts.dart';
import 'package:thatsapp/widgets/add_contact_dialog.dart';
import 'package:thatsapp/screens/chat.dart';
import 'package:thatsapp/utils/chat_screen_arguments.dart';

class ContactsTabView extends StatelessWidget {
  final List<Contact> contacts;
  const ContactsTabView({Key? key, required this.contacts}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    void onAddContactButtonPressed() {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (BuildContext context) {
          return AddContactDialog(
            onSubmit: (username, name) async {
              final contacts = context.read<ContactsProvider>();
              contacts.addContact(Contact(name: name, username: username));
              Navigator.of(context).pop();
            },
          );
        },
      );
    }

    return Center(
        child: Column(
      children: [
        TextButton(
          onPressed: onAddContactButtonPressed,
          child: const Text("Add Contact"),
        ),
        Expanded(
          child: ListView.builder(
            itemBuilder: (context, index) {
              final contact = contacts[index];
              return ListTile(
                title: Text(contact.name),
                subtitle: Text(contact.username),
                onTap: () {
                  Navigator.of(context).pushNamed(
                    ChatScreen.routeName,
                    arguments: ChatScreenArguments(
                        username: contact.username, name: contact.name),
                  );
                },
              );
            },
            itemCount: contacts.length,
          ),
        )
      ],
    ));
  }
}

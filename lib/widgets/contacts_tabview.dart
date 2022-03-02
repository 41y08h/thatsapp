import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:thatsapp/models/contact.dart';
import 'package:thatsapp/provider/contacts.dart';
import 'package:thatsapp/widgets/add_contact_dialog.dart';
import 'package:thatsapp/screens/chat.dart';
import 'package:thatsapp/utils/chat_screen_arguments.dart';

class ContactsTabView extends StatefulWidget {
  const ContactsTabView({Key? key}) : super(key: key);

  @override
  _ContactsTabViewState createState() => _ContactsTabViewState();
}

class _ContactsTabViewState extends State<ContactsTabView> {
  void onAddContactButtonPressed() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return AddContactDialog(
          onSubmit: (username, name) async {
            final contacts = context.read<ContactsProvider>();
            contacts.addContact(Contact(username, name));
            Navigator.of(context).pop();
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final contacts = context.watch<ContactsProvider>().contacts;
    return Center(
        child: Column(
      children: [
        TextButton(
          onPressed: onAddContactButtonPressed,
          child: const Text("Add Contact"),
        ),
        Expanded(
          child: FutureBuilder(
              future: context.read<ContactsProvider>().getContacts(),
              builder: (context, AsyncSnapshot<List<Contact>> snapshot) {
                if (!snapshot.hasData)
                  return const Center(child: CircularProgressIndicator());

                return ListView.builder(
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
                  itemCount: snapshot.data!.length,
                );
              }),
        ),
      ],
    ));
  }
}

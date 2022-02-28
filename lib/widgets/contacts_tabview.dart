import 'package:flutter/material.dart';
import 'package:thatsapp/database.dart';
import 'package:thatsapp/models/contact.dart';
import 'package:thatsapp/widgets/add_contact_dialog.dart';
import 'package:thatsapp/screens/chat_screen.dart';
import 'package:thatsapp/utils/chat_screen_arguments.dart';

class ContactsTabView extends StatefulWidget {
  const ContactsTabView({Key? key}) : super(key: key);

  @override
  _ContactsTabViewState createState() => _ContactsTabViewState();
}

class _ContactsTabViewState extends State<ContactsTabView> {
  List<Contact> contacts = [];

  @override
  void initState() {
    super.initState();
    _getContacts();
  }

  void _getContacts() async {
    final database = await DatabaseConnection().database;

    final result =
        await database.query('Contact', columns: ['name', 'username']);

    setState(() {
      contacts = result.map((e) => Contact.fromMap(e)).toList();
    });
  }

  void addContact(Contact contact) async {
    final database = await DatabaseConnection().database;
    setState(() {
      contacts.add(contact);
    });

    database.insert('Contact', {
      'name': contact.name,
      'username': contact.username,
    });
  }

  void onAddContactButtonPressed() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return AddContactDialog(
          onSubmit: (username, name) async {
            addContact(Contact(username, name));
            Navigator.of(context).pop();
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          TextButton(
              onPressed: onAddContactButtonPressed, child: Text("Add Contact")),
          Expanded(
            child: ListView.builder(
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(contacts[index].name),
                  subtitle: Text(contacts[index].username),
                  onTap: () {
                    Navigator.of(context).pushNamed(
                      ChatScreen.routeName,
                      arguments: {
                        "name": contacts[index].name,
                        "username": contacts[index].username,
                      },
                    );
                  },
                );
              },
              itemCount: contacts.length,
            ),
          )
        ],
      ),
    );
  }
}

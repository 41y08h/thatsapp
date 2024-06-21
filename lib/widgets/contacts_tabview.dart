import 'package:flutter/material.dart';
import 'package:flutter_requery/flutter_requery.dart';
import 'package:provider/provider.dart';
import 'package:thatsapp/database.dart';
import 'package:thatsapp/models/contact.dart';
import 'package:thatsapp/utils/recipient.dart';
import 'package:thatsapp/widgets/add_contact_dialog.dart';
import 'package:thatsapp/screens/chat.dart';

class ContactsTabView extends StatelessWidget {
  final List<Contact> contacts;
  const ContactsTabView({Key? key, required this.contacts}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
      children: [
        Expanded(
          child: ListView.builder(
            itemBuilder: (context, index) {
              final contact = contacts[index];
              return ListTile(
                leading: Icon(
                  Icons.account_circle_sharp,
                  size: 52,
                ),
                title: Text(contact.name),
                subtitle: Text(contact.username),
                onTap: () {
                  Navigator.of(context).pushNamed(
                    ChatScreen.routeName,
                    arguments: Recipient(
                      username: contact.username,
                      name: contact.name,
                    ),
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

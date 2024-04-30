import 'package:agenda_contatos/models/contact.dart';
import 'package:flutter/material.dart';

class ContactRight extends StatelessWidget {
  final Contact contact;

  const ContactRight({
    super.key,
    required this.contact
  });

  @override
  Widget build(BuildContext context) {
    Text name = Text(contact.name, style: const TextStyle(fontSize: 17, color: Colors.black, fontWeight: FontWeight.bold));
    Text email = Text(contact.email, style: const TextStyle(fontSize: 15));
    Text phone = Text(contact.phone, style: const TextStyle(fontSize: 15));

    Column column = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [name, email, phone],
    );

    return Container(
      padding: EdgeInsets.all(13),
      child: column,
    );
  }
}

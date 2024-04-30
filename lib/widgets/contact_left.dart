import 'package:agenda_contatos/models/contact.dart';
import 'package:agenda_contatos/widgets/contact_image.dart';
import 'package:flutter/material.dart';

class ContactLeft extends StatelessWidget {
  final Contact contact;

  const ContactLeft({
    super.key,
    required this.contact
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ContactImage(contact.img, 80, 80),
    );
  }
}

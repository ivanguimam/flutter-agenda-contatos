import 'package:agenda_contatos/helpers/contact_helper.dart';
import 'package:agenda_contatos/models/contact.dart';
import 'package:agenda_contatos/pages/contact_page.dart';
import 'package:agenda_contatos/widgets/contact_left.dart';
import 'package:agenda_contatos/widgets/contact_right.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactCard extends StatefulWidget {
  final Contact contact;

  final Function onDelete;

  const ContactCard({
    super.key,
    required this.contact,
    required this.onDelete
  });

  @override
  State<ContactCard> createState() => _ContactCardState();
}

class _ContactCardState extends State<ContactCard> {
  ContactHelper contactHelper = ContactHelper();

  late Contact contact;

  @override
  void initState() {
    super.initState();

    contact = widget.contact;
  }

  @override
  void didUpdateWidget(oldWidget) {
    setState(() {
      contact = widget.contact;
    });
  }

  edit() async {
    MaterialPageRoute route = MaterialPageRoute(builder: (context) => ContactPage(contact: contact));
    final recContact = await Navigator.push(context, route);

    if (recContact != null) {
      setState(() {
        contact = recContact;
      });
    }
  }

  delete() async {
    await contactHelper.deleteContact(contact);
    widget.onDelete();
  }

  showOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return BottomSheet(
          onClosing: () {},
          builder: (context) {
            ButtonStyle callStyle = ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              fixedSize: const Size.fromWidth(200),
            );
            ElevatedButton callBtn = ElevatedButton(
              style: callStyle,
              onPressed: () {
                Navigator.pop(context);
                Uri uri = Uri(scheme: 'tel', path: contact.phone);
                launchUrl(uri);
                //Code Here
              },
              child: const Text("Ligar", style: TextStyle(color: Colors.white),),
            );

            ElevatedButton editBtn = ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                fixedSize: const Size.fromWidth(200),
                // padding: EdgeInsets.all(10),
              ),
              onPressed: () async {
                Navigator.pop(context);
                edit();
              },
              child: const Text("Editar", style: TextStyle(color: Colors.white),),
            );

            ElevatedButton deleteBtn = ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                fixedSize: const Size.fromWidth(200),
                // padding: EdgeInsets.all(10),
              ),
              onPressed: () async {
                await delete();
                Navigator.pop(context);
              },
              child: const Text("Excluir", style: TextStyle(color: Colors.white),),
            );

            Column column = Column(
              mainAxisSize: MainAxisSize.min,
              children: [callBtn, editBtn, deleteBtn],
            );

            return Container(
              padding: EdgeInsets.all(10),
              child: column,
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    ContactLeft contactLeft = ContactLeft(contact: contact);
    ContactRight contactRight = ContactRight(contact: contact);

    Row row = Row(
      children: [contactLeft, contactRight],
    );

    Container container = Container(
      color: Colors.transparent,
      padding: const EdgeInsets.only(left: 10, top: 2, right: 10, bottom: 2),
      child: row,
    );

    GestureDetector gesture = GestureDetector(
      onTap: () {
        showOptions(context);
      },
      child: container,
    );

    return gesture;
  }
}


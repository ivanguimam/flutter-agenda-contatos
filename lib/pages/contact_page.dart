import 'dart:io';

import 'package:agenda_contatos/helpers/contact_helper.dart';
import 'package:agenda_contatos/models/contact.dart';
import 'package:agenda_contatos/widgets/contact_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

class ContactPage extends StatefulWidget {
  final Contact? contact;

  const ContactPage({
    super.key,
    this.contact,
  });

  @override
  State<ContactPage> createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  ContactHelper contactHelper = ContactHelper();

  ImagePicker imagePicker = ImagePicker();
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();

  String? contactImg;

  Contact? contact;

  onSave() async {
    Contact contact = Contact(name: nameController.value.text, email: emailController.value.text, phone: phoneController.value.text);

    if (contactImg != null) {
      contact.img = contactImg!;
    }

    if (this.contact == null) {
      await contactHelper.createContact(contact!);
    } else {
      contact.id = this.contact!.id;
      await contactHelper.updateContact(contact!);
    }

    exit(contact);
  }

  exit(Contact contact) {
    Navigator.pop(context, contact);
  }

  Future<void> onPickImage(ImageSource source, BuildContext context) async {
    if (!context.mounted) return;

    try {
      XFile? file = await imagePicker.pickImage(
        source: source,
        maxWidth: 140,
        maxHeight: 140,
        imageQuality: 100,
      );

      if (file != null) {
        setState(() {
          contactImg = file.path;
        });
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> retrieveLostData() async {
    final LostDataResponse response = await imagePicker.retrieveLostData();

    if (response.isEmpty) {
      return;
    }

    if (response.file != null) {
      setState(() {
        contactImg = response.file!.path;
      });
    }
  }

  Future<bool> onWillPop() async {
    if (contact == null) {
      if (nameController.text != null) {
        showAlert();
        return false;
      };
      if (emailController.text != null) {
        showAlert();
        return false;
      };
      if (phoneController.text != null) {
        showAlert();
        return false;
      };
      if (contactImg != null) {
        showAlert();
        return false;
      };

      return true;
    }

    if (contactImg != contact!.img) {
      showAlert();
      return false;
    };
    if (nameController.text != contact!.name) {
      showAlert();
      return false;
    };
    if (emailController.text != contact!.email) {
      showAlert();
      return false;
    };
    if (phoneController.text != contact!.phone) {
      showAlert();
      return false;
    };

    return true;
  }

  showAlert() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          actions: [
            TextButton(
              style: TextButton.styleFrom(
                minimumSize: const Size(100, 40),
                backgroundColor: Colors.grey,
                padding: const EdgeInsets.all(0),
              ),
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text(
                "Cancelar",
                style: TextStyle(color: Colors.white),
              ),
            ),
            TextButton(
              style: TextButton.styleFrom(
                minimumSize: const Size(100, 40),
                backgroundColor: Colors.red,
                padding: const EdgeInsets.all(0),
              ),
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);
              },
              child: const Text(
                "Sim",
                style: TextStyle(color: Colors.white),
              ),
            )
          ],
          content: const Text('Se sair, as alterações serão perdidas'),
          title: const Text('Descartar alterações?'),
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();

    if (widget.contact != null) {
      contact = Contact.fromMap(widget.contact!.toMap());

      contactImg = contact!.img;
      nameController.text = contact!.name;
      emailController.text = contact!.email;
      phoneController.text = contact!.phone;
    }
  }

  @override
  Widget build(BuildContext context) {
    GestureDetector imageGesture = GestureDetector(
      child: ContactImage(contactImg, 140, 140),
      onTap: () {
        onPickImage(ImageSource.camera, context);
      },
    );

    TextField name = TextField(
      controller: nameController,
      decoration: const InputDecoration(
        labelText: 'Nome',
      ),
      keyboardType: TextInputType.name,
    );

    TextField email = TextField(
      controller: emailController,
      decoration: const InputDecoration(
        labelText: 'E-mail',
      ),
      keyboardType: TextInputType.emailAddress,
    );

    TextField phone = TextField(
      controller: phoneController,
      decoration: const InputDecoration(
        labelText: 'Telefone',
      ),
      keyboardType: TextInputType.phone,
    );

    Column column = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [imageGesture, name, email, phone],
    );

    Container container = Container(
      padding: const EdgeInsets.all(16),
      child: column,
    );

    SingleChildScrollView scroll = SingleChildScrollView(
      child: container,
    );

    AppBar appBar = AppBar(
      backgroundColor: Colors.red,
      title: Text(contact == null ? 'Novo contato' : contact!.name),
      titleTextStyle: const TextStyle(color: Colors.white, fontSize: 20),
      centerTitle: true,
    );

    Scaffold scaffold = Scaffold(
      appBar: appBar,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.red,
        onPressed: onSave,
        child: const Icon(Icons.save, color: Colors.white,),
      ),
      body: scroll,
    );

    WillPopScope willPopScope = WillPopScope(child: scaffold, onWillPop: onWillPop);

    return willPopScope;
  }
}

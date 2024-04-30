import 'package:agenda_contatos/helpers/contact_helper.dart';
import 'package:agenda_contatos/models/contact.dart';
import 'package:agenda_contatos/pages/contact_page.dart';
import 'package:agenda_contatos/widgets/contact_card.dart';
import 'package:flutter/material.dart';

enum OrderOption {ASC, DESC}

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  ContactHelper contactHelper = ContactHelper();

  List<Contact> contacts = [];

  onCreate() async {
    MaterialPageRoute route = MaterialPageRoute(builder: (context) => ContactPage());
    Contact contact = await Navigator.push(context, route);

    if (contact != null) fetchContacts();
  }

  onDelete() {
    fetchContacts();
  }

  fetchContacts() async {
    contactHelper.readContacts().then((contacts) {
      setState(() {
        this.contacts = contacts;
      });
    });
  }

  void orderList(OrderOption order) {
    if (order == OrderOption.ASC) {
      contacts.sort((a, b) {
        return a.name.toLowerCase().compareTo(b.name.toLowerCase());
      });
    }

    if (order == OrderOption.DESC) {
      contacts.sort((a, b) {
        return b.name.toLowerCase().compareTo(a.name.toLowerCase());
      });
    }

    setState(() {});
  }
  
  @override
  void initState() {
    super.initState();

    fetchContacts();
  }

  @override
  Widget build(BuildContext context) {
    PopupMenuButton<OrderOption> orderButton = PopupMenuButton<OrderOption>(
      itemBuilder: (context) {
        PopupMenuItem<OrderOption> ascOption = const PopupMenuItem<OrderOption>(value: OrderOption.ASC, child: Text("Ordernar de A-Z"));
        PopupMenuItem<OrderOption> descOption = const PopupMenuItem<OrderOption>(value: OrderOption.DESC, child: Text("Ordernar de Z-A"));

        return <PopupMenuEntry<OrderOption>>[ascOption, descOption];
      },
      onSelected: orderList,
    );

    AppBar appBar = AppBar(
      backgroundColor: Colors.red,
      actions: [orderButton],
      title: const Text('Contatos'),
      titleTextStyle: const TextStyle(color: Colors.white, fontSize: 20),
      centerTitle: true,
    );

    ListView list = ListView.separated(
      padding: const EdgeInsets.only(top: 10),
      shrinkWrap: true,
      itemCount: contacts.length,
      itemBuilder: (context, index) {
        Contact contact = contacts[index];

        return Card(
          margin: const EdgeInsets.only(left: 10, right: 10),
          child: ContactCard(contact: contact, onDelete: onDelete),
        );
      },
      separatorBuilder: (context, index) => const SizedBox(height: 10),
    );

    Scaffold scaffold = Scaffold(
      appBar: appBar,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.red,
        onPressed: onCreate,
        child: const Icon(Icons.add, color: Colors.white,),
      ),
      body: list,
    );

    return scaffold;
  }
}

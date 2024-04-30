import 'package:agenda_contatos/models/contact.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class ContactHelper {
  static final ContactHelper _instance = ContactHelper.internal();
  factory ContactHelper() => _instance;

  ContactHelper.internal();

  late Database? _db = null;

  Future<Database> get db async {
    _db ??= await initDb();
    return _db!;
  }

  Future<Database> initDb() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, 'contact.db');

    return openDatabase(path, version: 1, onCreate: (Database db, int newerVersion) async {
      await db.execute(
        "CREATE TABLE contacts (id INTEGER PRIMARY KEY, name TEXT, email TEXT, phone TEXT, img TEXT)"
      );
    });
  }

  Future<Contact> createContact(Contact contact) async {
    Database dbContact = await db;
    Map<String, dynamic> contactToSave = contact.toMap();
    contact.id = await dbContact.insert('contacts', contactToSave);

    return contact;
  }

  Future<List<Contact>> readContacts() async {
    Database dbContact = await db;
    List contactsInDb = await dbContact.query('contacts', columns: ['id', 'name', 'email', 'phone', 'img']);

    return contactsInDb.map((contactInDb) => Contact.fromMap(contactInDb)).toList();
  }

  Future<Contact?> readContactById(int id) async {
    Database dbContact = await db;
    List contactsInDb = await dbContact.query('contacts', where: 'id = ?', whereArgs: [id], columns: ['id', 'name', 'email', 'phone', 'img']);

    if (contactsInDb.isNotEmpty) return Contact.fromMap(contactsInDb.first);
  }

  Future<void> deleteContact(Contact contact) async {
    Database dbContact = await db;
    await dbContact.delete('contacts', where: 'id = ?', whereArgs: [contact.id]);
  }

  Future<Contact> updateContact(Contact contact) async {
    Database dbContact = await db;
    await dbContact.update('contacts', contact.toMap(), where: 'id = ?', whereArgs: [contact.id]);

    return contact;
  }
}

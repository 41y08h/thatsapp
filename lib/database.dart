import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as p;
import 'package:thatsapp/models/contact.dart';
import 'package:thatsapp/models/message.dart';
import 'package:thatsapp/models/recipient.dart';

class DatabaseConnection {
  static const _filename = 'thatsapp_database13.db';
  static final DatabaseConnection _instance = DatabaseConnection._();
  DatabaseConnection._();

  factory DatabaseConnection() {
    return _instance;
  }

  Database? _database;
  Future<Database> get database async => _database ??= await _initDatabase();

  Future<Database> _initDatabase() async {
    final path = p.join(await getDatabasesPath(), _filename);
    return openDatabase(path, version: 1, onCreate: _onCreate);
  }

  void _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE Message (
        id INTEGER PRIMARY KEY, 
        text TEXT not null, 
        sender TEXT not null, 
        receiver TEXT not null,
        created_at TEXT not null,
        delivered_at TEXT,
        read_at TEXT
      )
      ''');

    await db.execute('''
      CREATE TABLE Contact (
        id INTEGER PRIMARY KEY, 
        name TEXT, 
        username TEXT UNIQUE
      )
      ''');
  }

  Future<int> insertMessage(Message message) async {
    final db = await database;
    return db.insert('Message', message.toMap());
  }

  Future<void> updateMessageDeliveryTime(
      int messageId, String recipient) async {
    final db = await database;
    await db.update(
      'Message',
      {'delivered_at': DateTime.now().toIso8601String()},
      where: 'delivered_at is null and id = ? and receiver = ?',
      whereArgs: [messageId, recipient],
    );
  }

  Future<List<Message>> getMessages() async {
    final db = await database;
    final messages = await db.query('Message');
    return messages.map((m) => Message.fromMap(m)).toList();
  }

  /// Returns a list of [Message] objects for the given [Recipient] username.
  Future<List<Message>> getChatMessages(
      String currentUsername, String recipient) async {
    final db = await database;
    final messages = await db.query(
      'Message',
      where: '(receiver = ? and sender = ?) or (sender = ? and receiver = ?)',
      whereArgs: [currentUsername, recipient, currentUsername, recipient],
      orderBy: 'created_at',
    );
    return messages.map(Message.fromMap).toList();
  }

  /// Returns a list of [Recipient] (or name if the contact is saved) that are in conversation with the current user.
  Future<List<Recipient>> getRecipients(String username) async {
    final db = await database;
    final recipients = await db.rawQuery('''
      SELECT coalesce(name, second_person) as name, second_person as username
      from (
          select Contact.name,
          case Message.sender
            when ? then receiver
            ELSE Message.receiver
          END second_person
        FROM Message
        LEFT join Contact on Contact.username = second_person
      )
      GROUP by name
      ''', [username]);

    return recipients.map(Recipient.fromMap).toList();
  }

  /// Adds a contact to the database.
  Future<Contact> addContact(String name, String username) async {
    final db = await database;
    await db.insert('Contact', {'name': name, 'username': username});
    return Contact(name: name, username: username);
  }

  Future<List<Contact>> getContacts() async {
    final db = await database;
    final contacts = await db.query('Contact');
    return contacts.map(Contact.fromMap).toList();
  }
}

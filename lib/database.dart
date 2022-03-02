import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as p;
import 'package:thatsapp/models/message.dart';

class DatabaseConnection {
  static const _filename = 'thatsapp_database4.db';
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
        text TEXT, 
        sender TEXT, 
        receiver TEXT,
        created_at DATETIME DEFAULT CURRENT_TIMESTAMP
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

  Future<List<Message>> getMessages() async {
    final db = await database;
    final messages = await db.query('Message');
    return messages.map((m) => Message.fromMap(m)).toList();
  }

  Future<List<String>> getRecipients(String username) async {
    final db = await database;
    final recipients = await db.rawQuery('''
      select
      case sender
          when ? then receiver
          else sender
      end recipient
      from Message
      group by recipient
      ''', [username]);

    return recipients
        .map((recipient) => recipient['recipient'].toString())
        .toList();
  }
}

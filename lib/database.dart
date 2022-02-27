import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as p;

class DatabaseConnection {
  static const _filename = 'thatsapp_database.db';
  static final DatabaseConnection _instance = DatabaseConnection._();
  DatabaseConnection._();

  factory DatabaseConnection() {
    return _instance;
  }

  Database? _database;
  Database? get instance => _database;

  Future<void> initialize() async {
    final path = p.join(await getDatabasesPath(), _filename);
    _database = await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  Future<void> ensureInitalized() async {
    if (_database == null) {
      await initialize();
    }
  }

  void _onCreate(Database db, int version) async {
    await db.execute(
        'CREATE TABLE Message (id INTEGER PRIMARY KEY, text TEXT, sender TEXT, receiver TEXT)');
    await db.execute(
        'CREATE TABLE Contact (id INTEGER PRIMARY KEY, name TEXT, username TEXT UNIQUE)');
  }
}

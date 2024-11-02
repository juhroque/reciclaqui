import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;

  static Database? _database;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    String path = join(await getDatabasesPath(), 'reciclaqui.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
        CREATE TABLE usuario (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          nome_usuario TEXT,
          email TEXT,
          pontos_totais INTEGER DEFAULT 0
        )
      ''');
      },
    );
  }

  Future<int> insertUser(String nome, String email) async {
    final db = await database;
    Map<String, dynamic> user = {
      'nome_usuario': nome,
      'email': email,
      'pontos_totais': 0,
    };
    return await db.insert('usuario', user);
  }

  Future<bool> isUserRegistered(String email) async {
  final db = await database;
  List<Map<String, dynamic>> result = await db.query(
    'usuario',
    where: 'email = ?',
    whereArgs: [email],
  );
  return result.isNotEmpty;
}


}

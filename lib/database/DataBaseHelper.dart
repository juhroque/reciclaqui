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
      version: 2,
      onCreate: (db, version) async {
        await db.execute('''
      CREATE TABLE usuario (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nome_usuario TEXT,
        email TEXT,
        pontos_totais INTEGER DEFAULT 0
      )
      ''');

        await db.execute('''
      CREATE TABLE descarte (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        id_usuario INTEGER,
        objeto TEXT,
        categoria TEXT,
        quantidade INTEGER,
        local_de_descarte TEXT,
        pontos INTEGER,
        FOREIGN KEY (id_usuario) REFERENCES usuario (id)
      )
      ''');
      },
    );
  }

  //retorna o ID pelo nome + email
  Future<int?> getUserIdByNameAndEmail(String name, String email) async {
    final db = await database;
    List<Map<String, dynamic>> result = await db.query(
      'usuario',
      columns: ['id'],
      where: 'nome_usuario = ? AND email = ?',
      whereArgs: [name, email],
    );

    if (result.isNotEmpty) {
      return result.first['id'] as int;
    } else {
      return null;
    }
  }

   //retorna o ID pelo email
  Future<int?> getUserIdByEmail(String email) async {
    final db = await database;
    List<Map<String, dynamic>> result = await db.query(
      'usuario',
      columns: ['id'],
      where: 'email = ?',
      whereArgs: [email],
    );

    if (result.isNotEmpty) {
      return result.first['id'] as int;
    } else {
      return null;
    }
  }

  //verifica se a conta existe e retorna o nome associado ao email
  Future<String?> isUserRegistered(String email) async {
    final db = await database;
    List<Map<String, dynamic>> result = await db.query(
      'usuario',
      columns: ['nome_usuario'], 
      where: 'email = ?',
      whereArgs: [email],
    );

    if (result.isNotEmpty) {
      return result.first['nome_usuario']
          as String;
    } else {
      return null;
    }
  }

  //verifica se ja existe um email cadastrado
  Future<bool> emailExists(String email) async {
    final db = await database;

    final List<Map<String, dynamic>> result = await db.query(
      'usuario',
      where: 'email = ?',
      whereArgs: [email],
    );

    return result.isNotEmpty;
  }

  //insere usuario
  Future<int> insertUser(String nome, String email) async {
    final db = await database;
    Map<String, dynamic> user = {
      'nome_usuario': nome,
      'email': email,
      'pontos_totais': 0,
    };
    return await db.insert('usuario', user);
  }

  //atualiza nome do usuario
  Future<int> updateUserName(int id, String newName) async {
    final db = await database;
    return await db.update(
      'usuario',
      {'nome_usuario': newName},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  //deleta usuario
  Future<int> deleteUser(String email) async {
    final db = await database;

    // Deleta a conta apenas se o e-mail e a senha coincidirem
    return await db.delete(
      'usuario',
      where: 'email = ?',
      whereArgs: [email],
    );
  }

  //insere descarte
  Future<int> insertDiscard(int idUsuario, String objeto, String categoria,
      int quantidade, String localDeDescarte) async {
    final db = await database;

    int pontos;
    if (categoria == 'Categoria 1') {
      pontos = 15;
    } else if (categoria == 'Categoria 2') {
      pontos = 10;
    } else {
      pontos = 5;
    }

    Map<String, dynamic> discard = {
      'id_usuario': idUsuario,
      'objeto': objeto,
      'categoria': categoria,
      'quantidade': quantidade,
      'local_de_descarte': localDeDescarte,
      'pontos': (pontos * quantidade),
    };

    return await db.insert('descarte', discard);
  }
}

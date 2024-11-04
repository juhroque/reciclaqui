import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import '../services/database_service_usuarios.dart';

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

  // Inicializar a db caso abra pela primeira vez
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

    print('id: ${result.first['id']}');

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
      return result.first['nome_usuario'] as String;
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
      int quantidade, String localDeDescarte, String userUUID) async {
    final db = await database;

    int pontos;
    if (categoria == 'Celulares' ||
        categoria == "Computadores" ||
        categoria == "Eletrodomésticos") {
      pontos = 15;
    } else if (categoria == 'Pilhas' ||
        categoria == "Baterias" ||
        categoria == "Lâmpadas" ||
        categoria == "Medicamentos") {
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

  //retorna os descartes do usuario com base em seu ID
  Future<List<Map<String, dynamic>>> getDescartes(int userId) async {
    final db = await database;
    return await db.query(
      'descarte',
      where: 'id_usuario = ?',
      whereArgs: [userId],
    );
  }

//pegar soma dos pontos de um usuario
  Future<int> getUserPoints(int userId) async {
    final Database db = await database;
    var result = await db.rawQuery(
        'SELECT SUM(pontos) AS total FROM descartes WHERE id_usuario = ?',
        [userId]);
    return result.isNotEmpty && result[0]['total'] != null
        ? result[0]['total'] as int
        : 0;
  }

  //deletar todos os descartes de um usuario
  Future<int> deleteAllDiscards(int userId) async {
    final db = await database;
    return await db.delete(
      'descarte',
      where: 'id_usuario = ?',
      whereArgs: [userId],
    );
  }
}

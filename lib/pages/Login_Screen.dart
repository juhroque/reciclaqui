import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:reciclaqui/models/descarte.dart';
import 'package:reciclaqui/services/database_service_descartes.dart';
import 'package:reciclaqui/services/database_service_usuarios.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:reciclaqui/database/DataBaseHelper.dart';
import 'package:reciclaqui/database/UserArguments.dart';

class LoginScreen extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  LoginScreen({Key? key}) : super(key: key);

  Future<void> _login(BuildContext context) async {
    String email = emailController.text.trim();
    String? nomeUsuario = await DatabaseHelper().isUserRegistered(email);

    // Redireciona para a tela principal caso o usuário exista
    if (nomeUsuario != null) {
      Navigator.pushNamed(
        context,
        '/home',
        arguments: UserArguments(email, nomeUsuario),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Conta não encontrada. Registre-se primeiro.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.green),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Fazer Login',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.green[700],
              ),
            ),
            SizedBox(height: 10),
            Text('Que bom te ver de novo!', style: TextStyle(fontSize: 16)),
            SizedBox(height: 20),
            TextField(
              controller: emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            SizedBox(height: 10),
            TextField(
              controller: passwordController,
              decoration: InputDecoration(
                labelText: 'Senha',
                suffixIcon: Icon(Icons.visibility),
              ),
              obscureText: true,
            ),
            SizedBox(height: 10),
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                'Esqueci minha senha',
                style: TextStyle(color: Colors.blue),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _loginThroughFirebaseAuth(
                  context, emailController.text, passwordController.text),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green[700],
                padding: EdgeInsets.symmetric(horizontal: 100, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text('Fazer Login', style: TextStyle(fontSize: 18)),
            ),
            SizedBox(height: 20),
            Text('ou entre com', style: TextStyle(fontSize: 16)),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildSocialButton('assets/images/search.png'),
                SizedBox(width: 10),
                _buildSocialButton('assets/images/apple.png'),
                SizedBox(width: 10),
                _buildSocialButton('assets/images/facebook.png'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSocialButton(String imagePath) {
    return InkWell(
      onTap: () {},
      child: Container(
        width: 50,
        height: 50,
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Image.asset(
          imagePath,
          fit: BoxFit.contain,
        ),
      ),
    );
  }

  Future<void> _loginThroughFirebaseAuth(
      BuildContext context, email, password) async {
    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Preencha todos os campos.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    try {
      final UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);

      await setUsuarioLogado(email);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? nome = prefs.getString('nomeUsuario');

      DatabaseHelper dbHelper = DatabaseHelper();
      // if (nome != null) {
      //   await dbHelper.insertUser(email, nome);
      // } else {
      //   ScaffoldMessenger.of(context).showSnackBar(
      //     SnackBar(
      //       content: Text('Erro: Nome do usuário não encontrado.'),
      //       backgroundColor: Colors.red,
      //     ),
      //   );
      // }
      // print('emaaail: $email');
      // int? sqliteId = await dbHelper.getUserIdByEmail(email);
      // print('id: $sqliteId');
      // prefs.setInt('sqliteId', sqliteId!);
      //  syncDescartes();

      Navigator.pushNamed(
        context,
        '/home',
        arguments: UserArguments(email, nome!),
      );
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro: ${e.message}'),
          backgroundColor: Colors.red,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> setUsuarioLogado(String email) async {
    DatabaseServiceUsers().getByEmail(email).then((usuario) async {
      if (usuario != null) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        print('usuario: $usuario');
        print("uuid: ${usuario.firebaseUuid}");
        prefs.setString('userLogado', usuario.firebaseUuid);
        prefs.setString('nomeUsuario', usuario.nomeUsuario);
        prefs.setString('email', usuario.email);
      }
    });
  }

  //sincronizar os descartes com o firebase inserindo-os no banco local sqlite
  // Future<void> syncDescartes() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   String? userUUID = prefs.getString('usuarioLogado');
  //   DatabaseHelper dbHelper = DatabaseHelper();
  //   String email = prefs.getString('email') ?? '';

  //   await dbHelper.deleteAllDiscards(0);
  //   int quantidadeDeDescartes = 0;
  //   if (userUUID != null) {
  //     List<Descarte> descartes =
  //         await DatabaseServiceDescartes().getByIdUsuario(userUUID);
  //     for (var descarte in descartes) {
  //       print('descarte: $descarte');
  //       quantidadeDeDescartes++;
  //       await DatabaseHelper().insertDiscard(
  //         prefs.getInt('sqliteId') ?? 0,
  //         descarte.objeto,
  //         descarte.categoria,
  //         descarte.quantidade,
  //         descarte.localDeDescarte,
  //         userUUID,
  //       );
  //     }
  //     prefs.setInt('numeroDescartes', quantidadeDeDescartes);
  //   }
  // }
}

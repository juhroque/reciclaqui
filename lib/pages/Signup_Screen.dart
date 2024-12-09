import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:reciclaqui/services/database_service_usuarios.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:reciclaqui/database/DataBaseHelper.dart';
import 'package:reciclaqui/database/UserArguments.dart';

import '../models/Usuario.dart';

class SignupScreen extends StatelessWidget {
  final DatabaseServiceUsers databaseServiceUsers = DatabaseServiceUsers();
  final TextEditingController nameController =
      TextEditingController(); // Controlador para o nome
  final TextEditingController emailController =
      TextEditingController(); // Controlador para o email
  final TextEditingController passwordController =
      TextEditingController(); // Controlador para a senha

  SignupScreen({super.key});

  Future<void> _handleSignup(BuildContext context) async {
    try {
      final nomeUsuario = nameController.text.trim();
      final email = emailController.text.trim();
      final password = passwordController.text;

      // Validation
      if (nomeUsuario.isEmpty || email.isEmpty || password.isEmpty) {
        throw Exception("Por favor, preencha todos os campos");
      }

      final dbHelper = DatabaseHelper();
      bool emailExists = await dbHelper.emailExists(email);

      if (emailExists) {
        throw Exception("Este email já está cadastrado. Tente outro.");
      }

      // Create Firebase account first
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      User? user = userCredential.user;
      if (user == null) throw Exception("Erro ao criar conta");

      // Update user display name
      await user.updateDisplayName(nomeUsuario);
      await user.reload();

      // Store data in SharedPreferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString("userLogado", user.uid);
      await prefs.setString('nomeUsuario', nomeUsuario);
      await prefs.setString('email', email);
      debugPrint("UserLogado: ${prefs.getString("userLogado")}");

      // Create Firestore user
      final usuarioProBancoFirestore = Usuario(
        nomeUsuario: nomeUsuario,
        email: email,
        pontosTotais: 0,
        firebaseUuid: user.uid,
      );

      databaseServiceUsers.addUsuario(usuarioProBancoFirestore);

      // Create local SQLite user
      await dbHelper.insertUser(nomeUsuario, email);

      // Navigate to home page
      if (context.mounted) {
        Navigator.pushReplacementNamed(
          context,
          '/home',
          arguments: UserArguments(email, nomeUsuario),
        );
      }
    } catch (e) {
      if (context.mounted) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text("Erro"),
              content: Text(e.toString()),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text("OK"),
                ),
              ],
            );
          },
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.green[700]),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView( // Permite o scroll caso o teclado apareça
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Criar uma nova conta',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.green[700],
                ),
              ),
              SizedBox(height: 10),
              Text(
                'Crie sua conta para começar!',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
              SizedBox(height: 20),

              // Campo de Nome
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: 'Nome',
                  labelStyle: TextStyle(color: Colors.grey),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.green[700]!),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              SizedBox(height: 15),

              // Campo de Email
              TextField(
                controller: emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  labelStyle: TextStyle(color: Colors.grey),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.green[700]!),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              SizedBox(height: 15),

              // Campo de Senha
              TextField(
                controller: passwordController,
                decoration: InputDecoration(
                  labelText: 'Senha',
                  labelStyle: TextStyle(color: Colors.grey),
                  suffixIcon: Icon(Icons.visibility, color: Colors.green[700]),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.green[700]!),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                obscureText: true,
              ),
              SizedBox(height: 20),

              // Botão de Criar Conta
              ElevatedButton(
                onPressed: () => _handleSignup(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green[700],
                  padding: EdgeInsets.symmetric(horizontal: 100, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  elevation: 5,
                ),
                child: Text(
                  'Criar Conta',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
              ),
              SizedBox(height: 20),

              // Texto de "ou continue com"
              Text(
                'ou continue com',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
              SizedBox(height: 10),

              // Botões sociais
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
              SizedBox(height: 20),

              // Texto para já ter uma conta
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, '/login');
                },
                child: Text(
                  'Já tem uma conta? Entrar',
                  style: TextStyle(color: Colors.green),
                ),
              ),
            ],
          ),
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
          color: Colors.white,
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 5,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Image.asset(
          imagePath,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}

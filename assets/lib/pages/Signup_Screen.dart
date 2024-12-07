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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Criar uma nova conta',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.green[700],
              ),
            ),
            SizedBox(height: 30),
            TextField(
              controller: nameController, // Usando o controlador
              decoration: InputDecoration(labelText: 'Nome'),
            ),
            TextField(
              controller: emailController, //usando o controlador
              decoration: InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: passwordController, // Usando o controlador
              decoration: InputDecoration(
                labelText: 'Senha',
                suffixIcon: Icon(Icons.visibility),
              ),
              obscureText: true,
            ),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: () async {
                final nomeUsuario = nameController.text;
                final email = emailController.text;
                final dbHelper = DatabaseHelper();

                // Verifica se o email já existe
                bool emailExists = await dbHelper.emailExists(email);

                if (emailExists) {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text("Erro"),
                        content:
                            Text("Este email já está cadastrado. Tente outro."),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text("OK"),
                          ),
                        ],
                      );
                    },
                  );
                } else {
                  await dbHelper.insertUser(nomeUsuario, email);
                  Navigator.pushNamed(
                    context,
                    '/home',
                    arguments: UserArguments(email, nomeUsuario),
                  );
                }

                _createFirebaseAccount(context);

                Navigator.pushNamed(context, '/home', arguments: nomeUsuario);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green[700],
                padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text('Criar Conta', style: TextStyle(fontSize: 18)),
            ),
            SizedBox(height: 20),
            Text('ou continue com'),
            SizedBox(height: 20),
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
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, '/login');
              },
              child: Text(
                'Já tem uma conta? Sign in',
                style: TextStyle(color: Colors.blue),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Função para criar os botões de redes sociais com ícones
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

  Future<void> _createFirebaseAccount(context) async {
    try {
      // Criação de usuário no Firebase
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );
      User? user = userCredential.user;
      if (user != null) {
        // Usuário criado com sucesso
        String userUid = user.uid;

        print("Novo usuário criado: $userUid");
        // Atualizar o nome do usuário
        await user.updateDisplayName(nameController.text);
        await user.reload();
        user = FirebaseAuth.instance.currentUser;
        print("Nome do usuário atualizado: ${user?.displayName}");
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString("userLogado", userUid);
        prefs.setString('nomeUsuario', nameController.text);

        print("UserLogado: ${prefs.getString("userLogado")}");

        final usuarioProBancoFirestore = Usuario(
            nomeUsuario: nameController.text,
            email: emailController.text,
            pontosTotais: 0,
            firebaseUuid: userUid);
        print(usuarioProBancoFirestore.toJson());
        databaseServiceUsers.addUsuario(usuarioProBancoFirestore);
      }
    } on FirebaseAuthException catch (e) {
      // Erro ao criar usuário
      print("Erro ao criar usuário: ${e.message}");
      AlertDialog(
        title: Text("Erro"),
        content: Text(e.message.toString()),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text("OK"),
          ),
        ],
      );
    } catch (e) {
      AlertDialog(
        title: Text("Erro"),
        content: Text(e.toString()),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text("OK"),
          ),
        ],
      );
    }
  }
}

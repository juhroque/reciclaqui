import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SignupScreen extends StatelessWidget {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

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
            const SizedBox(height: 30),
            TextField(
              controller: nameController, // Usando o controlador
              decoration: const InputDecoration(labelText: 'Nome'),
            ),
            TextField(
              controller: emailController, // Usando o controlador
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: passwordController, // Usando o controlador
              decoration: const InputDecoration(
                labelText: 'Senha',
                suffixIcon: Icon(Icons.visibility),
              ),
              obscureText: true,
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () async {
                await _createAccount();
                // Navegar para HomePage passando o nome
                //Navigator.pushNamed(context, '/home',
                //  arguments: nameController.text);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green[700],
                padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text('Criar Conta', style: TextStyle(fontSize: 18)),
            ),
            const SizedBox(height: 20),
            const Text('ou continue com'),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildSocialButton('assets/images/search.png'),
                const SizedBox(width: 10),
                _buildSocialButton('assets/images/apple.png'),
                const SizedBox(width: 10),
                _buildSocialButton('assets/images/facebook.png'),
              ],
            ),
            const SizedBox(height: 20),
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, '/login');
              },
              child: const Text(
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
        padding: const EdgeInsets.all(8),
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

  Future<void> _createAccount() async {
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
        print("Novo usuário criado: ${user.uid}");

        // Atualizar o nome do usuário
        await user.updateDisplayName(nameController.text);
        await user.reload();
        user = FirebaseAuth.instance.currentUser;
        print("Nome do usuário atualizado: ${user?.displayName}");
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('A senha fornecida é muito fraca.');
      } else if (e.code == 'email-already-in-use') {
        print('A conta já existe para esse e-mail.');
      }
    } catch (e) {
      print(e);
    }
  }
}

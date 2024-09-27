import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final TextEditingController emailController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.green),
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
            const SizedBox(height: 10),
            const Text('Que bom te ver de novo!',
                style: TextStyle(fontSize: 16)),
            const SizedBox(height: 20),
            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: passwordController,
              decoration: const InputDecoration(
                labelText: 'Senha',
                suffixIcon: Icon(Icons.visibility),
              ),
              obscureText: true,
            ),
            const SizedBox(height: 10),
            const Align(
              alignment: Alignment.centerRight,
              child: Text('Esqueci minha senha',
                  style: TextStyle(color: Colors.blue)),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                await _login(context, emailController.text.trim(),
                    passwordController.text.trim());
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green[700],
                padding:
                    const EdgeInsets.symmetric(horizontal: 100, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text('Fazer Login', style: TextStyle(fontSize: 18)),
            ),
            const SizedBox(height: 20),
            const Text('ou entre com', style: TextStyle(fontSize: 16)),
            const SizedBox(height: 10),
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
          ],
        ),
      ),
    );
  }

  // Função para criar os botões de login social com imagens
  Widget _buildSocialButton(String imagePath) {
    return InkWell(
      onTap: () {},
      child: Container(
        width: 50, // Largura fixa para os botões ficarem uniformes
        height: 50, // Altura fixa para os botões ficarem quadrados
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Image.asset(
          imagePath,
          fit: BoxFit.contain, // Mantém a imagem dentro do botão
        ),
      ),
    );
  }

  Future<void> _login(BuildContext context, email, password) async {
    if (email.isEmpty || password.isEmpty) {
      _showErrorDialog(context, "Por favor, preencha todos os campos.");
      return;
    }
    print(email);
    print(password);

    try {
      final UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      print(userCredential);
      print("teste");

      // Login bem-sucedido, redireciona para a tela inicial
      Navigator.pushNamed(context, '/home',
          arguments: userCredential.user?.email);
    } on FirebaseAuthException catch (e) {
      _showErrorDialog(context, e.message ?? 'Ocorreu um erro. Tente novamente.');
    } catch (e) {
      _showErrorDialog(context, 'Ocorreu um erro. Tente novamente mais tarde.');
    }
  }

  // Função para exibir diálogos de erro
  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Erro'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
            },
            child: const Text('Ok'),
          ),
        ],
      ),
    );
  }
}

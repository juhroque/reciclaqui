import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final TextEditingController nameController = TextEditingController();

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
              controller: nameController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            SizedBox(height: 10),
            TextField(
              decoration: InputDecoration(
                labelText: 'Senha',
                suffixIcon: Icon(Icons.visibility),
              ),
              obscureText: true,
            ),
            SizedBox(height: 10),
            Align(
              alignment: Alignment.centerRight,
              child: Text('Esqueci minha senha',
                  style: TextStyle(color: Colors.blue)),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/home',
                    arguments: nameController.text);
              },
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

  // Função para criar os botões de login social com imagens
  Widget _buildSocialButton(String imagePath) {
    return InkWell(
      onTap: () {},
      child: Container(
        width: 50, // Largura fixa para os botões ficarem uniformes
        height: 50, // Altura fixa para os botões ficarem quadrados
        padding: EdgeInsets.all(8),
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
}

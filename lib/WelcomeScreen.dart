import 'package:flutter/material.dart';

class WelcomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween, // imagem embaixo / textos cima
        children: [
          Container(
            width: double.infinity,
            color: const Color.fromARGB(255, 162, 219, 245), // azul claro
            padding: EdgeInsets.all(20), 
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center, // centraliza de lateralmente
              children: [
                Text(
                  'ReciclAqui!',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center, // centraliza o texto
                ),
                SizedBox(height: 10),
                // sublinhado apenas no "Sign up"
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, '/signup');
                  },
                  child: RichText(
                    text: TextSpan(
                      text: 'Ainda não tem uma conta? ',
                      style: TextStyle(fontSize: 16, color: Colors.white), 
                      children: [
                        TextSpan(
                          text: 'Sign up',
                          style: TextStyle(
                            decoration: TextDecoration.underline, 
                            color: Colors.white, 
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 20),
                // Botão de Login
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40.0),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/login');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green[900],
                      padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text('Fazer Login'),
                  ),
                ),
              ],
            ),
          ),
          // inferior imagem
          Container(
            width: double.infinity,
            child: Image.asset(
              'assets/images/teste.jpg', 
              fit: BoxFit.contain, // nao corta a laetral da imagem
            ),
          ),
        ],
      ),
    );
  }
}


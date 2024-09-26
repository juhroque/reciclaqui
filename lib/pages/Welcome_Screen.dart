import 'package:flutter/material.dart';

class WelcomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Container(
        width: screenWidth,
        height: screenHeight,
        child: Column(
          children: [
            // Área azul (texto e botão)
            Container(
              width: screenWidth,
              height: screenHeight * 0.44, // Área azul ocupa 44% da altura
              color: Color.fromRGBO(183, 244, 249, 1),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'ReciclAqui!',
                    style: TextStyle(
                      color: Color.fromRGBO(83, 128, 1, 1),
                      fontFamily: 'Montserrat',
                      fontSize: 32,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Ainda não tem uma conta? Sign up',
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'Roboto',
                      fontSize: 14,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color.fromRGBO(83, 128, 1, 1),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      padding: EdgeInsets.symmetric(
                          horizontal: screenWidth * 0.3, vertical: 15),
                    ),
                    onPressed: () {
                      // Ação do botão
                    },
                    child: Text(
                      'Fazer Login',
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'Roboto',
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Imagem de boas-vindas
            Expanded(
              child: Stack(
                children: [
                  Positioned(
                    top: 0,
                    left: 0,
                    child: Container(
                      width: screenWidth,
                      height: screenHeight * 0.46, // Ajusta a altura da imagem
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('assets/images/welcome-people.jpg'),
                          fit: BoxFit.fitWidth,
                        ),
                      ),
                    ),
                  ),
                  // Fundo verde abaixo da imagem
                  Positioned(
                    bottom: 0,
                    left: 0,
                    child: Container(
                      width: screenWidth,
                      height: screenHeight * 0.1, // altura do fundo verde
                      color: Color.fromRGBO(83, 128, 1, 1), // Fundo verde
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}


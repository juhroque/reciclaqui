import 'package:flutter/material.dart';

class ReasonScreen extends StatelessWidget {
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
            // Área azul (texto)
            Container(
              width: screenWidth,
              height: screenHeight * 0.44, // Área azul ocupa 44% da altura
              color: Color.fromRGBO(183, 244, 249, 1),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween, // Alinhamento horizontal
                    crossAxisAlignment: CrossAxisAlignment.center, // Alinhamento vertical
                    children: [
                      IconButton(
                        icon: Icon(Icons.arrow_back, color: Colors.green, size: 30), // Aumenta o tamanho da setinha
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                      const Text(
                        'Por que Reciclar?',
                        style: TextStyle(
                          color: Color.fromRGBO(83, 128, 1, 1),
                          fontFamily: 'Montserrat',
                          fontSize: 28,
                          fontWeight: FontWeight.bold, // Deixa o texto mais forte
                        ),
                      ),
                      // Um espaço vazio para centralizar o título
                      const SizedBox(width: 48), // Espaço para compensar o ícone da setinha
                    ],
                  ),
                  const SizedBox(height: 20), // Espaço entre o título e o texto
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 20.0),
                    child: const Text(
                      'It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. '
                      'It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.',
                      textAlign: TextAlign.justify,
                      style: TextStyle(
                        color: Color.fromRGBO(83, 128, 1, 1),
                        fontFamily: 'Montserrat',
                        fontSize: 15,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Imagem de fundo
            Expanded(
              child: Stack(
                children: [
                  Positioned(
                    top: 0,
                    left: 0,
                    child: Container(
                      width: screenWidth,
                      height: screenHeight * 0.46, // Ajusta a altura da imagem
                      decoration: const BoxDecoration(
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
                      height: screenHeight * 0.11, // altura do fundo verde
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

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
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly, // Alinhamento horizontal
                      crossAxisAlignment: CrossAxisAlignment.center, // Alinhamento vertical
                      children: [
                        IconButton(
                          icon: Icon(Icons.arrow_back, color: Colors.green),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),

                        const SizedBox(width: 10), // Espaço entre o botão/titulo e o texto
                        
                        const Text(
                          'Por que Reciclar?',
                          style: TextStyle(
                            color: Color.fromRGBO(83, 128, 1, 1),
                            fontFamily: 'Montserrat',
                            fontSize: 28,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ],
                  ),

                  Container(
                    padding: EdgeInsets.all(20.0),
                    child: const Text(
                      ' It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.',
                      textAlign: TextAlign.justify,
                      style: TextStyle(
                        color:Color.fromRGBO(83, 128, 1, 1),  
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
import 'package:flutter/material.dart';
import 'package:reciclaqui/pages/Login_Screen.dart';
import 'package:reciclaqui/pages/Signup_Screen.dart';
import 'package:flutter/gestures.dart';


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
                  RichText(
                    text: TextSpan(
                      text: 'Ainda não tem uma conta? ',
                      style: TextStyle(
                        color: const Color.fromRGBO(131, 126, 126, 1),
                        fontFamily: 'Roboto',
                        fontSize: 16,
                      ),
                      children: [
                        TextSpan(
                          text: 'Sign up',
                          style: TextStyle(
                            color: const Color.fromRGBO(131, 126, 126, 1),
                            decoration: TextDecoration.underline, // Apenas "Sign up" sublinhado
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => SignupScreen(),
                                ),
                              );
                            },
                        ),
                      ],
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
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => LoginScreen(),
                        ),
                      );
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


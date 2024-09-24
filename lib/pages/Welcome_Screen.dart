import 'package:flutter/material.dart';

class WelcomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: // Figma Flutter Generator Welcome_pageWidget - FRAME
            Container(
                width: 360,
                height: 640,
                decoration: BoxDecoration(
                  color: Color.fromRGBO(183, 244, 249, 1),
                ),
                child: Stack(children: <Widget>[
                  Positioned(
                      top: 279,
                      left: 0,
                      child: Container(
                          width: 360,
                          height: 361,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                                image: AssetImage(
                                    'assets/images/welcome-people.png'),
                                fit: BoxFit.fitWidth),
                          ))),
                  Positioned(
                      top: 143,
                      left: 36,
                      child: Container(
                          width: 287,
                          height: 98.70136260986328,
                          child: Stack(children: <Widget>[
                            Positioned(
                                top: 50,
                                left: 0,
                                child: Container(
                                    width: 287,
                                    height: 48.70136260986328,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(15),
                                        topRight: Radius.circular(15),
                                        bottomLeft: Radius.circular(15),
                                        bottomRight: Radius.circular(15),
                                      ),
                                      color: Color.fromRGBO(83, 128, 1, 1),
                                    ))),
                            Positioned(
                                top: 65,
                                left: 100,
                                child: Text(
                                  'Fazer Login',
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                      color: Color.fromRGBO(255, 255, 255, 1),
                                      fontFamily: 'Roboto',
                                      fontSize: 16,
                                      letterSpacing:
                                          0 /*percentages not used in flutter. defaulting to zero*/,
                                      fontWeight: FontWeight.normal,
                                      height: 1),
                                )),
                            Positioned(
                                top: 0,
                                left: 33,
                                child: Text(
                                  'Ainda não tem uma conta? Sign up',
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontFamily: 'Roboto',
                                      fontSize: 14,
                                      letterSpacing:
                                          0 /*percentages not used in flutter. defaulting to zero*/,
                                      fontWeight: FontWeight.normal,
                                      height: 2.142857142857143),
                                )),
                          ]))),
                  Positioned(
                      top: 87,
                      left: 84,
                      child: Text(
                        'ReciclAqui!',
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            color: Color.fromRGBO(83, 128, 1, 1),
                            fontFamily: 'Montserrat',
                            fontSize: 32,
                            letterSpacing:
                                0 /*percentages not used in flutter. defaulting to zero*/,
                            fontWeight: FontWeight.normal,
                            height: 1),
                      )),
                ])));
  }
}

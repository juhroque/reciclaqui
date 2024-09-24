import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InfosPerfil(),
      ],
    );
  }
}

class InfosPerfil extends StatelessWidget {
  const InfosPerfil({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
        width: 360,
        height: 256,
        child: Stack(children: <Widget>[
          Positioned(
              top: 0,
              left: 0,
              child: Container(
                  width: 360,
                  height: 256,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(0),
                      topRight: Radius.circular(0),
                      bottomLeft: Radius.circular(15),
                      bottomRight: Radius.circular(15),
                    ),
                    color: Color.fromRGBO(83, 128, 1, 1),
                  ))),
          Positioned(
              top: 196,
              left: 58,
              child: Container(
                  width: 249,
                  height: 37,
                  child: Stack(children: <Widget>[
                    Positioned(
                        top: 0,
                        left: 0,
                        child: Container(
                            width: 46,
                            height: 36,
                            child: Stack(children: <Widget>[
                              Positioned(
                                  top: 0,
                                  left: 4,
                                  child: Text(
                                    '1989',
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                        color: Color.fromRGBO(255, 255, 255, 1),
                                        decoration: TextDecoration.none,
                                        fontFamily: 'Inter',
                                        fontSize: 16,
                                        letterSpacing:
                                            0 /*percentages not used in flutter. defaulting to zero*/,
                                        fontWeight: FontWeight.normal,
                                        height: 1),
                                  )),
                              Positioned(
                                  top: 19,
                                  left: 0,
                                  child: Text(
                                    'Pontos',
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                        color: Color.fromRGBO(255, 255, 255, 1),
                                        fontFamily: 'Inter',
                                        decoration: TextDecoration.none,
                                        fontSize: 14,
                                        letterSpacing:
                                            0 /*percentages not used in flutter. defaulting to zero*/,
                                        fontWeight: FontWeight.normal,
                                        height: 1),
                                  )),
                            ]))),
                    Positioned(
                        top: 1,
                        left: 197,
                        child: Container(
                            width: 52,
                            height: 36,
                            child: Stack(children: <Widget>[
                              Positioned(
                                  top: 0,
                                  left: 15,
                                  child: Text(
                                    '13',
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                        color: Color.fromRGBO(255, 255, 255, 1),
                                        fontFamily: 'Inter',
                                        decoration: TextDecoration.none,
                                        fontSize: 16,
                                        letterSpacing:
                                            0 /*percentages not used in flutter. defaulting to zero*/,
                                        fontWeight: FontWeight.normal,
                                        height: 1),
                                  )),
                              Positioned(
                                  top: 19,
                                  left: 0,
                                  child: Text(
                                    'Ranking',
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                        color: Color.fromRGBO(255, 255, 255, 1),
                                        fontFamily: 'Inter',
                                        fontSize: 14,
                                        decoration: TextDecoration.none,
                                        letterSpacing:
                                            0 /*percentages not used in flutter. defaulting to zero*/,
                                        fontWeight: FontWeight.normal,
                                        height: 1),
                                  )),
                            ]))),
                    Positioned(
                        top: 0,
                        left: 82,
                        child: Container(
                            width: 79,
                            height: 36,
                            child: Stack(children: <Widget>[
                              Positioned(
                                  top: 0,
                                  left: 27,
                                  child: Text(
                                    '101',
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                        color: Color.fromRGBO(255, 255, 255, 1),
                                        fontFamily: 'Inter',
                                        fontSize: 16,
                                        decoration: TextDecoration.none,
                                        letterSpacing:
                                            0 /*percentages not used in flutter. defaulting to zero*/,
                                        fontWeight: FontWeight.normal,
                                        height: 1),
                                  )),
                              Positioned(
                                  top: 19,
                                  left: 0,
                                  child: Text(
                                    'Reciclagens',
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                        color: Color.fromRGBO(255, 255, 255, 1),
                                        fontFamily: 'Inter',
                                        decoration: TextDecoration.none,
                                        fontSize: 14,
                                        letterSpacing:
                                            0 /*percentages not used in flutter. defaulting to zero*/,
                                        fontWeight: FontWeight.normal,
                                        height: 1),
                                  )),
                            ]))),
                  ]))),
          Positioned(
              top: 154,
              left: 122,
              child: Text(
                'Vitória Araújo',
                textAlign: TextAlign.left,
                style: TextStyle(
                    color: Color.fromRGBO(255, 255, 255, 1),
                    fontFamily: 'Inter',
                    decoration: TextDecoration.none,
                    fontSize: 18,
                    letterSpacing:
                        0 /*percentages not used in flutter. defaulting to zero*/,
                    fontWeight: FontWeight.normal,
                    height: 1),
              )),
          Positioned(
              top: 47,
              left: 126,
              child: Container(
                  width: 108,
                  height: 103,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(600),
                      topRight: Radius.circular(600),
                      bottomLeft: Radius.circular(600),
                      bottomRight: Radius.circular(600),
                    ),
                    image: DecorationImage(
                        image: AssetImage('assets/images/Icon.png'),
                        fit: BoxFit.fitWidth),
                  ))),
          Positioned(
              top: 37,
              left: 324,
              child: Container(
                  width: 21,
                  height: 21,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage('assets/images/Search.png'),
                        fit: BoxFit.fitWidth),
                  ))),
          Positioned(
              top: 35,
              left: 11,
              child: Container(
                  width: 25,
                  height: 25,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage('assets/images/Help.png'),
                        fit: BoxFit.fitWidth),
                  ))),
        ]));
  }
}

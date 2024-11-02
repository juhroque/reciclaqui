import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:reciclaqui/pages/Home_Page.dart';
import 'package:reciclaqui/pages/Login_Screen.dart';
import 'package:reciclaqui/pages/Register_Discard.dart';
import 'package:reciclaqui/pages/Signup_Screen.dart';
import 'package:reciclaqui/pages/Welcome_Screen.dart';
import 'package:reciclaqui/pages/Reason_Screen.dart';
import 'package:reciclaqui/pages/Partners_Screen.dart';
import 'package:reciclaqui/pages/Search_Screen.dart';
import 'package:reciclaqui/pages/Pontos_Screen.dart';
import 'firebase_options.dart';

import 'package:reciclaqui/pages/Detail_Screen.dart';

Future<void> main() async {
   WidgetsFlutterBinding
      .ensureInitialized(); // Necessário para o uso de 'async' no main
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => WelcomeScreen(),
        '/login': (context) => LoginScreen(),
        '/signup': (context) => SignupScreen(),
        '/home': (context) => const HomePage(),
        '/reason': (context) => ReasonScreen(),
        '/partners': (context) => PartnersScreen(),
        '/registerDiscard': (context) => RegisterDiscardPage(),
        '/search': (context) => SearchScreen(),
        '/pontos': (context) => PontosScreen(),
      },
      onGenerateRoute: (settings) {
        if (settings.name == '/detail') {
          final args = settings.arguments as Map<String, dynamic>;
          return MaterialPageRoute(
            builder: (context) => DetailScreen(
              itemName: args['itemName'],
              itemDescription: args['itemDescription'],
              imageUrl: args['imageUrl'],
            ),
          );
        }
        return null;
      },
    );
  }
}

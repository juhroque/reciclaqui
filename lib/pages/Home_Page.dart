import 'package:flutter/material.dart';
import 'package:reciclaqui/database/DataBaseHelper.dart';
import 'Reason_Screen.dart';
import 'Search_Screen.dart';
import 'Pontos_Screen.dart';
import 'package:reciclaqui/database/UserArguments.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int? userId;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (userId == null) {
      _getUserId();
    }
  }

  Future<void> _getUserId() async {
    final route = ModalRoute.of(context);
    if (route != null && route.settings.arguments is UserArguments) {
      final UserArguments args = route.settings.arguments as UserArguments;
      final String email = args.email;

      int? id = await DatabaseHelper().getUserIdByEmail(email);
      setState(() {
        userId = id; // Atualiza o estado com o ID do usuário
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final UserArguments args =
        ModalRoute.of(context)!.settings.arguments as UserArguments;
    final String email = args.email;
    final String name = args.nomeUsuario;

    return Scaffold(
      body: Stack(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              InfosPerfil(name: name),
              SizedBox(height: 40),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildCard('Identificar Objeto', Icons.camera_alt, 130, '',
                        context),
                    _buildCard(
                      'Registrar Descarte',
                      Icons.delete,
                      130,
                      '/registerDiscard',
                      context,
                      userId: userId, // Passando o userId como argumento
                    ),
                    _buildCard('Estabelecimentos Parceiros', Icons.store, 130,
                        '/partners', context),
                  ],
                ),
              ),
            ],
          ),
          Positioned(
            top: 30,
            left: 16,
            child: IconButton(
              icon: Icon(Icons.help, color: Colors.white),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ReasonScreen()),
                );
              },
            ),
          ),
          Positioned(
            top: 30,
            right: 16,
            child: IconButton(
              icon: Icon(Icons.search, color: Colors.white),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SearchScreen()),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCard(
      String text, IconData icon, double height, String rota, context,
      {int? userId}) {
    return GestureDetector(
      onTap: () {
        if (rota == '/registerDiscard') {
          if (userId != null) {
            Navigator.pushNamed(context, rota, arguments: userId);
          } else {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text('Erro: ID do usuário não encontrado.'),
            ));
          }
        } else if (rota != '') {
          Navigator.pushNamed(context, rota);
        }
      },
      child: SizedBox(
        width: 300,
        height: height,
        child: Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  size: 50,
                  color: Colors.grey[700],
                ),
                SizedBox(height: 10),
                Text(
                  text,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class InfosPerfil extends StatelessWidget {
  final String name;

  const InfosPerfil({super.key, required this.name});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PontosScreen(),
            settings: RouteSettings(arguments: name),
          ),
        );
      },
      child: Container(
        width: double.infinity,
        height: 256,
        child: Stack(
          children: <Widget>[
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Container(
                height: 256,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(15),
                    bottomRight: Radius.circular(15),
                  ),
                  color: Color.fromRGBO(83, 128, 1, 1),
                ),
              ),
            ),
            Positioned(
              top: 47,
              left: 0,
              right: 0,
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: AssetImage('assets/images/Icon.png'),
                  ),
                  SizedBox(height: 10),
                  Text(
                    name,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildProfileStat('0', 'Pontos'),
                      _buildProfileStat('0', 'Reciclagens'),
                      _buildProfileStat('0', 'Ranking'),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileStat(String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            color: Colors.white,
            fontSize: 14,
          ),
        ),
      ],
    );
  }
}

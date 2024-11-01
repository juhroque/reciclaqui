import 'package:flutter/material.dart';
import 'Reason_Screen.dart'; // navegaca
import 'Search_Screen.dart';
import 'Pontos_Screen.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final String name = ModalRoute.of(context)!.settings.arguments
        as String; // Capturando o nome do sign up

    return Scaffold(
      body: Stack(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              InfosPerfil(name: name), // Passando o nome para InfosPerfil
              SizedBox(height: 40), // Espaçamento entre o perfil e os cards
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildCard('Identificar Objeto', Icons.camera_alt, 130, '',
                        context), //consegui deixar os cards do tamanho certo mudando indivualmente
                    _buildCard('Registrar Descarte', Icons.delete, 130,
                        '/registerDiscard', context),
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
                // navegacao reason screen
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
      String text, IconData icon, double height, String rota, context) {
    return GestureDetector(
      onTap: () {
        // os que ainda nao tao com a rota configurada tao '' no parametro
        if (rota != '') Navigator.pushNamed(context, rota);
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
        // Navegação para a tela PontosScreen ao clicar no painel de perfil
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
                    name, // Exibindo o nome do usuário
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
                      _buildProfileStat('1989', 'Pontos'),
                      _buildProfileStat('101', 'Reciclagens'),
                      _buildProfileStat('13', 'Ranking'),
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

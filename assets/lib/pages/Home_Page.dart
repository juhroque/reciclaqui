import 'package:flutter/material.dart';
import 'package:reciclaqui/database/DataBaseHelper.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/descarte.dart';
import '../services/database_service_descartes.dart';
import 'Reason_Screen.dart';
import 'Search_Screen.dart';
import 'Pontos_Screen.dart';
import 'ImageClassifierPage.dart'; // Importação da página de classificação
import 'package:reciclaqui/database/UserArguments.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int? userId;
  String userName = "";

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (userId == null) {
      _getUserId();
    }
  }

  Future<void> _loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      userName = prefs.getString("nomeUsuario") ?? "Usuário";
    });

    await syncDescartes();
  }

  Future<void> syncDescartes() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userUUID = prefs.getString('userLogado');
    DatabaseHelper dbHelper = DatabaseHelper();
    String email = prefs.getString('email') ?? '';
    int? sqliteId = await dbHelper.getUserIdByEmail(email);
    print('id: $sqliteId');
    print('userUUID: $userUUID');
    prefs.setInt('sqliteId', sqliteId!);
    dbHelper.deleteAllDiscards(sqliteId);

    int quantidadeDeDescartes = 0;
    if (userUUID != null) {
      List<Descarte> descartes =
          await DatabaseServiceDescartes().getByIdUsuario(userUUID);
      for (var descarte in descartes) {
        quantidadeDeDescartes++;
        await DatabaseHelper().insertDiscard(
          prefs.getInt('sqliteId') ?? 0,
          descarte.objeto,
          descarte.categoria,
          descarte.quantidade,
          descarte.localDeDescarte,
          userUUID,
        );
      }
      prefs.setInt('numeroDescartes', quantidadeDeDescartes);
    }
  }

  Future<void> _getUserId() async {
    final route = ModalRoute.of(context);
    if (route != null && route.settings.arguments is UserArguments) {
      final UserArguments args = route.settings.arguments as UserArguments;
      final String email = args.email;

      int? id = await DatabaseHelper().getUserIdByEmail(email);
      setState(() {
        userId = id;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final UserArguments args =
        ModalRoute.of(context)!.settings.arguments as UserArguments;
    final String email = args.email;
    String name = userName;
    int? pontos;

    Future<int> loadPontos() async {
      final prefs = await SharedPreferences.getInstance();
      pontos = prefs.getInt("pontosUsuario");
      debugPrint('Pontos: $pontos');
      return pontos ?? 0;
    }

    Future<int> loadNumeroDescartes() async {
      final prefs = await SharedPreferences.getInstance();
      int numeroDescartes = prefs.getInt("numeroDescartes") ?? 0;
      debugPrint('Número de descartes: $numeroDescartes');
      return numeroDescartes;
    }

    return Scaffold(
      body: Stack(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              FutureBuilder<int>(
                future: loadPontos(),
                builder: (context, pontosSnapshot) {
                  if (pontosSnapshot.connectionState ==
                      ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  } else if (pontosSnapshot.hasError) {
                    return Text('Erro ao carregar pontos');
                  } else {
                    return FutureBuilder<int>(
                      future: loadNumeroDescartes(),
                      builder: (context, descartesSnapshot) {
                        if (descartesSnapshot.connectionState ==
                            ConnectionState.waiting) {
                          return CircularProgressIndicator();
                        } else if (descartesSnapshot.hasError) {
                          return Text('Erro ao carregar número de descartes');
                        } else {
                          return InfosPerfil(
                            name: name,
                            onUpdateName: (newName) {
                              setState(() {
                                name = newName;
                              });
                            },
                            pontos: pontosSnapshot.data ?? 0,
                            numeroDescartes: descartesSnapshot.data ?? 0,
                          );
                        }
                      },
                    );
                  }
                },
              ),
              SizedBox(height: 40),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildCard(
                      'Identificar Objeto', 
                      Icons.camera_alt, 
                      130, 
                      context, 
                      onTap: () => Navigator.push(
                        context, 
                        MaterialPageRoute(
                          builder: (context) => ImageClassifierPage()
                        )
                      )
                    ),
                    _buildCard(
                      'Registrar Descarte',
                      Icons.delete,
                      130,
                      context,
                      onTap: () => Navigator.pushNamed(
                        context, 
                        '/registerDiscard', 
                        arguments: userId
                      ),
                    ),
                    _buildCard(
                      'Estabelecimentos Parceiros', 
                      Icons.store, 
                      130, 
                      context,
                      onTap: () => Navigator.pushNamed(context, '/partners'),
                    ),
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
    String text, 
    IconData icon, 
    double height, 
    BuildContext context, 
    {required VoidCallback onTap}
  ) {
    return GestureDetector(
      onTap: onTap,
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
  final Function(String) onUpdateName;
  final int pontos;
  final int numeroDescartes;

  const InfosPerfil(
      {super.key,
      required this.name,
      required this.onUpdateName,
      required this.pontos,
      required this.numeroDescartes});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        final updatedName = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PontosScreen(),
          ),
        );
        // Se houver um novo nome, atualize-o na HomePage
        if (updatedName != null) {
          onUpdateName(updatedName);
        }
      },
      child: SizedBox(
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
                      _buildProfileStat(pontos.toString(), 'Pontos'),
                      _buildProfileStat(
                          numeroDescartes.toString(), 'Reciclagens'),
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



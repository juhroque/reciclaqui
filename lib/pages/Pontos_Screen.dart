import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:reciclaqui/database/DataBaseHelper.dart';
import 'package:reciclaqui/pages/Welcome_Screen.dart';

class PontosScreen extends StatefulWidget {
  @override
  _PontosScreenState createState() => _PontosScreenState();
}

class _PontosScreenState extends State<PontosScreen> {
  late String userName;
  List<Map<String, dynamic>> _historicoDescartes = []; //armazenar descartes
  num _totalPontos = 0; //armazenar os pontos

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    userName = ModalRoute.of(context)!.settings.arguments as String;
    _loadHistoricoDescartes(); //pegar descartes
  }

  Future<void> _loadHistoricoDescartes() async {
    // Método para buscar o histórico de descartes no banco de dados
    final Database db = await DatabaseHelper().database;
    List<Map<String, dynamic>> descartaData = await db.query('descarte');

    setState(() {
      _historicoDescartes = descartaData; //atualizar
      _loadTotalPontos(); //pegar pontos
    });
  }

  void _loadTotalPontos() {
    _totalPontos = _historicoDescartes.fold(0, (sum, descarte) {
      return sum + (descarte['pontos'] ?? 0);
    });

    setState(
        () {}); // Atualiza o estado para refletir as mudanças na contagem total de pontos.
  }

  void _showEditNameDialog() {
    TextEditingController _oldNameController = TextEditingController();
    TextEditingController _emailController = TextEditingController();
    TextEditingController _newNameController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text("Editar nome:"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _oldNameController,
                decoration: InputDecoration(labelText: "Nome antigo"),
              ),
              TextField(
                controller: _emailController,
                decoration: InputDecoration(labelText: "Email"),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
              child: Text("Cancelar"),
            ),
            ElevatedButton(
              onPressed: () async {
                String oldName = _oldNameController.text;
                String email = _emailController.text;

                if (oldName.isNotEmpty && email.isNotEmpty) {
                  int? userId = await DatabaseHelper()
                      .getUserIdByNameAndEmail(oldName, email);

                  if (userId != null) {
                    Navigator.of(dialogContext).pop(); // Fecha o diálogo atual

                    showDialog(
                      context: context,
                      builder: (BuildContext editContext) {
                        return AlertDialog(
                          title: Text("Editar nome:"),
                          content: TextField(
                            controller: _newNameController,
                            decoration: InputDecoration(labelText: "Novo nome"),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(editContext).pop();
                              },
                              child: Text("Cancelar"),
                            ),
                            ElevatedButton(
                              onPressed: () async {
                                String newName = _newNameController.text;
                                if (newName.isNotEmpty) {
                                  await DatabaseHelper()
                                      .updateUserName(userId, newName);
                                  setState(() {
                                    userName = newName;
                                  });
                                }
                                Navigator.of(editContext).pop();
                              },
                              child: Text("Salvar"),
                            ),
                          ],
                        );
                      },
                    );
                  } else {
                    showDialog(
                      context: context,
                      builder: (BuildContext errorContext) {
                        return AlertDialog(
                          title: Text("Erro"),
                          content: Text(
                              "Usuário não encontrado. Verifique o nome e o email."),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(errorContext).pop();
                              },
                              child: Text("OK"),
                            ),
                          ],
                        );
                      },
                    );
                  }
                }
              },
              child: Text("Verificar"),
            ),
          ],
        );
      },
    );
  }

  void _showDeleteAccountDialog() {
    TextEditingController _emailController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Confirmação de Exclusão"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("Tem certeza de que deseja excluir sua conta?"),
              SizedBox(height: 16),
              TextField(
                controller: _emailController,
                decoration: InputDecoration(labelText: "Confirme seu E-mail"),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("Cancelar"),
            ),
            ElevatedButton(
              onPressed: () async {
                String email = _emailController.text;

                if (email.isNotEmpty) {
                  int result = await DatabaseHelper().deleteUser(email);

                  if (result > 0) {
                    Navigator.of(context).pop();
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text("Sucesso"),
                          content: Text("Conta deletada com sucesso."),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                                Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(
                                      builder: (context) => WelcomeScreen()),
                                );
                              },
                              child: Text("OK"),
                            ),
                          ],
                        );
                      },
                    );
                  } else {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text("Erro"),
                          content: Text("Conta não encontrada."),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text("OK"),
                            ),
                          ],
                        );
                      },
                    );
                  }
                }
              },
              child: Text("Confirmar"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Seu perfil"),
        backgroundColor: Color.fromRGBO(83, 128, 1, 1),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  userName,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black54,
                  ),
                ),
                SizedBox(width: 8),
                IconButton(
                  icon: Icon(Icons.edit, color: Colors.grey),
                  onPressed: _showEditNameDialog,
                ),
                IconButton(
                  icon: Icon(Icons.close, color: Colors.red),
                  onPressed: _showDeleteAccountDialog,
                ),
              ],
            ),
            SizedBox(height: 10),
            Text(
              "Seus pontos no ReciclAqui!",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black54,
              ),
            ),
            SizedBox(height: 10),
            Text(
              "${_totalPontos} Pontos",
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Color.fromRGBO(83, 128, 1, 1),
              ),
            ),
            SizedBox(height: 30),
            Text(
              "Seu histórico de descartes",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black54,
              ),
            ),
            SizedBox(height: 10),
            Divider(),
            // Construindo a lista de descartes
            Expanded(
              child: ListView.builder(
                itemCount: _historicoDescartes.length,
                itemBuilder: (context, index) {
                  final descarte = _historicoDescartes[index];
                  return Column(
                    children: [
                      _buildHistoricoItem(
                        descarte['objeto'],
                        "${descarte['categoria']} - ${descarte['quantidade']} Unidade(s)\n${descarte['local_de_descarte']}",
                        "+ ${descarte['pontos']} pontos no ReciclAqui!",
                        context,
                      ),
                      Divider(),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHistoricoItem(
      String titulo, String descricao, String pontos, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  titulo,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color.fromRGBO(83, 128, 1, 1),
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  descricao,
                  style: TextStyle(color: Colors.grey[600]),
                ),
                SizedBox(height: 4),
                Text(
                  pontos,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color.fromRGBO(83, 128, 1, 1),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

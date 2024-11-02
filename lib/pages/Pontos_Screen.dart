import 'package:flutter/material.dart';

class PontosScreen extends StatefulWidget {
  @override
  _PontosScreenState createState() => _PontosScreenState();
}

class _PontosScreenState extends State<PontosScreen> {
  late String userName;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    userName = ModalRoute.of(context)!.settings.arguments as String;
  }

  void _showEditNameDialog() {
    TextEditingController _nameController = TextEditingController(text: userName);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Editar Nome"),
          content: TextField(
            controller: _nameController,
            decoration: InputDecoration(labelText: "Novo nome"),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("Cancelar"),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  userName = _nameController.text;
                });
                Navigator.of(context).pop();
              },
              child: Text("Salvar"),
            ),
          ],
        );
      },
    );
  }

  void _showDeleteAccountDialog() {
    TextEditingController _emailController = TextEditingController();
    TextEditingController _passwordController = TextEditingController();

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
                decoration: InputDecoration(labelText: "E-mail"),
              ),
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(labelText: "Senha"),
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
              onPressed: () {
                // logica exclusa0
                Navigator.of(context).pop();
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
            "1989 Pontos",
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Color.fromRGBO(83, 128, 1, 1),
            ),
          ),
          SizedBox(height: 30),
          Text(
            "Seu histórico de Descartes",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black54,
            ),
          ),
          SizedBox(height: 10),
          Divider(),
          _buildHistoricoItem(
            "Garrafa de Água",
            "Categoria - 1 Unidade\n500 gramas (peso)\nNome Local",
            "+ 2 pontos no ReciclAqui!",
            context,
          ),
          Divider(),
          _buildHistoricoItem(
            "Bateria Alcalina",
            "Plástico - 1 Unidade\n50 gramas\nLocal Fictício",
            "+ 3 pontos no ReciclAqui!",
            context,
          ),
          Divider(),
        ],
      ),
    ),
  );
}


  Widget _buildHistoricoItem(String titulo, String descricao, String pontos, BuildContext context) {
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
                SizedBox(height: 5),
                Text(
                  descricao,
                  style: TextStyle(color: Colors.black54),
                ),
              ],
            ),
          ),
          Column(
            children: [
              Text(
                pontos,
                style: TextStyle(
                  color: Colors.black54,
                  fontWeight: FontWeight.bold,
                ),
              ),
              IconButton(
                icon: Icon(Icons.delete, color: Colors.red),
                onPressed: () {
                  _showDeleteConfirmationDialog(context, titulo);
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmationDialog(BuildContext context, String titulo) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Apagar descarte"),
          content: Text("Tem certeza que deseja apagar o descarte de $titulo?"),
          actions: [
            TextButton(
              child: Text("Cancelar"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text("Apagar", style: TextStyle(color: Colors.red)),
              onPressed: () {
                //lógica para apagar o item do histórico
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}


import 'package:flutter/material.dart';
import 'package:reciclaqui/database/DataBaseHelper.dart';
import 'package:reciclaqui/models/descarte.dart';
import 'package:reciclaqui/services/database_service_descartes.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RegisterDiscardPage extends StatefulWidget {
  final int idUsuario;

  const RegisterDiscardPage({Key? key, required this.idUsuario})
      : super(key: key);

  @override
  _RegisterDiscardPageState createState() => _RegisterDiscardPageState();
}

class _RegisterDiscardPageState extends State<RegisterDiscardPage> {
  final TextEditingController objetoController = TextEditingController();
  final TextEditingController quantidadeController = TextEditingController();
  final TextEditingController localDeDescarteController =
      TextEditingController();
  String? selectedCategoria;

  @override
  void dispose() {
    objetoController.dispose();
    quantidadeController.dispose();
    localDeDescarteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF),
      appBar: _buildAppBar(context),
      body: Center(
        child: SingleChildScrollView(
          child: _buildFormulario(context),
        ),
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: const Color(0xFFFFFFFF),
      title: Text(
        'Registrar Descarte',
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w500,
          color: Colors.green[700],
        ),
      ),
      centerTitle: true,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.green),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
    );
  }

  Widget _buildFormulario(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          TextField(
            controller: objetoController,
            decoration: inputDecoration('Objeto'),
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<String>(
            items: [
              DropdownMenuItem(
                  value: 'Restos de Alimentos',
                  child: Text('Restos de Alimentos')),
              DropdownMenuItem(
                  value: 'Cascas de Frutas', child: Text('Cascas de Frutas')),
              DropdownMenuItem(value: 'Vegetais', child: Text('Vegetais')),
              DropdownMenuItem(
                  value: 'Outros Biodegradáveis',
                  child: Text('Outros Biodegradáveis')),
              DropdownMenuItem(
                  value: 'Papéis/Papelão', child: Text('Papéis/Papelão')),
              DropdownMenuItem(value: 'Plásticos', child: Text('Plásticos')),
              DropdownMenuItem(value: 'Vidros', child: Text('Vidros')),
              DropdownMenuItem(value: 'Metais', child: Text('Metais')),
              DropdownMenuItem(value: 'Pilhas', child: Text('Pilhas')),
              DropdownMenuItem(value: 'Baterias', child: Text('Baterias')),
              DropdownMenuItem(value: 'Lâmpadas', child: Text('Lâmpadas')),
              DropdownMenuItem(
                  value: 'Medicamentos', child: Text('Medicamentos')),
              DropdownMenuItem(value: 'Celulares', child: Text('Celulares')),
              DropdownMenuItem(
                  value: 'Computadores', child: Text('Computadores')),
              DropdownMenuItem(
                  value: 'Eletrodomésticos', child: Text('Eletrodomésticos')),
              DropdownMenuItem(
                  value: 'Papéis Higiênicos', child: Text('Papéis Higiênicos')),
              DropdownMenuItem(value: 'Fraldas', child: Text('Fraldas')),
              DropdownMenuItem(
                  value: 'Esponjas Usadas', child: Text('Esponjas Usadas')),
              DropdownMenuItem(value: 'Outro', child: Text('Outro')),
            ],
            onChanged: (value) {
              setState(() {
                selectedCategoria = value;
              });
            },
            decoration: inputDecoration('Categoria'),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: quantidadeController,
            decoration: inputDecoration('Quantidade'),
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 16),
          TextField(
            controller: localDeDescarteController,
            decoration: inputDecoration('Local de Descarte'),
          ),
          const SizedBox(height: 30),
          ElevatedButton(
            onPressed: _registerDiscard,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green[700],
              padding:
                  const EdgeInsets.symmetric(horizontal: 100, vertical: 15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: const Text('Registrar Descarte',
                style: TextStyle(fontSize: 18, color: Colors.white)),
          ),
        ],
      ),
    );
  }

  InputDecoration inputDecoration(String text) {
    return InputDecoration(
      labelText: text,
      labelStyle: const TextStyle(color: Color(0xFF837E7E)),
      floatingLabelBehavior: FloatingLabelBehavior.never,
      contentPadding: const EdgeInsets.only(bottom: 8),
    );
  }

  Future<void> _registerDiscard() async {
    final objeto = objetoController.text;
    final categoria = selectedCategoria;
    final quantidade = int.tryParse(quantidadeController.text) ?? 0;
    final localDeDescarte = localDeDescarteController.text;

    if (objeto.isNotEmpty &&
        categoria != null &&
        quantidade > 0 &&
        localDeDescarte.isNotEmpty) {
      final SharedPreferences prefs = await SharedPreferences.getInstance();

      final String userUUID = prefs.getString("userLogado") ?? "";

      await DatabaseHelper().insertDiscard(
        widget.idUsuario,
        objeto,
        categoria,
        quantidade,
        localDeDescarte,
        userUUID,
      );

      DatabaseServiceDescartes().addDescarte(
        Descarte(
          idUsuario: userUUID,
          objeto: objeto,
          categoria: categoria,
          quantidade: quantidade,
          localDeDescarte: localDeDescarte,
        ),
      );

      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Descarte registrado com sucesso!')));

      //add +1 na sharedpref de numeroDescartes
      int numeroDescartes = prefs.getInt('numeroDescartes') ?? 0;
      numeroDescartes++;
      prefs.setInt('numeroDescartes', numeroDescartes);

      // Limpa os campos após o registro
      objetoController.clear();
      quantidadeController.clear();
      localDeDescarteController.clear();
      setState(() {
        selectedCategoria = null;
      });

      Navigator.of(context).pop(); // Fecha a página após o registro
    } else {
      _showErrorDialog("Por favor, preencha todos os campos corretamente.");
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Erro"),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
  }
}

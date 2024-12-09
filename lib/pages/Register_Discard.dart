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
      backgroundColor: Colors.white,
      appBar: _buildAppBar(context),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: _buildFormulario(context),
        ),
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      title: Text(
        'Registrar Descarte',
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        _buildInputField('Objeto', objetoController),
        const SizedBox(height: 16),
        _buildDropdownField(),
        const SizedBox(height: 16),
        _buildInputField('Quantidade', quantidadeController, keyboardType: TextInputType.number),
        const SizedBox(height: 16),
        _buildInputField('Local de Descarte', localDeDescarteController),
        const SizedBox(height: 30),
        Center(
          child: _buildSubmitButton(),
        ),
      ],
    );
  }

  Widget _buildInputField(String label, TextEditingController controller, {TextInputType? keyboardType}) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.grey[600]),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.green[700]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.green[700]!),
        ),
      ),
      keyboardType: keyboardType,
    );
  }

  Widget _buildDropdownField() {
    return DropdownButtonFormField<String>(
      value: selectedCategoria,
      items: [
        'Restos de Alimentos', 'Cascas de Frutas', 'Vegetais', 'Outros Biodegradáveis',
        'Papéis/Papelão', 'Plásticos', 'Vidros', 'Metais', 'Pilhas', 'Baterias', 'Lâmpadas',
        'Medicamentos', 'Celulares', 'Computadores', 'Eletrodomésticos', 'Papéis Higiênicos',
        'Fraldas', 'Esponjas Usadas', 'Outro',
      ]
          .map((e) => DropdownMenuItem(value: e, child: Text(e, style: TextStyle(fontSize: 16, color: Colors.black))))
          .toList(),
      onChanged: (value) {
        setState(() {
          selectedCategoria = value;
        });
      },
      decoration: InputDecoration(
        labelText: 'Categoria',
        labelStyle: TextStyle(color: Colors.grey[600], fontSize: 16), // Ajuste do tamanho e cor do texto
        contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.green[700]!, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.green[700]!, width: 1),
        ),
      ),
      dropdownColor: Colors.white, // Fundo branco para o dropdown
      iconEnabledColor: Colors.grey[600], // Cor do ícone do dropdown
    );
}



  Widget _buildSubmitButton() {
    return ElevatedButton(
      onPressed: _registerDiscard,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.green[700],
        padding: const EdgeInsets.symmetric(horizontal: 100, vertical: 15),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      child: const Text(
        'Registrar Descarte',
        style: TextStyle(fontSize: 18, color: Colors.white),
      ),
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

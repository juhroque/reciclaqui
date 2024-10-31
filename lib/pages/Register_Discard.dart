import 'package:flutter/material.dart';

class RegisterDiscardPage extends StatelessWidget {
  const RegisterDiscardPage({super.key});

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

  
  AppBar _buildAppBar(context) {
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

  Widget _buildFormulario(context) {
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          TextField(
            decoration: inputDecoration('Objeto'),
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<String>(
            items: [
              DropdownMenuItem(
                  value: 'Categoria 1', child: Text('Categoria 1')),
              DropdownMenuItem(
                  value: 'Categoria 2', child: Text('Categoria 2')),
            ],
            onChanged: (value) {},
            decoration: inputDecoration('Categoria'),
          ),
          const SizedBox(height: 16),
          TextField(
            decoration: inputDecoration('Quantidade'),
          ),
          const SizedBox(height: 16),
          TextField(
            decoration: inputDecoration('Local de Descarte'),
          ),
          const SizedBox(height: 30),
          ElevatedButton(
            onPressed: () {
              //TODO
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green[700],
              padding: EdgeInsets.symmetric(horizontal: 100, vertical: 15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: Text('Registrar Descarte',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                )),
          ),
        ],
      ),
    );
  }

  InputDecoration inputDecoration(text) {
    return InputDecoration(
      labelText: text,
      labelStyle: const TextStyle(color: Color(0xFF837E7E)),
      floatingLabelBehavior: FloatingLabelBehavior.never,
      contentPadding:
          const EdgeInsets.only(bottom: 8), // Ajusta a posição do label
    );
  }
}

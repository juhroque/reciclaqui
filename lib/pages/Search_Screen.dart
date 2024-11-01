import 'package:flutter/material.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text('Pesquisar'),
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.green),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              decoration: InputDecoration(
                hintText: 'Buscar no ReciclAqui!',
                prefixIcon: Icon(Icons.search, color: Colors.green),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.green),
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
            SizedBox(height: 20),
            _buildCategorySection('Orgânico', [
              {'label': 'Restos de Alimentos', 'icon': Icons.restaurant},
              {'label': 'Cascas de Frutas', 'icon': Icons.apple},
              {'label': 'Vegetais', 'icon': Icons.eco},
              {'label': 'Outros Biodegradáveis', 'icon': Icons.nature},
            ]),
            SizedBox(height: 20),
            _buildCategorySection('Recicláveis', [
              {'label': 'Papel e Papelão', 'icon': Icons.description},
              {'label': 'Plástico', 'icon': Icons.local_drink},
              {'label': 'Vidro', 'icon': Icons.wine_bar},
              {'label': 'Metal', 'icon': Icons.hardware},
            ]),
            SizedBox(height: 20),
            _buildCategorySection('Perigosos', [
              {'label': 'Pilhas', 'icon': Icons.battery_charging_full},
              {'label': 'Baterias', 'icon': Icons.battery_std},
              {'label': 'Lâmpadas', 'icon': Icons.lightbulb},
              {'label': 'Medicamentos', 'icon': Icons.medication},
            ]),
            SizedBox(height: 20),
            _buildCategorySection('Eletrônicos', [
              {'label': 'Celulares', 'icon': Icons.phone_android},
              {'label': 'Computadores', 'icon': Icons.computer},
              {'label': 'Eletrodomésticos', 'icon': Icons.kitchen},
            ]),
            SizedBox(height: 20),
            _buildCategorySection('Rejeitos', [
              {'label': 'Papéis Higiênicos', 'icon': Icons.article},
              {'label': 'Fraldas', 'icon': Icons.baby_changing_station},
              {'label': 'Esponjas Usadas', 'icon': Icons.cleaning_services},
            ]),
          ],
        ),
      ),
    );
  }

  Widget _buildCategorySection(String title, List<Map<String, dynamic>> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            color: Colors.green,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 10),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: items
                .map((item) => _buildCard(item['label'], item['icon']))
                .toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildCard(String label, IconData icon) {
    return Container(
      width: 100,
      height: 100,
      margin: EdgeInsets.only(right: 10), // espaço entre os cards
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 32, color: Colors.grey[700]), // icone
          SizedBox(height: 5),
          Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.grey[700],
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}

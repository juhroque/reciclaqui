import 'package:flutter/material.dart';

class PartnersScreen extends StatelessWidget {
  final int pontos = 30;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF),
      appBar: _buildAppBar(context),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildPontosSection(),
            const SizedBox(height: 16),
            _buildEstabelecimentosList(),
          ],
        ),
      ),
    );
  }

  AppBar _buildAppBar(context) {
    return AppBar(
      backgroundColor: const Color(0xFFFFFFFF),
      title: Text(
        'Estabelecimentos Parceiros',
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

  Widget _buildPontosSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Seus pontos no ReciclAqui!',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Color.fromARGB(255, 47, 121, 51),
          ),
        ),
        Text(
          '$pontos Pontos',
          style: const TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color:Color.fromARGB(255, 47, 121, 51),
          ),
        ),
        const SizedBox(height: 16),
        const Text(
          'No ReciclAqui suas contribuições valem pontos, conheça os estabelecimentos parceiros:',
          style: TextStyle(fontSize: 14),
        ),
      ],
    );
  }

  Widget _buildEstabelecimentosList() {
    // Simulação de parceiros (poderia vir de uma API ou banco de dados)
    final List<Parceiro> parceiros = [
      Parceiro(nome: 'Carrefour', imagem: 'assets/images/carrefour_logo.png'),
      Parceiro(nome: 'Carrefour', imagem: 'assets/images/carrefour_logo.png'),
      Parceiro(nome: 'Carrefour', imagem: 'assets/images/carrefour_logo.png'),
      Parceiro(nome: 'Carrefour', imagem: 'assets/images/carrefour_logo.png'),
      Parceiro(nome: 'Carrefour', imagem: 'assets/images/carrefour_logo.png'),
    ];

    return Expanded(
      child: ListView.builder(
        itemCount: parceiros.length,
        itemBuilder: (context, index) {
          return _buildParceiroCard(parceiros[index]);
        },
      ),
    );
  }

  Widget _buildParceiroCard(Parceiro parceiro) {
    return Card(
      color: const Color(0xFFFFFFFF),
      elevation: 3, // Adiciona uma leve sombra ao card
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12), // Cantos arredondados no card
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Image.asset(
              parceiro.imagem,
              width: 100,
              height: 90,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    parceiro.nome,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.green[700],
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'No ReciclAqui suas contribuições valem pontos, conheça os estabelecimentos parceiros:',
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.horizontal(
                          left: Radius.circular(10),
                          right: Radius.circular(10),
                        ),
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      backgroundColor: const Color(0xFF538001),
                    ),
                    onPressed: () {
                      // Ação ao trocar pontos
                    },
                    child: const Text(
                      'Trocar pontos',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Parceiro {
  final String nome;
  final String imagem;

  Parceiro({required this.nome, required this.imagem});
}

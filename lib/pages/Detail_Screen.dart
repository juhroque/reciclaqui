import 'package:flutter/material.dart';

class DetailScreen extends StatelessWidget {
  final String itemName;
  final String itemDescription;
  final String imageUrl;

  DetailScreen({
    required this.itemName,
    required this.itemDescription,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.green),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(itemName, style: TextStyle(color: Colors.green)),
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(
              imageUrl,
              fit: BoxFit.cover,
              width: double.infinity,
              height: 250, // imagem
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                itemDescription,
                style: TextStyle(fontSize: 16, color: Colors.black54),
              ),
            ),
            SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text("Postos de Descarte"),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text("Aqui estão alguns locais de descarte próximos:"),
                            SizedBox(height: 10),
                            Text("- Posto 1: Endereço e detalhes"),
                            Text("- Posto 2: Endereço e detalhes"),
                            Text("- Posto 3: Endereço e detalhes"),
                          ],
                        ),
                        actions: [
                          TextButton(
                            child: Text("Fechar"),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      );
                    },
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromRGBO(83, 128, 1, 1),
                  padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                ),
                child: Text("Onde descartar?", style: TextStyle(color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

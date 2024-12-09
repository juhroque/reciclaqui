import 'package:flutter/material.dart';
import './NearbyFetchPlaces.dart'; // Importe o serviço de locais próximos

class DetailScreen extends StatefulWidget {
  final String itemName;
  final String itemDescription;
  final String imageUrl;

  DetailScreen({
    required this.itemName,
    required this.itemDescription,
    required this.imageUrl,
  });

  @override
  _DetailScreenState createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  bool _isLoading = false;
  List<dynamic>? _nearbyPlaces;
  String? _errorMessage;

  // Função que carrega os locais de descarte assim que a página for carregada
  @override
  void initState() {
    super.initState();
    _fetchNearbyPlaces();
  }

  Future<void> _fetchNearbyPlaces() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final places = await Nearbyfetchplaces.fetchNearbyPlaces(widget.itemName);
      setState(() {
        _nearbyPlaces = places.isNotEmpty ? places : null;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Erro ao buscar locais: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

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
        title: Text(widget.itemName, style: TextStyle(fontWeight: FontWeight.w500,
            color: Colors.green[700],)), centerTitle: true,
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(
              widget.imageUrl,
              fit: BoxFit.cover,
              width: double.infinity,
              height: 250, // imagem
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                widget.itemDescription,
                style: TextStyle(fontSize: 16, color: Colors.black54),
              ),
            ),
            SizedBox(height: 20),
            // Texto "Onde descartar:"
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                "Onde descartar:",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.green[800], // Cor do texto
                ),
              ),
            ),
            SizedBox(height: 10),
            // Exibindo os locais de descarte diretamente
            _isLoading
                ? Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.green[700]!),
                    ),
                  )
                : _errorMessage != null
                    ? Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(
                          _errorMessage!,
                          style: TextStyle(color: Colors.red),
                        ),
                      )
                    : _nearbyPlaces != null && _nearbyPlaces!.isNotEmpty
                        ? Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: ListView.separated(
                              shrinkWrap: true,
                              itemCount: _nearbyPlaces!.length,
                              itemBuilder: (context, index) {
                                final place = _nearbyPlaces![index];
                                return ListTile(
                                  title: Text(
                                    place['name'],
                                    style: TextStyle(color: Colors.green[800]), // Cor do título
                                  ),
                                  subtitle: Text(
                                    '${place['vicinity'] ?? 'Sem endereço disponível'}\n'
                                    'Distância: ${(place['distance']! / 1000).toStringAsFixed(1)} km',
                                    style: TextStyle(color: Colors.grey), // Cor do subtítulo
                                  ),
                                );
                              },
                              separatorBuilder: (context, index) => Divider(),
                            ),
                          )
                        : Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Text(
                              "Nenhum local encontrado para descarte.",
                              style: TextStyle(color: Colors.black54),
                            ),
                          ),
          ],
        ),
      ),
    );
  }
}

import 'dart:convert';
import 'dart:io';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';

class ImageClassifierPage extends StatefulWidget {
  const ImageClassifierPage({super.key});

  @override
  _ImageClassifierPageState createState() => _ImageClassifierPageState();
}

class _ImageClassifierPageState extends State<ImageClassifierPage> {
  File? _image;
  String _classificationResult = 'Nenhuma Imagem Selecionada';
  bool _isLoading = false;
  List<dynamic>? _nearbyPlaces;


  final ImagePicker _picker = ImagePicker();

  // Configurações de URL e chave do Azure Custom Vision
  final String _azureCustomVisionUrl =
      'https://reciclaqui-prediction.cognitiveservices.azure.com/customvision/v3.0/Prediction/cf7ab6c5-847a-4a3e-866d-d4f3b9899c4f/classify/iterations/reciclaqui2/image';

  final String _azureSubscriptionKey = '7emtnvoiG2dTAO5RYhGOkaCuAEs9UUqzKLttzdg3HxJyyuSuaYFpJQQJ99ALACYeBjFXJ3w3AAAIACOGRGZ0';

  // Função para capturar a imagem da câmera
  Future<void> _pickImage() async {
    try {
      final XFile? pickedFile = await _picker.pickImage(source: ImageSource.camera);

      if (pickedFile != null) {
        setState(() {
          _image = File(pickedFile.path);
          _classificationResult = 'Classificando...';
          _isLoading = true;
        });

        // Adiciona um pequeno delay para garantir que o estado seja atualizado
        await Future.delayed(Duration(milliseconds: 300));
        
        await _classifyImage();
      }
    } catch (e) {
      _handleClassificationError('Erro ao capturar imagem: $e');
    }
  }

  Future<void> _classifyImage() async {
    if (_image == null) return;

    final client = http.Client();

    try {
      print('Iniciando classificação de imagem');
      
      final bytes = await _image!.readAsBytes();

      final response = await client.post(
        Uri.parse(_azureCustomVisionUrl),
        headers: {
          'Content-Type': 'application/octet-stream',
          'Prediction-Key': _azureSubscriptionKey,
        },
        body: bytes,
      ).timeout(
        Duration(seconds: 30),
        onTimeout: () {
          throw TimeoutException('Tempo limite de classificação excedido');
        },
      );

      print('Resposta recebida. Código de status: ${response.statusCode}');

      // Verifica o status da resposta
      if (response.statusCode == 200) {
        final Map<String, dynamic> result = jsonDecode(response.body);
        final classification = result['predictions'][0]['tagName'];
        
        setState(() {
          _classificationResult = classification;
          _isLoading = false;
        });

        print('Classificação concluída: $_classificationResult');

        _showResultSnackBar(_classificationResult);

        // Busca locais próximos
        await _fetchNearbyPlaces(_classificationResult);
      } else {
        _handleClassificationError('Falha ao classificar. Código: ${response.statusCode}');
      }
    } catch (e) {
      print('Erro durante a classificação: $e');
      _handleClassificationError('Erro na classificação: $e');
    } finally {
      client.close();
    }
  }

  void _handleClassificationError(String message) {
    setState(() {
      _classificationResult = message;
      _isLoading = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        duration: Duration(seconds: 3),
      ),
    );
  }

  void _showResultSnackBar(String result) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Classificado como: $result'),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 3),
      ),
    );
  }

  Future<void> _fetchNearbyPlaces(String classification) async {
    const String googleApiKey = 'AIzaSyBZpZ4hymQDXJD-0qvQTwb-pGjgy-Qbkr0';

    try {
      LocationPermission permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied || permission == LocationPermission.deniedForever) {
        _handleClassificationError('Permissão de localização negada');
        return;
      }

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      final double latitude = position.latitude;
      final double longitude = position.longitude;

      final String searchKeyword = 'descarte de $classification';
      final String placesUrl =
          'https://maps.googleapis.com/maps/api/place/nearbysearch/json'
          '?location=$latitude,$longitude'
          '&radius=30000'
          '&keyword=$searchKeyword'
          '&language=pt-BR'
          '&key=$googleApiKey';

      print('URL da requisição: $placesUrl');

      final response = await http.get(Uri.parse(placesUrl));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final List<dynamic> places = data['results'];

        // Ordena por distância
        final sortedPlaces = places.map((place) {
          final placeLatitude = place['geometry']['location']['lat'];
          final placeLongitude = place['geometry']['location']['lng'];
          final distance = Geolocator.distanceBetween(
            latitude,
            longitude,
            placeLatitude,
            placeLongitude,
          );
          return {
            ...place,
            'distance': distance,
          };
        }).toList()
          ..sort((a, b) => (a['distance'] as double).compareTo(b['distance'] as double));

        setState(() {
          _nearbyPlaces = sortedPlaces.isNotEmpty ? sortedPlaces : null;
        });

        if (sortedPlaces.isEmpty) {
          _handleClassificationError('Nenhum local encontrado para este resíduo.');
        }
      } else {
        _handleClassificationError('Erro ao buscar locais próximos: ${response.body}');
      }
    } catch (e) {
      _handleClassificationError('Erro ao buscar locais próximos: $e');
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFFFFFFF),
        title: Text(
          'Identificar Objeto',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w500,
            color: Colors.green[700],
          ),
        ),
        centerTitle: true,
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: <Widget>[
                Container(
                  width: 300,
                  height: 300,
                  decoration: BoxDecoration(
                    border: Border.all(color: Color.fromRGBO(83, 128, 1, 1), width: 2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: _image == null
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.image, size: 100, color: Colors.green[200]),
                            SizedBox(height: 10),
                            Text(
                              'Nenhuma Imagem Selecionada',
                              style: TextStyle(color: Colors.green[200]),
                            )
                          ],
                        )
                      : ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.file(_image!, fit: BoxFit.cover),
                        ),
                ),
                SizedBox(height: 20),
                ElevatedButton.icon(
                  onPressed: _pickImage,
                  icon: Icon(Icons.camera_alt, color: Colors.white), // Ícone branco
                  label: Text(
                    'Tirar Foto',
                    style: TextStyle(color: Colors.white), // Texto branco
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromRGBO(83, 128, 1, 1),
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(3), // Sem borda arredondada
                    ),
                  ),
                ),
                SizedBox(height: 20),
                _isLoading
                    ? CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Color.fromRGBO(83, 128, 1, 1)),
                      )
                    : Container(
                        padding: EdgeInsets.all(15),
                        decoration: BoxDecoration(
                        ),
                        child: Column(
                          children: [
                            Text(
                              'Tipo de Resíduo:',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.green[800],
                              ),
                            ),
                            SizedBox(height: 10),
                            Text(
                              _classificationResult,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.green[900],
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                SizedBox(height: 20),
                if (_nearbyPlaces != null)
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Locais de Descarte Próximos:',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.green[800],
                          ),
                        ),
                        ListView.separated(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: _nearbyPlaces!.length,
                          itemBuilder: (context, index) {
                            final place = _nearbyPlaces![index];
                            return ListTile(
                              title: Text(
                                place['name'],
                                style: TextStyle(color: Colors.green[800]),
                              ),
                              subtitle: Text(
                                '${place['vicinity'] ?? 'Sem endereço disponível'}\n'
                                'Distância: ${(place['distance']! / 1000).toStringAsFixed(1)} km',
                                style: TextStyle(color: Color.fromRGBO(75, 76, 74, 0.737)),
                              ),
                            );
                          },
                          separatorBuilder: (context, index) => Divider(
                            color: Color.fromRGBO(102, 104, 99, 0.241),
                            thickness: 1,
                          ),
                        ),

                      ],
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
import 'dart:convert';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

class Nearbyfetchplaces {
  static const String googleApiKey = 'AIzaSyBZpZ4hymQDXJD-0qvQTwb-pGjgy-Qbkr0';

  static Future<List<dynamic>> fetchNearbyPlaces(String classification) async {
    try {
      LocationPermission permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied || permission == LocationPermission.deniedForever) {
        throw Exception('Permissão de localização negada');
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

      final response = await http.get(Uri.parse(placesUrl));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final List<dynamic> places = data['results'];

        // Ordena por distância
        return places.map((place) {
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
      } else {
        throw Exception('Erro ao buscar locais: ${response.body}');
      }
    } catch (e) {
      throw Exception('Erro ao buscar locais próximos: $e');
    }
  }
}

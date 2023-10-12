import 'package:http/http.dart' as http;
import 'dart:convert';

class WeatherApi {
  String apiKey;

  WeatherApi({required this.apiKey});

  Future<Map<String, dynamic>> obtenerPronosticoClima(
      double latitud, double longitud) async {
    final apiUrl = 'http://api.openweathermap.org/data/2.5/forecast?appid=$apiKey'
        '&lat=$latitud&lon=$longitud';

    final response = await http.get(Uri.parse(apiUrl));
    
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      return {};
    }
  }
}

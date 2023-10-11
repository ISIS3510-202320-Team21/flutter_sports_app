import 'package:http/http.dart' as http;
import 'dart:convert';

class WeatherApi {
  String apiKey = '02788d36472def97753cd483ee2dd7fa';

  WeatherApi({required this.apiKey});

  Future<Map<String, dynamic>> obtenerPronosticoClima(double latitud, double longitud) async {
    final apiUrl = 'https://api.openweathermap.org/data/2.5/weather?'
        'lat=$latitud&lon=$longitud&appid=$apiKey&units=metric';

    final response = await http.get(Uri.parse(apiUrl));
    
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      return data;
    } else {
      return Map<String, dynamic>();
    }
  }
}

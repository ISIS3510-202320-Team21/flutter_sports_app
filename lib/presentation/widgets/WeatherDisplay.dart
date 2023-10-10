import 'package:flutter/material.dart';
import 'package:flutter_app_sports/data/services/weather_api.dart';

class WeatherDisplay extends StatefulWidget {
  final double latitude;
  final double longitude;

  WeatherDisplay({required this.latitude, required this.longitude});

  @override
  _WeatherDisplayState createState() => _WeatherDisplayState();
}

class _WeatherDisplayState extends State<WeatherDisplay> {
  late Future<Map<String, dynamic>> pronosticoClima;

  @override
  void initState() {
    super.initState();
    final weatherApi = WeatherApi(apiKey: 'TU_CLAVE_DE_API'); // Reemplaza con tu clave de API
    pronosticoClima = weatherApi.obtenerPronosticoClima(widget.latitude, widget.longitude);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(
      future: pronosticoClima,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (!snapshot.hasData) {
          return Text('No se recibieron datos del clima.');
        } else {
          // Aquí puedes construir y retornar un widget que muestre la información del clima
          // utilizando los datos en snapshot.data
          // Ejemplo:
          final climaData = snapshot.data;
          final temperatura = climaData?['main']['temp'];
          final descripcion = climaData?['weather'][0]['description'];
          return Text('Temperatura: $temperatura°C, Descripción: $descripcion');
        }
      },
    );
  }
}

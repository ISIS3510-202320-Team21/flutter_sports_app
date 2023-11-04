import 'package:flutter/material.dart';
import 'package:flutter_app_sports/data/services/weather_api.dart';
import 'package:geolocator/geolocator.dart';

class WeatherDisplay extends StatefulWidget {
  WeatherDisplay({Key? key, required double longitude, required double latitude}) : super(key: key);

  @override
  _WeatherDisplayState createState() => _WeatherDisplayState();
}

class _WeatherDisplayState extends State<WeatherDisplay> {
  Future<Map<String, dynamic>>? pronosticoClima;
  double? latitude;
  double? longitude;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  _getCurrentLocation() async {
    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      await Geolocator.requestPermission();
      return;
    } else if (permission == LocationPermission.deniedForever) {
      await Geolocator.openLocationSettings();
      return;
    } else {
      Position currentPosition =
          await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

      setState(() {
        latitude = currentPosition.latitude;
        longitude = currentPosition.longitude;
      });

      // print("Latitude Display: $latitude");
      // print("Longitude Display: $longitude");

      final weatherApi = WeatherApi(apiKey: '02788d36472def97753cd483ee2dd7fa');
      pronosticoClima = weatherApi.obtenerPronosticoClima(latitude!, longitude!);
    }
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
          return Text('Could not fetch weather data.');
        } else {
          final climaData = snapshot.data;
          final temperatura = climaData?['main']['temp'];
          final descripcion = climaData?['weather'][0]['description'];
          return Text('Temperature: $temperatura°C, Description: $descripcion');
        }
      },
    );
  }
}

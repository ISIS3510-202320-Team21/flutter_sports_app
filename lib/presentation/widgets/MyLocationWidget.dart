import 'package:flutter/material.dart';
//import 'package:flutter_app_sports/presentation/widgets/WeatherDisplay.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

class MyLocationWidget extends StatefulWidget {
  late final void Function(double lat, double lon) onLocationChanged;

  MyLocationWidget({required this.onLocationChanged});

  @override
  _MyLocationWidgetState createState() => _MyLocationWidgetState();
}

class _MyLocationWidgetState extends State<MyLocationWidget> {
  Position? _currentPosition; // Para almacenar la ubicación actual
  bool _isPermissionRequesting = false;

  @override
  void initState() {
    super.initState();
    //_getCurrentLocation();
    //_checkPermissionAndGetCurrentLocation();
  }

  _checkPermissionAndGetCurrentLocation() async {
    if (_isPermissionRequesting) {
      // Si ya se está realizando una solicitud de permisos, espera a que se complete.
      return;
    }

    _isPermissionRequesting = true;
    
    try {
      final status = await Permission.location.request();
      if (status.isGranted) {
        print("Permission granted por Permission location request");
        _getCurrentLocation();
      } else {
        print('Permission denied por Permission location request');
      }
    } catch (e) {
      print('Error al solicitar permisos: $e');
    } finally {
      _isPermissionRequesting = false; // Marcar que la solicitud ha terminado.
    }
  }

  // Función para obtener la ubicación actual
  _getCurrentLocation() async {
    final GeolocatorPlatform geolocator = GeolocatorPlatform.instance;
    try {
      final Position position = await geolocator.getCurrentPosition(
        // Get accuracy at its finest
        //LocationAccuracy.best,
      );
      setState(() {
        _currentPosition = position;
        print(_currentPosition!.latitude);
      });
      // Llamar a la función onLocationChanged del widget padre
      widget.onLocationChanged(_currentPosition!.latitude, _currentPosition!.longitude);

    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        if (_currentPosition != null)
          Text(
            'Latitud: ${_currentPosition!.latitude}, Longitud: ${_currentPosition!.longitude}',
          ),
        if (_currentPosition == null)
          Text('Ubicación no disponible'),
      ],
    );
  }
}

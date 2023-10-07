import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:io' show Platform;




class ConfigService {
  static String get backendUrl {
    if (kIsWeb || Platform.isIOS || Platform.isMacOS || Platform.isWindows) {
      return dotenv.env['BACKEND_URL_IOS_Windows']!;
    }
    else if (Platform.isAndroid); {
      return dotenv.env['BACKEND_URL_ANDROID']!;
    }
  }
}

import 'package:flutter_dotenv/flutter_dotenv.dart';

class ConfigService {
  static String get backendUrl {
    print(dotenv.env['BACKEND_URL_IOS_Windows']!);
    return dotenv.env['BACKEND_URL_IOS_Windows']!;
  }
}

import 'package:teste/models/auth.dart';

class ApiHelperService {
  static Future<Map<String, String>> buildHeaders(Auth? auth) async {
    Map<String, String> headers = {
      "Accept": "application/json",
      "Content-Type": "application/json",
    };

    if (auth == null) return headers;

    headers['Authorization'] = 'Bearer ${auth.token}';

    return headers;
  }
}

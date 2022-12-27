import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:teste/models/auth.dart';
import 'package:teste/models/login/login_request_model.dart';
import 'package:teste/services/api/mangos_api_service.dart';

GetIt getIt = GetIt.instance;

class AuthProvider extends ChangeNotifier {
  final _key = "jwt331";
  final _storage = const FlutterSecureStorage();
  late Timer _timer;
  Auth? _auth;

  AuthProvider() {
    _storage.read(key: _key).then(_setarAuth);
  }

  _setarAuth(value) {
    if (value == null) {
      return;
    }

    _auth = Auth.fromJson(json.decode(value));
    notifyListeners();

    _reiniciarTimer();
  }

  Future<bool> login(LoginRequestModel request) async {
    var s = getIt<MangosApiService>();

    var auth = await s.login(request);
    if (auth == null) {
      return false;
    }

    var authEncode = json.encode(auth.toJson(), toEncodable: _myEncode);

    await _storage.write(key: _key, value: authEncode);

    _auth = auth;
    notifyListeners();

    _reiniciarTimer();

    return true;
  }

  logout() {
    _storage.delete(key: _key).then((value) {
      _timer.cancel();

      _auth = null;
      notifyListeners();
    });
  }

  _reiniciarTimer() async {
    if (_auth == null) {
      return;
    }

    var duration = _auth!.expiration.difference(DateTime.now().add(const Duration(minutes: 10)));

    if (duration.isNegative) {
      await _atualizarToken();
      return;
    }

    debugPrint("Duration é: $duration");

    _timer = Timer(duration, () async => await _atualizarToken());
  }

  Future<bool> _atualizarToken() async {
    var s = getIt<MangosApiService>();

    var auth = await s.refresh();
    if (auth == null) {
      return false;
    }

    var authEncode = json.encode(auth.toJson(), toEncodable: _myEncode);

    await _storage.write(key: _key, value: authEncode);

    _auth = auth;
    notifyListeners();

    _reiniciarTimer();

    return true;
  }

  bool get isAuthenticated {
    return _auth != null;
  }

  dynamic _myEncode(dynamic item) {
    if (item is DateTime) {
      return item.toIso8601String();
    }
    return item;
  }
}

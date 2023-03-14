import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart'; // TODO: nao deveria ser o Material?
import 'package:get_it/get_it.dart';
import 'package:teste/models/auth.dart';
import 'package:teste/models/login/login_request_model.dart';
import 'package:teste/services/api/mangos_api_service.dart';
import 'package:teste/services/secure_storage_service.dart';

GetIt getIt = GetIt.instance;

// enum Status {
//   LoggedOut,
//   LoggingIn,
//   LoggedIn,
// }

class AuthProvider extends ChangeNotifier {
  late Timer _timer;
  Auth? _auth;
  Auth? get auth => _auth;
  bool isProcessing = false;

  AuthProvider() {
    SecureStorageService.storage.read(key: SecureStorageService.key).then(_setarAuth);
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

    isProcessing = true;
    notifyListeners();

    var auth = await s.login(request);

    isProcessing = false;
    notifyListeners();

    if (auth == null) {
      return false;
    }

    var authEncode = json.encode(auth.toJson(), toEncodable: _myEncode);

    await SecureStorageService.storage.write(key: SecureStorageService.key, value: authEncode);

    _auth = auth;
    notifyListeners();

    _reiniciarTimer();

    return true;
  }

  logout() {
    SecureStorageService.storage.delete(key: SecureStorageService.key).then((value) {
      if (_timer.isActive) _timer.cancel();

      _auth = null;
      notifyListeners();
    });
  }

  _reiniciarTimer() async {
    if (_auth == null) {
      return;
    }

    var duration = _auth!.expiration.difference(DateTime.now().add(const Duration(minutes: 10)));

    debugPrint("Duration é: $duration");

    if (duration.isNegative) {
      await refreshToken();
      return;
    }

    _timer = Timer(duration, () async {
      _timer.cancel();
      await refreshToken();
    });
  }

  Future<bool> refreshToken() async {
    if (_auth == null) return false;

    var s = getIt<MangosApiService>();

    isProcessing = true;
    notifyListeners();

    var newAuth = await s.refresh(_auth!);

    isProcessing = false;
    notifyListeners();

    if (newAuth == null) {
      return false;
    }

    var authEncode = json.encode(newAuth.toJson(), toEncodable: _myEncode);

    await SecureStorageService.storage.write(key: SecureStorageService.key, value: authEncode);

    _auth = newAuth;
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

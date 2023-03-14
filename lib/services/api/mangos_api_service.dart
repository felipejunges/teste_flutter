import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:retry/retry.dart';
import 'package:teste/models/api_error_model.dart';
import 'package:teste/models/auth.dart';
import 'package:teste/models/cartao_credito_model.dart';
import 'package:teste/models/conta_bancaria_model.dart';
import 'package:teste/models/despesa_rapida_model.dart';
import 'package:teste/models/login/login_request_model.dart';
import 'package:teste/models/login/login_response_model.dart';
import 'package:teste/models/pessoa_coordenada_model.dart';
import 'package:teste/models/saldo_conta_model.dart';
import 'package:teste/services/api/api_helper_service.dart';

class MangosApiService {
  //static const String apiUrl = "https://localhost:5051";
  static const String apiUrl = "https://api.mangos.inf.br";

  Future<Auth?> login(LoginRequestModel request) async {
    final url = Uri.parse('$apiUrl/api/Login');
    final headers = {"Content-Type": "application/json"};
    final body = request.toJson();

    try {
      debugPrint("Calling POST /Login...");

      final response = await retry(
        () => http
            .post(
              url,
              headers: headers,
              body: json.encode(body),
            )
            .timeout(const Duration(seconds: 15)),
        retryIf: (e) => e is SocketException || e is TimeoutException,
        maxAttempts: 3,
      );

      debugPrint("StatusCode: ${response.statusCode}");

      if (response.statusCode == 200) {
        var responseModel = LoginResponseModel.fromJson(jsonDecode(response.body));

        return Auth(responseModel.create, responseModel.expiration, responseModel.token, responseModel.refreshToken);
      } else {
        //var errorModel = ApiErrorModel.fromJson(jsonDecode(response.body));
        return null;
      }
    } catch (error) {
      print("Erro: $error");
      return null;
    }
  }

  Future<Auth?> refresh(Auth currentAuth) async {
    final url = Uri.parse('$apiUrl/api/Login');
    final headers = {"Content-Type": "application/json"};

    final body = {'authenticationToken': currentAuth.token, 'refreshToken': currentAuth.refreshToken};

    try {
      print("Calling PUT /Login...");

      final response = await retry(
        () => http
            .put(
              url,
              headers: headers,
              body: json.encode(body),
            )
            .timeout(const Duration(seconds: 15)),
        retryIf: (e) => e is SocketException || e is TimeoutException,
        maxAttempts: 3,
      );

      print("StatusCode: ${response.statusCode}");

      if (response.statusCode == 200) {
        var responseModel = LoginResponseModel.fromJson(jsonDecode(response.body));

        var auth = Auth(responseModel.create, responseModel.expiration, responseModel.token, responseModel.refreshToken);

        print("Body: ${response.body}");
        print("AuthToken: ${auth.token}");

        return auth;
      } else {
        return null;
      }
    } catch (error) {
      print("Erro: $error");
      return null;
    }
  }

  Future<List<SaldoContaModel>> getSaldosConta(Auth? auth) async {
    final url = Uri.parse('$apiUrl/api/SaldoConta');

    try {
      print("Calling GET /SaldoConta...");

      var response = await http
          .get(
            url,
            headers: await ApiHelperService.buildHeaders(auth),
          )
          .timeout(const Duration(seconds: 45));

      print("StatusCode: ${response.statusCode}");

      if (response.statusCode == 200) {
        print(response.body);

        List jsonResponse = json.decode(response.body);

        return jsonResponse.map<SaldoContaModel>((f) => SaldoContaModel.fromJson(f)).toList();
      } else {
        return [];
      }
    } catch (error) {
      print("Erro: $error");
      return Future.error(error);
    }
  }

  Future<List<ContaBancariaModel>> getContasBancarias(Auth? auth) async {
    final url = Uri.parse('$apiUrl/api/ContaBancaria');

    try {
      print("Calling GET /ContaBancaria...");

      var response = await http
          .get(
            url,
            headers: await ApiHelperService.buildHeaders(auth),
          )
          .timeout(const Duration(seconds: 45));

      print("StatusCode: ${response.statusCode}");

      if (response.statusCode == 200) {
        print(response.body);

        List jsonResponse = json.decode(response.body);

        return jsonResponse.map<ContaBancariaModel>((f) => ContaBancariaModel.fromJson(f)).toList();
      } else {
        return [];
      }
    } catch (error) {
      print("Erro: $error");
      return [];
    }
  }

  Future<List<CartaoCreditoModel>> getCartoesCredito(Auth? auth) async {
    final url = Uri.parse('$apiUrl/api/CartaoCredito');

    try {
      debugPrint("Calling GET /CartaoCredito...");

      var response = await http
          .get(
            url,
            headers: await ApiHelperService.buildHeaders(auth),
          )
          .timeout(const Duration(seconds: 45));

      debugPrint("StatusCode: ${response.statusCode}");

      if (response.statusCode == 200) {
        debugPrint(response.body);

        List jsonResponse = json.decode(response.body);

        return jsonResponse.map<CartaoCreditoModel>((f) => CartaoCreditoModel.fromJson(f)).toList();
      } else {
        return [];
      }
    } catch (error) {
      debugPrint("Erro: $error");
      return [];
    }
  }

  Future<PessoaCoordenadaModel?> getPessoaCoordenada(Auth? auth, double latitude, double longitude) async {
    final url = Uri.parse(
        '$apiUrl/api/PessoaCoordenada?Latitude=${latitude.toString().replaceAll(',', '.')}&Longitude=${longitude.toString().replaceAll(',', '.')}');

    try {
      print("Calling GET /PessoaCoordenada...");

      var response = await http
          .get(
            url,
            headers: await ApiHelperService.buildHeaders(auth),
          )
          .timeout(const Duration(seconds: 45));

      print("StatusCode: ${response.statusCode}");

      if (response.statusCode == 200) {
        print(response.body);

        var jsonResponse = json.decode(response.body);

        return PessoaCoordenadaModel.fromJson(jsonResponse);
      } else {
        return null;
      }
    } catch (error) {
      print("Erro: $error");
      return null;
    }
  }

  Future<bool> incluirDespesaRapida(Auth? auth, DespesaRapidaModel request) async {
    final url = Uri.parse('$apiUrl/api/DespesaRapida');
    final body = request.toJson();

    debugPrint(json.encode(body));

    try {
      print("Calling POST /DespesaRapida...");

      var response = await http
          .post(
            url,
            headers: await ApiHelperService.buildHeaders(auth),
            body: json.encode(body),
          )
          .timeout(const Duration(seconds: 45));

      if (response.statusCode == 200) {
        return true;
      } else {
        var errorModel = ApiErrorModel.fromJson(jsonDecode(response.body));
        return false;
      }
    } catch (error) {
      print("Erro: $error");
      return false;
    }
  }
}

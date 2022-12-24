import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:teste/models/api_error_model.dart';
import 'package:teste/models/auth.dart';
import 'package:teste/models/cartao_credito_model.dart';
import 'package:teste/models/conta_bancaria_model.dart';
import 'package:teste/models/despesa_rapida_model.dart';
import 'package:teste/models/login/login_request_model.dart';
import 'package:teste/models/login/login_response_model.dart';
import 'package:teste/models/pessoa_coordenada_model.dart';
import 'package:teste/models/saldo_conta_model.dart';

import 'auth_service.dart';

class MangosApiService {
  //static const String apiUrl = "https://localhost:5051";
  static const String apiUrl = "https://api.mangos.inf.br";

  Future<Auth?> login(LoginRequestModel request) async {
    final url = Uri.parse('$apiUrl/api/Login');
    final headers = {"Content-Type": "application/json"};
    final body = request.toJson();

    try {
      debugPrint("Calling POST /Login...");

      var response = await http
          .post(
            url,
            headers: headers,
            body: json.encode(body),
          )
          .timeout(const Duration(seconds: 45));

      debugPrint(response.statusCode.toString());

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

  //
  // TODO: todos os demais métodos devem usar um interceptor, pra não precisar usar o AuthService
  //

  Future<bool> refresh() async {
    final url = Uri.parse('$apiUrl/api/Login');
    final headers = {"Content-Type": "application/json"};

    final authService = AuthService(); // TODO: interceptor
    final auth = await authService.get();

    final body = {'authenticationToken': auth?.token, 'refreshToken': auth?.refreshToken};

    try {
      print("Calling PUT /Login...");

      var response = await http
          .put(
            url,
            headers: headers,
            body: json.encode(body),
          )
          .timeout(const Duration(seconds: 45));

      if (response.statusCode == 200) {
        var responseModel = LoginResponseModel.fromJson(jsonDecode(response.body));

        final authService = AuthService();
        final auth = Auth(responseModel.create, responseModel.expiration, responseModel.token, responseModel.refreshToken);
        await authService.save(auth);

        print("Body: ${response.body}");
        print("AuthToken: ${auth.token}");

        return true;
      } else {
        return false;
      }
    } catch (error) {
      print("Erro: $error");
      return false;
    }
  }

  Future<List<SaldoContaModel>> getSaldosConta() async {
    final authService = AuthService(); // TODO: interceptor
    final auth = await authService.get();

    final url = Uri.parse('$apiUrl/api/SaldoConta');
    var headers = {
      "Authorization": "Bearer ${auth?.token}",
    };

    try {
      print("Calling GET /SaldoConta...");

      var response = await http
          .get(
            url,
            headers: headers,
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
      return [];
    }
  }

  Future<List<ContaBancariaModel>> getContasBancarias() async {
    final authService = AuthService(); // TODO: interceptor
    final auth = await authService.get();

    final url = Uri.parse('$apiUrl/api/ContaBancaria');
    var headers = {
      "Authorization": "Bearer ${auth?.token}",
    };

    try {
      print("Calling GET /ContaBancaria...");

      var response = await http
          .get(
            url,
            headers: headers,
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

  Future<List<CartaoCreditoModel>> getCartoesCredito() async {
    final authService = AuthService(); // TODO: interceptor
    final auth = await authService.get();

    final url = Uri.parse('$apiUrl/api/CartaoCredito');
    var headers = {
      "Authorization": "Bearer ${auth?.token}",
    };

    try {
      debugPrint("Calling GET /CartaoCredito...");

      var response = await http
          .get(
            url,
            headers: headers,
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

  Future<PessoaCoordenadaModel?> getPessoaCoordenada(double latitude, double longitude) async {
    final authService = AuthService(); // TODO: interceptor
    final auth = await authService.get();

    final url = Uri.parse(
        '$apiUrl/api/PessoaCoordenada?Latitude=${latitude.toString().replaceAll(',', '.')}&Longitude=${longitude.toString().replaceAll(',', '.')}');
    var headers = {
      "Authorization": "Bearer ${auth?.token}",
    };

    try {
      print("Calling GET /PessoaCoordenada...");

      var response = await http
          .get(
            url,
            headers: headers,
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

  Future<bool> incluirDespesaRapida(DespesaRapidaModel request) async {
    final authService = AuthService(); // TODO: interceptor
    final auth = await authService.get();

    final url = Uri.parse('$apiUrl/api/DespesaRapida');
    final headers = {
      "Content-Type": "application/json",
      "Authorization": "Bearer ${auth?.token}",
    };
    final body = request.toJson();

    debugPrint(json.encode(body));

    try {
      print("Calling POST /DespesaRapida...");

      var response = await http
          .post(
            url,
            headers: headers,
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

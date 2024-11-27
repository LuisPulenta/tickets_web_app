import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:tickets_web_app/models/models.dart';
import 'constants.dart';

class ApiHelper {
  //--------------------------------------------------------------
  static Future<Response> getUser(Token token, String id) async {
    if (!_validateToken(token)) {
      return Response(
          isSuccess: false,
          message:
              'Sus credenciales se han vencido, por favor cierre sesión y vuelva a ingresar al sistema.');
    }
    var url = Uri.parse('${Constants.apiUrl}/api/Users/$id');
    var response = await http.get(
      url,
      headers: {
        'content-type': 'application/json',
        'accept': 'application/json',
        'authorization': 'bearer ${token.token}',
      },
    );
    var body = response.body;

    if (response.statusCode >= 400) {
      return Response(isSuccess: false, message: body);
    }

    var decodedJson = jsonDecode(body);
    return Response(isSuccess: true, result: User.fromJson(decodedJson));
  }

  //--------------------------------------------------------------
  static Future<Response> put(String controller, String id,
      Map<String, dynamic> request, Token token) async {
    if (!_validateToken(token)) {
      return Response(
          isSuccess: false,
          message:
              'Sus credenciales se han vencido, por favor cierre sesión y vuelva a ingresar al sistema.');
    }
    var url = Uri.parse('${Constants.apiUrl}$controller/$id');
    var response = await http.put(
      url,
      headers: {
        'content-type': 'application/json',
        'accept': 'application/json',
        'authorization': 'bearer ${token.token}',
      },
      body: jsonEncode(request),
    );

    if (response.statusCode >= 400) {
      return Response(isSuccess: false, message: response.body);
    }

    return Response(isSuccess: true);
  }

  //--------------------------------------------------------------
  static Future<Response> postNoToken(
      String controller, Map<String, dynamic> request) async {
    var url = Uri.parse('${Constants.apiUrl}$controller');
    var response = await http.post(
      url,
      headers: {
        'content-type': 'application/json',
        'accept': 'application/json',
      },
      body: jsonEncode(request),
    );

    if (response.statusCode >= 400) {
      return Response(isSuccess: false, message: response.body);
    }

    return Response(isSuccess: true);
  }

  //--------------------------------------------------------------
  static Future<Response> post(
      String controller, Map<String, dynamic> request, Token token) async {
    if (!_validateToken(token)) {
      return Response(
          isSuccess: false,
          message:
              'Sus credenciales se han vencido, por favor cierre sesión y vuelva a ingresar al sistema.');
    }
    var url = Uri.parse('${Constants.apiUrl}$controller');
    var response = await http.post(
      url,
      headers: {
        'content-type': 'application/json',
        'accept': 'application/json',
        'authorization': 'bearer ${token.token}',
      },
      body: jsonEncode(request),
    );

    if (response.statusCode >= 400) {
      return Response(isSuccess: false, message: response.body);
    }

    return Response(isSuccess: true);
  }

  //--------------------------------------------------------------
  static Future<Response> delete(
      String controller, String id, Token token) async {
    if (!_validateToken(token)) {
      return Response(
          isSuccess: false,
          message:
              'Sus credenciales se han vencido, por favor cierre sesión y vuelva a ingresar al sistema.');
    }
    var url = Uri.parse('${Constants.apiUrl}$controller$id');
    var response = await http.delete(
      url,
      headers: {
        'content-type': 'application/json',
        'accept': 'application/json',
        'authorization': 'bearer ${token.token}',
      },
    );

    if (response.statusCode >= 400) {
      return Response(isSuccess: false, message: response.body);
    }

    return Response(isSuccess: true);
  }

  //--------------------------------------------------------------
  static bool _validateToken(Token token) {
    if (DateTime.parse(token.expiration).isAfter(DateTime.now())) {
      return true;
    }
    return false;
  }

  //--------------------------------------------------------------
  static Future<Response> getCompanies(Token token) async {
    if (!_validateToken(token)) {
      return Response(
          isSuccess: false,
          message:
              'Sus credenciales se han vencido, por favor cierre sesión y vuelva a ingresar al sistema.');
    }
    var url = Uri.parse('${Constants.apiUrl}/Companies');
    var response = await http.get(
      url,
      headers: {
        'content-type': 'application/json',
        'accept': 'application/json',
        'authorization': 'bearer ${token.token}',
      },
    );
    var body = response.body;

    if (response.statusCode >= 400) {
      return Response(isSuccess: false, message: body);
    }

    List<Company> list = [];
    var decodedJson = jsonDecode(body);
    if (decodedJson != null) {
      for (var item in decodedJson) {
        list.add(Company.fromJson(item));
      }
    }
    return Response(isSuccess: true, result: list);
  }

  //--------------------------------------------------------------
  static Future<Response> getCompaniesCombo(Token token) async {
    if (!_validateToken(token)) {
      return Response(
          isSuccess: false,
          message:
              'Sus credenciales se han vencido, por favor cierre sesión y vuelva a ingresar al sistema.');
    }
    var url = Uri.parse('${Constants.apiUrl}/Companies/Combo');
    var response = await http.get(
      url,
      headers: {
        'content-type': 'application/json',
        'accept': 'application/json',
        'authorization': 'bearer ${token.token}',
      },
    );
    var body = response.body;

    if (response.statusCode >= 400) {
      return Response(isSuccess: false, message: body);
    }

    List<Company> list = [];
    var decodedJson = jsonDecode(body);
    if (decodedJson != null) {
      for (var item in decodedJson) {
        list.add(Company.fromJson(item));
      }
    }
    return Response(isSuccess: true, result: list);
  }

  //--------------------------------------------------------------
  static Future<Response> getUsers(Token token) async {
    if (!_validateToken(token)) {
      return Response(
          isSuccess: false,
          message:
              'Sus credenciales se han vencido, por favor cierre sesión y vuelva a ingresar al sistema.');
    }
    var url = Uri.parse('${Constants.apiUrl}/Account');
    var response = await http.get(
      url,
      headers: {
        'content-type': 'application/json',
        'accept': 'application/json',
        'authorization': 'bearer ${token.token}',
      },
    );
    var body = response.body;

    if (response.statusCode >= 400) {
      return Response(isSuccess: false, message: body);
    }

    List<User> list = [];
    var decodedJson = jsonDecode(body);
    if (decodedJson != null) {
      for (var item in decodedJson) {
        list.add(User.fromJson(item));
      }
    }
    return Response(isSuccess: true, result: list);
  }
}

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:tickets_web_app/models/models.dart';
import 'package:tickets_web_app/services/local_storage.dart';
import 'constants.dart';

class ApiHelper {
  //--------------------------------------------------------------
  static Future<Response> getUser(String id) async {
    Token token = Token.fromJson(
        jsonDecode(LocalStorage.prefs.getString('userBody') ?? ''));

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
  static Future<Response> put(
      String controller, String id, Map<String, dynamic> request) async {
    Token token = Token.fromJson(
        jsonDecode(LocalStorage.prefs.getString('userBody') ?? ''));

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
      String controller, Map<String, dynamic> request) async {
    Token token = Token.fromJson(
        jsonDecode(LocalStorage.prefs.getString('userBody') ?? ''));

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
  static Future<Response> delete(String controller, String id) async {
    Token token = Token.fromJson(
        jsonDecode(LocalStorage.prefs.getString('userBody') ?? ''));

    if (!_validateToken(token)) {
      return Response(
          isSuccess: false,
          message:
              'Sus credenciales se han vencido, por favor cierre sesión y vuelva a ingresar al sistema.');
    }
    var url = Uri.parse('${Constants.apiUrl}$controller/$id');
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
  static Future<Response> getCompanies() async {
    Token token = Token.fromJson(
        jsonDecode(LocalStorage.prefs.getString('userBody') ?? ''));

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
  static Future<Response> getCompaniesCombo() async {
    Token token = Token.fromJson(
        jsonDecode(LocalStorage.prefs.getString('userBody') ?? ''));

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
  static Future<Response> getUsers() async {
    Token token = Token.fromJson(
        jsonDecode(LocalStorage.prefs.getString('userBody') ?? ''));

    int userType = LocalStorage.prefs.getInt('userType') ?? 99;
    int userCompany = LocalStorage.prefs.getInt('userCompany') ?? 99;

    if (!_validateToken(token)) {
      return Response(
          isSuccess: false,
          message:
              'Sus credenciales se han vencido, por favor cierre sesión y vuelva a ingresar al sistema.');
    }
    Uri url;
    var response;

    if (userType == 0) {
      url = Uri.parse('${Constants.apiUrl}/Account');
      response = await http.get(
        url,
        headers: {
          'content-type': 'application/json',
          'accept': 'application/json',
          'authorization': 'bearer ${token.token}',
        },
      );
    } else {
      url = Uri.parse('${Constants.apiUrl}/Account/GetUsers/$userCompany');
      response = await http.post(
        url,
        headers: {
          'content-type': 'application/json',
          'accept': 'application/json',
          'authorization': 'bearer ${token.token}',
        },
      );
    }

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

  //--------------------------------------------------------------
  static Future<Response> getCompany(int id) async {
    Token token = Token.fromJson(
        jsonDecode(LocalStorage.prefs.getString('userBody') ?? ''));

    if (!_validateToken(token)) {
      return Response(
          isSuccess: false,
          message:
              'Sus credenciales se han vencido, por favor cierre sesión y vuelva a ingresar al sistema.');
    }
    var url = Uri.parse('${Constants.apiUrl}/Companies/$id');
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
    return Response(isSuccess: true, result: Company.fromJson(decodedJson));
  }

  //--------------------------------------------------------------
  static Future<Response> getTicketCabs() async {
    Token token = Token.fromJson(
        jsonDecode(LocalStorage.prefs.getString('userBody') ?? ''));

    if (!_validateToken(token)) {
      return Response(
          isSuccess: false,
          message:
              'Sus credenciales se han vencido, por favor cierre sesión y vuelva a ingresar al sistema.');
    }
    var url = Uri.parse('${Constants.apiUrl}/ticketCabs');
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

    List<TicketCab> list = [];
    var decodedJson = jsonDecode(body);
    if (decodedJson != null) {
      for (var item in decodedJson) {
        list.add(TicketCab.fromJson(item));
      }
    }
    return Response(isSuccess: true, result: list);
  }

  //--------------------------------------------------------------
  static Future<Response> getTicketUser(String id) async {
    Token token = Token.fromJson(
        jsonDecode(LocalStorage.prefs.getString('userBody') ?? ''));

    if (!_validateToken(token)) {
      return Response(
          isSuccess: false,
          message:
              'Sus credenciales se han vencido, por favor cierre sesión y vuelva a ingresar al sistema.');
    }
    var url = Uri.parse('${Constants.apiUrl}/ticketCabs/GetTicketUser/$id');
    var response = await http.post(
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

    List<TicketCab> list = [];
    var decodedJson = jsonDecode(body);
    if (decodedJson != null) {
      for (var item in decodedJson) {
        list.add(TicketCab.fromJson(item));
      }
    }
    return Response(isSuccess: true, result: list);
  }

  //--------------------------------------------------------------
  static Future<Response> getTicketAdmin(int id) async {
    Token token = Token.fromJson(
        jsonDecode(LocalStorage.prefs.getString('userBody') ?? ''));

    if (!_validateToken(token)) {
      return Response(
          isSuccess: false,
          message:
              'Sus credenciales se han vencido, por favor cierre sesión y vuelva a ingresar al sistema.');
    }
    var url = Uri.parse('${Constants.apiUrl}/ticketCabs/GetTicketAdmin/$id');
    var response = await http.post(
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

    List<TicketCab> list = [];
    var decodedJson = jsonDecode(body);
    if (decodedJson != null) {
      for (var item in decodedJson) {
        list.add(TicketCab.fromJson(item));
      }
    }
    return Response(isSuccess: true, result: list);
  }

  //--------------------------------------------------------------
  static Future<Response> getTicketAdminKP() async {
    Token token = Token.fromJson(
        jsonDecode(LocalStorage.prefs.getString('userBody') ?? ''));

    if (!_validateToken(token)) {
      return Response(
          isSuccess: false,
          message:
              'Sus credenciales se han vencido, por favor cierre sesión y vuelva a ingresar al sistema.');
    }
    var url = Uri.parse('${Constants.apiUrl}/ticketCabs/GetTicketAdminKP');
    var response = await http.post(
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

    List<TicketCab> list = [];
    var decodedJson = jsonDecode(body);
    if (decodedJson != null) {
      for (var item in decodedJson) {
        list.add(TicketCab.fromJson(item));
      }
    }
    return Response(isSuccess: true, result: list);
  }

  //--------------------------------------------------------------
  static Future<Response> getTicketResueltosUser(String id) async {
    Token token = Token.fromJson(
        jsonDecode(LocalStorage.prefs.getString('userBody') ?? ''));

    if (!_validateToken(token)) {
      return Response(
          isSuccess: false,
          message:
              'Sus credenciales se han vencido, por favor cierre sesión y vuelva a ingresar al sistema.');
    }
    var url =
        Uri.parse('${Constants.apiUrl}/ticketCabs/GetTicketResueltosUser/$id');
    var response = await http.post(
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

    List<TicketCab> list = [];
    var decodedJson = jsonDecode(body);
    if (decodedJson != null) {
      for (var item in decodedJson) {
        list.add(TicketCab.fromJson(item));
      }
    }
    return Response(isSuccess: true, result: list);
  }

  //--------------------------------------------------------------
  static Future<Response> getTicketResueltosAdmin(int id) async {
    Token token = Token.fromJson(
        jsonDecode(LocalStorage.prefs.getString('userBody') ?? ''));

    if (!_validateToken(token)) {
      return Response(
          isSuccess: false,
          message:
              'Sus credenciales se han vencido, por favor cierre sesión y vuelva a ingresar al sistema.');
    }
    var url =
        Uri.parse('${Constants.apiUrl}/ticketCabs/GetTicketResueltosAdmin/$id');
    var response = await http.post(
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

    List<TicketCab> list = [];
    var decodedJson = jsonDecode(body);
    if (decodedJson != null) {
      for (var item in decodedJson) {
        list.add(TicketCab.fromJson(item));
      }
    }
    return Response(isSuccess: true, result: list);
  }

  //--------------------------------------------------------------
  static Future<Response> getTicketResueltosAdminKP() async {
    Token token = Token.fromJson(
        jsonDecode(LocalStorage.prefs.getString('userBody') ?? ''));

    if (!_validateToken(token)) {
      return Response(
          isSuccess: false,
          message:
              'Sus credenciales se han vencido, por favor cierre sesión y vuelva a ingresar al sistema.');
    }
    var url =
        Uri.parse('${Constants.apiUrl}/ticketCabs/GetTicketResueltosAdminKP');
    var response = await http.post(
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

    List<TicketCab> list = [];
    var decodedJson = jsonDecode(body);
    if (decodedJson != null) {
      for (var item in decodedJson) {
        list.add(TicketCab.fromJson(item));
      }
    }
    return Response(isSuccess: true, result: list);
  }

  //--------------------------------------------------------------
  static Future<Response> postTicketCab(
      String controller, Map<String, dynamic> request) async {
    Token token = Token.fromJson(
        jsonDecode(LocalStorage.prefs.getString('userBody') ?? ''));

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

    var body = response.body;
    var decodedJson = jsonDecode(body);
    int nro = decodedJson["id"];

    return Response(isSuccess: true, result: nro);
  }

  //--------------------------------------------------------------
  static Future<Response> postTicketDet(
      String controller, Map<String, dynamic> request) async {
    Token token = Token.fromJson(
        jsonDecode(LocalStorage.prefs.getString('userBody') ?? ''));

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

    var body = response.body;
    var decodedJson = jsonDecode(body);
    var result = TicketDet.fromJson(decodedJson);

    return Response(isSuccess: true, result: result);
  }

  //--------------------------------------------------------------
  static Future<Response> getTicketCab(String id) async {
    Token token = Token.fromJson(
        jsonDecode(LocalStorage.prefs.getString('userBody') ?? ''));

    if (!_validateToken(token)) {
      return Response(
          isSuccess: false,
          message:
              'Sus credenciales se han vencido, por favor cierre sesión y vuelva a ingresar al sistema.');
    }
    var url = Uri.parse('${Constants.apiUrl}/TicketCabs/$id');
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
    return Response(isSuccess: true, result: TicketCab.fromJson(decodedJson));
  }
}

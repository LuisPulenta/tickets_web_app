import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/models.dart';
import '../services/local_storage.dart';
import 'constants.dart';

class ApiHelper {
  //--------------------------------------------------------------
  static Future<Response> getUser(String id) async {
    Token token = Token.fromJson(
        jsonDecode(LocalStorage.prefs.getString('tickets-userBody') ?? ''));

    if (!_validateToken(token)) {
      return Response(
          isSuccess: false,
          message:
              'Sus credenciales se han vencido, por favor cierre sesión y vuelva a ingresar al sistema.');
    }
    var url = Uri.parse('${Constants.apiUrl}/Account/$id');
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
        jsonDecode(LocalStorage.prefs.getString('tickets-userBody') ?? ''));

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
        jsonDecode(LocalStorage.prefs.getString('tickets-userBody') ?? ''));

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
        jsonDecode(LocalStorage.prefs.getString('tickets-userBody') ?? ''));

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
        jsonDecode(LocalStorage.prefs.getString('tickets-userBody') ?? ''));

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
        jsonDecode(LocalStorage.prefs.getString('tickets-userBody') ?? ''));

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
  static Future<Response> getBranchesCombo() async {
    Token token = Token.fromJson(
        jsonDecode(LocalStorage.prefs.getString('tickets-userBody') ?? ''));

    int userCompany = LocalStorage.prefs.getInt('tickets-userCompany') ?? 99;

    if (!_validateToken(token)) {
      return Response(
          isSuccess: false,
          message:
              'Sus credenciales se han vencido, por favor cierre sesión y vuelva a ingresar al sistema.');
    }
    var url = Uri.parse('${Constants.apiUrl}/Branches/Combo/$userCompany');
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

    List<Branch> list = [];
    var decodedJson = jsonDecode(body);
    if (decodedJson != null) {
      for (var item in decodedJson) {
        list.add(Branch.fromJson(item));
      }
    }
    return Response(isSuccess: true, result: list);
  }

  //--------------------------------------------------------------
  static Future<Response> getUsers() async {
    Token token = Token.fromJson(
        jsonDecode(LocalStorage.prefs.getString('tickets-userBody') ?? ''));

    int userType = LocalStorage.prefs.getInt('tickets-userType') ?? 99;
    int userCompany = LocalStorage.prefs.getInt('tickets-userCompany') ?? 99;

    if (!_validateToken(token)) {
      return Response(
          isSuccess: false,
          message:
              'Sus credenciales se han vencido, por favor cierre sesión y vuelva a ingresar al sistema.');
    }
    Uri url;
    http.Response response;

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
  static Future<Response> getBranches() async {
    Token token = Token.fromJson(
        jsonDecode(LocalStorage.prefs.getString('tickets-userBody') ?? ''));

    int userType = LocalStorage.prefs.getInt('tickets-userType') ?? 99;
    int userCompany = LocalStorage.prefs.getInt('tickets-userCompany') ?? 99;

    if (!_validateToken(token)) {
      return Response(
          isSuccess: false,
          message:
              'Sus credenciales se han vencido, por favor cierre sesión y vuelva a ingresar al sistema.');
    }
    Uri url;
    http.Response response;

    url = Uri.parse('${Constants.apiUrl}/Branches/GetBranches/$userCompany');
    response = await http.get(
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

    List<Branch> list = [];
    var decodedJson = jsonDecode(body);
    if (decodedJson != null) {
      for (var item in decodedJson) {
        list.add(Branch.fromJson(item));
      }
    }
    return Response(isSuccess: true, result: list);
  }

  //--------------------------------------------------------------
  static Future<Response> getCompany(int id) async {
    Token token = Token.fromJson(
        jsonDecode(LocalStorage.prefs.getString('tickets-userBody') ?? ''));

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
        jsonDecode(LocalStorage.prefs.getString('tickets-userBody') ?? ''));

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
        jsonDecode(LocalStorage.prefs.getString('tickets-userBody') ?? ''));

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
        jsonDecode(LocalStorage.prefs.getString('tickets-userBody') ?? ''));

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
        jsonDecode(LocalStorage.prefs.getString('tickets-userBody') ?? ''));

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
  static Future<Response> postTicketCab(
      String controller, Map<String, dynamic> request) async {
    Token token = Token.fromJson(
        jsonDecode(LocalStorage.prefs.getString('tickets-userBody') ?? ''));

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
    int nro = decodedJson['id'];

    return Response(isSuccess: true, result: nro);
  }

  //--------------------------------------------------------------
  static Future<Response> postTicketDet(
      String controller, Map<String, dynamic> request) async {
    Token token = Token.fromJson(
        jsonDecode(LocalStorage.prefs.getString('tickets-userBody') ?? ''));

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
        jsonDecode(LocalStorage.prefs.getString('tickets-userBody') ?? ''));

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

  //--------------------------------------------------------------
  static Future<Response> getTicketsResueltos(
      String controller, Map<String, dynamic> request) async {
    Token token = Token.fromJson(
        jsonDecode(LocalStorage.prefs.getString('tickets-userBody') ?? ''));

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
  static Future<Response> getTicketCabParaResolver(String id) async {
    Token token = Token.fromJson(
        jsonDecode(LocalStorage.prefs.getString('tickets-userBody') ?? ''));

    if (!_validateToken(token)) {
      return Response(
          isSuccess: false,
          message:
              'Sus credenciales se han vencido, por favor cierre sesión y vuelva a ingresar al sistema.');
    }
    var url =
        Uri.parse('${Constants.apiUrl}/TicketCabs/GetTicketParaResolver/$id');
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
  static Future<Response> deleteUser(String id) async {
    Token token = Token.fromJson(
        jsonDecode(LocalStorage.prefs.getString('tickets-userBody') ?? ''));

    if (!_validateToken(token)) {
      return Response(
          isSuccess: false,
          message:
              'Sus credenciales se han vencido, por favor cierre sesión y vuelva a ingresar al sistema.');
    }
    Uri url;
    http.Response response;

    url = Uri.parse('${Constants.apiUrl}/Account/DeleteUserById/$id');
    response = await http.delete(
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

    return Response(isSuccess: true, result: response.body);
  }

  //--------------------------------------------------------------
  static Future<Response> getUsersCombo(int id) async {
    Token token = Token.fromJson(
        jsonDecode(LocalStorage.prefs.getString('tickets-userBody') ?? ''));

    if (!_validateToken(token)) {
      return Response(
          isSuccess: false,
          message:
              'Sus credenciales se han vencido, por favor cierre sesión y vuelva a ingresar al sistema.');
    }
    var url = Uri.parse('${Constants.apiUrl}/Account/Combo/$id');
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

  //--------------------------------------------------------------
  static Future<Response> getCategories() async {
    Token token = Token.fromJson(
        jsonDecode(LocalStorage.prefs.getString('tickets-userBody') ?? ''));

    if (!_validateToken(token)) {
      return Response(
          isSuccess: false,
          message:
              'Sus credenciales se han vencido, por favor cierre sesión y vuelva a ingresar al sistema.');
    }
    var url = Uri.parse('${Constants.apiUrl}/Categories');
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

    List<Category> list = [];
    var decodedJson = jsonDecode(body);
    if (decodedJson != null) {
      for (var item in decodedJson) {
        list.add(Category.fromJson(item));
      }
    }
    return Response(isSuccess: true, result: list);
  }

  //--------------------------------------------------------------
  static Future<Response> getCategory(String id) async {
    Token token = Token.fromJson(
        jsonDecode(LocalStorage.prefs.getString('tickets-userBody') ?? ''));

    if (!_validateToken(token)) {
      return Response(
          isSuccess: false,
          message:
              'Sus credenciales se han vencido, por favor cierre sesión y vuelva a ingresar al sistema.');
    }
    var url = Uri.parse('${Constants.apiUrl}/Categories/GetCategoryById/$id');
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

    var decodedJson = jsonDecode(body);
    Category category = Category.fromJson(decodedJson);
    return Response(isSuccess: true, result: category);
  }

  //--------------------------------------------------------------
  static Future<Response> getSubcategories(String id) async {
    Token token = Token.fromJson(
        jsonDecode(LocalStorage.prefs.getString('tickets-userBody') ?? ''));

    if (!_validateToken(token)) {
      return Response(
          isSuccess: false,
          message:
              'Sus credenciales se han vencido, por favor cierre sesión y vuelva a ingresar al sistema.');
    }
    var url =
        Uri.parse('${Constants.apiUrl}/Subcategories/GetSubcategories/$id');
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
    List<Subcategory> list = [];
    var decodedJson = jsonDecode(body);
    if (decodedJson != null) {
      for (var item in decodedJson) {
        list.add(Subcategory.fromJson(item));
      }
    }
    return Response(isSuccess: true, result: list);
  }

  //--------------------------------------------------------------
  static Future<Response> getCategoriesCombo() async {
    Token token = Token.fromJson(
        jsonDecode(LocalStorage.prefs.getString('tickets-userBody') ?? ''));

    if (!_validateToken(token)) {
      return Response(
          isSuccess: false,
          message:
              'Sus credenciales se han vencido, por favor cierre sesión y vuelva a ingresar al sistema.');
    }
    var url = Uri.parse('${Constants.apiUrl}/Categories/Combo');
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

    List<Category> list = [];
    var decodedJson = jsonDecode(body);
    if (decodedJson != null) {
      for (var item in decodedJson) {
        list.add(Category.fromJson(item));
      }
    }
    return Response(isSuccess: true, result: list);
  }

  //--------------------------------------------------------------
  static Future<Response> getSubcategoriesCombo(int categoryId) async {
    Token token = Token.fromJson(
        jsonDecode(LocalStorage.prefs.getString('tickets-userBody') ?? ''));

    if (!_validateToken(token)) {
      return Response(
          isSuccess: false,
          message:
              'Sus credenciales se han vencido, por favor cierre sesión y vuelva a ingresar al sistema.');
    }
    var url = Uri.parse('${Constants.apiUrl}/Subcategories/Combo/$categoryId');
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

    List<Subcategory> list = [];
    var decodedJson = jsonDecode(body);
    if (decodedJson != null) {
      for (var item in decodedJson) {
        list.add(Subcategory.fromJson(item));
      }
    }
    return Response(isSuccess: true, result: list);
  }

  //--------------------------------------------------------------
  static Future<Response> sendMail(Map<String, dynamic> request) async {
    Token token = Token.fromJson(
        jsonDecode(LocalStorage.prefs.getString('tickets-userBody') ?? ''));

    if (!_validateToken(token)) {
      return Response(
          isSuccess: false,
          message:
              'Sus credenciales se han vencido, por favor cierre sesión y vuelva a ingresar al sistema.');
    }
    var url = Uri.parse('${Constants.apiUrl}/TicketCabs/SendEmail');
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
    return Response(isSuccess: true, result: true);
  }

  //--------------------------------------------------------------
  static Future<Response> getMailsAdmin(int companyId) async {
    var url = Uri.parse('${Constants.apiUrl}/account/GetMailsAdmin/$companyId');
    var response = await http.post(
      url,
      headers: {
        'content-type': 'application/json',
        'accept': 'application/json',
      },
    );
    var body = response.body;

    if (response.statusCode >= 400) {
      return Response(isSuccess: false, message: body);
    }

    var decodedJson = jsonDecode(body);
    return Response(
        isSuccess: true, result: EmailResponse.fromJson(decodedJson));
  }

  //--------------------------------------------------------------
  static Future<Response> getMailsAdminKP() async {
    var url = Uri.parse('${Constants.apiUrl}/account/GetMailsAdminKP');
    var response = await http.post(
      url,
      headers: {
        'content-type': 'application/json',
        'accept': 'application/json',
      },
    );

    var body = response.body;

    if (response.statusCode >= 400) {
      return Response(isSuccess: false, message: body);
    }

    var decodedJson = jsonDecode(body);
    return Response(
        isSuccess: true, result: EmailResponse.fromJson(decodedJson));
  }
}

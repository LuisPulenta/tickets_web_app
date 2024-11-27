import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:tickets_web_app/helpers/constants.dart';
import 'package:tickets_web_app/models/models.dart';
import 'package:tickets_web_app/router/router.dart';
import 'package:tickets_web_app/services/local_storage.dart';
import 'package:tickets_web_app/services/navigation_services.dart';
import 'package:http/http.dart' as http;
import 'package:tickets_web_app/services/notifications_service.dart';

enum AuthStatus {
  checking,
  authenticated,
  notAuthenticated,
}

class AuthProvider extends ChangeNotifier {
  String? _token;
  AuthStatus authStatus = AuthStatus.checking;
  User? user;

  AuthProvider() {
    isAuthenticated();
  }

  //----------------------------------------------------------------
  login(String email, String password) async {
    final data = {
      "userName": email,
      "password": password,
    };

    var url = Uri.parse('${Constants.apiUrl}/Account/CreateToken');

    var response = await http.post(
      url,
      headers: {
        'content-type': 'application/json',
        'accept': 'application/json',
      },
      body: jsonEncode(data),
    );

    if (response.statusCode >= 400) {
      NotificationsService.showSnackbarError("Credenciales no válidas");
      return;
    }

    var body = response.body;
    var decodedJson = jsonDecode(body);
    var token = Token.fromJson(decodedJson);

    user = token.user;

    authStatus = AuthStatus.authenticated;
    LocalStorage.prefs.setString('token', token.token);
    LocalStorage.prefs.setString('userBody', body);
    NavigationServices.replaceTo(Flurorouter.dashboardRoute);
    notifyListeners();
  }

//NotificationsService.showSnackbarError("Credenciales no válidas");

  //----------------------------------------------------------------
  Future<bool> isAuthenticated() async {
    final token = LocalStorage.prefs.getString('token');
    String? userBody = LocalStorage.prefs.getString('userBody');

    if (token == null) {
      authStatus = AuthStatus.notAuthenticated;
      notifyListeners();
      return false;
    }
    //ir al backend y comprobar si el JWT es válido
    try {
      if (userBody != null) {
        var decodedJson = jsonDecode(userBody);
        var token2 = Token.fromJson(decodedJson);
        if (DateTime.parse(token2.expiration).isAfter(DateTime.now())) {
          authStatus = AuthStatus.authenticated;
          user = token2.user;
        }
      }
      return true;
    } catch (e) {
      print(e);
      authStatus = AuthStatus.notAuthenticated;
      notifyListeners();
      return false;
    }
  }

  //---------------------------------------------------------------
  logout() {
    LocalStorage.prefs.remove('token');
    authStatus = AuthStatus.notAuthenticated;
    notifyListeners();
  }
}

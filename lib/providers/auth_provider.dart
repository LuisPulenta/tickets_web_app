import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../helpers/api_helper.dart';
import '../helpers/constants.dart';
import '../models/models.dart';
import '../router/router.dart';
import '../services/local_storage.dart';
import '../services/navigation_services.dart';
import '../services/notifications_service.dart';

enum AuthStatus {
  checking,
  authenticated,
  notAuthenticated,
}

class AuthProvider extends ChangeNotifier {
  AuthStatus authStatus = AuthStatus.checking;
  User? user;
  bool showLoader = false;

  AuthProvider() {
    isAuthenticated();
  }

  //----------------------------------------------------------------
  login(String email, String password) async {
    showLoader = true;
    notifyListeners();

    final data = {
      'userName': email,
      'password': password,
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
      NotificationsService.showSnackbarError('Credenciales no válidas');
      showLoader = false;
      notifyListeners();
      return;
    }

    var body = response.body;
    var decodedJson = jsonDecode(body);
    var token = Token.fromJson(decodedJson);

    user = token.user;

    if (!user!.active) {
      NotificationsService.showSnackbarError('Usuario no activo');
      showLoader = false;
      notifyListeners();
      return;
    }

    LocalStorage.prefs.setString('tickets-token', token.token);
    LocalStorage.prefs.setString('tickets-userBody', body);
    LocalStorage.prefs.setInt('tickets-userType', user!.userTypeId);
    LocalStorage.prefs.setInt('tickets-userCompany', user!.companyId);

    Response response2 = await ApiHelper.getCompany(user!.companyId);

    Company company = response2.result;

    authStatus = AuthStatus.authenticated;

    LocalStorage.prefs.setString('tickets-companyLogo', company.photoFullPath);
    NavigationServices.replaceTo(Flurorouter.dashboardRoute);
    showLoader = false;
    notifyListeners();
  }

//NotificationsService.showSnackbarError("Credenciales no válidas");

  //----------------------------------------------------------------
  Future<bool> isAuthenticated() async {
    final token = LocalStorage.prefs.getString('tickets-token');
    String? userBody = LocalStorage.prefs.getString('tickets-userBody');

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
      //print(e);
      authStatus = AuthStatus.notAuthenticated;
      notifyListeners();
      return false;
    }
  }

  //---------------------------------------------------------------
  logout() {
    LocalStorage.prefs.remove('tickets-token');
    authStatus = AuthStatus.notAuthenticated;
    notifyListeners();
  }

  //----------------------------------------------------------------
  recoverPassword(String email) async {
    showLoader = true;
    notifyListeners();

    final data = {
      'Email': email,
    };

    var url = Uri.parse('${Constants.apiUrl}/Account/RecoverPassword');

    var response = await http.post(
      url,
      headers: {
        'content-type': 'application/json',
        'accept': 'application/json',
      },
      body: jsonEncode(data),
    );

    if (response.statusCode >= 400) {
      NotificationsService.showSnackbarError('Ese Email no está registrado');
      showLoader = false;
      notifyListeners();
      return;
    }

    NavigationServices.replaceTo(Flurorouter.loginRoute);
    NotificationsService.showSnackbar(
        'Las instrucciones para el cambio de contraseña han sido enviadas al email $email');
    showLoader = false;
    notifyListeners();
  }

  //----------------------------------------------------------------
  resendEmail(String email) async {
    showLoader = true;
    notifyListeners();

    final data = {
      'Email': email,
    };

    var url = Uri.parse('${Constants.apiUrl}/Account/ResendToken');

    var response = await http.post(
      url,
      headers: {
        'content-type': 'application/json',
        'accept': 'application/json',
      },
      body: jsonEncode(data),
    );

    if (response.statusCode >= 400) {
      NotificationsService.showSnackbarError('Ese Email no está registrado');
      showLoader = false;
      notifyListeners();
      return;
    }

    NavigationServices.replaceTo(Flurorouter.loginRoute);
    NotificationsService.showSnackbar(
        'Las instrucciones para la confirmación de cuenta han sido enviadas al email $email');
    showLoader = false;
    notifyListeners();
  }

  //----------------------------------------------------------------
  changePassword(
    String oldpassword,
    String newpassword,
    String confirmpassword,
  ) async {
    showLoader = true;
    notifyListeners();

    final data = {
      'OldPassword': oldpassword,
      'NewPassword': newpassword,
      'Confirm': confirmpassword,
    };

    Response response = await ApiHelper.post('/Account/ChangePassword', data);

    if (!response.isSuccess) {
      NotificationsService.showSnackbarError('Error al cambiar la Contraseña');
      showLoader = false;
      notifyListeners();
      return;
    }

    NavigationServices.replaceTo(Flurorouter.loginRoute);
    NotificationsService.showSnackbar('Contraseña cambiada con éxito!!');
    showLoader = false;
    notifyListeners();
  }
}

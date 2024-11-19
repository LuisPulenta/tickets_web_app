import 'package:flutter/material.dart';
import 'package:tickets_web_app/router/router.dart';
import 'package:tickets_web_app/services/local_storage.dart';
import 'package:tickets_web_app/services/navigation_services.dart';

enum AuthStatus {
  checking,
  authenticated,
  notAuthenticated,
}

class AuthProvider extends ChangeNotifier {
  String? _token;
  AuthStatus authStatus = AuthStatus.checking;

  AuthProvider() {
    isAuthenticated();
  }

  //----------------------------------------------------------------
  login(String email, String password) {
    //TODO: Petición HTTP
    _token = 'abcdefgh12345678';
    LocalStorage.prefs.setString('token', _token!);
    NavigationServices.replaceTo(Flurorouter.dashboardRoute);
    //print(LocalStorage.prefs.getString('token'));

    //TODO: Navegar al Dashboard
    authStatus = AuthStatus.authenticated;
    notifyListeners();
  }

  //----------------------------------------------------------------
  Future<bool> isAuthenticated() async {
    final token = LocalStorage.prefs.getString('token');

    if (token == null) {
      authStatus = AuthStatus.notAuthenticated;
      notifyListeners();
      return false;
    }

    //TODO: ir al backend y comprobar si el JWT es válido

    await Future.delayed(const Duration(milliseconds: 1000));
    authStatus = AuthStatus.authenticated;
    notifyListeners();
    return true;
  }

  //---------------------------------------------------------------
  logout() {
    LocalStorage.prefs.remove('token');
    authStatus = AuthStatus.notAuthenticated;
    notifyListeners();
  }
}

import 'package:flutter/material.dart';
import 'package:tickets_web_app/helpers/api_helper.dart';
import 'package:tickets_web_app/models/models.dart';
import 'package:tickets_web_app/services/notifications_service.dart';

class UsersProvider extends ChangeNotifier {
  List<User> users = [];

  //---------------------------------------------------------------------
  getUsers(Token token) async {
    Response response = await ApiHelper.getUsers(token);

    if (!response.isSuccess) {
      NotificationsService.showSnackbarError('Se ha producido un error');
      return;
    }
    users = response.result;
    notifyListeners();
  }

  //---------------------------------------------------------------------
  Future newUser(String name, Token token) async {
    Map<String, dynamic> request = {
      'name': name,
    };

    try {
      Response response = await ApiHelper.post('/account', request, token);

      //final newCompany = Company.fromJson(response.result);

      getUsers(token);
      // companies.add(newCompany);
      // notifyListeners();
    } catch (e) {
      NotificationsService.showSnackbarError(
          'Se ha producido un error al crear la Empresa');
    }
  }
}

import 'package:flutter/material.dart';
import 'package:tickets_web_app/helpers/api_helper.dart';
import 'package:tickets_web_app/models/models.dart';
import 'package:tickets_web_app/services/notifications_service.dart';

class UsersProvider extends ChangeNotifier {
  List<User> users = [];

  //---------------------------------------------------------------------
  getUsers() async {
    Response response = await ApiHelper.getUsers();

    if (!response.isSuccess) {
      NotificationsService.showSnackbarError('Se ha producido un error');
      return;
    }
    users = response.result;
    notifyListeners();
  }

  //---------------------------------------------------------------------
  Future newUser(
      String firstName,
      String lastName,
      String email,
      String phoneNumber,
      int companyId,
      int idUserType,
      Token token,
      String userLogged) async {
    Map<String, dynamic> request = {
      'Email': email,
      'FirstName': firstName,
      'LastName': lastName,
      'PhoneNumber': phoneNumber,
      'IdCompany': companyId,
      'Company': '',
      'IdUserType': idUserType,
      'UserType': idUserType == 0 ? 'Admin' : 'User',
      'CreateUser': userLogged,
      'LastChangeUser': userLogged,
      'Active': true,
      'Password': '123456',
    };

    try {
      Response response = await ApiHelper.post('/account/createuser', request);

      if (!response.isSuccess) {
        NotificationsService.showSnackbarError(
            'Se ha producido un error al crear el Usuario');
        return;
      }

      NotificationsService.showSnackbar(
          "Se ha enviado un correo con las instrucciones para activar el usuario.");

      getUsers();
      notifyListeners();
    } catch (e) {
      NotificationsService.showSnackbarError(
          'Se ha producido un error al crear el Usuario');
    }
  }

  //---------------------------------------------------------------------
  Future updateUser(
      String id,
      String firstName,
      String lastName,
      String email,
      String phoneNumber,
      int companyId,
      int idUserType,
      String userLogged,
      bool active) async {
    Map<String, dynamic> request = {
      'Id': id,
      'Email': email,
      'FirstName': firstName,
      'LastName': lastName,
      'PhoneNumber': phoneNumber,
      'IdCompany': companyId,
      'Company': '',
      'IdUserType': idUserType,
      'UserType': idUserType == 0 ? 'Admin' : 'User',
      'CreateUser': userLogged,
      'LastChangeUser': userLogged,
      'Active': active,
    };

    try {
      Response response = await ApiHelper.put('/account', id, request);
      if (response.isSuccess) {
        getUsers();
        NotificationsService.showSnackbar("Cambios guardados con éxito");
      }
    } catch (e) {
      NotificationsService.showSnackbarError(
          'Se ha producido un error al guardar los cambios');
    }
  }
}

import 'package:flutter/material.dart';

import '../helpers/api_helper.dart';
import '../models/models.dart';
import '../services/notifications_service.dart';

class UsersProvider extends ChangeNotifier {
  List<User> users = [];
  List<User> originalUsers = [];
  bool ascending = true;
  int? sortColumnIndex;
  bool showLoader = false;
  String search = '';
  bool onlyActives = false;

  //---------------------------------------------------------------
  void sort<T>(Comparable<T> Function(User user) getField) {
    users.sort((a, b) {
      final aValue = getField(a);
      final bValue = getField(b);
      return ascending
          ? Comparable.compare(aValue, bValue)
          : Comparable.compare(bValue, aValue);
    });
    ascending = !ascending;
    notifyListeners();
  }

  //---------------------------------------------------------------------
  getUsers() async {
    showLoader = true;
    notifyListeners();
    Response response = await ApiHelper.getUsers();

    if (!response.isSuccess) {
      NotificationsService.showSnackbarError('Se ha producido un error');
      showLoader = false;
      notifyListeners();
      return;
    }
    users = response.result;
    originalUsers = users;
    showLoader = false;
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
      String userLoggedId) async {
    showLoader = true;
    notifyListeners();
    Map<String, dynamic> request = {
      'Email': email,
      'FirstName': firstName,
      'LastName': lastName,
      'PhoneNumber': phoneNumber,
      'IdCompany': companyId,
      'IdUserType': idUserType,
      'CreateUserId': userLoggedId,
      'LastChangeUserId': userLoggedId,
      'Active': true,
      'Password': '123456',
    };

    try {
      Response response = await ApiHelper.post('/account/createuser', request);

      if (!response.isSuccess) {
        NotificationsService.showSnackbarError(
            'Se ha producido un error al crear el Usuario');
        showLoader = false;
        notifyListeners();
        return;
      }
      showLoader = false;
      notifyListeners();
      NotificationsService.showSnackbar(
          'Se ha enviado un correo con las instrucciones para activar el usuario.');

      getUsers();
      notifyListeners();
    } catch (e) {
      NotificationsService.showSnackbarError(
          'Se ha producido un error al crear el Usuario');
      showLoader = false;
      notifyListeners();
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
    String userLoggedId,
    bool active,
    bool isResolver,
    String emailLogged,
  ) async {
    showLoader = true;
    notifyListeners();
    if (email == emailLogged && !active) {
      NotificationsService.showSnackbarError(
          'No puede desactivarse a sí mismo');
      notifyListeners();
      showLoader = false;
      notifyListeners();
      return;
    }

    Map<String, dynamic> request = {
      'Id': id,
      'Email': email,
      'FirstName': firstName,
      'LastName': lastName,
      'PhoneNumber': phoneNumber,
      'IdCompany': companyId,
      'IdUserType': idUserType,
      'CreateUserId': '',
      'LastChangeUserId': userLoggedId,
      'Active': active,
      'IsResolver': isResolver ? 1 : 0,
    };

    try {
      Response response = await ApiHelper.put('/account', id, request);
      if (response.isSuccess) {
        getUsers();
        showLoader = false;
        notifyListeners();
        NotificationsService.showSnackbar('Cambios guardados con éxito');
      }
    } catch (e) {
      showLoader = false;
      notifyListeners();
      NotificationsService.showSnackbarError(
          'Se ha producido un error al guardar los cambios');
    }
  }

  //--------------------------------------------------------------------
  void filter() {
    users = originalUsers;

    List<User> filteredList = [];
    if (!onlyActives) {
      for (var user in users) {
        if (user.firstName.toLowerCase().contains(search.toLowerCase()) ||
            user.lastName.toLowerCase().contains(search.toLowerCase()) ||
            user.companyName.toLowerCase().contains(search.toLowerCase())) {
          filteredList.add(user);
        }
      }
    } else {
      for (var user in users) {
        if ((user.firstName.toLowerCase().contains(search.toLowerCase()) ||
                user.lastName.toLowerCase().contains(search.toLowerCase()) ||
                user.companyName
                    .toLowerCase()
                    .contains(search.toLowerCase())) &&
            user.active) {
          filteredList.add(user);
        }
      }
    }

    users = filteredList;
    notifyListeners();
  }

  //--------------------------------------------------------------------
  Future deleteUser(
    String id,
    String LoggedId,
  ) async {
    if (id == LoggedId) {
      NotificationsService.showSnackbarError('No puede borrarse a sí mismo');
      return;
    }

    try {
      showLoader = true;
      notifyListeners();
      Response response = await ApiHelper.deleteUser(id);

      if (!response.isSuccess) {
        NotificationsService.showSnackbarError('No se pudo borrar el Usuario');
        showLoader = false;
        notifyListeners();
        return;
      }
      getUsers();
      NotificationsService.showSnackbar('Usuario borrado con éxito');
    } catch (e) {
      throw ('Error al borrar el Usuario');
    }
    showLoader = false;
    notifyListeners();
  }

  //--------------------------------------------------------------------
  void notify() {
    showLoader = false;
    notifyListeners();
  }
}

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:tickets_web_app/helpers/api_helper.dart';
import 'package:tickets_web_app/models/http/company.dart';
import 'package:tickets_web_app/models/http/response.dart';
import 'package:tickets_web_app/models/http/token.dart';
import 'package:tickets_web_app/services/notifications_service.dart';

class CompaniesProvider extends ChangeNotifier {
  List<Company> companies = [];

  //---------------------------------------------------------------------
  getCompanies(Token token) async {
    Response response = await ApiHelper.getCompanies(token);

    if (!response.isSuccess) {
      NotificationsService.showSnackbarError('Se ha producido un error');
      return;
    }
    companies = response.result;

    companies.sort((a, b) {
      return a.name
          .toString()
          .toLowerCase()
          .compareTo(b.name.toString().toLowerCase());
    });

    notifyListeners();
  }

  //---------------------------------------------------------------------
  Future newCompany(String name, Token token, String userLogged) async {
    Map<String, dynamic> request = {
      'Name': name,
      'CreateUser': userLogged,
      'LastChangeUser': userLogged,
      'Photo': null
    };

    try {
      Response response = await ApiHelper.post('/companies', request, token);
      if (response.isSuccess) {
        getCompanies(token);
        NotificationsService.showSnackbar("Empresa guardada con éxito");
      } else {
        NotificationsService.showSnackbarError('$name ya existe!!');
      }
    } catch (e) {
      NotificationsService.showSnackbarError(
          'Se ha producido un error al crear la Empresa');
    }
  }
}

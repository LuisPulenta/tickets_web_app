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
    notifyListeners();
  }

  //---------------------------------------------------------------------
  Future newCompany(String name, Token token) async {
    Map<String, dynamic> request = {
      'name': name,
    };

    try {
      Response response = await ApiHelper.post('/companies', request, token);

      //final newCompany = Company.fromJson(response.result);

      getCompanies(token);
      // companies.add(newCompany);
      // notifyListeners();
    } catch (e) {
      NotificationsService.showSnackbarError(
          'Se ha producido un error al crear la Empresa');
    }
  }
}

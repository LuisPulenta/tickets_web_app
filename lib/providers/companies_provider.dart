import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../helpers/api_helper.dart';
import '../models/models.dart';
import '../services/notifications_service.dart';

class CompaniesProvider extends ChangeNotifier {
  List<Company> companies = [];
  List<Company> originalCompanies = [];
  bool ascending = true;
  int? sortColumnIndex;
  bool showLoader = false;
  String search = '';
  bool onlyActives = false;

  //---------------------------------------------------------------
  void sort<T>(Comparable<T> Function(Company user) getField) {
    companies.sort((a, b) {
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
  getCompanies() async {
    showLoader = true;
    notifyListeners();

    Response response = await ApiHelper.getCompanies();

    if (!response.isSuccess) {
      NotificationsService.showSnackbarError('Se ha producido un error');
      showLoader = false;
      notifyListeners();
      return;
    }
    companies = response.result;

    companies.sort((a, b) {
      return a.name
          .toString()
          .toLowerCase()
          .compareTo(b.name.toString().toLowerCase());
    });

    originalCompanies = companies;

    showLoader = false;
    notifyListeners();
  }

  //---------------------------------------------------------------------
  Future newCompany(
      String name, String base64Image, Token token, String userLoggedId) async {
    showLoader = true;
    notifyListeners();

    Map<String, dynamic> request = {
      'Name': name,
      'CreateUserId': userLoggedId,
      'LastChangeUserId': userLoggedId,
      'ImageArray': base64Image != '' ? base64Image : null
    };

    try {
      Response response = await ApiHelper.post('/companies', request);
      if (response.isSuccess) {
        getCompanies();
        NotificationsService.showSnackbar('Empresa guardada con éxito');
      } else {
        NotificationsService.showSnackbarError('$name ya existe!!');
      }
    } catch (e) {
      NotificationsService.showSnackbarError(
          'Se ha producido un error al crear la Empresa');
    }
    showLoader = false;
    notifyListeners();
  }

  //---------------------------------------------------------------------
  Future updateCompany(int id, String name, String base64Image, Token token,
      String userLoggedId, bool active) async {
    showLoader = true;
    notifyListeners();

    Map<String, dynamic> request = {
      'Id': id,
      'Name': name,
      'LastChangeUserId': userLoggedId,
      'Active': active,
      'ImageArray': base64Image != '' ? base64Image : null
    };

    try {
      Response response =
          await ApiHelper.put('/companies', id.toString(), request);
      if (response.isSuccess) {
        getCompanies();
        NotificationsService.showSnackbar('Cambios guardados con éxito');
      } else {
        NotificationsService.showSnackbarError('$name ya existe!!');
      }
    } catch (e) {
      NotificationsService.showSnackbarError(
          'Se ha producido un error al guardar los cambios');
    }

    showLoader = false;
    notifyListeners();
  }

  //--------------------------------------------------------------------
  Future deleteCompany(String id) async {
    try {
      showLoader = true;
      notifyListeners();
      Response response = await ApiHelper.delete('/companies', id);

      if (!response.isSuccess) {
        NotificationsService.showSnackbarError('No se puedo borrar la Empresa');
        showLoader = false;
        notifyListeners();
        return;
      }
      getCompanies();
      NotificationsService.showSnackbar('Empresa borrada con éxito');
    } catch (e) {
      throw ('Error al borrar la Categoría');
    }
    showLoader = false;
    notifyListeners();
  }

  //--------------------------------------------------------------------
  void filter() {
    companies = originalCompanies;

    List<Company> filteredList = [];
    if (!onlyActives) {
      for (var company in companies) {
        if (company.name.toLowerCase().contains(search.toLowerCase())) {
          filteredList.add(company);
        }
      }
    } else {
      for (var company in companies) {
        if ((company.name.toLowerCase().contains(search.toLowerCase())) &&
            company.active) {
          filteredList.add(company);
        }
      }
    }

    companies = filteredList;
    notifyListeners();
  }

  //--------------------------------------------------------------------
  void notify() {
    showLoader = false;
    notifyListeners();
  }
}

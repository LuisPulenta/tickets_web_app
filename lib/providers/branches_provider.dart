import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../helpers/api_helper.dart';
import '../models/models.dart';
import '../services/notifications_service.dart';

class BranchesProvider extends ChangeNotifier {
  List<Branch> branches = [];
  List<Branch> originalBranches = [];
  bool ascending = true;
  int? sortColumnIndex;
  bool showLoader = false;
  String search = '';
  bool onlyActives = false;

  //---------------------------------------------------------------
  void sort<T>(Comparable<T> Function(Branch branch) getField) {
    branches.sort((a, b) {
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
  getBranches() async {
    showLoader = true;
    notifyListeners();

    Response response = await ApiHelper.getBranches();

    if (!response.isSuccess) {
      NotificationsService.showSnackbarError('Se ha producido un error');
      showLoader = false;
      notifyListeners();
      return;
    }
    branches = response.result;

    branches.sort((a, b) {
      return a.name
          .toString()
          .toLowerCase()
          .compareTo(b.name.toString().toLowerCase());
    });

    originalBranches = branches;

    showLoader = false;
    notifyListeners();
  }

  //---------------------------------------------------------------------
  Future newBranch(
      String name, Token token, String userLoggedId, int userCompanyId) async {
    showLoader = true;
    notifyListeners();

    Map<String, dynamic> request = {
      'Name': name,
      'CreateUserId': userLoggedId,
      'LastChangeUserId': userLoggedId,
      'CompanyId': userCompanyId,
    };

    try {
      Response response = await ApiHelper.post('/branches', request);
      if (response.isSuccess) {
        getBranches();
        NotificationsService.showSnackbar('Sucursal guardada con éxito');
      } else {
        NotificationsService.showSnackbarError('$name ya existe!!');
      }
    } catch (e) {
      NotificationsService.showSnackbarError(
          'Se ha producido un error al crear la Sucursal');
    }
    showLoader = false;
    notifyListeners();
  }

  //---------------------------------------------------------------------
  Future updateBranch(int id, String name, Token token, String userLoggedId,
      bool active) async {
    showLoader = true;
    notifyListeners();

    Map<String, dynamic> request = {
      'Id': id,
      'Name': name,
      'LastChangeUserId': userLoggedId,
      'Active': active,
    };

    try {
      Response response =
          await ApiHelper.put('/branches', id.toString(), request);
      if (response.isSuccess) {
        getBranches();
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
  Future deleteBranch(String id) async {
    try {
      showLoader = true;
      notifyListeners();
      Response response = await ApiHelper.delete('/branches', id);

      if (!response.isSuccess) {
        NotificationsService.showSnackbarError(
            'No se puedo borrar la Sucursal');
        showLoader = false;
        notifyListeners();
        return;
      }
      getBranches();
      NotificationsService.showSnackbar('Sucursal borrada con éxito');
    } catch (e) {
      throw ('Error al borrar la Sucursal');
    }
    showLoader = false;
    notifyListeners();
  }

  //--------------------------------------------------------------------
  void filter() {
    branches = originalBranches;

    List<Branch> filteredList = [];
    if (!onlyActives) {
      for (var branch in branches) {
        if (branch.name.toLowerCase().contains(search.toLowerCase())) {
          filteredList.add(branch);
        }
      }
    } else {
      for (var branch in branches) {
        if ((branch.name.toLowerCase().contains(search.toLowerCase())) &&
            branch.active) {
          filteredList.add(branch);
        }
      }
    }

    branches = filteredList;
    notifyListeners();
  }

  //--------------------------------------------------------------------
  void notify() {
    showLoader = false;
    notifyListeners();
  }
}

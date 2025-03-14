import 'package:flutter/material.dart';
import 'package:tickets_web_app/helpers/api_helper.dart';
import 'package:tickets_web_app/models/models.dart';
import 'package:tickets_web_app/services/notifications_service.dart';

class SubcategoriesProvider extends ChangeNotifier {
  Category? category;
  List<Subcategory> subcategories = [];
  List<Subcategory> originalSubcategories = [];
  bool ascending = true;
  int? sortColumnIndex;
  bool showLoader = false;
  String search = '';

  //---------------------------------------------------------------
  void sort<T>(Comparable<T> Function(Subcategory subcategory) getField) {
    subcategories.sort((a, b) {
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
  getSubcategories(String categoryId) async {
    showLoader = true;
    notifyListeners();

    Response response = await ApiHelper.getSubcategories(categoryId.toString());

    if (!response.isSuccess) {
      NotificationsService.showSnackbarError('Se ha producido un error');
      showLoader = false;
      notifyListeners();
      return;
    }
    subcategories = response.result;

    subcategories.sort((a, b) {
      return a.name
          .toString()
          .toLowerCase()
          .compareTo(b.name.toString().toLowerCase());
    });

    originalSubcategories = subcategories;

    showLoader = false;
    notifyListeners();
  }

  //---------------------------------------------------------------------
  Future newSubcategory(
      String name, String categoryId, String categoryName) async {
    showLoader = true;
    notifyListeners();

    Map<String, dynamic> request = {
      'Id': 0,
      'Name': name,
      'CategoryId': categoryId,
      'CategoryName': categoryName,
    };

    try {
      Response response = await ApiHelper.post('/subcategories', request);
      if (response.isSuccess) {
        getSubcategories(categoryId);
        NotificationsService.showSnackbar("Subcategoría guardada con éxito");
      } else {
        NotificationsService.showSnackbarError('$name ya existe!!');
      }
    } catch (e) {
      NotificationsService.showSnackbarError(
          'Se ha producido un error al crear la Subcategoría');
    }
    showLoader = false;
    notifyListeners();
  }

  //---------------------------------------------------------------------
  Future updateSubcategory(
      int id, String name, String categoryId, String categoryName) async {
    showLoader = true;
    notifyListeners();

    Map<String, dynamic> request = {
      'Id': id,
      'CategoryId': categoryId,
      'CategoryName': categoryName,
      'Name': name,
    };

    try {
      Response response =
          await ApiHelper.put('/subcategories', id.toString(), request);
      if (response.isSuccess) {
        getSubcategories(categoryId);
        NotificationsService.showSnackbar("Cambios guardados con éxito");
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
  Future deleteSubcategory(String id, String categoryId) async {
    try {
      showLoader = true;
      notifyListeners();
      Response response = await ApiHelper.delete('/subcategories', id);

      if (!response.isSuccess) {
        NotificationsService.showSnackbarError(
            'No se puedo borrar la Subcategoría');
        showLoader = false;
        notifyListeners();
        return;
      }
      getSubcategories(categoryId);
      NotificationsService.showSnackbar("Subcategoría borrada con éxito");
    } catch (e) {
      throw ('Error al borrar la Subcategoría');
    }
    showLoader = false;
    notifyListeners();
  }

  //--------------------------------------------------------------------
  void filter() {
    subcategories = originalSubcategories;

    List<Subcategory> filteredList = [];

    for (var subcategory in subcategories) {
      if (subcategory.name.toLowerCase().contains(search.toLowerCase())) {
        filteredList.add(subcategory);
      }

      subcategories = filteredList;
      notifyListeners();
    }
  }

  //--------------------------------------------------------------------
  void refresh() {
    notifyListeners();
  }
}

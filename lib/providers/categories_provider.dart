import 'package:flutter/material.dart';
import 'package:tickets_web_app/helpers/api_helper.dart';
import 'package:tickets_web_app/models/models.dart';
import 'package:tickets_web_app/services/notifications_service.dart';

class CategoriesProvider extends ChangeNotifier {
  List<Category> categories = [];
  List<Category> originalCategories = [];
  bool ascending = true;
  int? sortColumnIndex;
  bool showLoader = false;
  String search = '';

  //---------------------------------------------------------------
  void sort<T>(Comparable<T> Function(Category category) getField) {
    categories.sort((a, b) {
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
  getCategories() async {
    showLoader = true;
    notifyListeners();

    Response response = await ApiHelper.getCategories();

    if (!response.isSuccess) {
      NotificationsService.showSnackbarError('Se ha producido un error');
      showLoader = false;
      notifyListeners();
      return;
    }
    categories = response.result;

    categories.sort((a, b) {
      return a.name
          .toString()
          .toLowerCase()
          .compareTo(b.name.toString().toLowerCase());
    });

    originalCategories = categories;

    showLoader = false;
    notifyListeners();
  }

  //---------------------------------------------------------------------
  Future newCategory(String name) async {
    showLoader = true;
    notifyListeners();

    Map<String, dynamic> request = {
      'Name': name,
    };

    try {
      Response response = await ApiHelper.post('/categories', request);
      if (response.isSuccess) {
        getCategories();
        NotificationsService.showSnackbar("Categoría guardada con éxito");
      } else {
        NotificationsService.showSnackbarError('$name ya existe!!');
      }
    } catch (e) {
      NotificationsService.showSnackbarError(
          'Se ha producido un error al crear la Categoría');
    }
    showLoader = false;
    notifyListeners();
  }

  //---------------------------------------------------------------------
  Future updateCategory(int id, String name) async {
    showLoader = true;
    notifyListeners();

    Map<String, dynamic> request = {
      'Id': id,
      'Name': name,
    };

    try {
      Response response =
          await ApiHelper.put('/categories', id.toString(), request);
      if (response.isSuccess) {
        getCategories();
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
  Future deleteCategory(String id) async {
    try {
      showLoader = true;
      notifyListeners();
      Response response = await ApiHelper.delete('/categories', id);

      if (!response.isSuccess) {
        NotificationsService.showSnackbarError(
            'No se puedo borrar la Categoría');
        showLoader = false;
        notifyListeners();
        return;
      }
      getCategories();
      NotificationsService.showSnackbar("Categoría borrada con éxito");
    } catch (e) {
      throw ('Error al borrar la Categoría');
    }
    showLoader = false;
    notifyListeners();
  }

  //--------------------------------------------------------------------
  void filter() {
    categories = originalCategories;

    List<Category> filteredList = [];

    for (var category in categories) {
      if (category.name.toLowerCase().contains(search.toLowerCase())) {
        filteredList.add(category);
      }

      categories = filteredList;
      notifyListeners();
    }
  }

  //--------------------------------------------------------------------
  Future<Category> getCategoryById(String id) async {
    try {
      Response response = await ApiHelper.getCategory(id);

      Category category = response.result;

      return category;
    } catch (e) {
      throw e;
    }
  }
}

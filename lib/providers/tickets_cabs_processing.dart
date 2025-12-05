import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../helpers/api_helper.dart';
import '../helpers/constants.dart';
import '../models/models.dart';
import '../services/services.dart';

class TicketCabsProcessingProvider extends ChangeNotifier {
  List<TicketCab> ticketCabsProcessing = [];
  List<TicketCab> originalTicketCabsProcessing = [];
  bool ascending = true;
  int? sortColumnIndex;
  bool showLoader = false;
  String search = '';

  //---------------------------------------------------------------
  void sort<T>(Comparable<T> Function(TicketCab ticketCab) getField) {
    ticketCabsProcessing.sort((a, b) {
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
  getTicketProcessingCabs(
    String userIdLogged,
  ) async {
    showLoader = true;
    notifyListeners();

    Response response = await ApiHelper.getTicketCabProcessing();

    if (!response.isSuccess) {
      NotificationsService.showSnackbarError('Se ha producido un error');
      showLoader = false;
      notifyListeners();
      return;
    }
    ticketCabsProcessing = response.result;

    ticketCabsProcessing.sort((a, b) {
      return a.id.compareTo(b.id);
    });

    originalTicketCabsProcessing = ticketCabsProcessing;

    showLoader = false;
    notifyListeners();
  }

  //--------------------------------------------------------------------
  void filter() {
    ticketCabsProcessing = originalTicketCabsProcessing;

    List<TicketCab> filteredList = [];

    for (var ticketCab in ticketCabsProcessing) {
      if ((ticketCab.companyName
              .toLowerCase()
              .contains(search.toLowerCase())) ||
          (Constants.estados[ticketCab.ticketState]
              .toLowerCase()
              .contains(search.toLowerCase())) ||
          (ticketCab.createUserName
              .toLowerCase()
              .contains(search.toLowerCase())) ||
          (ticketCab.categoryName
              .toLowerCase()
              .contains(search.toLowerCase())) ||
          (ticketCab.subcategoryName
              .toLowerCase()
              .contains(search.toLowerCase())) ||
          (ticketCab.title.toLowerCase().contains(search.toLowerCase()))) {
        filteredList.add(ticketCab);
      }
    }

    ticketCabsProcessing = filteredList;
    notifyListeners();
  }

  //--------------------------------------------------------------------
  Future<TicketCab> getTicketCabById(String id) async {
    try {
      Response response = await ApiHelper.getTicketCab(id);

      TicketCab ticketCab = response.result;

      return ticketCab;
    } catch (e) {
      rethrow;
    }
  }

  //--------------------------------------------------------------------
  void notify() {
    showLoader = false;
    notifyListeners();
  }
}

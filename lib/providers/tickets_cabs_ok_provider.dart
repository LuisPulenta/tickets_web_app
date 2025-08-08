import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../helpers/api_helper.dart';
import '../helpers/constants.dart';
import '../models/models.dart';
import '../services/services.dart';

class TicketCabsOkProvider extends ChangeNotifier {
  List<TicketCab> ticketCabsOk = [];
  List<TicketCab> originalTicketCabsDerivated = [];
  bool ascending = true;
  int? sortColumnIndex;
  bool showLoader = false;
  String search = '';

  //---------------------------------------------------------------
  void sort<T>(Comparable<T> Function(TicketCab ticketCab) getField) {
    ticketCabsOk.sort((a, b) {
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
  getTicketOkCabs(int userTypeLogged, String userIdLogged, int companyIdLogged,
      DateTime desde, DateTime hasta) async {
    showLoader = true;
    notifyListeners();

    Map<String, dynamic> request = {
      'UserType': userTypeLogged,
      'UserId': userIdLogged,
      'CompanyId': companyIdLogged,
      'Desde': desde.toString().substring(0, 10),
      'Hasta': hasta.toString().substring(0, 10),
    };

    Response response = await ApiHelper.getTicketsResueltos(
        '/ticketCabs/GetTicketResueltos', request);

    if (!response.isSuccess) {
      NotificationsService.showSnackbarError('Se ha producido un error');
      showLoader = false;
      notifyListeners();
      return;
    }
    ticketCabsOk = response.result;

    ticketCabsOk.sort((a, b) {
      return a.id.compareTo(b.id);
    });

    originalTicketCabsDerivated = ticketCabsOk;

    showLoader = false;
    notifyListeners();
  }

  //--------------------------------------------------------------------
  void filter() {
    ticketCabsOk = originalTicketCabsDerivated;

    List<TicketCab> filteredList = [];

    for (var ticketCab in ticketCabsOk) {
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

    ticketCabsOk = filteredList;
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

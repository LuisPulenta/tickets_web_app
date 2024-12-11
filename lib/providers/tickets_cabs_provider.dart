import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:tickets_web_app/helpers/api_helper.dart';
import 'package:tickets_web_app/models/models.dart';
import 'package:tickets_web_app/services/notifications_service.dart';
import 'package:tickets_web_app/services/services.dart';

class TicketCabsProvider extends ChangeNotifier {
  List<TicketCab> ticketCabs = [];
  List<TicketCab> originalTicketCabs = [];
  bool ascending = true;
  int? sortColumnIndex;
  bool showLoader = false;
  String search = '';

  //---------------------------------------------------------------
  void sort<T>(Comparable<T> Function(TicketCab ticketCab) getField) {
    ticketCabs.sort((a, b) {
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
  getTicketCabs() async {
    showLoader = true;
    notifyListeners();

    Response response = await ApiHelper.getTicketCabs();

    if (!response.isSuccess) {
      NotificationsService.showSnackbarError('Se ha producido un error');
      showLoader = false;
      notifyListeners();
      return;
    }
    ticketCabs = response.result;

    ticketCabs.sort((a, b) {
      return a.id.compareTo(b.id);
    });

    originalTicketCabs = ticketCabs;

    showLoader = false;
    notifyListeners();
  }

  //---------------------------------------------------------------------
  Future newTicketCab(TicketCab ticketCab, String userLogged,
      String companyLogged, String description, String base64Image) async {
    showLoader = true;
    notifyListeners();

    final userBody = LocalStorage.prefs.getString('userBody');
    var decodedJson = jsonDecode(userBody!);
    Token token = Token.fromJson(decodedJson);
    User userLogged = token.user;

    Map<String, dynamic> request = {
      'UserId': userLogged.id,
      'UserName': userLogged.fullName,
      'CompanyId': userLogged.companyId,
      'CompanyName': userLogged.companyName,
      'Title': ticketCab.title,
    };

    try {
      Response response =
          await ApiHelper.postTicketCab('/ticketCabs/PostTicketCab', request);
      if (response.isSuccess) {
        int nroTicket = response.result;

        Map<String, dynamic> request2 = {
          'TicketCabId': nroTicket,
          'Description': description,
          'TicketState': 0,
          'StateUserId': userLogged.id,
          'StateUserName': userLogged.fullName,
          'ImageArray': base64Image != '' ? base64Image : null,
        };

        try {
          Response response2 = await ApiHelper.postTicketDet(
              '/ticketCabs/PostTicketDet', request2);
          if (response2.isSuccess) {
            await getTicketCabs();
            NotificationsService.showSnackbar("Ticket guardado con éxito");
          }
        } catch (e) {}
      } else {
        NotificationsService.showSnackbarError(
            'Hubo un error al guardar el Ticket');
      }
    } catch (e) {
      NotificationsService.showSnackbarError(
          'Hubo un error al guardar el Ticket');
    }
    showLoader = false;
    notifyListeners();
  }

  //---------------------------------------------------------------------
  Future updateTicketCab(TicketCab ticketCab, String userLogged) async {
    showLoader = true;
    notifyListeners();

    Map<String, dynamic> request = {
      'Id': ticketCab.id,
      'Name': ticketCab.companyName,
      'LastChangeUser': userLogged,
    };

    try {
      Response response =
          await ApiHelper.put('/ticketCabs', ticketCab.id.toString(), request);
      if (response.isSuccess) {
        getTicketCabs();
        NotificationsService.showSnackbar("Cambios guardados con éxito");
      } else {
        NotificationsService.showSnackbarError(
            'Hubo un error al guardar el Ticket');
      }
    } catch (e) {
      NotificationsService.showSnackbarError(
          'Se ha producido un error al guardar los cambios');
    }

    showLoader = false;
    notifyListeners();
  }

  //--------------------------------------------------------------------
  Future deleteTicketCab(String id) async {
    try {
      showLoader = true;
      notifyListeners();
      Response response = await ApiHelper.delete('/ticketCabs', id);

      if (!response.isSuccess) {
        NotificationsService.showSnackbarError('No se pudo borrar el Ticket');
        showLoader = false;
        notifyListeners();
        return;
      }
      getTicketCabs();
      NotificationsService.showSnackbar("Ticket borrado con éxito");
    } catch (e) {
      throw ('Error al borrar el Ticket');
    }
    showLoader = false;
    notifyListeners();
  }

  //--------------------------------------------------------------------
  void filter() {
    ticketCabs = originalTicketCabs;

    List<TicketCab> filteredList = [];

    for (var ticketCab in ticketCabs) {
      if (ticketCab.companyName.toLowerCase().contains(search.toLowerCase())) {
        filteredList.add(ticketCab);
      }
    }

    ticketCabs = filteredList;
    notifyListeners();
  }
}

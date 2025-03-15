import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:tickets_web_app/helpers/api_helper.dart';
import 'package:tickets_web_app/helpers/constants.dart';
import 'package:tickets_web_app/models/models.dart';
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

    final userBody = LocalStorage.prefs.getString('userBody');
    var decodedJson = jsonDecode(userBody!);
    Token token = Token.fromJson(decodedJson);
    int userTypeLogged = token.user.userTypeId;
    String userIdLogged = token.user.id;
    int companyIdLogged = token.user.companyId;

    Response response = Response(isSuccess: false);

    if (userTypeLogged == 2) {
      response = await ApiHelper.getTicketUser(userIdLogged);
    }
    if (userTypeLogged == 1) {
      response = await ApiHelper.getTicketAdmin(companyIdLogged);
    }
    if (userTypeLogged == 0) {
      response = await ApiHelper.getTicketAdminKP();
    }

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
    ticketCabs = response.result;

    ticketCabs.sort((a, b) {
      return a.id.compareTo(b.id);
    });

    originalTicketCabs = ticketCabs;

    showLoader = false;
    notifyListeners();
  }

  //---------------------------------------------------------------------
  getTicketDerivatedCabs(
    String userIdLogged,
  ) async {
    showLoader = true;
    notifyListeners();

    Response response = await ApiHelper.getTicketCabParaResolver(userIdLogged);

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
  Future newTicketCab(
      TicketCab ticketCab,
      String userLogged,
      String companyLogged,
      String description,
      String base64Image,
      String fileName,
      String fileExtension) async {
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
      'CategoryId': ticketCab.categoryId,
      'CategoryName': ticketCab.categoryName,
      'SubcategoryId': ticketCab.subcategoryId,
      'SubcategoryName': ticketCab.subcategoryName,
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
          'FileName': base64Image != '' ? fileName : null,
          'FileExtension': base64Image != '' ? fileExtension : null,
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
  Future newTicketDet(
    TicketCab ticketCab,
    String userLogged,
    String companyLogged,
    String description,
    String base64Image,
    int estado,
    String userAsign,
    String userAsignName,
  ) async {
    showLoader = true;
    notifyListeners();

    final userBody = LocalStorage.prefs.getString('userBody');
    var decodedJson = jsonDecode(userBody!);
    Token token = Token.fromJson(decodedJson);
    User userLogged = token.user;
    String ahora = DateTime.now().toString().substring(0, 10);

    Map<String, dynamic> request2 = {
      'TicketCabId': ticketCab.id,
      'Description': description,
      'TicketState': estado,
      'StateUserId': userLogged.id,
      'StateUserName': userLogged.fullName,
      'ImageArray': base64Image != '' ? base64Image : null,
    };

    try {
      Response response2 =
          await ApiHelper.postTicketDet('/ticketCabs/PostTicketDet', request2);
      if (response2.isSuccess) {
        //---------- Actualiza TicketCab ----------
        Map<String, dynamic> request = {
          'Id': ticketCab.id,
          'UserId': ticketCab.createUserId,
          'UserName': ticketCab.createUserName,
          'CompanyId': ticketCab.companyId,
          'CompanyName': ticketCab.companyName,
          'Title': ticketCab.title,
          'TicketState': estado,
          'UserAsign': estado == 5 ? userAsign : '',
          'UserAsignName': estado == 5 ? userAsignName : '',
          'AsignDate': (estado == 2)
              ? ahora
              : (estado == 3 || estado == 4 || estado == 5)
                  ? ticketCab.asignDate
                  : null,
          'InProgressDate': (estado == 3 || estado == 5)
              ? ahora
              : (estado == 4)
                  ? ticketCab.asignDate
                  : null,
          'FinishDate': estado == 4 ? ahora : null,
        };

        Response response = await ApiHelper.put(
            '/ticketCabs', ticketCab.id.toString(), request);

        if (response.isSuccess) {
          await getTicketCabs();
          NotificationsService.showSnackbar("Ticket guardado con éxito");
        }
      }
    } catch (e) {}
    showLoader = false;
    notifyListeners();
  }

  //--------------------------------------------------------------------
  void filter() {
    ticketCabs = originalTicketCabs;

    List<TicketCab> filteredList = [];

    for (var ticketCab in ticketCabs) {
      if ((ticketCab.companyName
              .toLowerCase()
              .contains(search.toLowerCase())) ||
          (Constants.estados[ticketCab.ticketState]
              .toLowerCase()
              .contains(search.toLowerCase())) ||
          (ticketCab.createUserName
              .toLowerCase()
              .contains(search.toLowerCase()))) {
        filteredList.add(ticketCab);
      }
    }

    ticketCabs = filteredList;
    notifyListeners();
  }

  //--------------------------------------------------------------------
  Future<TicketCab> getTicketCabById(String id) async {
    try {
      Response response = await ApiHelper.getTicketCab(id);

      TicketCab ticketCab = response.result;

      return ticketCab;
    } catch (e) {
      throw e;
    }
  }
}

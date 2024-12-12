import 'package:flutter/material.dart';
import 'package:tickets_web_app/models/models.dart';

class TicketFormProvider extends ChangeNotifier {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  String description = '';
  String photo = '';
  String photoFullPath = '';
  bool photoChanged = false;
  String base64Image = '';

  TicketCab ticketCab = TicketCab(
      id: 0,
      createDate: DateTime.now().toString(),
      createUserId: '',
      createUserName: '',
      companyId: 0,
      companyName: '',
      title: '',
      ticketState: 0,
      asignDate: '',
      finishDate: '',
      inProgressDate: '',
      ticketDets: [],
      ticketDetsNumber: 0);

  //----------------------------------------------------------------
  bool validateForm() {
    if (formKey.currentState!.validate()) {
      return true;
    } else {
      return false;
    }
  }
}

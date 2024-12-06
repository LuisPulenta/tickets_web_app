import 'package:flutter/material.dart';
import 'package:tickets_web_app/models/models.dart';

class TicketFormProvider extends ChangeNotifier {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  TicketCab ticketCab = TicketCab(
      id: 0,
      createDate: DateTime.now(),
      createUser: '',
      company: '',
      title: '',
      description: '',
      ticketState: '',
      stateDate: DateTime.now(),
      stateUser: '');

  //----------------------------------------------------------------
  bool validateForm() {
    if (formKey.currentState!.validate()) {
      return true;
    } else {
      return false;
    }
  }
}

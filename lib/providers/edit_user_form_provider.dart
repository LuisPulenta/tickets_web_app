import 'package:flutter/material.dart';

class EditUserFormProvider extends ChangeNotifier {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  String id = '';
  String email = '';
  String firstName = '';
  String lastName = '';
  String phoneNumber = '';
  int companyId = 0;
  int idUserType = -1;
  bool active = false;
  bool isResolver = false;

  //----------------------------------------------------------------
  bool validateForm() {
    if (formKey.currentState!.validate()) {
      return true;
    } else {
      return false;
    }
  }
}

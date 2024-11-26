import 'package:flutter/material.dart';

class CompanyFormProvider extends ChangeNotifier {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  int id = 0;
  String name = '';
  String photo = '';
  bool photoChanged = false;
  String base64Image = '';
  bool active = false;

  //----------------------------------------------------------------
  bool validateForm() {
    if (formKey.currentState!.validate()) {
      return true;
    } else {
      return false;
    }
  }
}

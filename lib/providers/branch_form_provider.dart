import 'package:flutter/material.dart';

class BranchFormProvider extends ChangeNotifier {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  int id = 0;
  String name = '';
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

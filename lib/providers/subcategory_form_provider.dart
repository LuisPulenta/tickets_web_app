import 'package:flutter/material.dart';

class SubcategoryFormProvider extends ChangeNotifier {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  int id = 0;
  String name = '';

  //----------------------------------------------------------------
  bool validateForm() {
    if (formKey.currentState!.validate()) {
      return true;
    } else {
      return false;
    }
  }
}

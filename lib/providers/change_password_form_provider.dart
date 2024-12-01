import 'package:flutter/material.dart';

class ChangePasswordFormProvider extends ChangeNotifier {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  String oldpassword = '';
  String newpassword = '';
  String confirmpassword = '';

  //----------------------------------------------------------------
  bool validateForm() {
    if (formKey.currentState!.validate()) {
      return true;
    } else {
      return false;
    }
  }
}

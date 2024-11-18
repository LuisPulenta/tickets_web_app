import 'package:flutter/material.dart';
import 'package:tickets_web_app/providers/auth_provider.dart';

class LoginFormProvider extends ChangeNotifier {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  String email = '';
  String password = '';

  bool validateForm() {
    if (formKey.currentState!.validate()) {
      return true;
    } else {
      return false;
    }
  }
}

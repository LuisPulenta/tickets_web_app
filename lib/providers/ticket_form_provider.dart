import 'package:flutter/material.dart';
import 'package:tickets_web_app/models/models.dart';

class TicketFormProvider extends ChangeNotifier {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  String fileName = '';
  String fileExtension = '';
  String description = '';
  String photo = '';
  String photoFullPath = '';
  bool photoChanged = false;
  String base64Image = '';
  String userAsign = '';
  String userAsignName = '';
  int categoryId = 0;
  String category = '';
  int subcategoryId = 0;
  String subcategory = '';

  TicketCab ticketCab = TicketCab(
      id: 0,
      createDate: DateTime.now().toString(),
      createUserId: '',
      createUserName: '',
      companyId: 0,
      companyName: '',
      categoryId: 0,
      categoryName: '',
      subcategoryId: 0,
      subcategoryName: '',
      title: '',
      ticketState: 0,
      asignDate: '',
      userAsign: '',
      userAsignName: '',
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

import 'dart:convert';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:tickets_web_app/models/category.dart';
import 'package:tickets_web_app/models/token.dart';
import 'package:tickets_web_app/providers/categories_provider.dart';
import 'package:tickets_web_app/providers/category_form_provider.dart';
import 'package:tickets_web_app/providers/providers.dart';
import 'package:tickets_web_app/services/services.dart';
import 'package:tickets_web_app/ui/buttons/custom_outlined_button.dart';
import 'package:tickets_web_app/ui/cards/white_card.dart';
import 'package:tickets_web_app/ui/inputs/custom_inputs.dart';
import 'package:tickets_web_app/ui/labels/custom_labels.dart';

class CategoryModal extends StatefulWidget {
  final Category? category;

  const CategoryModal({Key? key, this.category}) : super(key: key);

  @override
  State<CategoryModal> createState() => _CategoryModalState();
}

class _CategoryModalState extends State<CategoryModal> {
//---------------------------------------------------------------------------
  int? id;
  late Token token;
  late CategoryFormProvider categoryFormProvider;

//---------------------------------------------------------------------------
  @override
  void initState() {
    super.initState();
    final userBody = LocalStorage.prefs.getString('userBody');
    var decodedJson = jsonDecode(userBody!);
    token = Token.fromJson(decodedJson);

    categoryFormProvider =
        Provider.of<CategoryFormProvider>(context, listen: false);

    categoryFormProvider.id = widget.category?.id ?? 0;
    categoryFormProvider.name = widget.category?.name ?? '';
  }

//---------------------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      height: 500,
      width: 300,
      decoration: buildBoxDecoration(),
      child: Form(
        autovalidateMode: AutovalidateMode.always,
        key: categoryFormProvider.formKey,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.category?.name ?? 'Nueva Categoría',
                  style: CustomLabels.h1.copyWith(color: Colors.white),
                ),
                IconButton(
                    icon: const Icon(
                      Icons.close,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    })
              ],
            ),
            Divider(
              color: Colors.white.withOpacity(0.3),
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Spacer(),
                Expanded(
                  child: TextFormField(
                    onFieldSubmitted: (_) =>
                        onFormSubmit(categoryFormProvider, token),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Ingrese Nombre de Categoría";
                      }
                      if (value.length < 3) {
                        return "Mínimo 3 caracteres";
                      }
                      if (value.length > 50) {
                        return "Máximo 50 caracteres";
                      }
                      return null;
                    },
                    onChanged: (value) {
                      categoryFormProvider.name = value;
                    },
                    initialValue: widget.category?.name ?? '',
                    decoration: CustomInput.loginInputDecoration(
                      hint: 'Nombre de la Categoría',
                      label: 'Categoría',
                      icon: Icons.category_outlined,
                    ),
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
                categoryFormProvider.id > 0 ? const Spacer() : Container(),
                const Spacer(),
              ],
            ),
            Container(
              margin: const EdgeInsets.only(top: 30),
              alignment: Alignment.center,
              child: CustomOutlinedButton(
                onPressed: () async {
                  onFormSubmit(categoryFormProvider, token);
                },
                text: "Guardar",
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  //--------------------------------------------------------------------
  void onFormSubmit(
      CategoryFormProvider categoryFormProvider, Token token) async {
    final isValid = categoryFormProvider.validateForm();
    if (isValid) {
      try {
        //Nueva Empresa
        if (categoryFormProvider.id == 0) {
          final categoriesProvider =
              Provider.of<CategoriesProvider>(context, listen: false);
          await categoriesProvider
              .newCategory(categoryFormProvider.name)
              .then((value) => Navigator.of(context).pop());
        } else {
          //Editar Empresa
          final categoriesProvider =
              Provider.of<CategoriesProvider>(context, listen: false);
          await categoriesProvider
              .updateCategory(
                categoryFormProvider.id,
                categoryFormProvider.name,
              )
              .then((value) => Navigator.of(context).pop());
        }
      } catch (e) {
        NotificationsService.showSnackbarError(
            "No se pudo guardar la Categoría");
      }
    }
  }

  //---------------------------------------------------------------------------
  BoxDecoration buildBoxDecoration() => const BoxDecoration(
          color: Color(0xff0f2041),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black,
            )
          ]);
}

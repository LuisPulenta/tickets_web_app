import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tickets_web_app/models/models.dart';
import 'package:tickets_web_app/providers/providers.dart';
import 'package:tickets_web_app/services/services.dart';
import 'package:tickets_web_app/ui/buttons/custom_outlined_button.dart';
import 'package:tickets_web_app/ui/inputs/custom_inputs.dart';
import 'package:tickets_web_app/ui/labels/custom_labels.dart';

class SubcategoryModal extends StatefulWidget {
  final Subcategory? subcategory;
  final Category? category;

  const SubcategoryModal({Key? key, this.subcategory, this.category})
      : super(key: key);

  @override
  State<SubcategoryModal> createState() => _SubcategoryModalState();
}

class _SubcategoryModalState extends State<SubcategoryModal> {
//---------------------------------------------------------------------------
  int? id;
  late Token token;
  late SubcategoryFormProvider subcategoryFormProvider;

//---------------------------------------------------------------------------
  @override
  void initState() {
    super.initState();
    final userBody = LocalStorage.prefs.getString('userBody');
    var decodedJson = jsonDecode(userBody!);
    token = Token.fromJson(decodedJson);

    subcategoryFormProvider =
        Provider.of<SubcategoryFormProvider>(context, listen: false);

    subcategoryFormProvider.id = widget.subcategory?.id ?? 0;
    subcategoryFormProvider.name = widget.subcategory?.name ?? '';
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
        key: subcategoryFormProvider.formKey,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.subcategory?.name ?? 'Nueva Subcategoría',
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
                        onFormSubmit(subcategoryFormProvider, token),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Ingrese Nombre de Subcategoría";
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
                      subcategoryFormProvider.name = value;
                    },
                    initialValue: widget.subcategory?.name ?? '',
                    decoration: CustomInput.loginInputDecoration(
                      hint: 'Nombre de la Subcategoría',
                      label: 'Subcategoría',
                      icon: Icons.category_outlined,
                    ),
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
                subcategoryFormProvider.id > 0 ? const Spacer() : Container(),
                const Spacer(),
              ],
            ),
            Container(
              margin: const EdgeInsets.only(top: 30),
              alignment: Alignment.center,
              child: CustomOutlinedButton(
                onPressed: () async {
                  onFormSubmit(subcategoryFormProvider, token);
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
      SubcategoryFormProvider subcategoryFormProvider, Token token) async {
    final isValid = subcategoryFormProvider.validateForm();
    if (isValid) {
      try {
        //Nueva Empresa
        if (subcategoryFormProvider.id == 0) {
          final subcategoriesProvider =
              Provider.of<SubcategoriesProvider>(context, listen: false);
          await subcategoriesProvider
              .newSubcategory(subcategoryFormProvider.name,
                  widget.category!.id.toString(), widget.category!.name)
              .then((value) => Navigator.of(context).pop());
        } else {
          //Editar Empresa
          final subcategoriesProvider =
              Provider.of<SubcategoriesProvider>(context, listen: false);
          await subcategoriesProvider
              .updateSubcategory(
                subcategoryFormProvider.id,
                subcategoryFormProvider.name,
                widget.category!.id.toString(),
                widget.category!.name,
              )
              .then((value) => Navigator.of(context).pop());
        }
      } catch (e) {
        NotificationsService.showSnackbarError(
            "No se pudo guardar la Subcategoría");
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

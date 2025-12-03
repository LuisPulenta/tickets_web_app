import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/branch.dart';
import '../../models/token.dart';
import '../../providers/providers.dart';
import '../../services/services.dart';
import '../buttons/custom_outlined_button.dart';
import '../inputs/custom_inputs.dart';
import '../labels/custom_labels.dart';

class BranchModal extends StatefulWidget {
  final Branch? branch;

  const BranchModal({Key? key, this.branch}) : super(key: key);

  @override
  State<BranchModal> createState() => _BranchModalState();
}

class _BranchModalState extends State<BranchModal> {
//---------------------------------------------------------------------------
  int? id;
  late Token token;
  late BranchFormProvider branchFormProvider;

//---------------------------------------------------------------------------
  @override
  void initState() {
    super.initState();
    final userBody = LocalStorage.prefs.getString('tickets-userBody');
    var decodedJson = jsonDecode(userBody!);
    token = Token.fromJson(decodedJson);

    branchFormProvider =
        Provider.of<BranchFormProvider>(context, listen: false);

    branchFormProvider.id = widget.branch?.id ?? 0;
    branchFormProvider.name = widget.branch?.name ?? '';
    branchFormProvider.active = widget.branch?.active ?? false;
  }

//---------------------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    final userLoggedId =
        Provider.of<AuthProvider>(context, listen: false).user!.id;

    final userCompanyId =
        Provider.of<AuthProvider>(context, listen: false).user!.companyId;

    return Container(
      padding: const EdgeInsets.all(20),
      height: 500,
      width: 300,
      decoration: buildBoxDecoration(),
      child: Form(
        autovalidateMode: AutovalidateMode.always,
        key: branchFormProvider.formKey,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.branch?.name ?? 'Nueva Sucursal',
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
                    onFieldSubmitted: (_) => onFormSubmit(
                        branchFormProvider, token, userLoggedId, userCompanyId),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Ingrese Nombre de Sucursal';
                      }
                      if (value.length < 3) {
                        return 'Mínimo 3 caracteres';
                      }
                      if (value.length > 50) {
                        return 'Máximo 50 caracteres';
                      }
                      return null;
                    },
                    onChanged: (value) {
                      branchFormProvider.name = value;
                    },
                    initialValue: widget.branch?.name ?? '',
                    decoration: CustomInput.loginInputDecoration(
                      hint: 'Nombre de la Sucursal',
                      label: 'Sucursal',
                      icon: Icons.category_outlined,
                    ),
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
                branchFormProvider.id > 0 ? const Spacer() : Container(),
                branchFormProvider.id > 0
                    ? Expanded(
                        child: SwitchListTile(
                            title: const Text(
                              'Activa:',
                              style: TextStyle(color: Colors.white),
                            ),
                            value: branchFormProvider.active,
                            onChanged: (value) {
                              branchFormProvider.active = value;
                              setState(() {});
                            }),
                      )
                    : Container(),
                const Spacer(),
              ],
            ),
            Container(
              margin: const EdgeInsets.only(top: 30),
              alignment: Alignment.center,
              child: CustomOutlinedButton(
                onPressed: () async {
                  onFormSubmit(
                      branchFormProvider, token, userLoggedId, userCompanyId);
                },
                text: 'Guardar',
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  //--------------------------------------------------------------------
  void onFormSubmit(BranchFormProvider branchFormProvider, Token token,
      String userLoggedId, int userCompanyId) async {
    final isValid = branchFormProvider.validateForm();
    if (isValid) {
      try {
        //Nueva Sucursal
        if (branchFormProvider.id == 0) {
          final branchesProvider =
              Provider.of<BranchesProvider>(context, listen: false);
          await branchesProvider
              .newBranch(
                  branchFormProvider.name, token, userLoggedId, userCompanyId)
              .then((value) => Navigator.of(context).pop());
        } else {
          //Editar Sucursal
          final branchesProvider =
              Provider.of<BranchesProvider>(context, listen: false);
          await branchesProvider
              .updateBranch(branchFormProvider.id, branchFormProvider.name,
                  token, userLoggedId, branchFormProvider.active)
              .then((value) => Navigator.of(context).pop());
        }
      } catch (e) {
        NotificationsService.showSnackbarError(
            'No se pudo guardar la Sucursal');
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

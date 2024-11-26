import 'dart:ui' as ui;
import 'dart:convert';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:tickets_web_app/models/http/company.dart';
import 'package:tickets_web_app/models/http/token.dart';
import 'package:tickets_web_app/providers/auth_provider.dart';
import 'package:tickets_web_app/providers/companies_provider.dart';
import 'package:tickets_web_app/providers/company_form_provider.dart';
import 'package:tickets_web_app/services/local_storage.dart';
import 'package:tickets_web_app/services/notifications_service.dart';
import 'package:tickets_web_app/ui/buttons/custom_outlined_button.dart';
import 'package:tickets_web_app/ui/cards/white_card.dart';
import 'package:tickets_web_app/ui/inputs/custom_inputs.dart';
import 'package:tickets_web_app/ui/labels/custom_labels.dart';

class CompanyModal extends StatefulWidget {
  final Company? company;

  const CompanyModal({Key? key, this.company}) : super(key: key);

  @override
  State<CompanyModal> createState() => _CompanyModalState();
}

class _CompanyModalState extends State<CompanyModal> {
  int? id;
  late Token token;
  late CompanyFormProvider companyFormProvider;

//---------------------------------------------------------------------------
  @override
  void initState() {
    super.initState();
    final userBody = LocalStorage.prefs.getString('userBody');
    companyFormProvider =
        Provider.of<CompanyFormProvider>(context, listen: false);
    var decodedJson = jsonDecode(userBody!);
    token = Token.fromJson(decodedJson);

    id = widget.company?.id;
    companyFormProvider.name = widget.company?.name ?? '';
  }

//---------------------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    final userLogged =
        Provider.of<AuthProvider>(context, listen: false).user!.fullName;

    return Container(
      padding: const EdgeInsets.all(20),
      height: 500,
      width: 300,
      decoration: buildBoxDecoration(),
      child: Form(
        autovalidateMode: AutovalidateMode.always,
        key: companyFormProvider.formKey,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.company?.name ?? 'Nueva Empresa',
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
                        onFormSubmit(companyFormProvider, token, userLogged),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Ingrese Nombre de Empresa";
                      }
                      if (value.length < 3) {
                        return "Mínimo 3 caracteres";
                      }
                      return null;
                    },
                    onChanged: (value) {
                      companyFormProvider.name = value;
                    },
                    initialValue: widget.company?.name ?? '',
                    decoration: CustomInput.loginInputDecoration(
                      hint: 'Nombre de la Empresa',
                      label: 'Empresa',
                      icon: Icons.category_outlined,
                    ),
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
                const Spacer(),
                const _AvatarContainer(),
                const Spacer(),
              ],
            ),
            Container(
              margin: const EdgeInsets.only(top: 30),
              alignment: Alignment.center,
              child: CustomOutlinedButton(
                onPressed: () async {
                  onFormSubmit(companyFormProvider, token, userLogged);
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
  void onFormSubmit(CompanyFormProvider companyFormProvider, Token token,
      String userLogged) async {
    final isValid = companyFormProvider.validateForm();
    if (isValid) {
      try {
        if (id == null) {
          //Nueva Empresa
          if (id == null) {
            final companiesProvider =
                Provider.of<CompaniesProvider>(context, listen: false);
            await companiesProvider
                .newCompany(companyFormProvider.name, token, userLogged)
                .then((value) => Navigator.of(context).pop());
          } else {
            //Editar Empresa
            //await companyProvider.updateCompany(nombre, token, userLogged);
            NotificationsService.showSnackbar("Cambios guardados con éxito");
          }
        } else {}
      } catch (e) {
        NotificationsService.showSnackbarError("No se pudo guardar la Empresa");
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

//-------------------------------------------------------
class _AvatarContainer extends StatefulWidget {
  const _AvatarContainer();

  @override
  State<_AvatarContainer> createState() => _AvatarContainerState();
}

class _AvatarContainerState extends State<_AvatarContainer> {
  PlatformFile? file;

  @override
  Widget build(BuildContext context) {
    final companyFormProvider = Provider.of<CompanyFormProvider>(context);
    final photo = companyFormProvider.photo;

    Widget image = (file != null)
        ? Image.memory(
            Uint8List.fromList(file!.bytes!),
            width: 250,
            height: 160,
          )
        : const Image(
            image: AssetImage('no-image.jpg'),
          );

    return Stack(
      children: [
        WhiteCard(
          width: 250,
          child: SizedBox(
            width: double.infinity,
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Logo',
                    style: CustomLabels.h2,
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  SizedBox(
                    width: 180,
                    height: 110,
                    child: Stack(
                      children: [
                        Center(
                          child: image,
                        ),

//*********************************************************************************
//*********************************************************************************
//*********************************************************************************

//*********************************************************************************
//*********************************************************************************
//*********************************************************************************
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Text(companyFormProvider.name,
                      style: const TextStyle(fontWeight: FontWeight.bold))
                ]),
          ),
        ),
        Positioned(
          bottom: 10,
          right: 10,
          child: Container(
            width: 45,
            height: 45,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.white, width: 5),
              borderRadius: BorderRadius.circular(100),
            ),
            child: FloatingActionButton(
              backgroundColor: Colors.indigo,
              elevation: 0,
              child: const Icon(
                Icons.camera_alt_outlined,
                size: 20,
              ),
              onPressed: () async {
                FilePickerResult? result = await FilePicker.platform.pickFiles(
                  type: FileType.custom,
                  allowedExtensions: ['jpg', 'jpeg', 'png'],
                  allowMultiple: false,
                );
                if (result != null) {
                  NotificationsService.showBusyIndicator(context);

                  file = result.files.first;
                  setState(() {});

                  // Provider.of<UsersProvider>(context,
                  //         listen: false)
                  //     .refreshUser(newUser);

                  Navigator.of(context).pop();
                } else {
                  print("User canceled the picker");
                }
              },
            ),
          ),
        ),
      ],
    );
  }
}

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:tickets_web_app/models/models.dart';
import 'package:tickets_web_app/providers/providers.dart';
import 'package:tickets_web_app/services/services.dart';
import 'package:tickets_web_app/ui/buttons/custom_outlined_button.dart';
import 'package:tickets_web_app/ui/cards/white_card.dart';
import 'package:tickets_web_app/ui/inputs/custom_inputs.dart';
import 'package:tickets_web_app/ui/labels/custom_labels.dart';

class EditUserView extends StatefulWidget {
  const EditUserView({Key? key}) : super(key: key);

  @override
  State<EditUserView> createState() => _EditUserViewState();
}

class _EditUserViewState extends State<EditUserView> {
  //---------------------------------------------------------------------------
  String? id;
  late Token token;
  late EditUserFormProvider editUserFormProvider;
  late ChangePasswordFormProvider changePasswordFormProvider;
  late User user;
  bool showChangePassword = false;

//---------------------------------------------------------------------------
  @override
  void initState() {
    super.initState();

    final userBody = LocalStorage.prefs.getString('userBody');
    var decodedJson = jsonDecode(userBody!);
    token = Token.fromJson(decodedJson);
    user = token.user;

    editUserFormProvider =
        Provider.of<EditUserFormProvider>(context, listen: false);

    changePasswordFormProvider =
        Provider.of<ChangePasswordFormProvider>(context, listen: false);

    editUserFormProvider.id = user.id;
    editUserFormProvider.firstName = user.firstName;
    editUserFormProvider.lastName = user.lastName;
    editUserFormProvider.active = user.active;
    editUserFormProvider.email = user.email;
    editUserFormProvider.phoneNumber = user.phoneNumber;
    editUserFormProvider.company = user.company;
    editUserFormProvider.companyId = user.companyId;
    editUserFormProvider.idUserType = user.userType;
  }

  //---------------------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    final userLogged =
        Provider.of<AuthProvider>(context, listen: false).user!.fullName;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: ListView(
        physics: const ClampingScrollPhysics(),
        children: [
          WhiteCard(
            title: "Editar Usuario",
            child: Column(
              children: [
                Form(
                  autovalidateMode: AutovalidateMode.disabled,
                  key: editUserFormProvider.formKey,
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const Expanded(
                            flex: 1,
                            child: Spacer(),
                          ),
                          Expanded(
                            flex: 2,
                            child: TextFormField(
                              initialValue: editUserFormProvider.firstName,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Ingrese Nombre del Usuario";
                                }
                                if (value.length < 3) {
                                  return "Mínimo 3 caracteres";
                                }
                                return null;
                              },
                              onChanged: (value) {
                                editUserFormProvider.firstName = value;
                              },
                              decoration: CustomInput.editInputDecoration(
                                hint: 'Nombre del Usuario',
                                label: 'Nombre del Usuario',
                                icon: Icons.person,
                              ),
                              style: const TextStyle(color: Colors.black),
                            ),
                          ),
                          const SizedBox(
                            width: 15,
                          ),
                          Expanded(
                            flex: 2,
                            child: TextFormField(
                              initialValue: editUserFormProvider.lastName,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Ingrese Apellido del Usuario";
                                }
                                if (value.length < 3) {
                                  return "Mínimo 3 caracteres";
                                }
                                return null;
                              },
                              onChanged: (value) {
                                editUserFormProvider.lastName = value;
                              },
                              decoration: CustomInput.editInputDecoration(
                                hint: 'Apellido del Usuario',
                                label: 'Apellido del Usuario',
                                icon: Icons.person,
                              ),
                              style: const TextStyle(color: Colors.black),
                            ),
                          ),
                          const SizedBox(
                            width: 15,
                          ),
                          Expanded(
                            flex: 2,
                            child: TextFormField(
                              initialValue: editUserFormProvider.phoneNumber,
                              keyboardType: TextInputType.number,
                              onChanged: (value) {
                                editUserFormProvider.phoneNumber = value;
                              },
                              decoration: CustomInput.editInputDecoration(
                                hint: 'Teléfono',
                                label: 'Teléfono',
                                icon: Icons.phone_outlined,
                              ),
                              style: const TextStyle(color: Colors.black),
                            ),
                          ),
                          const Expanded(
                            flex: 1,
                            child: Spacer(),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Row(
                        children: [
                          const Spacer(),
                          Container(
                            margin: const EdgeInsets.only(top: 30),
                            alignment: Alignment.center,
                            child: CustomOutlinedButton(
                              onPressed: () async {
                                onFormSubmit(
                                    editUserFormProvider, token, userLogged);
                              },
                              text: "Guardar",
                              color: const Color.fromARGB(255, 25, 15, 219),
                              isFilled: true,
                            ),
                          ),
                          const Spacer(),
                        ],
                      ),
                      !showChangePassword
                          ? Row(
                              children: [
                                const Spacer(),
                                Container(
                                  margin: const EdgeInsets.only(top: 30),
                                  alignment: Alignment.center,
                                  child: CustomOutlinedButton(
                                    onPressed: () async {
                                      showChangePassword = true;
                                      setState(() {});
                                    },
                                    text: "Cambiar Contraseña",
                                    color:
                                        const Color.fromARGB(255, 25, 15, 219),
                                    isFilled: true,
                                  ),
                                ),
                                const Spacer(),
                              ],
                            )
                          : Container(),
                    ],
                  ),
                ),
                showChangePassword
                    ? const SizedBox(
                        height: 15,
                      )
                    : Container(),
                const Divider(),
                showChangePassword
                    ? Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          'Cambiar Contraseña',
                          style: GoogleFonts.roboto(
                              fontSize: 15, fontWeight: FontWeight.bold),
                        ),
                      )
                    : Container(),
                showChangePassword ? const Divider() : Container(),
                //**************************************************************************************
                //**************************************************************************************
                //**************************************************************************************
                showChangePassword
                    ? Form(
                        autovalidateMode: AutovalidateMode.disabled,
                        key: changePasswordFormProvider.formKey,
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                const Expanded(
                                  flex: 1,
                                  child: Spacer(),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: TextFormField(
                                    obscureText: true,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return "Ingrese Contraseña actual";
                                      }
                                      if (value.length < 6) {
                                        return "Mínimo 6 caracteres";
                                      }

                                      return null;
                                    },
                                    onChanged: (value) {
                                      changePasswordFormProvider.oldpassword =
                                          value;
                                    },
                                    decoration: CustomInput.editInputDecoration(
                                      hint: 'Ingrese su Contraseña actual',
                                      label: 'Contraseña actual',
                                      icon: Icons.password,
                                    ),
                                    style: const TextStyle(color: Colors.black),
                                  ),
                                ),
                                const SizedBox(
                                  width: 15,
                                ),
                                Expanded(
                                  flex: 2,
                                  child: TextFormField(
                                    obscureText: true,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return "Ingrese Nueva Contraseña";
                                      }
                                      if (value.length < 6) {
                                        return "Mínimo 6 caracteres";
                                      }
                                      if (changePasswordFormProvider
                                              .confirmpassword !=
                                          changePasswordFormProvider
                                              .newpassword) {
                                        return 'La nueva contraseña y la confirmación no son iguales';
                                      }
                                      return null;
                                    },
                                    onChanged: (value) {
                                      changePasswordFormProvider.newpassword =
                                          value;
                                    },
                                    decoration: CustomInput.editInputDecoration(
                                      hint: 'Ingrese Nueva Contraseña',
                                      label: 'Nueva Contraseña',
                                      icon: Icons.password,
                                    ),
                                    style: const TextStyle(color: Colors.black),
                                  ),
                                ),
                                const SizedBox(
                                  width: 15,
                                ),
                                Expanded(
                                  flex: 2,
                                  child: TextFormField(
                                    obscureText: true,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return "Ingrese Confirmación de Contraseña";
                                      }
                                      if (value.length < 6) {
                                        return "Mínimo 6 caracteres";
                                      }
                                      if (changePasswordFormProvider
                                              .confirmpassword !=
                                          changePasswordFormProvider
                                              .newpassword) {
                                        return 'La nueva contraseña y la confirmación no son iguales';
                                      }
                                    },
                                    keyboardType: TextInputType.number,
                                    onChanged: (value) {
                                      changePasswordFormProvider
                                          .confirmpassword = value;
                                    },
                                    decoration: CustomInput.editInputDecoration(
                                      hint: 'Confirme Nueva Contraseña',
                                      label: 'Confirme Nueva Contraseña',
                                      icon: Icons.password,
                                    ),
                                    style: const TextStyle(color: Colors.black),
                                  ),
                                ),
                                const Expanded(
                                  flex: 1,
                                  child: Spacer(),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            Row(
                              children: [
                                const Spacer(),
                                Container(
                                  margin: const EdgeInsets.only(top: 30),
                                  alignment: Alignment.center,
                                  child: CustomOutlinedButton(
                                    onPressed: () async {
                                      onForm2Submit(
                                          changePasswordFormProvider, token);
                                    },
                                    text: "Cambiar Contraseña",
                                    color:
                                        const Color.fromARGB(255, 25, 15, 219),
                                    isFilled: true,
                                  ),
                                ),
                                const Spacer(),
                              ],
                            ),
                          ],
                        ),
                      )
                    : Container(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  //--------------------------------------------------------------------
  void onForm2Submit(ChangePasswordFormProvider changePasswordFormProvider,
      Token token) async {
    final isValid = changePasswordFormProvider.validateForm();
    if (isValid) {
      try {
        final authProvider = Provider.of<AuthProvider>(context, listen: false);
        await authProvider.changePassword(
          changePasswordFormProvider.oldpassword,
          changePasswordFormProvider.newpassword,
          changePasswordFormProvider.confirmpassword,
        );

        Navigator.of(context).pop();
      } catch (e) {}
    }
  }

  //--------------------------------------------------------------------
  void onFormSubmit(EditUserFormProvider editUserFormProvider, Token token,
      String userLogged) async {
    final isValid = editUserFormProvider.validateForm();
    if (isValid) {
      try {
        final usersProvider =
            Provider.of<UsersProvider>(context, listen: false);
        await usersProvider
            .updateUser(
                editUserFormProvider.id,
                editUserFormProvider.firstName,
                editUserFormProvider.lastName,
                editUserFormProvider.email,
                editUserFormProvider.phoneNumber,
                editUserFormProvider.companyId,
                editUserFormProvider.idUserType,
                userLogged,
                editUserFormProvider.active,
                '')
            .then((value) => Navigator.of(context).pop());
      } catch (e) {
        NotificationsService.showSnackbarError("No se pudo guardar el Usuario");
      }
    }
  }
}

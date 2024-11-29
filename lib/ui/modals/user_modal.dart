import 'dart:convert';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tickets_web_app/helpers/api_helper.dart';
import 'package:tickets_web_app/models/models.dart';
import 'package:tickets_web_app/providers/providers.dart';
import 'package:tickets_web_app/services/services.dart';
import 'package:tickets_web_app/ui/buttons/custom_outlined_button.dart';
import 'package:tickets_web_app/ui/inputs/custom_inputs.dart';
import 'package:tickets_web_app/ui/labels/custom_labels.dart';

class UserModal extends StatefulWidget {
  final User? user;

  const UserModal({Key? key, this.user}) : super(key: key);

  @override
  State<UserModal> createState() => _UserModalState();
}

class _UserModalState extends State<UserModal> {
  //---------------------------------------------------------------------------
  String? id;
  late Token token;
  late UserFormProvider userFormProvider;
  late User user;
  List<Company> _companies = [];

//---------------------------------------------------------------------------
  @override
  void initState() {
    super.initState();

    final userBody = LocalStorage.prefs.getString('userBody');
    var decodedJson = jsonDecode(userBody!);
    token = Token.fromJson(decodedJson);

    _getCompanies();

    userFormProvider = Provider.of<UserFormProvider>(context, listen: false);

    if (widget.user == null) {
      user = User(
        // firstName: 'Gonzalo',
        // lastName: 'Prieto',
        // userType: 0,
        // company: 'Rowing',
        // companyId: 3,
        // createDate: DateTime.now().toString(),
        // createUser: 'Luis Núñez',
        // lastChangeDate: DateTime.now().toString(),
        // lastChangeUser: 'Luis Núñez',
        // active: true,
        // fullName: 'Luis Núñez',
        // id: '',
        // email: 'gprieto@yopmail.com',
        // emailConfirmed: false,
        // phoneNumber: '011 123 456',

        firstName: '',
        lastName: '',
        userType: -1,
        company: '',
        companyId: 0,
        createDate: '',
        createUser: '',
        lastChangeDate: '',
        lastChangeUser: '',
        active: false,
        fullName: '',
        id: '',
        email: '',
        emailConfirmed: false,
        phoneNumber: '',
      );
    } else {
      user = User(
        firstName: widget.user!.firstName,
        lastName: widget.user!.lastName,
        userType: widget.user!.userType,
        company: widget.user!.company,
        companyId: widget.user!.companyId,
        createDate: widget.user!.createDate,
        createUser: widget.user!.createUser,
        lastChangeDate: widget.user!.lastChangeDate,
        lastChangeUser: widget.user!.lastChangeDate,
        active: widget.user!.active,
        fullName: widget.user!.fullName,
        id: widget.user!.id,
        email: widget.user!.email,
        emailConfirmed: widget.user!.emailConfirmed,
        phoneNumber: widget.user!.phoneNumber,
      );
    }

    userFormProvider.id = user.id;
    userFormProvider.firstName = user.firstName;
    userFormProvider.lastName = user.lastName;
    userFormProvider.active = user.active;
    userFormProvider.email = user.email;
    userFormProvider.phoneNumber = user.phoneNumber;
    userFormProvider.company =
        widget.user == null ? 'Seleccione una Empresa...' : user.company;
    userFormProvider.companyId = widget.user == null ? 0 : user.companyId;
    userFormProvider.idUserType = user.userType;
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
        autovalidateMode: AutovalidateMode.disabled,
        key: userFormProvider.formKey,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  userFormProvider.id == ''
                      ? 'Nuevo Usuario'
                      : '${userFormProvider.lastName} ${userFormProvider.firstName}',
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
              height: 20,
            ),
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
                    enabled: userFormProvider.id == '',
                    initialValue: userFormProvider.email,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Ingrese Email del Usuario";
                      }
                      if (!EmailValidator.validate(value)) {
                        return "El Email no tiene formato válido";
                      }
                      return null;
                    },
                    onChanged: (value) {
                      userFormProvider.email = value;
                    },
                    decoration: CustomInput.loginInputDecoration(
                      hint: 'Email',
                      label: 'Email',
                      icon: Icons.email_outlined,
                    ),
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
                const SizedBox(
                  width: 15,
                ),
                Expanded(
                  flex: 2,
                  child: TextFormField(
                    initialValue: userFormProvider.firstName,
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
                      userFormProvider.firstName = value;
                    },
                    decoration: CustomInput.loginInputDecoration(
                      hint: 'Nombre del Usuario',
                      label: 'Nombre del Usuario',
                      icon: Icons.person,
                    ),
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
                const SizedBox(
                  width: 15,
                ),
                Expanded(
                  flex: 2,
                  child: TextFormField(
                    initialValue: userFormProvider.lastName,
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
                      userFormProvider.lastName = value;
                    },
                    decoration: CustomInput.loginInputDecoration(
                      hint: 'Apellido del Usuario',
                      label: 'Apellido del Usuario',
                      icon: Icons.person,
                    ),
                    style: const TextStyle(color: Colors.white),
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
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const Expanded(
                  flex: 1,
                  child: Spacer(),
                ),
                Expanded(
                  flex: 2,
                  child: TextFormField(
                    initialValue: userFormProvider.phoneNumber,
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      userFormProvider.phoneNumber = value;
                    },
                    decoration: CustomInput.loginInputDecoration(
                      hint: 'Teléfono',
                      label: 'Teléfono',
                      icon: Icons.phone_outlined,
                    ),
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
                const SizedBox(
                  width: 15,
                ),
                Expanded(
                  flex: 2,
                  child: _showCompany(),
                ),
                const SizedBox(
                  width: 15,
                ),
                Expanded(
                  flex: 2,
                  child: _showUserType(),
                ),
                const Expanded(
                  flex: 1,
                  child: Spacer(),
                ),
              ],
            ),
            Row(
              children: [
                const Spacer(),
                userFormProvider.id != ''
                    ? Container(
                        padding: const EdgeInsets.only(top: 30),
                        width: 200,
                        child: SwitchListTile(
                            tileColor: Colors.red,
                            title: const Text(
                              'Activo:',
                              style: TextStyle(color: Colors.white),
                            ),
                            value: userFormProvider.active,
                            onChanged: (value) {
                              userFormProvider.active = value;
                              setState(() {});
                            }),
                      )
                    : Container(),
                const SizedBox(
                  width: 50,
                ),
                Container(
                  margin: const EdgeInsets.only(top: 30),
                  alignment: Alignment.center,
                  child: CustomOutlinedButton(
                    onPressed: () async {
                      onFormSubmit(userFormProvider, token, userLogged);
                    },
                    text: "Guardar",
                    color: Colors.white,
                  ),
                ),
                const Spacer(),
              ],
            ),
          ],
        ),
      ),
    );
  }

  //--------------------------------------------------------------------
  Future<void> _getCompanies() async {
    Response response = await ApiHelper.getCompaniesCombo();

    if (!response.isSuccess) {
      NotificationsService.showSnackbarError("Error al cargar las Empresas");
      return;
    }

    setState(() {
      _companies = response.result;
    });
  }

  //--------------------------------------------------------------------
  void onFormSubmit(
      UserFormProvider userFormProvider, Token token, String userLogged) async {
    final isValid = userFormProvider.validateForm();
    if (isValid) {
      try {
        //Nuevo Usuario
        if (userFormProvider.id == '') {
          final usersProvider =
              Provider.of<UsersProvider>(context, listen: false);
          await usersProvider
              .newUser(
                  userFormProvider.firstName,
                  userFormProvider.lastName,
                  userFormProvider.email,
                  userFormProvider.phoneNumber,
                  userFormProvider.companyId,
                  userFormProvider.idUserType,
                  token,
                  userLogged)
              .then((value) => Navigator.of(context).pop());
        } else {
          //Editar User
          final usersProvider =
              Provider.of<UsersProvider>(context, listen: false);
          await usersProvider
              .updateUser(
                  userFormProvider.id,
                  userFormProvider.firstName,
                  userFormProvider.lastName,
                  userFormProvider.email,
                  userFormProvider.phoneNumber,
                  userFormProvider.companyId,
                  userFormProvider.idUserType,
                  userLogged,
                  userFormProvider.active)
              .then((value) => Navigator.of(context).pop());
        }
      } catch (e) {
        NotificationsService.showSnackbarError("No se pudo guardar el Usuario");
      }
    }
  }

  //---------------------------------------------------------------------------
  List<DropdownMenuItem<int>> _getComboCompanies() {
    List<DropdownMenuItem<int>> list = [];
    list.add(const DropdownMenuItem(
      value: 0,
      child: Text('Seleccione una Empresa...'),
    ));

    for (var company in _companies) {
      list.add(DropdownMenuItem(
        value: company.id,
        child: Text(company.name),
      ));
    }
    return list;
  }

  //---------------------------------------------------------------------------
  List<DropdownMenuItem<int>> _getComboUserTypes() {
    List<DropdownMenuItem<int>> list = [];
    list.add(const DropdownMenuItem(
      value: -1,
      child: Text('Seleccione un Tipo de Usuario...'),
    ));

    list.add(const DropdownMenuItem(
      value: 0,
      child: Text('Administrador'),
    ));

    list.add(const DropdownMenuItem(
      value: 1,
      child: Text('Usuario'),
    ));
    return list;
  }

  //---------------------------------------------------------------------------
  Widget _showCompany() {
    return Container(
      child: _companies.isEmpty
          ? const Text('Cargando Empresas...')
          : DropdownButtonFormField(
              validator: (value) {
                if (value == 0) {
                  return "Seleccione una Empresa";
                }
                return null;
              },
              dropdownColor: const Color(0xff0f2041),
              isExpanded: true,
              isDense: true,
              style:
                  TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 16),
              items: _getComboCompanies(),
              value: userFormProvider.companyId,
              onChanged: (option) {
                setState(() {
                  userFormProvider.companyId = option!;
                });
              },
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.storefront,
                    color: Colors.white.withOpacity(0.5)),
                labelStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
                hintText: 'Seleccione una Empresa...',
                labelText: 'Empresa',
                border: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.white.withOpacity(0.3),
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.white.withOpacity(0.3),
                  ),
                ),
              ),
            ),
    );
  }

  //---------------------------------------------------------------------------
  Widget _showUserType() {
    return DropdownButtonFormField(
      validator: (value) {
        if (value == -1) {
          return "Seleccione un Tipo de Usuario...";
        }
        return null;
      },
      dropdownColor: const Color(0xff0f2041),
      isExpanded: true,
      isDense: true,
      style: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 16),
      items: _getComboUserTypes(),
      value: userFormProvider.idUserType,
      onChanged: (option) {
        setState(() {
          userFormProvider.idUserType = option!;
        });
      },
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.supervised_user_circle,
            color: Colors.white.withOpacity(0.5)),
        labelStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
        hintText: 'Seleccione un Tipo de Usuario...',
        labelText: 'Tipo de Usuario',
        border: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.white.withOpacity(0.3),
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.white.withOpacity(0.3),
          ),
        ),
      ),
    );
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

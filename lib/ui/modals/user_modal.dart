import 'dart:convert';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../helpers/api_helper.dart';
import '../../helpers/constants.dart';
import '../../models/models.dart';
import '../../providers/providers.dart';
import '../../services/services.dart';
import '../buttons/custom_outlined_button.dart';
import '../inputs/custom_inputs.dart';
import '../labels/custom_labels.dart';

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
  late User userLogged;
  List<Company> _companies = [];
  List<Branch> _branches = [];
  List<User> _bosses = [];
  String userNameSelected = '';
  String userIdSelected = '';

//---------------------------------------------------------------------------
  @override
  void initState() {
    super.initState();

    final userBody = LocalStorage.prefs.getString('tickets-userBody');
    var decodedJson = jsonDecode(userBody!);
    token = Token.fromJson(decodedJson);
    userLogged = token.user;

    _getCompanies();

    userFormProvider = Provider.of<UserFormProvider>(context, listen: false);

    if (widget.user == null) {
      user = User(
          id: '',
          firstName: '',
          lastName: '',
          userTypeId: -1,
          userTypeName: '',
          email: '',
          emailConfirm: false,
          phoneNumber: '',
          companyId: 0,
          companyName: '',
          createDate: '',
          createUserId: '',
          createUserName: '',
          lastChangeDate: '',
          lastChangeUserId: '',
          lastChangeUserName: '',
          active: false,
          isResolver: 0,
          isBoss: 0,
          branchId: 0,
          branchName: '',
          bossAsign: '',
          bossAsignName: '',
          tickets: [],
          fullName: '');
    } else {
      user = User(
        id: widget.user!.id,
        firstName: widget.user!.firstName,
        lastName: widget.user!.lastName,
        userTypeId: widget.user!.userTypeId,
        userTypeName: widget.user!.userTypeName,
        email: widget.user!.email,
        emailConfirm: widget.user!.emailConfirm,
        phoneNumber: widget.user!.phoneNumber,
        companyId: widget.user!.companyId,
        companyName: widget.user!.companyName,
        createDate: widget.user!.createDate,
        createUserId: widget.user!.createUserId,
        createUserName: widget.user!.createUserName,
        lastChangeDate: widget.user!.lastChangeDate,
        lastChangeUserId: widget.user!.lastChangeUserId,
        lastChangeUserName: widget.user!.lastChangeUserName,
        active: widget.user!.active,
        isResolver: widget.user!.isResolver,
        isBoss: widget.user!.isBoss,
        branchId: widget.user!.branchId,
        branchName: widget.user!.branchName,
        bossAsign: widget.user!.bossAsign,
        bossAsignName: widget.user!.bossAsignName,
        tickets: widget.user!.tickets,
        fullName: widget.user!.fullName,
      );
    }

    userFormProvider.id = user.id;
    userFormProvider.firstName = user.firstName;
    userFormProvider.lastName = user.lastName;
    userFormProvider.active = user.active;
    userFormProvider.isResolver = user.isResolver == 1 ? true : false;
    userFormProvider.isBoss = user.isBoss == 1 ? true : false;
    userFormProvider.email = user.email;
    userFormProvider.phoneNumber = user.phoneNumber;
    userFormProvider.company =
        widget.user == null ? 'Seleccione una Empresa...' : user.companyName;
    userFormProvider.companyId = widget.user == null ? 0 : user.companyId;

    userFormProvider.branch =
        widget.user == null ? 'Seleccione una Sucursal...' : user.branchName;
    userFormProvider.branchId = widget.user == null
        ? 0
        : user.branchId != null
            ? user.branchId!
            : null;

    userFormProvider.idUserType = user.userTypeId;
  }

//---------------------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    final userLoggedId =
        Provider.of<AuthProvider>(context, listen: false).user!.id;

    final emailLogged =
        Provider.of<AuthProvider>(context, listen: false).user!.email;

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
            //********************************************************************************************************************
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(
                  flex: 2,
                  child: TextFormField(
                    enabled: userFormProvider.id == '',
                    initialValue: userFormProvider.email,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Ingrese Email del Usuario';
                      }
                      if (!EmailValidator.validate(value)) {
                        return 'El Email no tiene formato válido';
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
                        return 'Ingrese Nombre del Usuario';
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
                        return 'Ingrese Apellido del Usuario';
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
            //********************************************************************************************************************
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
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
                userLogged.userTypeId == 0
                    ? Expanded(flex: 2, child: _showCompany())
                    : const SizedBox(),
                userLogged.userTypeId == 1 && userFormProvider.id != ''
                    ? Expanded(flex: 2, child: _showBranch())
                    : const SizedBox(),
                const SizedBox(
                  width: 15,
                ),
                userLogged.userTypeId == 0
                    ? Expanded(flex: 2, child: _showUserType())
                    : const SizedBox(),
                const Expanded(
                  flex: 4,
                  child: SizedBox(
                    width: 200,
                  ),
                ),
                const Spacer(),
              ],
            ),
            //******************************************************************************************************************** */
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
                userFormProvider.id != ''
                    ? Container(
                        padding: const EdgeInsets.only(top: 30),
                        width: 200,
                        child: SwitchListTile(
                            tileColor: Colors.red,
                            title: const Text(
                              'Es Resolvedor:',
                              style: TextStyle(color: Colors.white),
                            ),
                            value: userFormProvider.isResolver,
                            onChanged: (value) {
                              userFormProvider.isResolver = value;
                              setState(() {});
                            }),
                      )
                    : Container(),
                const SizedBox(
                  width: 50,
                ),
                userFormProvider.id != ''
                    ? Container(
                        padding: const EdgeInsets.only(top: 30),
                        width: 200,
                        child: SwitchListTile(
                            tileColor: Colors.red,
                            title: const Text(
                              'Es Jefe:',
                              style: TextStyle(color: Colors.white),
                            ),
                            value: userFormProvider.isBoss,
                            onChanged: (value) {
                              userFormProvider.isBoss = value;
                              setState(() {});
                            }),
                      )
                    : Container(),
                const SizedBox(
                  width: 50,
                ),
                userFormProvider.id != ''
                    ? Container(
                        padding: const EdgeInsets.only(top: 30),
                        child: const Text(
                          'Jefe:  ',
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        ),
                      )
                    : Container(),
                userFormProvider.id != ''
                    ? Container(
                        padding: const EdgeInsets.only(top: 30),
                        child: _showUser())
                    : Container(),
                const SizedBox(
                  width: 50,
                ),
                Container(
                  margin: const EdgeInsets.only(top: 30),
                  alignment: Alignment.center,
                  child: CustomOutlinedButton(
                    onPressed: () async {
                      onFormSubmit(
                          userFormProvider, token, userLoggedId, emailLogged);
                    },
                    text: 'Guardar',
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
      NotificationsService.showSnackbarError('Error al cargar las Empresas');
      return;
    }

    setState(() {
      _companies = response.result;
    });

    await _getBosses();
    await _getBranches();
  }

  //--------------------------------------------------------------------
  Future<void> _getBranches() async {
    Response response = await ApiHelper.getBranchesCombo();

    if (!response.isSuccess) {
      NotificationsService.showSnackbarError('Error al cargar las Sucursales');
      return;
    }

    setState(() {
      _branches = response.result;
    });
  }

  //--------------------------------------------------------------------
  Future<void> _getBosses() async {
    final companyLoggedId =
        Provider.of<AuthProvider>(context, listen: false).user!.companyId;

    Response response = await ApiHelper.getUsersCombo(companyLoggedId);

    if (!response.isSuccess) {
      NotificationsService.showSnackbarError('Error al cargar los Jefes');
      return;
    }

    setState(() {
      _bosses = response.result;
    });
  }

  //--------------------------------------------------------------------
  void onFormSubmit(UserFormProvider userFormProvider, Token token,
      String userLoggedId, String emailLogged) async {
    final isValid = userFormProvider.validateForm();

    if (userLogged.userTypeId == 1) {
      userFormProvider.companyId = userLogged.companyId;
      userFormProvider.idUserType = 2;
    }

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
                  userLoggedId)
              .then((value) => Navigator.of(context).pop());
        } else {
          //Editar User
          final usersProvider =
              Provider.of<UsersProvider>(context, listen: false);

          if (userFormProvider.id == userFormProvider.bossAsign) {
            NotificationsService.showSnackbarError(
                'No puede ser Jefe de si mismo!!');

            return;
          }

          await usersProvider
              .updateUser(
                  userFormProvider.id,
                  userFormProvider.firstName,
                  userFormProvider.lastName,
                  userFormProvider.email,
                  userFormProvider.phoneNumber,
                  userFormProvider.companyId,
                  userFormProvider.idUserType,
                  userLoggedId,
                  userFormProvider.active,
                  userFormProvider.isResolver,
                  userFormProvider.isBoss,
                  userFormProvider.bossAsign,
                  userFormProvider.bossAsignName,
                  userFormProvider.branchId,
                  emailLogged)
              .then((value) => Navigator.of(context).pop());
        }
      } catch (e) {
        NotificationsService.showSnackbarError('No se pudo guardar el Usuario');
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
  List<DropdownMenuItem<int>> _getComboBranches() {
    List<DropdownMenuItem<int>> list = [];
    list.add(const DropdownMenuItem(
      value: 0,
      child: Text('Seleccione una Sucursal...'),
    ));

    for (var branch in _branches) {
      list.add(DropdownMenuItem(
        value: branch.id,
        child: Text(branch.name),
      ));
    }
    return list;
  }

  //---------------------------------------------------------------------------
  List<DropdownMenuItem<int>> _getComboUserTypes() {
    List<DropdownMenuItem<int>> list = [];
    list.add(const DropdownMenuItem(
      value: -1,
      child: Text('Elija un Tipo de Usuario...'),
    ));

    list.add(const DropdownMenuItem(
      value: 0,
      child: Text('Administrador KeyPress'),
    ));

    list.add(const DropdownMenuItem(
      value: 1,
      child: Text('Administrador Empresa'),
    ));

    list.add(const DropdownMenuItem(
      value: 2,
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
                  return 'Seleccione una Empresa...';
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
  Widget _showBranch() {
    return Row(
      children: [
        Expanded(
          child: Container(
            child: _branches.isEmpty
                ? const Text('Cargando Sucursales...')
                : DropdownButtonFormField(
                    dropdownColor: const Color(0xff0f2041),
                    isExpanded: true,
                    isDense: true,
                    style: TextStyle(
                        color: Colors.white.withOpacity(0.5), fontSize: 16),
                    items: _getComboBranches(),
                    value: userFormProvider.branchId,
                    onChanged: (option) {
                      setState(() {
                        userFormProvider.branchId = option!;
                      });
                    },
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.storefront,
                          color: Colors.white.withOpacity(0.5)),
                      labelStyle:
                          TextStyle(color: Colors.white.withOpacity(0.5)),
                      hintText: 'Seleccione una Sucursal...',
                      labelText: 'Sucursal',
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
          ),
        ),
        IconButton(
          icon: const Icon(
            Icons.delete,
            color: Colors.white,
          ),
          onPressed: () {
            setState(() {
              userFormProvider.branchId = null;
            });
          },
        ),
      ],
    );
  }

  //---------------------------------------------------------------------------
  Widget _showUserType() {
    return DropdownButtonFormField(
      validator: (value) {
        if (value == -1) {
          return 'Elija un Tipo de Usuario...';
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
        hintText: 'Elija un Tipo de Usuario...',
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

//---------------------------------------------------------------------------
  Widget _showUser() {
    return SizedBox(
      width: 300,
      child: _bosses.isEmpty
          ? const Text('Cargando Usuarios...')
          : Row(
              children: [
                Expanded(
                  child: DropdownSearch<String>(
                    selectedItem: widget.user!.bossAsignName,
                    items: _getComboBosses(),
                    popupProps: PopupProps.menu(
                      showSearchBox: true,
                      searchFieldProps: TextFieldProps(
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors
                              .grey.shade200, // Fondo de la caja de búsqueda
                          hintText: 'Buscar...',
                          hintStyle: const TextStyle(color: Colors.grey),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                      itemBuilder: (context, item, isSelected) {
                        return Container(
                          color: isSelected
                              ? colorEnviado
                              : colorEnviado
                                  .withOpacity(0.5), // fondo de cada opción
                          padding: const EdgeInsets.all(12),
                          child: Text(
                            item,
                            style: TextStyle(
                              color: isSelected
                                  ? Colors.blue
                                  : Colors.black, // color del texto
                              fontWeight: isSelected
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                            ),
                          ),
                        );
                      },
                      menuProps: MenuProps(
                        backgroundColor:
                            colorEnviado, // Fondo del menú desplegable
                      ),
                    ),
                    dropdownDecoratorProps: DropDownDecoratorProps(
                      baseStyle:
                          const TextStyle(color: Colors.black, fontSize: 16),
                      dropdownSearchDecoration: InputDecoration(
                        fillColor: colorEnviado,
                        border: const OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.black,
                          ),
                        ),
                        enabledBorder: const OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.black,
                          ),
                        ),
                        filled: true,
                        //isDense: true,
                        labelStyle:
                            const TextStyle(color: Colors.black, fontSize: 16),

                        labelText: 'Jefe',
                        hintText: 'Seleccione un Jefe...',
                      ),
                    ),
                    onChanged: (option) {
                      setState(() {
                        userNameSelected = option!;

                        for (User user in _bosses) {
                          if (userNameSelected == user.fullName) {
                            userIdSelected = user.id;
                          }
                        }
                        userFormProvider.bossAsign = userIdSelected;
                        userFormProvider.bossAsignName = userNameSelected;
                      });
                    },
                  ),
                ),
                IconButton(
                  icon: const Icon(
                    Icons.delete,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    setState(() {
                      // Resetea el valor del DropdownSearch
                      userNameSelected =
                          ''; // o el valor por defecto que quieras
                      userIdSelected = '';
                      userFormProvider.bossAsign = '';
                      userFormProvider.bossAsignName = '';
                      widget.user!.bossAsignName = '';
                    });
                  },
                ),
              ],
            ),
    );
  }

  //---------------------------------------------------------------------------
  List<String> _getComboBosses() {
    List<String> list = [];
    //list.add('Seleccione un Usuario...');

    for (var user in _bosses) {
      if (user.isBoss == 1) {
        list.add(user.fullName);
      }
    }
    return list;
  }
}

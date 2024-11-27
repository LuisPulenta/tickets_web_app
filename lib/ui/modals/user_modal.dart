import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tickets_web_app/models/models.dart';
import 'package:tickets_web_app/providers/providers.dart';
import 'package:tickets_web_app/services/local_storage.dart';
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

//---------------------------------------------------------------------------
  @override
  void initState() {
    super.initState();
    final userBody = LocalStorage.prefs.getString('userBody');
    var decodedJson = jsonDecode(userBody!);
    token = Token.fromJson(decodedJson);

    userFormProvider = Provider.of<UserFormProvider>(context, listen: false);

    if (widget.user == null) {
      user = User(
          firstName: '',
          lastName: '',
          userType: 0,
          company: '',
          createDate: '',
          createUser: '',
          lastChangeDate: '',
          lastChangeUser: '',
          active: false,
          fullName: '',
          id: '',
          email: '',
          emailConfirmed: false,
          phoneNumber: '');
    } else {
      user = User(
        firstName: widget.user!.firstName,
        lastName: widget.user!.lastName,
        userType: widget.user!.userType,
        company: widget.user!.company,
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
    userFormProvider.phoneNumber = user.phoneNumber;
    userFormProvider.company = user.company;
    userFormProvider.userType = user.userType.toString();
  }

//---------------------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UsersProvider>(context, listen: false);

    return Container(
      padding: const EdgeInsets.all(20),
      height: 500,
      width: 300,
      decoration: buildBoxDecoration(),
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
                  initialValue: userFormProvider.firstName,
                  onChanged: (value) {
                    userFormProvider.firstName = value;
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
                  initialValue: userFormProvider.firstName,
                  onChanged: (value) {
                    userFormProvider.firstName = value;
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
                child: TextFormField(
                  initialValue: userFormProvider.firstName,
                  onChanged: (value) {
                    userFormProvider.firstName = value;
                  },
                  decoration: CustomInput.loginInputDecoration(
                    hint: 'Empresa',
                    label: 'Empresa',
                    icon: Icons.storefront,
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
                  onChanged: (value) {
                    userFormProvider.lastName = value;
                  },
                  decoration: CustomInput.loginInputDecoration(
                    hint: 'Tipo de Usuario',
                    label: 'Tipo de Usuario',
                    icon: Icons.supervised_user_circle_rounded,
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
          Container(
            margin: const EdgeInsets.only(top: 30),
            alignment: Alignment.center,
            child: CustomOutlinedButton(
              onPressed: () async {
                if (id == null) {
                  await userProvider.newUser(userFormProvider.firstName, token);
                } else {}

                Navigator.of(context).pop();
              },
              text: "Guardar",
              color: Colors.white,
            ),
          ),
        ],
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

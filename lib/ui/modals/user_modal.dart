import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tickets_web_app/models/http/token.dart';
import 'package:tickets_web_app/models/http/user.dart';
import 'package:tickets_web_app/providers/companies_provider.dart';
import 'package:tickets_web_app/providers/users_provider.dart';
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
  String firstName = '';
  String lastName = '';
  String? id;
  late Token token;

//---------------------------------------------------------------------------
  @override
  void initState() {
    super.initState();
    final userBody = LocalStorage.prefs.getString('userBody');
    var decodedJson = jsonDecode(userBody!);
    token = Token.fromJson(decodedJson);

    id = widget.user?.id;
    firstName = widget.user!.firstName;
    lastName = widget.user!.lastName;
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
                widget.user!.id == 0
                    ? 'Nuevo Usuario'
                    : '${widget.user!.lastName} ${widget.user!.firstName}',
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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Spacer(),
              Expanded(
                child: TextFormField(
                  initialValue: widget.user?.firstName ?? '',
                  onChanged: (value) {
                    firstName = value;
                  },
                  decoration: CustomInput.loginInputDecoration(
                    hint: 'Nombre del Usuario',
                    label: 'Nombre del Usuario',
                    icon: Icons.category_outlined,
                  ),
                  style: const TextStyle(color: Colors.white),
                ),
              ),
              const Spacer(),
              Expanded(
                child: TextFormField(
                  initialValue: widget.user?.lastName ?? '',
                  onChanged: (value) {
                    lastName = value;
                  },
                  decoration: CustomInput.loginInputDecoration(
                    hint: 'Apellido del Usuario',
                    label: 'Apellido del Usuario',
                    icon: Icons.category_outlined,
                  ),
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
          Container(
            margin: const EdgeInsets.only(top: 30),
            alignment: Alignment.center,
            child: CustomOutlinedButton(
              onPressed: () async {
                if (id == null) {
                  await userProvider.newUser(firstName, token);
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

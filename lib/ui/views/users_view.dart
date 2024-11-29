import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tickets_web_app/datatables/users_datasource.dart';
import 'package:tickets_web_app/models/models.dart';
import 'package:tickets_web_app/providers/users_provider.dart';
import 'package:tickets_web_app/services/local_storage.dart';
import 'package:tickets_web_app/ui/buttons/custom_icon_button.dart';
import 'package:tickets_web_app/ui/modals/user_modal.dart';

class UsersView extends StatefulWidget {
  const UsersView({Key? key}) : super(key: key);

  @override
  State<UsersView> createState() => _UsersViewState();
}

class _UsersViewState extends State<UsersView> {
  int _rowsPerPage = PaginatedDataTable.defaultRowsPerPage;

  //-------------------- initState ----------------------------

  @override
  void initState() {
    super.initState();
    final userBody = LocalStorage.prefs.getString('userBody');
    var decodedJson = jsonDecode(userBody!);
    var token = Token.fromJson(decodedJson);

    Provider.of<UsersProvider>(context, listen: false).getUsers(token);
  }

  //-------------------- Pantalla ----------------------------
  @override
  Widget build(BuildContext context) {
    List<User> users = Provider.of<UsersProvider>(context).users;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: ListView(
        physics: const ClampingScrollPhysics(),
        children: [
          PaginatedDataTable(
            columns: const [
              DataColumn(
                  label: Text("Empresa",
                      style: TextStyle(fontWeight: FontWeight.bold))),
              DataColumn(
                  label: Text("Nombre y Apellido",
                      style: TextStyle(fontWeight: FontWeight.bold))),
              DataColumn(
                  label: Text("Email",
                      style: TextStyle(fontWeight: FontWeight.bold))),
              DataColumn(
                  label: Text("Email Confirm.",
                      style: TextStyle(fontWeight: FontWeight.bold))),
              DataColumn(
                  label: Text("Teléfono",
                      style: TextStyle(fontWeight: FontWeight.bold))),
              DataColumn(
                  label: Text("Tipo Usuario",
                      style: TextStyle(fontWeight: FontWeight.bold))),
              DataColumn(
                  label: Text("Activo",
                      style: TextStyle(fontWeight: FontWeight.bold))),
              DataColumn(
                  label: Text("Acciones",
                      style: TextStyle(fontWeight: FontWeight.bold))),
            ],
            source: UsersDTS(users, context),
            header: const Text(
              "Usuarios",
              maxLines: 1,
            ),
            rowsPerPage: _rowsPerPage,
            onRowsPerPageChanged: (value) {
              _rowsPerPage = value ?? 10;
              setState(() {});
            },
            actions: [
              CustomIconButton(
                icon: Icons.add_outlined,
                text: "Nuevo Usuario",
                onPressed: () {
                  showModalBottomSheet(
                    backgroundColor: Colors.transparent,
                    context: context,
                    builder: (_) => const UserModal(
                      user: null,
                    ),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}

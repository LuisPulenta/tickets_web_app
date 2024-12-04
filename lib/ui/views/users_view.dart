import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tickets_web_app/datatables/users_datasource.dart';
import 'package:tickets_web_app/models/models.dart';
import 'package:tickets_web_app/providers/users_provider.dart';
import 'package:tickets_web_app/ui/buttons/custom_icon_button.dart';
import 'package:tickets_web_app/ui/inputs/custom_inputs.dart';
import 'package:tickets_web_app/ui/layouts/shared/widgets/loader_component.dart';
import 'package:tickets_web_app/ui/modals/user_modal.dart';

class UsersView extends StatefulWidget {
  const UsersView({Key? key}) : super(key: key);

  @override
  State<UsersView> createState() => _UsersViewState();
}

class _UsersViewState extends State<UsersView> {
  int _rowsPerPage = PaginatedDataTable.defaultRowsPerPage;
  bool showLoader = true;

  //-------------------- initState ----------------------------

  @override
  void initState() {
    super.initState();
    Provider.of<UsersProvider>(context, listen: false).getUsers();
    showLoader = false;
    setState(() {});
  }

  //-------------------- Pantalla ----------------------------
  @override
  Widget build(BuildContext context) {
    final usersProvider = Provider.of<UsersProvider>(context);
    final size = MediaQuery.of(context).size;
    List<User> users = Provider.of<UsersProvider>(context).users;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: ListView(
        physics: const ClampingScrollPhysics(),
        children: [
          Stack(
            children: [
              PaginatedDataTable(
                sortAscending: usersProvider.ascending,
                sortColumnIndex: usersProvider.sortColumnIndex,
                columns: [
                  DataColumn(
                      label: const Text("Empresa",
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      onSort: (colIndex, _) {
                        usersProvider.sortColumnIndex = colIndex;
                        usersProvider.sort<String>((user) => user.company);
                      }),
                  DataColumn(
                      label: const Text("Nombre y Apellido",
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      onSort: (colIndex, _) {
                        usersProvider.sortColumnIndex = colIndex;
                        usersProvider.sort<String>(
                            (user) => user.lastName + user.firstName);
                      }),
                  DataColumn(
                      label: const Text("Email",
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      onSort: (colIndex, _) {
                        usersProvider.sortColumnIndex = colIndex;
                        usersProvider.sort<String>((user) => user.email);
                      }),
                  const DataColumn(
                      label: Text("Email Confirm.",
                          style: TextStyle(fontWeight: FontWeight.bold))),
                  const DataColumn(
                      label: Text("Teléfono",
                          style: TextStyle(fontWeight: FontWeight.bold))),
                  const DataColumn(
                      label: Text("Tipo Usuario",
                          style: TextStyle(fontWeight: FontWeight.bold))),
                  const DataColumn(
                      label: Text("Activo",
                          style: TextStyle(fontWeight: FontWeight.bold))),
                  const DataColumn(
                      label: Text("Acciones",
                          style: TextStyle(fontWeight: FontWeight.bold))),
                ],
                source: UsersDTS(users, context),
                header: Row(
                  children: [
                    const Text(
                      "Usuarios",
                      maxLines: 1,
                    ),
                    const SizedBox(
                      width: 50,
                    ),
                    //Search input
                    ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 250),
                      child: Container(
                        height: 40,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.grey.withOpacity(0.2),
                        ),
                        child: TextField(
                          decoration: CustomInput.searchInputDecoration(
                              hint: "Buscar...", icon: Icons.search_outlined),
                          onSubmitted: (value) {
                            usersProvider.search = value;
                            usersProvider.filter();
                          },
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 50,
                    ),
                    SizedBox(
                      width: 200,
                      child: CheckboxListTile(
                          title: const Text('Sólo Activos',
                              style:
                                  TextStyle(color: Colors.black, fontSize: 16)),
                          value: usersProvider.onlyActives,
                          onChanged: (value) {
                            usersProvider.onlyActives = value!;
                            setState(() {});
                            usersProvider.filter();
                          }),
                    )
                  ],
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
              showLoader
                  ? Positioned(
                      left: size.width * 0.5 - 300,
                      top: size.height * 0.5 - 50,
                      child: const LoaderComponent(
                        text: 'Cargando Usuarios...',
                      ))
                  : Container()
            ],
          ),
        ],
      ),
    );
  }
}

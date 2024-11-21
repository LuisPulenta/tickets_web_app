import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tickets_web_app/datatables/companies_datasource.dart';
import 'package:tickets_web_app/models/http/company.dart';
import 'package:tickets_web_app/models/http/token.dart';
import 'package:tickets_web_app/providers/companies_provider.dart';
import 'package:tickets_web_app/services/local_storage.dart';
import 'package:tickets_web_app/ui/buttons/custom_icon_button.dart';
import 'package:tickets_web_app/ui/labels/custom_labels.dart';
import 'package:tickets_web_app/ui/modals/company_modal.dart';

class CompaniesView extends StatefulWidget {
  const CompaniesView({Key? key}) : super(key: key);

  @override
  State<CompaniesView> createState() => _CompaniesViewState();
}

class _CompaniesViewState extends State<CompaniesView> {
  int _rowsPerPage = PaginatedDataTable.defaultRowsPerPage;

  //-------------------- initState ----------------------------

  @override
  void initState() {
    super.initState();
    final userBody = LocalStorage.prefs.getString('userBody');
    var decodedJson = jsonDecode(userBody!);
    var token = Token.fromJson(decodedJson);

    Provider.of<CompaniesProvider>(context, listen: false).getCompanies(token);
  }

//-------------------- Pantalla ----------------------------
  @override
  Widget build(BuildContext context) {
    List<Company> companies = Provider.of<CompaniesProvider>(context).companies;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: ListView(
        physics: const ClampingScrollPhysics(),
        children: [
          PaginatedDataTable(
            columns: const [
              DataColumn(label: Text("Logo")),
              DataColumn(label: Text("ID")),
              DataColumn(label: Text("Nombre")),
              DataColumn(label: Text("Usuario Alta")),
              DataColumn(label: Text("Fecha Alta")),
              DataColumn(label: Text("Usuario Ult. Modif.")),
              DataColumn(label: Text("Fecha Ult. Modif.")),
              DataColumn(label: Text("Usuarios")),
              DataColumn(label: Text("Activa")),
              DataColumn(label: Text("Acciones")),
            ],
            source: CompaniesDTS(companies, context),
            header: const Text(
              "Empresas",
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
                text: "Nueva Empresa",
                onPressed: () {
                  showModalBottomSheet(
                    backgroundColor: Colors.transparent,
                    context: context,
                    builder: (_) => const CompanyModal(
                      company: null,
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

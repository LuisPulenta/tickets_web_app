import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tickets_web_app/datatables/companies_datasource.dart';
import 'package:tickets_web_app/models/models.dart';
import 'package:tickets_web_app/providers/companies_provider.dart';
import 'package:tickets_web_app/ui/buttons/custom_icon_button.dart';
import 'package:tickets_web_app/ui/inputs/custom_inputs.dart';
import 'package:tickets_web_app/ui/layouts/shared/widgets/loader_component.dart';
import 'package:tickets_web_app/ui/layouts/shared/widgets/search_text.dart';
import 'package:tickets_web_app/ui/modals/company_modal.dart';

class CompaniesView extends StatefulWidget {
  const CompaniesView({Key? key}) : super(key: key);

  @override
  State<CompaniesView> createState() => _CompaniesViewState();
}

class _CompaniesViewState extends State<CompaniesView> {
  int _rowsPerPage = PaginatedDataTable.defaultRowsPerPage;
  bool showLoader = true;

  //-------------------- initState ----------------------------

  @override
  void initState() {
    super.initState();
    Provider.of<CompaniesProvider>(context, listen: false).getCompanies();
    showLoader = false;
    setState(() {});
  }

//-------------------- Pantalla ----------------------------
  @override
  Widget build(BuildContext context) {
    final companiesProvider = Provider.of<CompaniesProvider>(context);
    List<Company> companies = Provider.of<CompaniesProvider>(context).companies;
    final size = MediaQuery.of(context).size;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: ListView(
        physics: const ClampingScrollPhysics(),
        children: [
          Stack(
            children: [
              PaginatedDataTable(
                sortAscending: companiesProvider.ascending,
                sortColumnIndex: companiesProvider.sortColumnIndex,
                columns: [
                  const DataColumn(
                      label: Text("Logo",
                          style: TextStyle(fontWeight: FontWeight.bold))),
                  const DataColumn(
                      label: Text("ID",
                          style: TextStyle(fontWeight: FontWeight.bold))),
                  DataColumn(
                      label: const Text("Nombre",
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      onSort: (colIndex, _) {
                        companiesProvider.sortColumnIndex = colIndex;
                        companiesProvider.sort<String>((user) => user.name);
                      }),
                  DataColumn(
                      label: const Text("Fecha y Usuario Alta",
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      onSort: (colIndex, _) {
                        companiesProvider.sortColumnIndex = colIndex;
                        companiesProvider
                            .sort<String>((user) => user.createDate.toString());
                      }),
                  const DataColumn(
                      label: Text("Fecha y Usuario Ult. Modif.",
                          style: TextStyle(fontWeight: FontWeight.bold))),
                  const DataColumn(
                      label: Text("Usuarios",
                          style: TextStyle(fontWeight: FontWeight.bold))),
                  const DataColumn(
                      label: Text("Activa",
                          style: TextStyle(fontWeight: FontWeight.bold))),
                  const DataColumn(
                      label: Text("Acciones",
                          style: TextStyle(fontWeight: FontWeight.bold))),
                ],
                source: CompaniesDTS(companies, context),
                header: Row(
                  children: [
                    const Text(
                      "Empresas",
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
                            companiesProvider.search = value;
                            companiesProvider.filter();
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
                          title: const Text('Sólo Activas',
                              style:
                                  TextStyle(color: Colors.black, fontSize: 16)),
                          value: companiesProvider.onlyActives,
                          onChanged: (value) {
                            companiesProvider.onlyActives = value!;
                            setState(() {});
                            companiesProvider.filter();
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
              showLoader
                  ? Positioned(
                      left: size.width * 0.5 - 300,
                      top: size.height * 0.5 - 50,
                      child: const LoaderComponent(
                        text: 'Cargando Empresas...',
                      ))
                  : Container()
            ],
          ),
        ],
      ),
    );
  }
}

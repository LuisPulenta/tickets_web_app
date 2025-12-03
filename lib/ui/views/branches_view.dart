import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../datatables/branches_datasource.dart';
import '../../models/models.dart';
import '../../providers/providers.dart';
import '../buttons/custom_icon_button.dart';
import '../inputs/custom_inputs.dart';
import '../layouts/shared/widgets/loader_component.dart';
import '../modals/branch_modal.dart';

class BranchesView extends StatefulWidget {
  const BranchesView({Key? key}) : super(key: key);

  @override
  State<BranchesView> createState() => _BranchesViewState();
}

class _BranchesViewState extends State<BranchesView> {
  int _rowsPerPage = PaginatedDataTable.defaultRowsPerPage;
  bool showLoader = true;

  //-------------------- initState ----------------------------

  @override
  void initState() {
    super.initState();
    Provider.of<BranchesProvider>(context, listen: false).getBranches();
    showLoader = false;
    setState(() {});
  }

  //-------------------- Pantalla ----------------------------
  @override
  Widget build(BuildContext context) {
    final branchesProvider = Provider.of<BranchesProvider>(context);
    final size = MediaQuery.of(context).size;
    List<Branch> branches = Provider.of<BranchesProvider>(context).branches;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: ListView(
        physics: const ClampingScrollPhysics(),
        children: [
          Stack(
            children: [
              PaginatedDataTable(
                columnSpacing: 10.0,
                sortAscending: branchesProvider.ascending,
                sortColumnIndex: branchesProvider.sortColumnIndex,
                columns: [
                  const DataColumn(
                      label: Text('ID',
                          style: TextStyle(fontWeight: FontWeight.bold))),
                  DataColumn(
                      label: const Text('Nombre',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      onSort: (colIndex, _) {
                        branchesProvider.sortColumnIndex = colIndex;
                        branchesProvider.sort<String>((user) => user.name);
                      }),
                  DataColumn(
                      label: const Text('Fecha y Usuario Alta',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      onSort: (colIndex, _) {
                        branchesProvider.sortColumnIndex = colIndex;
                        branchesProvider
                            .sort<String>((user) => user.createDate.toString());
                      }),
                  const DataColumn(
                      label: Text('Fecha y Usuario Ult. Modif.',
                          style: TextStyle(fontWeight: FontWeight.bold))),
                  const DataColumn(
                      label: Text('Usuarios',
                          style: TextStyle(fontWeight: FontWeight.bold))),
                  const DataColumn(
                      label: Text('Activa',
                          style: TextStyle(fontWeight: FontWeight.bold))),
                  const DataColumn(
                      label: Text('Acciones',
                          style: TextStyle(fontWeight: FontWeight.bold))),
                ],
                source: BranchesDTS(branches, context),
                header: Row(
                  children: [
                    const Text(
                      'Sucursales',
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
                            hint: 'Buscar...',
                            icon: Icons.search_outlined,
                            onClear: () {
                              branchesProvider.search = '';
                              branchesProvider.filter();
                              branchesProvider.notify();
                            },
                          ),
                          onSubmitted: (value) {
                            branchesProvider.search = value;
                            branchesProvider.filter();
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
                          value: branchesProvider.onlyActives,
                          onChanged: (value) {
                            branchesProvider.onlyActives = value!;
                            setState(() {});
                            branchesProvider.filter();
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
                    text: 'Nueva Sucursal',
                    onPressed: () {
                      showModalBottomSheet(
                        backgroundColor: Colors.transparent,
                        context: context,
                        builder: (_) => const BranchModal(
                          branch: null,
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

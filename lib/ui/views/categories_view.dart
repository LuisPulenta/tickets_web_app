import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../datatables/categories_datasource.dart';
import '../../models/models.dart';
import '../../providers/categories_provider.dart';
import '../buttons/custom_icon_button.dart';
import '../inputs/custom_inputs.dart';
import '../layouts/shared/widgets/loader_component.dart';
import '../modals/category_modal.dart';

class CategoriesView extends StatefulWidget {
  const CategoriesView({Key? key}) : super(key: key);

  @override
  State<CategoriesView> createState() => _CategoriesViewState();
}

class _CategoriesViewState extends State<CategoriesView> {
  int _rowsPerPage = PaginatedDataTable.defaultRowsPerPage;
  bool showLoader = true;

  //-------------------- initState ----------------------------

  @override
  void initState() {
    super.initState();
    Provider.of<CategoriesProvider>(context, listen: false).getCategories();
    showLoader = false;
    setState(() {});
  }

//-------------------- Pantalla ----------------------------
  @override
  Widget build(BuildContext context) {
    final categoriesProvider = Provider.of<CategoriesProvider>(context);
    List<Category> categories =
        Provider.of<CategoriesProvider>(context).categories;
    final size = MediaQuery.of(context).size;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: ListView(
        physics: const ClampingScrollPhysics(),
        children: [
          Stack(
            children: [
              PaginatedDataTable(
                columnSpacing: 10.0,
                sortAscending: categoriesProvider.ascending,
                sortColumnIndex: categoriesProvider.sortColumnIndex,
                columns: [
                  const DataColumn(
                      label: Text('ID',
                          style: TextStyle(fontWeight: FontWeight.bold))),
                  DataColumn(
                      label: const Text('Nombre',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      onSort: (colIndex, _) {
                        categoriesProvider.sortColumnIndex = colIndex;
                        categoriesProvider.sort<String>((user) => user.name);
                      }),
                  const DataColumn(
                    label: Text(
                      'Subcategorías',
                    ),
                  ),
                  const DataColumn(
                      label: Text('Acciones',
                          style: TextStyle(fontWeight: FontWeight.bold))),
                ],
                source: CategoriesDTS(categories, context),
                header: Row(
                  children: [
                    const Text(
                      'Categorías',
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
                              hint: 'Buscar...', icon: Icons.search_outlined),
                          onSubmitted: (value) {
                            categoriesProvider.search = value;
                            categoriesProvider.filter();
                          },
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 50,
                    ),
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
                    text: 'Nueva Categoría',
                    onPressed: () {
                      showModalBottomSheet(
                        backgroundColor: Colors.transparent,
                        context: context,
                        builder: (_) => const CategoryModal(
                          category: null,
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

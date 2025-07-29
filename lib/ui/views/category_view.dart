import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tickets_web_app/datatables/subcategories_datasource.dart';
import 'package:tickets_web_app/providers/providers.dart';
import 'package:tickets_web_app/services/local_storage.dart';
import 'package:tickets_web_app/ui/buttons/custom_icon_button.dart';
import 'package:tickets_web_app/ui/inputs/custom_inputs.dart';
import 'package:tickets_web_app/ui/layouts/shared/widgets/loader_component.dart';
import 'package:tickets_web_app/ui/modals/subcategory_modal.dart';

import '../../models/models.dart';

class CategoryView extends StatefulWidget {
  final String id;
  const CategoryView({Key? key, required this.id}) : super(key: key);

  @override
  State<CategoryView> createState() => _CategoryViewState();
}

class _CategoryViewState extends State<CategoryView> {
  //----------------------------------------------------------------------
  int _rowsPerPage = PaginatedDataTable.defaultRowsPerPage;
  bool showLoader = false;
  late Token token;
  String userTypeLogged = "";

  //----------------------------------------------------------------------
  @override
  void initState() {
    showLoader = true;

    final userBody = LocalStorage.prefs.getString('tickets-userBody');
    var decodedJson = jsonDecode(userBody!);
    token = Token.fromJson(decodedJson);
    userTypeLogged = token.user.userTypeName;

    setState(() {});
    getCategory();

    showLoader = false;
    setState(() {});
  }

  //-------------------- getCategory ----------------------------

  void getCategory() {
    final categoriesProvider =
        Provider.of<CategoriesProvider>(context, listen: false);
    final subcategoriesProvider =
        Provider.of<SubcategoriesProvider>(context, listen: false);
    categoriesProvider.getCategoryById(widget.id).then(
          (categoryDB) => setState(
            () {
              subcategoriesProvider.category = categoryDB;
              subcategoriesProvider.subcategories =
                  subcategoriesProvider.category!.subcategories!;
            },
          ),
        );
  }

  //-------------------- Pantalla ----------------------------
  @override
  Widget build(BuildContext context) {
    final categoriesProvider = Provider.of<CategoriesProvider>(context);
    final subcategoriesProvider = Provider.of<SubcategoriesProvider>(context);
    List<Subcategory> subcategories =
        Provider.of<SubcategoriesProvider>(context).subcategories;
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
                sortColumnIndex: subcategoriesProvider.sortColumnIndex,
                columns: [
                  const DataColumn(
                      label: Text("ID",
                          style: TextStyle(fontWeight: FontWeight.bold))),
                  DataColumn(
                      label: const Text("Nombre",
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      onSort: (colIndex, _) {
                        subcategoriesProvider.sortColumnIndex = colIndex;
                        subcategoriesProvider.sort<String>((user) => user.name);
                      }),
                  const DataColumn(
                      label: Text("Acciones",
                          style: TextStyle(fontWeight: FontWeight.bold))),
                ],
                source: SubcategoriesDTS(subcategories, context, widget.id,
                    subcategoriesProvider.category!),
                header: Row(
                  children: [
                    Text(
                      "Categoría: ${subcategoriesProvider.category!.name}",
                      style: const TextStyle(
                          color: Colors.black,
                          fontSize: 28,
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      width: 50,
                    ),
                    const Text(
                      "Subcategorías",
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
                    text: "Nueva Subcategoría",
                    onPressed: () async {
                      await showModalBottomSheet(
                        backgroundColor: Colors.transparent,
                        context: context,
                        builder: (_) => SubcategoryModal(
                          subcategory: null,
                          category: subcategoriesProvider.category!,
                        ),
                      );
                      getCategory();
                    },
                  ),
                ],
              ),
              showLoader
                  ? Positioned(
                      left: size.width * 0.5 - 300,
                      top: size.height * 0.5 - 50,
                      child: const LoaderComponent(
                        text: 'Cargando Subcategorías...',
                      ))
                  : Container()
            ],
          ),
        ],
      ),
    );
  }
}

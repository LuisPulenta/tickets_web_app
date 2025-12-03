import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/models.dart';
import '../providers/providers.dart';
import '../ui/modals/subcategory_modal.dart';

class SubcategoriesDTS extends DataTableSource {
  List<Subcategory> subcategories;
  final BuildContext context;
  final String categoryId;
  final Category category;

  SubcategoriesDTS(
      this.subcategories, this.context, this.categoryId, this.category);

  @override
  DataRow getRow(int index) {
    final subcategory = subcategories[index];

    return DataRow.byIndex(
      index: index,
      cells: [
        DataCell(
          Text(subcategory.id.toString()),
        ),
        DataCell(
          Text(subcategory.name,
              style: const TextStyle(
                  color: Color.fromARGB(255, 12, 5, 228),
                  fontWeight: FontWeight.bold)),
        ),
        DataCell(
          Row(
            children: [
              IconButton(
                tooltip: 'Editar Categoría',
                onPressed: () async {
                  await showModalBottomSheet(
                    backgroundColor: Colors.transparent,
                    context: context,
                    builder: (_) => SubcategoryModal(
                      subcategory: subcategory,
                      category: category,
                    ),
                  );
                  getCategory();
                },
                icon: const Icon(Icons.edit_outlined, color: Colors.orange),
              ),
              IconButton(
                tooltip: 'Borrar Subcategoría',
                onPressed: () async {
                  final dialog = AlertDialog(
                    title: const Text('Atención!!'),
                    content: Text(
                        'Está seguro de borrar la subcategoría ${subcategory.name}?'),
                    actions: [
                      TextButton(
                        onPressed: () async {
                          final subcategoriesProvider =
                              Provider.of<SubcategoriesProvider>(context,
                                  listen: false);
                          await subcategoriesProvider.deleteSubcategory(
                              subcategory.id.toString(), categoryId);
                          Navigator.of(context).pop();
                          await getCategory();
                        },
                        child: const Text('Si'),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text('No'),
                      ),
                    ],
                  );
                  showDialog(context: context, builder: (_) => dialog);
                },
                icon: const Icon(
                  Icons.delete_outline_outlined,
                  color: Colors.red,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  //-------------------- getCategory ----------------------------

  Future<void> getCategory() async {
    final categoriesProvider =
        Provider.of<CategoriesProvider>(context, listen: false);
    final subcategoriesProvider =
        Provider.of<SubcategoriesProvider>(context, listen: false);
    subcategoriesProvider.category =
        await categoriesProvider.getCategoryById(categoryId);
    subcategoriesProvider.subcategories =
        subcategoriesProvider.category!.subcategories!;
    subcategories = subcategoriesProvider.subcategories;
    subcategoriesProvider.refresh();
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => subcategories.length;

  @override
  int get selectedRowCount => 0;
}

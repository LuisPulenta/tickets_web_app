import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/models.dart';
import '../providers/categories_provider.dart';
import '../services/navigation_services.dart';
import '../ui/modals/category_modal.dart';

class CategoriesDTS extends DataTableSource {
  final List<Category> categories;
  final BuildContext context;

  CategoriesDTS(this.categories, this.context);

  @override
  DataRow getRow(int index) {
    final category = categories[index];

    return DataRow.byIndex(
      index: index,
      cells: [
        DataCell(
          Text(category.id.toString()),
        ),
        DataCell(
          Text(category.name,
              style: const TextStyle(
                  color: Color.fromARGB(255, 12, 5, 228),
                  fontWeight: FontWeight.bold)),
        ),
        DataCell(
          category.subcategoriesNumber != 0
              ? Text(category.subcategoriesNumber.toString(),
                  style: const TextStyle(fontSize: 12))
              : Container(),
        ),
        DataCell(
          Row(
            children: [
              IconButton(
                tooltip: 'Ver Subcategorías',
                onPressed: () {
                  NavigationServices.replaceTo(
                      '/dashboard/categories/${category.id}');
                },
                icon: const Icon(Icons.remove_red_eye_outlined,
                    color: Colors.blue),
              ),
              IconButton(
                tooltip: 'Editar Categoría',
                onPressed: () {
                  showModalBottomSheet(
                    backgroundColor: Colors.transparent,
                    context: context,
                    builder: (_) => CategoryModal(
                      category: category,
                    ),
                  );
                },
                icon: const Icon(Icons.edit_outlined, color: Colors.orange),
              ),
              category.subcategoriesNumber == 0
                  ? IconButton(
                      tooltip: 'Borrar Categoría',
                      onPressed: () {
                        final dialog = AlertDialog(
                          title: const Text('Atención!!'),
                          content: Text(
                              'Está seguro de borrar la categoría ${category.name}?'),
                          actions: [
                            TextButton(
                              onPressed: () async {
                                final categoriesProvider =
                                    Provider.of<CategoriesProvider>(context,
                                        listen: false);
                                await categoriesProvider
                                    .deleteCategory(category.id.toString());
                                Navigator.of(context).pop();
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
                    )
                  : Container(),
            ],
          ),
        ),
      ],
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => categories.length;

  @override
  int get selectedRowCount => 0;
}

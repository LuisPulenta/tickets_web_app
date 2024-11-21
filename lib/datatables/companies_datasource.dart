import 'package:flutter/material.dart';
import 'package:tickets_web_app/models/http/company.dart';

class CompaniesDTS extends DataTableSource {
  final List<Company> companies;
  final BuildContext context;

  CompaniesDTS(this.companies, this.context);

  @override
  DataRow getRow(int index) {
    final company = companies[index];
    return DataRow.byIndex(
      index: index,
      cells: [
        DataCell(
          Text(company.id.toString()),
        ),
        DataCell(
          Text(company.name),
        ),
        DataCell(
          Text(company.users != null ? company.users.toString() : ''),
        ),
        DataCell(
          Row(
            children: [
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.edit_outlined, color: Colors.orange),
              ),
              IconButton(
                onPressed: () {
                  final dialog = AlertDialog(
                    title: const Text("Atención!!"),
                    content: Text(
                        "Está seguro de borrar la empresa ${company.name}?"),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text("Si"),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text("No"),
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

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => companies.length;

  @override
  int get selectedRowCount => 0;
}

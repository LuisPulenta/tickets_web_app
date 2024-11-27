import 'package:flutter/material.dart';

import 'package:intl/intl.dart';
import 'package:tickets_web_app/models/models.dart';
import 'package:tickets_web_app/ui/modals/company_modal.dart';

class CompaniesDTS extends DataTableSource {
  final List<Company> companies;
  final BuildContext context;

  CompaniesDTS(this.companies, this.context);

  @override
  DataRow getRow(int index) {
    final company = companies[index];

    final image = FadeInImage.assetNetwork(
      placeholder: 'loader.gif',
      image: company.photoFullPath,
      width: 35,
      height: 35,
    );

    return DataRow.byIndex(
      index: index,
      cells: [
        DataCell(
          SizedBox(width: 160, height: 80, child: image),
        ),
        DataCell(
          Text(company.id.toString()),
        ),
        DataCell(
          Text(company.name,
              style: const TextStyle(
                  color: Color.fromARGB(255, 12, 5, 228),
                  fontWeight: FontWeight.bold)),
        ),
        DataCell(
          Text(
              '${DateFormat('dd/MM/yyyy').format(DateTime.parse(company.createDate.toString()))}-${company.createUser}',
              style: const TextStyle(fontSize: 12)),
        ),
        DataCell(
          Text(
              '${DateFormat('dd/MM/yyyy').format(DateTime.parse(company.lastChangeDate.toString()))}-${company.lastChangeUser}',
              style: const TextStyle(fontSize: 12)),
        ),
        DataCell(
          Text(company.usersNumber.toString(),
              style: const TextStyle(fontSize: 12)),
        ),
        DataCell(
          Text(company.active ? "Sí" : 'No',
              style: TextStyle(
                  fontSize: 12,
                  color: company.active ? Colors.green : Colors.red)),
        ),
        DataCell(
          Row(
            children: [
              IconButton(
                onPressed: () {
                  showModalBottomSheet(
                    backgroundColor: Colors.transparent,
                    context: context,
                    builder: (_) => CompanyModal(
                      company: company,
                    ),
                  );
                },
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

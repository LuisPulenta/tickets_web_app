import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../models/models.dart';
import '../providers/branches_provider.dart';
import '../ui/modals/branch_modal.dart';

class BranchesDTS extends DataTableSource {
  final List<Branch> branches;
  final BuildContext context;

  BranchesDTS(this.branches, this.context);

  @override
  DataRow getRow(int index) {
    final branch = branches[index];

    return DataRow.byIndex(
      index: index,
      cells: [
        DataCell(
          Text(branch.id.toString()),
        ),
        DataCell(
          Text(branch.name,
              style: const TextStyle(
                  color: Color.fromARGB(255, 12, 5, 228),
                  fontWeight: FontWeight.bold)),
        ),
        DataCell(
          Text(
              '${DateFormat('dd/MM/yyyy').format(DateTime.parse(branch.createDate.toString()))}-${branch.createUserName}',
              style: const TextStyle(fontSize: 12)),
        ),
        DataCell(
          Text(
              '${DateFormat('dd/MM/yyyy').format(DateTime.parse(branch.lastChangeDate.toString()))}-${branch.lastChangeUserName}',
              style: const TextStyle(fontSize: 12)),
        ),
        DataCell(
          branch.usersNumber != 0
              ? Text(branch.usersNumber.toString(),
                  style: const TextStyle(fontSize: 12))
              : Container(),
        ),
        DataCell(
          Text(branch.active ? 'Sí' : 'No',
              style: TextStyle(
                  fontSize: 12,
                  color: branch.active ? Colors.green : Colors.red)),
        ),
        DataCell(
          Row(
            children: [
              IconButton(
                tooltip: 'Editar Sucursal',
                onPressed: () {
                  showModalBottomSheet(
                    backgroundColor: Colors.transparent,
                    context: context,
                    builder: (_) => BranchModal(
                      branch: branch,
                    ),
                  );
                },
                icon: const Icon(Icons.edit_outlined, color: Colors.orange),
              ),
              branch.usersNumber == 0
                  ? IconButton(
                      tooltip: 'Borrar Sucursal',
                      onPressed: () {
                        final dialog = AlertDialog(
                          title: const Text('Atención!!'),
                          content: Text(
                              'Está seguro de borrar la Sucursal ${branch.name}?'),
                          actions: [
                            TextButton(
                              onPressed: () async {
                                final companiesProvider =
                                    Provider.of<BranchesProvider>(context,
                                        listen: false);
                                await companiesProvider
                                    .deleteBranch(branch.id.toString());
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
  int get rowCount => branches.length;

  @override
  int get selectedRowCount => 0;
}

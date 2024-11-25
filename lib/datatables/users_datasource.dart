import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tickets_web_app/models/http/user.dart';

class UsersDTS extends DataTableSource {
  final List<User> users;
  final BuildContext context;

  UsersDTS(this.users, this.context);

  @override
  DataRow getRow(int index) {
    final user = users[index];

    return DataRow.byIndex(
      index: index,
      cells: [
        DataCell(
          Text(user.company,
              style: const TextStyle(
                  color: Color.fromARGB(255, 12, 5, 228),
                  fontWeight: FontWeight.bold)),
        ),
        DataCell(
          Text('${user.lastName} ${user.firstName}',
              style: const TextStyle(
                  color: Color.fromARGB(255, 12, 5, 228),
                  fontWeight: FontWeight.bold)),
        ),
        DataCell(
          Text(user.email),
        ),
        DataCell(
          Text(user.emailConfirmed ? "Sí" : 'No',
              style: TextStyle(
                  fontSize: 12,
                  color: user.emailConfirmed ? Colors.green : Colors.red)),
        ),
        DataCell(
          Text(user.active ? "Sí" : 'No',
              style: TextStyle(
                  fontSize: 12,
                  color: user.active ? Colors.green : Colors.red)),
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
                        "Está seguro de borrar el Usuario ${user.lastName} ${user.firstName} ?"),
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
  int get rowCount => users.length;

  @override
  int get selectedRowCount => 0;
}

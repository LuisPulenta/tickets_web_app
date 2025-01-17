import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:tickets_web_app/models/models.dart';
import 'package:tickets_web_app/providers/providers.dart';
import 'package:tickets_web_app/ui/modals/user_modal.dart';

class UsersDTS extends DataTableSource {
  final List<User> users;
  final BuildContext context;

  UsersDTS(this.users, this.context);

  @override
  DataRow getRow(int index) {
    final user = users[index];
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    return DataRow.byIndex(
      index: index,
      cells: [
        DataCell(
          Text(user.companyName,
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
          user.tickets.isNotEmpty
              ? Text('${user.tickets.length}',
                  style: const TextStyle(
                      color: Color.fromARGB(255, 12, 5, 228),
                      fontWeight: FontWeight.bold))
              : const Text(''),
        ),
        DataCell(
          Text(user.email),
        ),
        DataCell(
          Text(user.emailConfirm ? "Sí" : 'No',
              style: TextStyle(
                  fontSize: 12,
                  color: user.emailConfirm ? Colors.green : Colors.red)),
        ),
        DataCell(
          Text(user.phoneNumber),
        ),
        DataCell(
          Text(
              user.userTypeId == 0
                  ? 'AdminKP'
                  : user.userTypeId == 1
                      ? 'Admin'
                      : 'Usuario',
              style: user.userTypeId == 0
                  ? const TextStyle(fontWeight: FontWeight.bold)
                  : const TextStyle(fontWeight: FontWeight.normal)),
        ),
        DataCell(
          Text(user.active ? "Sí" : 'No',
              style: TextStyle(
                  fontSize: 12,
                  color: user.active ? Colors.green : Colors.red)),
        ),
        DataCell(
          Text(
              '${DateFormat('dd/MM/yyyy').format(DateTime.parse(user.lastChangeDate.toString()))}-${user.lastChangeUserName}',
              style: const TextStyle(fontSize: 12)),
        ),
        DataCell(
          Row(
            children: [
              user.emailConfirm
                  ? Container()
                  : IconButton(
                      tooltip: 'Reenviar Mail de Confirmación de Cuenta',
                      onPressed: () {
                        authProvider.resendEmail(user.email);
                      },
                      icon: const Icon(Icons.outgoing_mail, color: Colors.blue),
                    ),
              IconButton(
                tooltip: 'Editar Usuario',
                onPressed: () {
                  showModalBottomSheet(
                    backgroundColor: Colors.transparent,
                    context: context,
                    builder: (_) => UserModal(
                      user: user,
                    ),
                  );
                },
                icon: const Icon(Icons.edit_outlined, color: Colors.orange),
              ),
              user.tickets.isNotEmpty
                  ? Container()
                  : IconButton(
                      tooltip: 'Borrar Usuario',
                      onPressed: () {
                        final dialog = AlertDialog(
                          title: const Text("Atención!!"),
                          content: Text(
                              "Está seguro de borrar el Usuario ${user.lastName} ${user.firstName} ?"),
                          actions: [
                            TextButton(
                              onPressed: () async {
                                final usersProvider =
                                    Provider.of<UsersProvider>(context,
                                        listen: false);

                                final userLoggedId = Provider.of<AuthProvider>(
                                        context,
                                        listen: false)
                                    .user!
                                    .id;

                                await usersProvider
                                    .deleteUser(
                                      user.id,
                                      userLoggedId,
                                    )
                                    .then((value) =>
                                        {Navigator.of(context).pop()});
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

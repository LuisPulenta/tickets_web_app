import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../helpers/constants.dart';
import '../models/models.dart';
import '../services/services.dart';

class TicketCabsAuthorizeDTS extends DataTableSource {
  final List<TicketCab> ticketCabsAuthorize;
  final BuildContext context;

  TicketCabsAuthorizeDTS(this.ticketCabsAuthorize, this.context);

  @override
  DataRow getRow(int index) {
    final ticketCab = ticketCabsAuthorize[index];

    return DataRow.byIndex(
      index: index,
      cells: [
        DataCell(
          Text(ticketCab.id.toString()),
        ),
        DataCell(
          Text(ticketCab.companyName,
              style: const TextStyle(
                  color: Color.fromARGB(255, 12, 5, 228),
                  fontWeight: FontWeight.bold)),
        ),
        DataCell(
          Text(
              '${DateFormat('dd/MM/yyyy').format(DateTime.parse(ticketCab.createDate.toString()))}-${ticketCab.createUserName}',
              style: const TextStyle(fontSize: 12)),
        ),
        DataCell(
          Text(ticketCab.categoryName,
              style: const TextStyle(
                  color: Color.fromARGB(255, 12, 5, 228),
                  fontWeight: FontWeight.bold)),
        ),
        DataCell(
          Text(ticketCab.subcategoryName,
              style: const TextStyle(
                  color: Color.fromARGB(255, 12, 5, 228),
                  fontWeight: FontWeight.bold)),
        ),
        DataCell(
          Text(ticketCab.title,
              style: const TextStyle(
                  color: Color.fromARGB(255, 12, 5, 228),
                  fontWeight: FontWeight.bold)),
        ),
        DataCell(
          Text(
            '${Constants.estados[ticketCab.ticketState]} ${ticketCab.userAsignName}',
            style: const TextStyle(
              color: Color.fromARGB(255, 12, 5, 228),
            ),
          ),
        ),
        DataCell(
          Text(
            ticketCab.ticketDetsNumber.toString(),
            style: const TextStyle(color: Colors.black),
          ),
        ),
        DataCell(
          Row(
            children: [
              IconButton(
                tooltip: 'Editar Ticket',
                onPressed: () {
                  NavigationServices.replaceTo(
                      '/dashboard/tickets/${ticketCab.id}');
                },
                icon: const Icon(Icons.edit_outlined, color: Colors.orange),
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
  int get rowCount => ticketCabsAuthorize.length;

  @override
  int get selectedRowCount => 0;
}

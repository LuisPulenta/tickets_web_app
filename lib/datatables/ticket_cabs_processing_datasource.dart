import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../helpers/helpers.dart';
import '../models/models.dart';
import '../providers/providers.dart';
import '../services/services.dart';

class TicketCabsProcessingDTS extends DataTableSource {
  final List<TicketCab> ticketCabsProcessing;
  final BuildContext context;

  TicketCabsProcessingDTS(this.ticketCabsProcessing, this.context);

  @override
  DataRow getRow(int index) {
    final ticketCab = ticketCabsProcessing[index];

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
          Row(
            children: [
              ticketCab.lastDate != ''
                  ? Text(
                      DateFormat('dd/MM/yyyy').format(
                          DateTime.parse(ticketCab.lastDate.toString())),
                      style: const TextStyle(fontSize: 12))
                  : Container(),
              const SizedBox(
                width: 10,
              ),
              (ticketCab.lastDate != '' &&
                      (DateTime.parse(ticketCab.lastDate.toString())
                          .add(const Duration(days: 7))
                          .isBefore(DateTime.now())))
                  ? const Icon(
                      Icons.watch_later,
                      color: Colors.red,
                      size: 18,
                    )
                  : Container()
            ],
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
              if (ticketCab.lastDate != '' &&
                  (DateTime.parse(ticketCab.lastDate.toString())
                      .add(const Duration(days: 7))
                      .isBefore(DateTime.now())))
                IconButton(
                  tooltip: 'Cerrar Ticket',
                  onPressed: () {
                    final dialog = AlertDialog(
                      title: const Text('Atención!!'),
                      content: Text(
                          'Está seguro de cerrar el Ticket ${ticketCab.id}?'),
                      actions: [
                        TextButton(
                          onPressed: () async {
                            onFormSubmit(
                                ticketCab,
                                Provider.of<TicketFormProvider>(context,
                                    listen: false),
                                Provider.of<AuthProvider>(context,
                                        listen: false)
                                    .user!
                                    .fullName,
                                Provider.of<AuthProvider>(context,
                                        listen: false)
                                    .user!
                                    .companyName,
                                6);
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
                  icon: const Icon(Icons.close, color: Colors.red),
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
  int get rowCount => ticketCabsProcessing.length;

  @override
  int get selectedRowCount => 0;

//--------------------------------------------------------------------------------------
  void onFormSubmit(
    TicketCab ticketCab,
    TicketFormProvider ticketFormProvider,
    String userLogged,
    String companyLogged,
    int estado,
  ) async {
    try {
      final ticketsCabsProvider2 =
          Provider.of<TicketCabsProvider>(context, listen: false);

      Response response = await ApiHelper.getUser(ticketCab.createUserId);
      User userTicket = response.result;
      String emailUserTicket = userTicket.email;
      String emailUserSelected = '';

      ticketFormProvider.userAsign == '';
      ticketFormProvider.userAsignName == '';

      await ticketsCabsProvider2.newTicketDet(
        ticketCab,
        userLogged,
        companyLogged,
        ticketFormProvider.description,
        ticketFormProvider.photoChanged ? ticketFormProvider.base64Image : '',
        estado,
        ticketFormProvider.userAsign,
        ticketFormProvider.userAsignName,
        ticketFormProvider.userAuthorize,
        ticketFormProvider.userAuthorizeName,
        ticketFormProvider.photoChanged ? ticketFormProvider.fileName : '',
        ticketFormProvider.photoChanged ? ticketFormProvider.fileExtension : '',
      );

      String ticketStateName = 'Cerrado';

      await Provider.of<TicketCabsProcessingProvider>(context, listen: false)
          .getTicketProcessingCabs(
              Provider.of<AuthProvider>(context, listen: false).user!.id);

      _sendEmail(
          estado,
          ticketCab.id,
          emailUserTicket,
          emailUserSelected,
          ticketCab.companyId,
          ticketCab.categoryName,
          ticketCab.subcategoryName);
      ticketFormProvider.description = '';
    } catch (e) {
      NotificationsService.showSnackbarError('No se pudo guardar el Ticket');
    }
  }

//---------------------------------------------------------------------------------------
  void _sendEmail(
      int estado,
      int nroTicket,
      String emailUserTicket,
      String emailUserSelected,
      int companyTicketId,
      String categoryName,
      String subcategoryName) async {
    String emailUserLogged =
        Provider.of<AuthProvider>(context, listen: false).user!.email;
    int companyLoggedId =
        Provider.of<AuthProvider>(context, listen: false).user!.companyId;

    Response response = await ApiHelper.getMailsAdmin(companyTicketId);
    EmailResponse emailResponse = response.result;

    String emailsAdmin = emailResponse.emails;

    Response response2 = await ApiHelper.getMailsAdminKP();
    EmailResponse emailResponse2 = response2.result;

    String emailsAdminKP = emailResponse2.emails;

    String to = '';
    String cc = '';
    String subject = '';
    String body = '';

    to = emailUserTicket;
    cc = emailUserLogged;
    subject =
        'TicketN N° $nroTicket CERRADO - Categoría: $categoryName - Subcategoría: $subcategoryName';
    body = '''
Se ha cerrado el Ticket N° $nroTicket que estaba como devuelto hace más de 15 días.<br>
Haga clic aquí --> <a href="https://gaos2.keypress.com.ar/TicketsWeb" style="color: blue;">Ir al ticket</a>
''';

    Map<String, dynamic> request = {
      'to': to,
      'cc': cc,
      'subject': subject,
      'body': body,
    };

    try {
      await ApiHelper.sendMail(request);
    } catch (e) {
      return null;
    }
  }

//---------------------------------------------------------------------
  void navigateTo(String routeName) {
    NavigationServices.navigateTo(routeName);
    SideMenuProvider.closeMenu();
  }
}

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../datatables/ticket_cabs_processing_datasource.dart';
import '../../helpers/helpers.dart';
import '../../models/models.dart';
import '../../providers/providers.dart';
import '../../services/services.dart';
import '../buttons/custom_icon_button.dart';
import '../inputs/custom_inputs.dart';
import '../layouts/shared/widgets/loader_component.dart';

class TicketsProcessingView extends StatefulWidget {
  const TicketsProcessingView({Key? key}) : super(key: key);

  @override
  State<TicketsProcessingView> createState() => _TicketsProcessingViewState();
}

class _TicketsProcessingViewState extends State<TicketsProcessingView> {
  int _rowsPerPage = PaginatedDataTable.defaultRowsPerPage;
  late Token token;
  String userTypeLogged = '';
  int companyIdLogged = -1;

//--------------- getTickets -------------------

  Future<void> getTickets() async {
    final userBody = LocalStorage.prefs.getString('tickets-userBody');
    var decodedJson = jsonDecode(userBody!);
    Token token = Token.fromJson(decodedJson);
    String userIdLogged = token.user.id;
    await Provider.of<TicketCabsProcessingProvider>(context, listen: false)
        .getTicketProcessingCabs(userIdLogged);
    setState(() {});
  }

  //-------------------- initState ----------------------------

  @override
  void initState() {
    super.initState();
    getTickets();
  }

//-------------------- Pantalla ----------------------------
  @override
  Widget build(BuildContext context) {
    final ticketCabsProcessingProvider =
        Provider.of<TicketCabsProcessingProvider>(context);
    List<TicketCab> ticketCabsProcessing =
        Provider.of<TicketCabsProcessingProvider>(context).ticketCabsProcessing;

    if (ticketCabsProcessingProvider.showLoader) {
      return const Center(child: LoaderComponent(text: 'Cargando Tickets...'));
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: ListView(
        physics: const ClampingScrollPhysics(),
        children: [
          Stack(
            children: [
              PaginatedDataTable(
                columnSpacing: 10.0,
                sortAscending: ticketCabsProcessingProvider.ascending,
                sortColumnIndex: ticketCabsProcessingProvider.sortColumnIndex,
                columns: [
                  const DataColumn(
                      label: Text('ID',
                          style: TextStyle(fontWeight: FontWeight.bold))),
                  DataColumn(
                      label: const Text('Empresa',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      onSort: (colIndex, _) {
                        ticketCabsProcessingProvider.sortColumnIndex = colIndex;
                        ticketCabsProcessingProvider
                            .sort<String>((item) => item.companyName);
                      }),
                  DataColumn(
                      label: const Text('Fecha y Usuario Alta',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      onSort: (colIndex, _) {
                        ticketCabsProcessingProvider.sortColumnIndex = colIndex;
                        ticketCabsProcessingProvider
                            .sort<String>((item) => item.createDate.toString());
                      }),
                  DataColumn(
                      label: const Text('Categoría',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      onSort: (colIndex, _) {
                        ticketCabsProcessingProvider.sortColumnIndex = colIndex;
                        ticketCabsProcessingProvider
                            .sort<String>((item) => item.categoryName);
                      }),
                  DataColumn(
                      label: const Text('Subcategoría',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      onSort: (colIndex, _) {
                        ticketCabsProcessingProvider.sortColumnIndex = colIndex;
                        ticketCabsProcessingProvider
                            .sort<String>((item) => item.subcategoryName);
                      }),
                  DataColumn(
                      label: const Text('Asunto',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      onSort: (colIndex, _) {
                        ticketCabsProcessingProvider.sortColumnIndex = colIndex;
                        ticketCabsProcessingProvider
                            .sort<String>((item) => item.title);
                      }),
                  DataColumn(
                      label: const Text('Estado',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      onSort: (colIndex, _) {
                        ticketCabsProcessingProvider.sortColumnIndex = colIndex;
                        ticketCabsProcessingProvider
                            .sort<String>((item) => item.title);
                      }),
                  DataColumn(
                      label: const Text('Fec. Ult.Modif.',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      onSort: (colIndex, _) {
                        ticketCabsProcessingProvider.sortColumnIndex = colIndex;
                        ticketCabsProcessingProvider
                            .sort<String>((item) => item.title);
                      }),
                  DataColumn(
                      label: const Text('Registros',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      onSort: (colIndex, _) {
                        ticketCabsProcessingProvider.sortColumnIndex = colIndex;
                        ticketCabsProcessingProvider
                            .sort<String>((item) => item.title);
                      }),
                  const DataColumn(
                      label: Text('Acciones',
                          style: TextStyle(fontWeight: FontWeight.bold))),
                ],
                source: TicketCabsProcessingDTS(ticketCabsProcessing, context),
                header: Row(
                  children: [
                    const Text(
                      'Tickets en proceso',
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
                            hint: 'Buscar...',
                            icon: Icons.search_outlined,
                            onClear: () {
                              ticketCabsProcessingProvider.search = '';
                              ticketCabsProcessingProvider.filter();
                              ticketCabsProcessingProvider.notify();
                            },
                          ),
                          onSubmitted: (value) {
                            ticketCabsProcessingProvider.search = value;
                            ticketCabsProcessingProvider.filter();
                          },
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    const Icon(
                      Icons.watch_later,
                      color: Colors.red,
                      size: 18,
                    ),
                    const Text(': Tickets devueltos hace más de 15 días  -->  ',
                        style: TextStyle(
                          color: Colors.red,
                        )),
                    CustomIconButton(
                      icon: Icons.close,
                      color: Colors.red,
                      text: 'Cerrarlos',
                      onPressed: () {
                        final dialog = AlertDialog(
                          title: const Text('Atención!!'),
                          content: const Text(
                              'Está seguro de cerrar todos los Tickets devueltos hace al menos 15 días?'),
                          actions: [
                            TextButton(
                              onPressed: () async {
                                _cerrarTickets();
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
                    )
                  ],
                ),
                rowsPerPage: _rowsPerPage,
                onRowsPerPageChanged: (value) {
                  _rowsPerPage = value ?? 10;
                  setState(() {});
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  //-----------------------------------------------------------
  void _cerrarTickets() {
    List<TicketCab> ticketCabsProcessing =
        Provider.of<TicketCabsProcessingProvider>(context, listen: false)
            .ticketCabsProcessing;

    for (TicketCab ticket in ticketCabsProcessing) {
      if (ticket.lastDate != null &&
          (DateTime.parse(ticket.lastDate)
              .add(const Duration(days: 7))
              .isBefore(DateTime.now()))) {
        onFormSubmit(
            ticket,
            Provider.of<TicketFormProvider>(context, listen: false),
            Provider.of<AuthProvider>(context, listen: false).user!.fullName,
            Provider.of<AuthProvider>(context, listen: false).user!.companyName,
            6);
      }
    }
  }

//---------------------------------------------------------------------------------------
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
}

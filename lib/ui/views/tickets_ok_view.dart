import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../datatables/ticket_cabs_ok_datasource.dart';
import '../../models/models.dart';
import '../../providers/providers.dart';
import '../../services/services.dart';
import '../inputs/custom_inputs.dart';
import '../layouts/shared/widgets/loader_component.dart';

class TicketsOkView extends StatefulWidget {
  const TicketsOkView({Key? key}) : super(key: key);

  @override
  State<TicketsOkView> createState() => _TicketsOkViewState();
}

class _TicketsOkViewState extends State<TicketsOkView> {
  int _rowsPerPage = PaginatedDataTable.defaultRowsPerPage;

  late Token token;
  int companyIdLogged = -1;
  DateTime desde = DateTime.now().add(const Duration(days: -30));

  DateTime hasta = DateTime.now();

  //--------------- getTickets -------------------

  Future<void> getTickets() async {
    final userBody = LocalStorage.prefs.getString('tickets-userBody');
    var decodedJson = jsonDecode(userBody!);
    Token token = Token.fromJson(decodedJson);
    int userTypeLogged = token.user.userTypeId;
    String userIdLogged = token.user.id;
    int companyIdLogged = token.user.companyId;
    await Provider.of<TicketCabsOkProvider>(context, listen: false)
        .getTicketOkCabs(
            userTypeLogged, userIdLogged, companyIdLogged, desde, hasta);
    setState(() {});
  }

  //-------------------- initState ----------------------------

  @override
  void initState() {
    super.initState();
    desde = DateTime.now().add(
      const Duration(days: -30),
    );
    hasta = DateTime.now();
    getTickets();
  }

//-------------------- Pantalla ----------------------------
  @override
  Widget build(BuildContext context) {
    final ticketCabsOkProvider = Provider.of<TicketCabsOkProvider>(context);
    List<TicketCab> ticketCabsOk =
        Provider.of<TicketCabsOkProvider>(context).ticketCabsOk;

    if (ticketCabsOkProvider.showLoader) {
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
                sortAscending: ticketCabsOkProvider.ascending,
                sortColumnIndex: ticketCabsOkProvider.sortColumnIndex,
                columns: [
                  const DataColumn(
                      label: Text('ID',
                          style: TextStyle(fontWeight: FontWeight.bold))),
                  DataColumn(
                      label: const Text('Empresa',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      onSort: (colIndex, _) {
                        ticketCabsOkProvider.sortColumnIndex = colIndex;
                        ticketCabsOkProvider
                            .sort<String>((item) => item.companyName);
                      }),
                  DataColumn(
                      label: const Text('Fecha y Usuario Alta',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      onSort: (colIndex, _) {
                        ticketCabsOkProvider.sortColumnIndex = colIndex;
                        ticketCabsOkProvider
                            .sort<String>((item) => item.createDate.toString());
                      }),
                  DataColumn(
                      label: const Text('Categoría',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      onSort: (colIndex, _) {
                        ticketCabsOkProvider.sortColumnIndex = colIndex;
                        ticketCabsOkProvider
                            .sort<String>((item) => item.categoryName);
                      }),
                  DataColumn(
                      label: const Text('Subcategoría',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      onSort: (colIndex, _) {
                        ticketCabsOkProvider.sortColumnIndex = colIndex;
                        ticketCabsOkProvider
                            .sort<String>((item) => item.subcategoryName);
                      }),
                  DataColumn(
                      label: const Text('Asunto',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      onSort: (colIndex, _) {
                        ticketCabsOkProvider.sortColumnIndex = colIndex;
                        ticketCabsOkProvider.sort<String>((item) => item.title);
                      }),
                  DataColumn(
                      label: const Text('Estado',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      onSort: (colIndex, _) {
                        ticketCabsOkProvider.sortColumnIndex = colIndex;
                        ticketCabsOkProvider.sort<String>((item) => item.title);
                      }),
                  DataColumn(
                      label: const Text('Registros',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      onSort: (colIndex, _) {
                        ticketCabsOkProvider.sortColumnIndex = colIndex;
                        ticketCabsOkProvider.sort<String>((item) => item.title);
                      }),
                  const DataColumn(
                      label: Text('Acciones',
                          style: TextStyle(fontWeight: FontWeight.bold))),
                ],
                source: TicketCabsOkDTS(ticketCabsOk, context),
                header: Row(
                  children: [
                    const Text(
                      'Tickets Resueltos',
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
                              ticketCabsOkProvider.search = '';
                              ticketCabsOkProvider.filter();
                              ticketCabsOkProvider.notify();
                            },
                          ),
                          onSubmitted: (value) {
                            ticketCabsOkProvider.search = value;
                            ticketCabsOkProvider.filter();
                          },
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 15,
                    ),
                    const Text('Desde: '),
                    Text(
                      DateFormat('dd/MM/yyyy').format(
                        DateTime.parse(
                          desde.toString(),
                        ),
                      ),
                      style: const TextStyle(
                          color: Color.fromARGB(255, 19, 9, 212)),
                    ),
                    IconButton(
                      onPressed: () {
                        desdeFecha();
                      },
                      icon: const Icon(Icons.calendar_today_outlined,
                          color: Color.fromARGB(255, 19, 9, 212)),
                    ),
                    const SizedBox(
                      width: 15,
                    ),
                    const Text('Hasta: '),
                    Text(
                      DateFormat('dd/MM/yyyy').format(
                        DateTime.parse(
                          hasta.toString(),
                        ),
                      ),
                      style: const TextStyle(
                          color: Color.fromARGB(255, 19, 9, 212)),
                    ),
                    IconButton(
                      onPressed: () {
                        hastaFecha();
                      },
                      icon: const Icon(Icons.calendar_today_outlined,
                          color: Color.fromARGB(255, 19, 9, 212)),
                    ),
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

  //--------------- calendar -------------------
  desdeFecha() {
    showDatePicker(
      context: context,
      locale: const Locale('es', 'ES'),
      initialDate: desde,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    ).then((value) {
      if (value != null) {
        desde = value;
        getTickets();
      }
      setState(() {});
    });
  }

  //--------------- calendar -------------------
  hastaFecha() {
    showDatePicker(
      context: context,
      locale: const Locale('es', 'ES'),
      initialDate: hasta,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    ).then((value) {
      if (value != null) {
        hasta = value;
        getTickets();
      }
      setState(() {});
    });
  }
}

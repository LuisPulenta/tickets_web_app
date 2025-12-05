import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../datatables/ticket_cabs_processing_datasource.dart';
import '../../models/models.dart';
import '../../providers/providers.dart';
import '../../services/services.dart';
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
}

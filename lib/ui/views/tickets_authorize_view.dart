import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../datatables/ticket_cabs_authorize_datasource.dart';
import '../../models/models.dart';
import '../../providers/providers.dart';
import '../../services/services.dart';
import '../buttons/custom_icon_button.dart';
import '../inputs/custom_inputs.dart';
import '../layouts/shared/widgets/loader_component.dart';
import '../modals/ticket_modal.dart';

class TicketsAuthorizeView extends StatefulWidget {
  const TicketsAuthorizeView({Key? key}) : super(key: key);

  @override
  State<TicketsAuthorizeView> createState() => _TicketsAuthorizeViewState();
}

class _TicketsAuthorizeViewState extends State<TicketsAuthorizeView> {
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
    await Provider.of<TicketCabsAuthorizeProvider>(context, listen: false)
        .getTicketAuthorizeCabs(userIdLogged);
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
    final ticketCabsAuthorizeProvider =
        Provider.of<TicketCabsAuthorizeProvider>(context);
    List<TicketCab> ticketCabsAuthorize =
        Provider.of<TicketCabsAuthorizeProvider>(context).ticketCabsAuthorize;

    if (ticketCabsAuthorizeProvider.showLoader) {
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
                sortAscending: ticketCabsAuthorizeProvider.ascending,
                sortColumnIndex: ticketCabsAuthorizeProvider.sortColumnIndex,
                columns: [
                  const DataColumn(
                      label: Text('ID',
                          style: TextStyle(fontWeight: FontWeight.bold))),
                  DataColumn(
                      label: const Text('Empresa',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      onSort: (colIndex, _) {
                        ticketCabsAuthorizeProvider.sortColumnIndex = colIndex;
                        ticketCabsAuthorizeProvider
                            .sort<String>((item) => item.companyName);
                      }),
                  DataColumn(
                      label: const Text('Fecha y Usuario Alta',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      onSort: (colIndex, _) {
                        ticketCabsAuthorizeProvider.sortColumnIndex = colIndex;
                        ticketCabsAuthorizeProvider
                            .sort<String>((item) => item.createDate.toString());
                      }),
                  DataColumn(
                      label: const Text('Categoría',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      onSort: (colIndex, _) {
                        ticketCabsAuthorizeProvider.sortColumnIndex = colIndex;
                        ticketCabsAuthorizeProvider
                            .sort<String>((item) => item.categoryName);
                      }),
                  DataColumn(
                      label: const Text('Subcategoría',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      onSort: (colIndex, _) {
                        ticketCabsAuthorizeProvider.sortColumnIndex = colIndex;
                        ticketCabsAuthorizeProvider
                            .sort<String>((item) => item.subcategoryName);
                      }),
                  DataColumn(
                      label: const Text('Asunto',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      onSort: (colIndex, _) {
                        ticketCabsAuthorizeProvider.sortColumnIndex = colIndex;
                        ticketCabsAuthorizeProvider
                            .sort<String>((item) => item.title);
                      }),
                  DataColumn(
                      label: const Text('Estado',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      onSort: (colIndex, _) {
                        ticketCabsAuthorizeProvider.sortColumnIndex = colIndex;
                        ticketCabsAuthorizeProvider
                            .sort<String>((item) => item.title);
                      }),
                  DataColumn(
                      label: const Text('Registros',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      onSort: (colIndex, _) {
                        ticketCabsAuthorizeProvider.sortColumnIndex = colIndex;
                        ticketCabsAuthorizeProvider
                            .sort<String>((item) => item.title);
                      }),
                  const DataColumn(
                      label: Text('Acciones',
                          style: TextStyle(fontWeight: FontWeight.bold))),
                ],
                source: TicketCabsAuthorizeDTS(ticketCabsAuthorize, context),
                header: Row(
                  children: [
                    const Text(
                      'Tickets p/Autorizar',
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
                              ticketCabsAuthorizeProvider.search = '';
                              ticketCabsAuthorizeProvider.filter();
                              ticketCabsAuthorizeProvider.notify();
                            },
                          ),
                          onSubmitted: (value) {
                            ticketCabsAuthorizeProvider.search = value;
                            ticketCabsAuthorizeProvider.filter();
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
                actions: [
                  (userTypeLogged == 'User')
                      ? CustomIconButton(
                          icon: Icons.add_outlined,
                          text: 'Nuevo Ticket',
                          onPressed: () {
                            showModalBottomSheet(
                              backgroundColor: Colors.transparent,
                              context: context,
                              builder: (_) => const TicketModal(
                                ticketCab: null,
                              ),
                            );
                          },
                        )
                      : Container(),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

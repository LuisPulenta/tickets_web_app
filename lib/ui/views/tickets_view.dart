import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tickets_web_app/datatables/ticket_cabs_datasource.dart';
import 'package:tickets_web_app/models/models.dart';
import 'package:tickets_web_app/providers/providers.dart';
import 'package:tickets_web_app/ui/buttons/custom_icon_button.dart';
import 'package:tickets_web_app/ui/inputs/custom_inputs.dart';
import 'package:tickets_web_app/ui/layouts/shared/widgets/loader_component.dart';
import 'package:tickets_web_app/ui/modals/ticket_modal.dart';

class TicketsView extends StatefulWidget {
  const TicketsView({Key? key}) : super(key: key);

  @override
  State<TicketsView> createState() => _TicketsViewState();
}

class _TicketsViewState extends State<TicketsView> {
  int _rowsPerPage = PaginatedDataTable.defaultRowsPerPage;
  bool showLoader = true;

  //-------------------- initState ----------------------------

  @override
  void initState() {
    super.initState();
    Provider.of<TicketCabsProvider>(context, listen: false).getTicketCabs();
    showLoader = false;
    setState(() {});
  }

//-------------------- Pantalla ----------------------------
  @override
  Widget build(BuildContext context) {
    final ticketCabsProvider = Provider.of<TicketCabsProvider>(context);
    List<TicketCab> ticketCabs =
        Provider.of<TicketCabsProvider>(context).ticketCabs;
    final size = MediaQuery.of(context).size;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: ListView(
        physics: const ClampingScrollPhysics(),
        children: [
          Stack(
            children: [
              PaginatedDataTable(
                sortAscending: ticketCabsProvider.ascending,
                sortColumnIndex: ticketCabsProvider.sortColumnIndex,
                columns: [
                  const DataColumn(
                      label: Text("ID",
                          style: TextStyle(fontWeight: FontWeight.bold))),
                  DataColumn(
                      label: const Text("Empresa",
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      onSort: (colIndex, _) {
                        ticketCabsProvider.sortColumnIndex = colIndex;
                        ticketCabsProvider
                            .sort<String>((item) => item.companyName);
                      }),
                  DataColumn(
                      label: const Text("Fecha y Usuario Alta",
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      onSort: (colIndex, _) {
                        ticketCabsProvider.sortColumnIndex = colIndex;
                        ticketCabsProvider
                            .sort<String>((item) => item.createDate.toString());
                      }),
                  DataColumn(
                      label: const Text("Asunto",
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      onSort: (colIndex, _) {
                        ticketCabsProvider.sortColumnIndex = colIndex;
                        ticketCabsProvider.sort<String>((item) => item.title);
                      }),
                  DataColumn(
                      label: const Text("Estado",
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      onSort: (colIndex, _) {
                        ticketCabsProvider.sortColumnIndex = colIndex;
                        ticketCabsProvider.sort<String>((item) => item.title);
                      }),
                  const DataColumn(
                      label: Text("Acciones",
                          style: TextStyle(fontWeight: FontWeight.bold))),
                ],
                source: TicketCabsDTS(ticketCabs, context),
                header: Row(
                  children: [
                    const Text(
                      "Tickets",
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
                              hint: "Buscar...", icon: Icons.search_outlined),
                          onSubmitted: (value) {
                            ticketCabsProvider.search = value;
                            ticketCabsProvider.filter();
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
                  CustomIconButton(
                    icon: Icons.add_outlined,
                    text: "Nuevo Ticket",
                    onPressed: () {
                      showModalBottomSheet(
                        backgroundColor: Colors.transparent,
                        context: context,
                        builder: (_) => const TicketModal(
                          ticketCab: null,
                        ),
                      );
                    },
                  ),
                ],
              ),
              showLoader
                  ? Positioned(
                      left: size.width * 0.5 - 300,
                      top: size.height * 0.5 - 50,
                      child: const LoaderComponent(
                        text: 'Cargando Tickets...',
                      ))
                  : Container()
            ],
          ),
        ],
      ),
    );
  }
}

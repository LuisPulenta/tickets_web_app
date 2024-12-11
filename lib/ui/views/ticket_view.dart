import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:tickets_web_app/models/models.dart';
import 'package:tickets_web_app/providers/providers.dart';
import 'package:tickets_web_app/ui/layouts/shared/widgets/loader_component.dart';

class TicketView extends StatefulWidget {
  final String id;
  const TicketView({Key? key, required this.id}) : super(key: key);

  @override
  State<TicketView> createState() => _TicketViewState();
}

class _TicketViewState extends State<TicketView> {
  TicketCab? ticketCab;
  String ticketStateName = "Enviado";
  late List<TicketDet> ticketDets;
  bool _showLoader = false;

//----------------------------------------------------------------------
  @override
  void initState() {
    _showLoader = true;
    setState(() {});
    final ticketCabsProvider =
        Provider.of<TicketCabsProvider>(context, listen: false);
    ticketCabsProvider.getTicketCabById(widget.id).then(
          (ticketCabDB) => setState(
            () {
              ticketCab = ticketCabDB;
              ticketDets =
                  ticketCab!.ticketDets != null ? ticketCab!.ticketDets! : [];

              if (ticketCab!.ticketState == 1) {
                ticketStateName = "Devuelto";
              }

              if (ticketCab!.ticketState == 2) {
                ticketStateName = "Asignado";
              }

              if (ticketCab!.ticketState == 3) {
                ticketStateName = "En Curso";
              }

              if (ticketCab!.ticketState == 4) {
                ticketStateName = "Resuelto";
              }
            },
          ),
        );
    _showLoader = false;

    setState(() {});
  }

//----------------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    return _showLoader
        ? const Center(child: LoaderComponent(text: 'Por favor espere...'))
        : _getContent();
  }

//------------------------------ _getContent --------------------------
  Widget _getContent() {
    return Column(
      children: <Widget>[
        ticketDets.isEmpty
            ? Expanded(child: _noContent())
            : Expanded(child: _getListView()),
      ],
    );
  }

//------------------------------ _noContent -----------------------------
  Widget _noContent() {
    return Container(
      margin: const EdgeInsets.all(20),
      child: const Center(
        child: Text(
          'No Registros en este Ticket',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  //-----------------------------------------------------------------------
//------------------------------ _getListView ---------------------------
//-----------------------------------------------------------------------

  Widget _getListView() {
    return Column(
      children: [
        Container(
          width: double.infinity,
          height: 130,
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(6.0),
              side: const BorderSide(
                color: Colors.black,
                width: 0.5,
              ),
            ),
            color: const Color.fromARGB(255, 12, 133, 160),
            shadowColor: Colors.white,
            elevation: 10,
            margin: const EdgeInsets.fromLTRB(10, 0, 10, 10),
            child: Center(
              child: Row(
                children: [
                  SizedBox(
                    width: 300,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              const Text('Creado por: ',
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                      color: Colors.white60, fontSize: 14)),
                              Expanded(
                                child: Text(ticketCab!.createUserName,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                        color: Colors.white, fontSize: 14)),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              const Text('Empresa: ',
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                      color: Colors.white60, fontSize: 14)),
                              Expanded(
                                child: Text(ticketCab!.companyName,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                        color: Colors.white, fontSize: 14)),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              const Text('Fecha: ',
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                      color: Colors.white60, fontSize: 14)),
                              Text(
                                  DateFormat('dd/MM/yyyy').format(
                                      DateTime.parse(
                                          ticketCab!.createDate.toString())),
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                      color: Colors.white, fontSize: 14)),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              const Text('Hora: ',
                                  style: TextStyle(
                                      color: Colors.white60, fontSize: 14)),
                              Text(
                                  DateFormat('hh:mm').format(DateTime.parse(
                                      ticketCab!.createDate.toString())),
                                  style: const TextStyle(
                                      color: Colors.white, fontSize: 14)),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 60,
                    child: Center(
                      child: Container(
                        margin: const EdgeInsetsDirectional.only(
                            start: 10.0, end: 10.0),
                        width: 0.5,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      'TICKET N°: ${ticketCab?.id} - ${ticketCab?.title}',
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(
                    height: 60,
                    child: Center(
                      child: Container(
                        margin: const EdgeInsetsDirectional.only(
                            start: 10.0, end: 10.0),
                        width: 0.5,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 300,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              const Text('Estado: ',
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                      color: Colors.white60, fontSize: 14)),
                              Expanded(
                                child: CustomChip(estado: ticketStateName),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: const [
                              Text(' ',
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                      color: Colors.white60, fontSize: 14)),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              const Text('Fec. Asignación: ',
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                      color: Colors.white60, fontSize: 14)),
                              Expanded(
                                child: Text(
                                    ticketCab!.asignDate != null
                                        ? DateFormat('dd/MM/yyyy').format(
                                            DateTime.parse(ticketCab!.asignDate
                                                .toString()))
                                        : '',
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                        color: Colors.white, fontSize: 14)),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              const Text('Fec. En Curso: ',
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                      color: Colors.white60, fontSize: 14)),
                              Expanded(
                                child: Text(
                                    ticketCab!.inProgressDate != null
                                        ? DateFormat('dd/MM/yyyy').format(
                                            DateTime.parse(ticketCab!
                                                .inProgressDate
                                                .toString()))
                                        : '',
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                        color: Colors.white, fontSize: 14)),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              const Text('Fecha Fin: ',
                                  style: TextStyle(
                                      color: Colors.white60, fontSize: 14)),
                              Expanded(
                                child: Text(
                                    ticketCab!.finishDate != null
                                        ? DateFormat('dd/MM/yyyy').format(
                                            DateTime.parse(ticketCab!.finishDate
                                                .toString()))
                                        : '',
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                        color: Colors.white, fontSize: 14)),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        Expanded(
          child: ListView(
            children: ticketDets.map((e) {
              return Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6.0),
                  side: const BorderSide(
                    color: Colors.black,
                    width: 0.5,
                  ),
                ),
                color: Colors.white,
                shadowColor: Colors.white,
                elevation: 10,
                margin: const EdgeInsets.fromLTRB(10, 0, 10, 10),
                child: Container(
                  margin: const EdgeInsets.all(0),
                  padding: const EdgeInsets.all(5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: 200,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        const Text('Fecha: ',
                                            textAlign: TextAlign.start,
                                            style: TextStyle(
                                                color: Color.fromARGB(
                                                    255, 3, 30, 184),
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold)),
                                        Text(
                                            DateFormat('dd/MM/yyyy').format(
                                                DateTime.parse(
                                                    e.stateDate.toString())),
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                                color: Colors.black,
                                                fontSize: 12)),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        const Text('Hora: ',
                                            style: TextStyle(
                                                color: Color.fromARGB(
                                                    255, 3, 30, 184),
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold)),
                                        Text(
                                            DateFormat('hh:mm').format(
                                                DateTime.parse(
                                                    e.stateDate.toString())),
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                                color: Colors.black,
                                                fontSize: 12)),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        const Text('Usuario: ',
                                            style: TextStyle(
                                                color: Color.fromARGB(
                                                    255, 3, 30, 184),
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold)),
                                        Expanded(
                                          child: Text(e.stateUserName,
                                              overflow: TextOverflow.ellipsis,
                                              style: const TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 12)),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 60,
                                child: Center(
                                  child: Container(
                                    margin: const EdgeInsetsDirectional.only(
                                        start: 10.0, end: 10.0),
                                    width: 0.5,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Text(e.description,
                                    style: const TextStyle(
                                        color: Colors.black, fontSize: 12)),
                              ),
                              const VerticalDivider(
                                color: Colors.black,
                              ),
                              SizedBox(
                                height: 60,
                                child: Center(
                                  child: Container(
                                    margin: const EdgeInsetsDirectional.only(
                                        start: 10.0, end: 10.0),
                                    width: 0.5,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                              Container(
                                width: 100,
                                child: CustomChip(estado: e.ticketState),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}

//-------------------------------------------------------------
class CustomChip extends StatelessWidget {
  final String estado;
  const CustomChip({
    super.key,
    required this.estado,
  });

  @override
  Widget build(BuildContext context) {
    return Chip(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(6.0),
        side: const BorderSide(
          color: Colors.black,
          width: 0.5,
        ),
      ),
      label: Text(estado.toUpperCase(),
          style: const TextStyle(
              color: Colors.black, fontSize: 12, fontWeight: FontWeight.bold)),
      backgroundColor: estado == 'Enviado'
          ? const Color.fromARGB(255, 169, 220, 227)
          : estado == 'Devuelto'
              ? const Color.fromARGB(255, 226, 179, 132)
              : estado == 'Asignado'
                  ? const Color.fromARGB(255, 240, 113, 101)
                  : estado == 'Encurso'
                      ? const Color.fromARGB(255, 217, 135, 219)
                      : const Color.fromARGB(255, 145, 228, 109),
    );
  }
}

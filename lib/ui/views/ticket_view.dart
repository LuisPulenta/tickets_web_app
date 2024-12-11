import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:tickets_web_app/helpers/constants.dart';
import 'package:tickets_web_app/models/models.dart';
import 'package:tickets_web_app/providers/providers.dart';
import 'package:tickets_web_app/ui/cards/white_card.dart';
import 'package:tickets_web_app/ui/labels/custom_labels.dart';
import 'package:tickets_web_app/ui/layouts/shared/widgets/loader_component.dart';

class TicketView extends StatefulWidget {
  final String id;
  const TicketView({Key? key, required this.id}) : super(key: key);

  @override
  State<TicketView> createState() => _TicketViewState();
}

class _TicketViewState extends State<TicketView> {
  TicketCab? ticketCab;
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
          height: 60,
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(6.0),
              side: const BorderSide(
                color: Colors.black,
                width: 0.5,
              ),
            ),
            color: Color.fromARGB(255, 12, 133, 160),
            shadowColor: Colors.white,
            elevation: 10,
            margin: const EdgeInsets.fromLTRB(10, 0, 10, 10),
            child: Center(
              child: Text(
                'TICKET N°: ${ticketCab?.id} - ${ticketCab?.title}',
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold),
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
                color: const Color.fromARGB(255, 137, 212, 229),
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
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
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
                                          style: const TextStyle(
                                              color: Colors.black,
                                              fontSize: 12)),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
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
                                          style: const TextStyle(
                                              color: Colors.black,
                                              fontSize: 12)),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      const Text('Usuario: ',
                                          style: TextStyle(
                                              color: Color.fromARGB(
                                                  255, 3, 30, 184),
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold)),
                                      Text(e.stateUserName,
                                          style: const TextStyle(
                                              color: Colors.black,
                                              fontSize: 12)),
                                    ],
                                  ),
                                ],
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
                                child: Chip(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(6.0),
                                    side: const BorderSide(
                                      color: Colors.black,
                                      width: 0.5,
                                    ),
                                  ),
                                  label: Text(e.ticketState.toUpperCase(),
                                      style: const TextStyle(
                                          color: Colors.black,
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold)),
                                  backgroundColor: e.ticketState == 'Enviado'
                                      ? const Color.fromARGB(255, 169, 220, 227)
                                      : e.ticketState == 'Devuelto'
                                          ? const Color.fromARGB(
                                              255, 226, 179, 132)
                                          : e.ticketState == 'Asignado'
                                              ? const Color.fromARGB(
                                                  255, 240, 113, 101)
                                              : e.ticketState == 'Encurso'
                                                  ? const Color.fromARGB(
                                                      255, 217, 135, 219)
                                                  : const Color.fromARGB(
                                                      255, 145, 228, 109),
                                ),
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

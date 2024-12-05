import 'package:flutter/material.dart';
import 'package:tickets_web_app/ui/cards/white_card.dart';

class DashboardView extends StatelessWidget {
  const DashboardView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: ListView(
        physics: const ClampingScrollPhysics(),
        children: const [
          WhiteCard(
            title: 'Bienvenido a TicketsWeb',
            child: Text(
                'En esta Web usted podrá registrar Tickets de reclamos por cuestiones relacionadas al funcionamiento de softwares implementados por la Empresa KeyPress, y hacer el seguimiento de los mismos.'),
          ),
        ],
      ),
    );
  }
}

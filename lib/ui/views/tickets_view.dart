import 'package:flutter/material.dart';
import 'package:tickets_web_app/ui/cards/white_card.dart';
import 'package:tickets_web_app/ui/labels/custom_labels.dart';

class TicketsView extends StatelessWidget {
  const TicketsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: const ClampingScrollPhysics(),
      children: [
        Text(
          "Tickets",
          style: CustomLabels.h1,
        ),
        const SizedBox(
          height: 10,
        ),
        const WhiteCard(
          title: "TicketsView",
          child: Text('Hola Mundo'),
        ),
      ],
    );
  }
}

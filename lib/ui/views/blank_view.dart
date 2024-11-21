import 'package:flutter/material.dart';
import 'package:tickets_web_app/ui/cards/white_card.dart';
import 'package:tickets_web_app/ui/labels/custom_labels.dart';

class BlankView extends StatelessWidget {
  const BlankView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: ListView(
        physics: const ClampingScrollPhysics(),
        children: [
          Text(
            "BlankView",
            style: CustomLabels.h1,
          ),
          const SizedBox(
            height: 10,
          ),
          const WhiteCard(
            title: "Sales Statistics",
            child: Text('Hola Mundo'),
          ),
        ],
      ),
    );
  }
}

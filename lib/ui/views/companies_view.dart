import 'package:flutter/material.dart';
import 'package:tickets_web_app/ui/cards/white_card.dart';
import 'package:tickets_web_app/ui/labels/custom_labels.dart';

class CompaniesView extends StatelessWidget {
  const CompaniesView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: const ClampingScrollPhysics(),
      children: [
        Text(
          "Icons",
          style: CustomLabels.h1,
        ),
        const SizedBox(
          height: 10,
        ),
        Wrap(
          crossAxisAlignment: WrapCrossAlignment.start,
          direction: Axis.horizontal,
          children: const [
            WhiteCard(
              title: "ac_unit_outlined",
              width: 170,
              child: Center(child: Icon(Icons.ac_unit_outlined)),
            ),
            WhiteCard(
              title: "abc_outlined",
              width: 170,
              child: Center(child: Icon(Icons.abc_outlined)),
            ),
            WhiteCard(
              title: "access_alarm_outlined",
              width: 170,
              child: Center(child: Icon(Icons.access_alarm_outlined)),
            ),
            WhiteCard(
              title: "home_outlined",
              width: 170,
              child: Center(child: Icon(Icons.home_outlined)),
            ),
            WhiteCard(
              title: "person_outline",
              width: 170,
              child: Center(child: Icon(Icons.person_outline)),
            ),
            WhiteCard(
              title: "settings_outlined",
              width: 170,
              child: Center(child: Icon(Icons.settings_outlined)),
            ),
          ],
        )
      ],
    );
  }
}

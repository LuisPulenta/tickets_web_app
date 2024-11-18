import 'package:flutter/material.dart';

class NotificationsIndicator extends StatelessWidget {
  const NotificationsIndicator({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      const Icon(
        Icons.notifications_none_outlined,
        color: Colors.grey,
      ),
      Positioned(
        left: 2,
        child: Container(
          height: 5,
          width: 5,
          decoration: buildDecoration(),
        ),
      ),
    ]);
  }

  //-----------------------------------------------------
  BoxDecoration buildDecoration() => BoxDecoration(
        color: Colors.red,
        borderRadius: BorderRadius.circular(100),
      );
}

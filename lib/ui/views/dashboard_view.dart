import 'package:flutter/material.dart';

class DashboardView extends StatelessWidget {
  const DashboardView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(
        child: Text("DashboardView",
            style: TextStyle(
                color: Colors.black,
                fontSize: 28,
                fontWeight: FontWeight.bold)));
  }
}

import 'package:flutter/material.dart';

class DashboardLayout extends StatelessWidget {
  final Widget child;

  const DashboardLayout({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('DashboardLayout'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          children: [
            const Text(
              'Dashboard',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 50,
                  fontWeight: FontWeight.bold),
            ),
            Expanded(child: child),
          ],
        ),
      ),
    );
  }
}

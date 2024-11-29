import 'package:flutter/material.dart';

class LoaderComponent extends StatelessWidget {
  final String text;

  const LoaderComponent({super.key, this.text = ''});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 200,
        height: 100,
        decoration: BoxDecoration(
            color: const Color(0xFFFFFFFF),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.black)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(),
            const SizedBox(
              height: 20,
            ),
            Text(text, style: const TextStyle(fontSize: 15)),
          ],
        ),
      ),
    );
  }
}

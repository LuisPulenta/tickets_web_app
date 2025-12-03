import 'package:flutter/material.dart';

class Background extends StatelessWidget {
  const Background({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 900),
      child: const Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 30),
          child: Image(
            image: AssetImage('bg.png'),
            fit: BoxFit.contain,
            width: 600,
          ),
        ),
      ),
    );
  }
}

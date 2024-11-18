import 'package:flutter/material.dart';

class Background extends StatelessWidget {
  const Background({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        decoration: buildBoxDecoration(),
        child: Container(
          constraints: const BoxConstraints(maxWidth: 400),
          child: const Center(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 30),
              child: Image(
                image: AssetImage("bg.png"),
                width: 400,
              ),
            ),
          ),
        ),
      ),
    );
  }

//-------------------------------------------------------------
  BoxDecoration buildBoxDecoration() {
    return const BoxDecoration(
      image: DecorationImage(image: AssetImage("bg.png"), fit: BoxFit.cover),
    );
  }
}

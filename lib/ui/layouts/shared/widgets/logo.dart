import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Logo extends StatelessWidget {
  const Logo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 30),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 25,
            backgroundColor: Colors.white,
            child: Image.asset(
              'bg.png',
              width: 35,
              height: 35,
              fit: BoxFit.contain,
            ),
          ),
          const SizedBox(width: 10),
          Text('TicketsWeb',
              style: GoogleFonts.montserratAlternates(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white))
        ],
      ),
    );
  }
}

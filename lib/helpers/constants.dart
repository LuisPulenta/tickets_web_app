import 'package:flutter/material.dart';

Color colorEnviado = const Color.fromARGB(255, 169, 220, 227);
Color colorDevuelto = const Color.fromARGB(255, 226, 179, 132);
Color colorAsignado = const Color.fromARGB(255, 240, 113, 101);
Color colorEnCurso = const Color.fromARGB(255, 217, 135, 219);
Color colorDerivado = const Color.fromARGB(255, 200, 47, 33);
Color colorResuelto = const Color.fromARGB(255, 145, 228, 109);

class Constants {
  static String get apiUrl => 'https://keypress.serveftp.net/Tickets/api';

  static List<String> estados = [
    'Enviado',
    'Devuelto',
    'Asignado',
    'En Curso',
    'Resuelto',
    'Derivado'
  ];
}

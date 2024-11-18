import 'package:flutter/material.dart';
import 'package:tickets_web_app/ui/buttons/link_text.dart';

class LinksBar extends StatelessWidget {
  const LinksBar({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      width: double.infinity,
      height: size.width > 1000 ? size.height * 0.08 : null,
      color: Colors.black,
      child: Wrap(
        alignment: WrapAlignment.center,
        children: [
          LinkText(
            text: 'Acerca de',
            onPressed: () {},
          ),
          LinkText(
            text: 'Términos del Servicio',
            onPressed: () {},
          ),
          LinkText(
            text: 'Política de Privacidad',
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}

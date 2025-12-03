import 'package:flutter/material.dart';

import '../../../../providers/side_menu_provider.dart';
import 'navbar_avatar.dart';

class Navbar extends StatelessWidget {
  const Navbar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      width: double.infinity,
      height: 50,
      decoration: buildBoxDecoration(),
      child: Row(
        children: [
          //Icono Menu
          if (size.width <= 700)
            IconButton(
              icon: const Icon(Icons.menu_outlined),
              onPressed: () {
                SideMenuProvider.openMenu();
              },
            ),
          const SizedBox(
            width: 5,
          ),

          const Spacer(),
          // const NotificationsIndicator(),
          // const SizedBox(
          //   width: 10,
          // ),
          const NavbarAvatar(),
          const SizedBox(
            width: 10,
          ),
        ],
      ),
    );
  }

  BoxDecoration buildBoxDecoration() => const BoxDecoration(
      color: Colors.white,
      boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 5)]);
}

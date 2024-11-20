import 'package:flutter/material.dart';
import 'package:tickets_web_app/providers/side_menu_provider.dart';
import 'package:tickets_web_app/ui/layouts/shared/widgets/navbar_avatar.dart';
import 'package:tickets_web_app/ui/layouts/shared/widgets/notifications_indicator.dart';
import 'package:tickets_web_app/ui/layouts/shared/widgets/search_text.dart';

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
          //Search input
          if (size.width >= 390)
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 250),
              child: const SearchText(),
            ),
          const Spacer(),
          const NotificationsIndicator(),
          const SizedBox(
            width: 10,
          ),
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

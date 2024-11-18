import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tickets_web_app/providers/side_menu_provider.dart';
import 'package:tickets_web_app/router/router.dart';
import 'package:tickets_web_app/services/navigation_services.dart';
import 'package:tickets_web_app/ui/layouts/shared/widgets/logo.dart';
import 'package:tickets_web_app/ui/layouts/shared/widgets/menu_item.dart';
import 'package:tickets_web_app/ui/layouts/shared/widgets/text_separator.dart';

class Sidebar extends StatelessWidget {
  const Sidebar({Key? key}) : super(key: key);

  void navigateTo(String routeName) {
    NavigationServices.navigateTo(routeName);
    SideMenuProvider.closeMenu();
  }

  @override
  Widget build(BuildContext context) {
    final sideMenuProvider = Provider.of<SideMenuProvider>(context);
    return Container(
      width: 200,
      height: double.infinity,
      decoration: buildBoxDecoration(),
      child: ListView(
        physics: const ClampingScrollPhysics(),
        children: [
          const Logo(),
          const SizedBox(
            height: 50,
          ),
          MenuItem(
              text: 'Dashboard',
              icon: Icons.compass_calibration_outlined,
              isActive:
                  sideMenuProvider.currentPage == Flurorouter.dashboardRoute,
              onPressed: () {
                print('DASHBOARD');
                navigateTo(Flurorouter.dashboardRoute);
              }),
          const TextSeparator(text: 'Empresas y Usuarios'),
          MenuItem(
              text: 'Empresas',
              icon: Icons.compass_calibration_outlined,
              isActive:
                  sideMenuProvider.currentPage == Flurorouter.companiesRoute,
              onPressed: () {
                print('EMPRESAS');
                navigateTo(Flurorouter.companiesRoute);
              }),
          MenuItem(
            text: 'Usuarios',
            icon: Icons.person,
            isActive: false,
            onPressed: () => print('Usuarios'),
          ),
          const TextSeparator(text: 'Tickets'),
          MenuItem(
            text: 'Tickets',
            icon: Icons.settings,
            isActive: false,
            onPressed: () => print('Tickets'),
          ),
          const Divider(
            thickness: 2,
            color: Colors.white,
          ),
          MenuItem(
            text: 'Logout',
            icon: Icons.exit_to_app_outlined,
            isActive: false,
            onPressed: () => print('Discount'),
          ),
        ],
      ),
    );
  }

//--------------------------------------------------------------
  BoxDecoration buildBoxDecoration() {
    return const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xff092044),
            Color.fromARGB(255, 1, 108, 122),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10,
          ),
        ]);
  }
}

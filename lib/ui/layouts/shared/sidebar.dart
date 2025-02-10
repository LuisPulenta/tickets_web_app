import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tickets_web_app/providers/auth_provider.dart';
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
    final userType =
        Provider.of<AuthProvider>(context, listen: false).user!.userTypeId;
    return Container(
      width: 200,
      height: double.infinity,
      decoration: buildBoxDecoration(),
      child: ListView(
        physics: const ClampingScrollPhysics(),
        children: [
          const Logo(),
          const SizedBox(
            height: 25,
          ),
          const Divider(
            thickness: 2,
            color: Colors.white,
          ),
          const SizedBox(
            height: 5,
          ),
          MenuItem(
            text: 'Inicio',
            icon: Icons.home,
            isActive:
                sideMenuProvider.currentPage == Flurorouter.dashboardRoute,
            onPressed: () => navigateTo(Flurorouter.dashboardRoute),
          ),
          userType == 0
              ? const TextSeparator(text: 'Empresas y Usuarios')
              : Container(),
          userType == 0
              ? MenuItem(
                  text: 'Empresas',
                  icon: Icons.storefront,
                  isActive: sideMenuProvider.currentPage ==
                      Flurorouter.companiesRoute,
                  onPressed: () => navigateTo(Flurorouter.companiesRoute),
                )
              : Container(),
          userType == 0 || userType == 1
              ? MenuItem(
                  text: 'Usuarios',
                  icon: Icons.groups,
                  isActive:
                      sideMenuProvider.currentPage == Flurorouter.usersRoute,
                  onPressed: () => navigateTo(Flurorouter.usersRoute),
                )
              : Container(),
          const TextSeparator(text: 'Tickets'),
          MenuItem(
            text: 'Pendientes',
            icon: Icons.local_activity_outlined,
            isActive: sideMenuProvider.currentPage == Flurorouter.ticketsRoute,
            onPressed: () => navigateTo(Flurorouter.ticketsRoute),
          ),
          userType == 2
              ? MenuItem(
                  text: 'P/Resolver',
                  icon: Icons.emoji_objects_outlined,
                  isActive: sideMenuProvider.currentPage ==
                      Flurorouter.ticketsDerivatedRoute,
                  onPressed: () =>
                      navigateTo(Flurorouter.ticketsDerivatedRoute),
                )
              : Container(),
          MenuItem(
            text: 'Resueltos',
            icon: Icons.verified_outlined,
            isActive:
                sideMenuProvider.currentPage == Flurorouter.ticketsOkRoute,
            onPressed: () => navigateTo(Flurorouter.ticketsOkRoute),
          ),
          const Divider(
            thickness: 2,
            color: Colors.white,
          ),
          MenuItem(
            text: 'Logout',
            icon: Icons.exit_to_app_outlined,
            isActive: false,
            onPressed: () {
              navigateTo(Flurorouter.dashboardRoute);
              Provider.of<AuthProvider>(context, listen: false).logout();
            },
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

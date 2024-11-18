import 'package:fluro/fluro.dart';
import 'package:provider/provider.dart';
import 'package:tickets_web_app/providers/auth_provider.dart';
import 'package:tickets_web_app/providers/side_menu_provider.dart';
import 'package:tickets_web_app/router/router.dart';
import 'package:tickets_web_app/ui/views/view.dart';

class DashboardHandlers {
  static Handler dashboard = Handler(handlerFunc: (context, params) {
    final authProvider = Provider.of<AuthProvider>(context!);
    Provider.of<SideMenuProvider>(context, listen: false)
        .setCurrentPageUrl(Flurorouter.dashboardRoute);

    if (authProvider.authStatus == AuthStatus.authenticated) {
      return const DashboardView();
    } else {
      return const LoginView();
    }
  });

  static Handler companies = Handler(handlerFunc: (context, params) {
    final authProvider = Provider.of<AuthProvider>(context!);
    Provider.of<SideMenuProvider>(context, listen: false)
        .setCurrentPageUrl(Flurorouter.companiesRoute);

    if (authProvider.authStatus == AuthStatus.authenticated) {
      return const CompaniesView();
    } else {
      return const LoginView();
    }
  });
}

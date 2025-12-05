import 'package:fluro/fluro.dart';
import 'package:provider/provider.dart';

import '../providers/auth_provider.dart';
import '../providers/side_menu_provider.dart';
import '../ui/views/categories_view.dart';
import '../ui/views/category_view.dart';
import '../ui/views/ticket_view.dart';
import '../ui/views/view.dart';
import 'router.dart';

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

  static Handler categories = Handler(handlerFunc: (context, params) {
    final authProvider = Provider.of<AuthProvider>(context!);
    Provider.of<SideMenuProvider>(context, listen: false)
        .setCurrentPageUrl(Flurorouter.categoriesRoute);

    if (authProvider.authStatus == AuthStatus.authenticated) {
      return const CategoriesView();
    } else {
      return const LoginView();
    }
  });

  static Handler category = Handler(handlerFunc: (context, params) {
    final authProvider = Provider.of<AuthProvider>(context!);
    Provider.of<SideMenuProvider>(context, listen: false)
        .setCurrentPageUrl(Flurorouter.categoryRoute);
    if (authProvider.authStatus == AuthStatus.authenticated) {
      return CategoryView(
        id: params['id']!.first,
      );
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

  static Handler branches = Handler(handlerFunc: (context, params) {
    final authProvider = Provider.of<AuthProvider>(context!);
    Provider.of<SideMenuProvider>(context, listen: false)
        .setCurrentPageUrl(Flurorouter.branchesRoute);

    if (authProvider.authStatus == AuthStatus.authenticated) {
      return const BranchesView();
    } else {
      return const LoginView();
    }
  });

  static Handler users = Handler(handlerFunc: (context, params) {
    final authProvider = Provider.of<AuthProvider>(context!);
    Provider.of<SideMenuProvider>(context, listen: false)
        .setCurrentPageUrl(Flurorouter.usersRoute);

    if (authProvider.authStatus == AuthStatus.authenticated) {
      return const UsersView();
    } else {
      return const LoginView();
    }
  });

  static Handler tickets = Handler(handlerFunc: (context, params) {
    final authProvider = Provider.of<AuthProvider>(context!);
    Provider.of<SideMenuProvider>(context, listen: false)
        .setCurrentPageUrl(Flurorouter.ticketsRoute);

    if (authProvider.authStatus == AuthStatus.authenticated) {
      return const TicketsView();
    } else {
      return const LoginView();
    }
  });

  static Handler ticketsOk = Handler(handlerFunc: (context, params) {
    final authProvider = Provider.of<AuthProvider>(context!);
    Provider.of<SideMenuProvider>(context, listen: false)
        .setCurrentPageUrl(Flurorouter.ticketsOkRoute);

    if (authProvider.authStatus == AuthStatus.authenticated) {
      return const TicketsOkView();
    } else {
      return const LoginView();
    }
  });

  static Handler ticketsDerivated = Handler(handlerFunc: (context, params) {
    final authProvider = Provider.of<AuthProvider>(context!);
    Provider.of<SideMenuProvider>(context, listen: false)
        .setCurrentPageUrl(Flurorouter.ticketsDerivatedRoute);

    if (authProvider.authStatus == AuthStatus.authenticated) {
      return const TicketsDerivatedView();
    } else {
      return const LoginView();
    }
  });

  static Handler ticketsProcessing = Handler(handlerFunc: (context, params) {
    final authProvider = Provider.of<AuthProvider>(context!);
    Provider.of<SideMenuProvider>(context, listen: false)
        .setCurrentPageUrl(Flurorouter.ticketsProcessingRoute);

    if (authProvider.authStatus == AuthStatus.authenticated) {
      return const TicketsProcessingView();
    } else {
      return const LoginView();
    }
  });

  static Handler editUser = Handler(handlerFunc: (context, params) {
    final authProvider = Provider.of<AuthProvider>(context!);
    Provider.of<SideMenuProvider>(context, listen: false)
        .setCurrentPageUrl(Flurorouter.editUserRoute);

    if (authProvider.authStatus == AuthStatus.authenticated) {
      return const EditUserView();
    } else {
      return const LoginView();
    }
  });

  static Handler ticket = Handler(handlerFunc: (context, params) {
    final authProvider = Provider.of<AuthProvider>(context!);
    Provider.of<SideMenuProvider>(context, listen: false)
        .setCurrentPageUrl(Flurorouter.ticketRoute);
    if (authProvider.authStatus == AuthStatus.authenticated) {
      if (params['id']?.first != null) {
        return TicketView(
          id: params['id']!.first,
        );
      } else {
        return const TicketsOkView();
      }
    } else {
      return const LoginView();
    }
  });
}

import 'package:fluro/fluro.dart';

import 'admin_handlers.dart';
import 'dashboard_handler.dart';
import 'no_page_found_handlers.dart';

class Flurorouter {
  static final FluroRouter router = FluroRouter();

  static String rootRoute = '/';

  //Auth Router
  static String loginRoute = '/auth/login';
  static String registerRoute = '/auth/register';
  static String recoverPasswordRoute = '/auth/recoverpassword';

  //Dashboard Router
  static String dashboardRoute = '/dashboard';
  static String categoriesRoute = '/dashboard/categories';
  static String categoryRoute = '/dashboard/categories/:id';
  static String companiesRoute = '/dashboard/companies';

  static String branchesRoute = '/dashboard/branches';
  static String usersRoute = '/dashboard/users';
  static String ticketsRoute = '/dashboard/tickets';
  static String ticketsOkRoute = '/dashboard/ticketsok';
  static String ticketsDerivatedRoute = '/dashboard/ticketsderivated';
  static String editUserRoute = '/dashboard/editUser';
  static String ticketRoute = '/dashboard/tickets/:id';

  static void configureRoutes() {
    router.define(
      rootRoute,
      handler: AdminHandlers.login,
      transitionType: TransitionType.none,
    );

    router.define(
      loginRoute,
      handler: AdminHandlers.login,
      transitionType: TransitionType.none,
    );

    router.define(
      recoverPasswordRoute,
      handler: AdminHandlers.recoverPassword,
      transitionType: TransitionType.none,
    );

    router.define(
      editUserRoute,
      handler: DashboardHandlers.editUser,
      transitionType: TransitionType.none,
    );

    router.define(
      dashboardRoute,
      handler: DashboardHandlers.dashboard,
      transitionType: TransitionType.fadeIn,
    );

    router.define(
      categoriesRoute,
      handler: DashboardHandlers.categories,
      transitionType: TransitionType.fadeIn,
    );

    router.define(
      categoryRoute,
      handler: DashboardHandlers.category,
      transitionType: TransitionType.fadeIn,
    );

    router.define(
      companiesRoute,
      handler: DashboardHandlers.companies,
      transitionType: TransitionType.fadeIn,
    );

    router.define(
      branchesRoute,
      handler: DashboardHandlers.branches,
      transitionType: TransitionType.fadeIn,
    );

    router.define(
      usersRoute,
      handler: DashboardHandlers.users,
      transitionType: TransitionType.fadeIn,
    );

    router.define(
      ticketsRoute,
      handler: DashboardHandlers.tickets,
      transitionType: TransitionType.fadeIn,
    );

    router.define(
      ticketsOkRoute,
      handler: DashboardHandlers.ticketsOk,
      transitionType: TransitionType.fadeIn,
    );

    router.define(
      ticketsDerivatedRoute,
      handler: DashboardHandlers.ticketsDerivated,
      transitionType: TransitionType.fadeIn,
    );

    router.define(
      ticketRoute,
      handler: DashboardHandlers.ticket,
      transitionType: TransitionType.fadeIn,
    );

    //  router.define(
    //   registerRoute,
    //   handler: loginHandler,
    // );

    router.notFoundHandler = NoPageFoundHandlers.noPageFound;
  }
}

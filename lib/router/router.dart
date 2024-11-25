import 'package:fluro/fluro.dart';
import 'package:tickets_web_app/router/admin_handlers.dart';
import 'package:tickets_web_app/router/dashboard_handler.dart';
import 'package:tickets_web_app/router/no_page_found_handlers.dart';

class Flurorouter {
  static final FluroRouter router = FluroRouter();

  static String rootRoute = '/';

  //Auth Router
  static String loginRoute = '/auth/login';
  static String registerRoute = '/auth/register';
  static String recoverPasswordRoute = '/auth/recoverpassword';

  //Dashboard Router
  static String dashboardRoute = '/dashboard';
  static String companiesRoute = '/dashboard/companies';
  static String usersRoute = '/dashboard/users';
  static String ticketsRoute = '/dashboard/tickets';

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
      dashboardRoute,
      handler: DashboardHandlers.dashboard,
      transitionType: TransitionType.fadeIn,
    );

    router.define(
      companiesRoute,
      handler: DashboardHandlers.companies,
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

    //  router.define(
    //   registerRoute,
    //   handler: loginHandler,
    // );

    router.notFoundHandler = NoPageFoundHandlers.noPageFound;
  }
}

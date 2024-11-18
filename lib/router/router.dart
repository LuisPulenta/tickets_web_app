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

  //Dashboard Router
  static String dashboardRoute = '/dashboard';

  static void configureRoutes() {
    router.define(
      rootRoute,
      handler: AdminHandlers.login,
    );

    router.define(
      loginRoute,
      handler: AdminHandlers.login,
    );

    router.define(
      dashboardRoute,
      handler: DashboardHandlers.dashboard,
      transitionType: TransitionType.fadeIn,
    );

    //  router.define(
    //   registerRoute,
    //   handler: loginHandler,
    // );

    router.notFoundHandler = NoPageFoundHandlers.noPageFound;
  }
}

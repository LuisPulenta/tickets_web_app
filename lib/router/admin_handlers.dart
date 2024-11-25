import 'package:fluro/fluro.dart';
import 'package:provider/provider.dart';
import 'package:tickets_web_app/providers/auth_provider.dart';

import 'package:tickets_web_app/ui/views/view.dart';

class AdminHandlers {
  static Handler login = Handler(handlerFunc: (context, params) {
    final authProvider = Provider.of<AuthProvider>(context!);
    if (authProvider.authStatus == AuthStatus.notAuthenticated) {
      return const LoginView();
    } else {
      return const DashboardView();
    }
  });

  static Handler recoverPassword = Handler(handlerFunc: (context, params) {
    final authProvider = Provider.of<AuthProvider>(context!);
    if (authProvider.authStatus == AuthStatus.notAuthenticated) {
      return const RecoverPasswordView();
    } else {
      return const DashboardView();
    }
  });
}

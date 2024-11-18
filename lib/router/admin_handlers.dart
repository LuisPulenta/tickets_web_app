import 'package:fluro/fluro.dart';
import 'package:tickets_web_app/ui/views/view.dart';

class AdminHandlers {
  static Handler login = Handler(handlerFunc: (context, params) {
    return const LoginView();
  });
}

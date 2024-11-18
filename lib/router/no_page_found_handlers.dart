import 'package:fluro/fluro.dart';
import 'package:tickets_web_app/ui/views/view.dart';

class NoPageFoundHandlers {
  static Handler noPageFound = Handler(handlerFunc: (context, params) {
    return const NoPageFoundView();
  });
}

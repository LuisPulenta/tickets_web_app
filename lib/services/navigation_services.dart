import 'package:flutter/material.dart';

class NavigationServices {
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  static navigateTo(String routeName) {
    return navigatorKey.currentState!.pushNamed(routeName);
  }

  static replaceTo(String routeName) {
    return navigatorKey.currentState!.pushReplacementNamed(routeName);
  }
}

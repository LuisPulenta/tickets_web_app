import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tickets_web_app/providers/auth_provider.dart';
import 'package:tickets_web_app/providers/companies_provider.dart';
import 'package:tickets_web_app/providers/company_form_provider.dart';
import 'package:tickets_web_app/providers/side_menu_provider.dart';
import 'package:tickets_web_app/providers/users_provider.dart';
import 'package:tickets_web_app/router/router.dart';
import 'package:tickets_web_app/services/local_storage.dart';
import 'package:tickets_web_app/services/navigation_services.dart';
import 'package:tickets_web_app/services/notifications_service.dart';
import 'package:tickets_web_app/ui/layouts/auth/auth_layout.dart';
import 'package:tickets_web_app/ui/layouts/dashboard/dashboard_layout.dart';
import 'package:tickets_web_app/ui/layouts/splash/splash_layout.dart';

void main() async {
  await LocalStorage.configurePrefs();
  Flurorouter.configureRoutes();
  runApp(const AppState());
}

//----------------------------------------------------------------
class AppState extends StatelessWidget {
  const AppState({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          lazy: false,
          create: (_) => AuthProvider(),
        ),
        ChangeNotifierProvider(
          lazy: false,
          create: (_) => SideMenuProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => CompaniesProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => UsersProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => CompanyFormProvider(),
        ),
      ],
      child: const MyApp(),
    );
  }
}

//----------------------------------------------------------------
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Tickets',
      initialRoute: '/',
      onGenerateRoute: Flurorouter.router.generator,
      navigatorKey: NavigationServices.navigatorKey,
      scaffoldMessengerKey: NotificationsService.messengerKey,
      builder: (_, child) {
        final authProvider = Provider.of<AuthProvider>(context);
        if (authProvider.authStatus == AuthStatus.checking) {
          return const SplashLayout();
        }

        if (authProvider.authStatus == AuthStatus.authenticated) {
          return DashboardLayout(child: child!);
        } else {
          return AuthLayout(child: child!);
        }
      },
      theme: ThemeData.light().copyWith(
        scrollbarTheme: ScrollbarThemeData(
          thumbColor: MaterialStateProperty.all(Colors.grey[500]),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tickets_web_app/providers/providers.dart';
import 'package:tickets_web_app/router/router.dart';
import 'package:tickets_web_app/services/services.dart';
import 'package:tickets_web_app/ui/layouts/layouts.dart';

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
        ChangeNotifierProvider(
          create: (_) => UserFormProvider(),
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

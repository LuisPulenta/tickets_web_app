import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

import 'providers/providers.dart';
import 'router/router.dart';
import 'services/services.dart';
import 'ui/layouts/layouts.dart';

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
          create: (_) => CategoriesProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => CompaniesProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => BranchesProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => UsersProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => CategoryFormProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => SubcategoryFormProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => SubcategoriesProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => CompanyFormProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => BranchFormProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => UserFormProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => EditUserFormProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => ChangePasswordFormProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => TicketCabsProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => TicketCabsOkProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => TicketCabsDerivatedProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => TicketFormProvider(),
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
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('en'), Locale('es')],
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

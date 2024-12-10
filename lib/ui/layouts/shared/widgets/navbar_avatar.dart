import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tickets_web_app/providers/auth_provider.dart';
import 'package:tickets_web_app/services/services.dart';
import 'package:tickets_web_app/ui/buttons/link_text.dart';

class NavbarAvatar extends StatelessWidget {
  const NavbarAvatar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final userLogged =
        Provider.of<AuthProvider>(context, listen: false).user!.fullName;

    String? companyLogo = LocalStorage.prefs.getString('companyLogo');

    return Row(
      children: [
        LinkText(
            text: userLogged,
            onPressed: () =>
                NavigationServices.navigateTo('/dashboard/editUser')),
        const SizedBox(
          width: 15,
        ),
        FadeInImage(
          height: 30,
          placeholder: const AssetImage('assets/loader.gif'),
          image: NetworkImage(companyLogo!),
        ),
        const SizedBox(
          width: 15,
        ),
      ],
    );
  }
}

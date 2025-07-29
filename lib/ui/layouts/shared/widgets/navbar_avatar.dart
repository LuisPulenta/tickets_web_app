import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../providers/auth_provider.dart';
import '../../../../services/services.dart';
import '../../../buttons/link_text.dart';

class NavbarAvatar extends StatelessWidget {
  const NavbarAvatar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final userLogged = Provider.of<AuthProvider>(context, listen: false).user;

    String? companyLogo = LocalStorage.prefs.getString('tickets-companyLogo');

    return Row(
      children: [
        LinkText(
            text:
                '${userLogged!.fullName} - ${userLogged.email} - ${userLogged.userTypeName}',
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

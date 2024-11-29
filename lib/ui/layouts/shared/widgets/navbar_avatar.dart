import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tickets_web_app/providers/auth_provider.dart';
import 'package:tickets_web_app/services/services.dart';

class NavbarAvatar extends StatelessWidget {
  const NavbarAvatar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final userLogged =
        Provider.of<AuthProvider>(context, listen: false).user!.fullName;

    String? companyLogo = LocalStorage.prefs.getString('companyLogo');

    return Row(
      children: [
        Text(
          userLogged,
          style: const TextStyle(
              color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold),
        ),
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

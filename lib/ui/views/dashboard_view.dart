import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tickets_web_app/models/models.dart';
import 'package:tickets_web_app/providers/auth_provider.dart';
import 'package:tickets_web_app/ui/cards/white_card.dart';
import 'package:tickets_web_app/ui/labels/custom_labels.dart';

class DashboardView extends StatelessWidget {
  const DashboardView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    User user = authProvider.user!;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: ListView(
        physics: const ClampingScrollPhysics(),
        children: [
          Text(
            "DashboardView",
            style: CustomLabels.h1,
          ),
          const SizedBox(
            height: 10,
          ),
          WhiteCard(
            title: '${user.firstName} ${user.lastName}',
            child: Text(user.email),
          ),
        ],
      ),
    );
  }
}

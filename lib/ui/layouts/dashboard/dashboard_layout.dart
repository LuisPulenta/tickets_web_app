import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../providers/providers.dart';
import '../shared/sidebar.dart';
import '../shared/widgets/loader_component.dart';
import '../shared/widgets/navbar.dart';

class DashboardLayout extends StatefulWidget {
  final Widget child;

  const DashboardLayout({Key? key, required this.child}) : super(key: key);

  @override
  State<DashboardLayout> createState() => _DashboardLayoutState();
}

class _DashboardLayoutState extends State<DashboardLayout>
    with SingleTickerProviderStateMixin {
  late TicketFormProvider ticketFormProvider;
//----------------------------------------------------------------
  @override
  void initState() {
    super.initState();

    ticketFormProvider =
        Provider.of<TicketFormProvider>(context, listen: false);
    ticketFormProvider.description = '';

    SideMenuProvider.menuController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
  }

//----------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    bool showLoader = Provider.of<UsersProvider>(context).showLoader ||
        Provider.of<CompaniesProvider>(context).showLoader;
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: const Color(0xffEDF1F2),
      body: Stack(
        children: [
          Row(
            children: [
              if (size.width >= 700) const Sidebar(),
              Expanded(
                child: Column(
                  children: [
                    const Navbar(),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                        child: widget.child,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (size.width < 700)
            AnimatedBuilder(
              animation: SideMenuProvider.menuController,
              builder: (context, _) => Stack(
                children: [
                  if (SideMenuProvider.isOpen)
                    AnimatedOpacity(
                      opacity: SideMenuProvider.opacity.value,
                      duration: const Duration(milliseconds: 200),
                      child: GestureDetector(
                        onTap: () {
                          SideMenuProvider.closeMenu();
                        },
                        child: Container(
                          width: size.width,
                          height: size.height,
                          color: Colors.black26,
                        ),
                      ),
                    ),
                  Transform.translate(
                    offset: Offset(SideMenuProvider.movement.value, 0),
                    child: const Sidebar(),
                  ),
                ],
              ),
            ),
          showLoader
              ? Positioned(
                  left: size.width * 0.5 - 100,
                  top: size.height * 0.5 - 50,
                  child: const LoaderComponent(
                    text: 'Por favor espere...',
                  ))
              : Container(),
        ],
      ),
    );
  }
}

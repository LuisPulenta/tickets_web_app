import 'package:flutter/material.dart';
import 'package:tickets_web_app/ui/layouts/auth/widgets/background.dart';
import 'package:tickets_web_app/ui/layouts/auth/widgets/custom_title.dart';
import 'package:tickets_web_app/ui/layouts/auth/widgets/links_bar.dart';

class AuthLayout extends StatelessWidget {
  final Widget child;
  AuthLayout({Key? key, required this.child}) : super(key: key);

  final ScrollController controller = ScrollController();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: ListView(children: [
        (size.width >= 1000)
            ? _DesktopBody(child: child)
            : _MobileBody(child: child),

        //Links
        const LinksBar(),
      ]),
    );
  }
}

//------------------------------------------------------------
class _DesktopBody extends StatelessWidget {
  final Widget child;
  const _DesktopBody({required this.child});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      width: size.width,
      height: size.height * 0.92,
      color: Colors.white,
      child: Row(
        children: [
          //Twitter Background
          const Expanded(child: Background()),

          //View Container
          Container(
            width: 900,
            height: double.infinity,
            color: Colors.black,
            child: Column(
              children: [
                const CustomTitle(),
                Expanded(child: child),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

//------------------------------------------------------------
class _MobileBody extends StatelessWidget {
  final Widget child;
  const _MobileBody({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const SizedBox(
            height: 20,
          ),
          const CustomTitle(),
          SizedBox(
            width: double.infinity,
            height: 420,
            child: child,
          ),
          const SizedBox(
            width: double.infinity,
            child: Background(),
          ),
        ],
      ),
    );
  }
}

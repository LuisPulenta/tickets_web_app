import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class NotificationsService {
  static GlobalKey<ScaffoldMessengerState> messengerKey =
      GlobalKey<ScaffoldMessengerState>();

  //------------------------------------------------------------------------
  static showSnackbarError(String message) {
    final snackBar = SnackBar(
      backgroundColor: Colors.red.withOpacity(0.9),
      content: Text(
        message,
        style: const TextStyle(color: Colors.white, fontSize: 20),
      ),
    );
    messengerKey.currentState!.showSnackBar(snackBar);
  }

  //------------------------------------------------------------------------
  static showSnackbar(String message) {
    final snackBar = SnackBar(
      backgroundColor: Colors.green.withOpacity(0.9),
      content: Text(
        message,
        style: const TextStyle(color: Colors.white, fontSize: 20),
      ),
    );

    messengerKey.currentState!.showSnackBar(snackBar);
  }

  //------------------------------------------------------------------------
  static showBusyIndicator(BuildContext context) {
    const AlertDialog dialog = AlertDialog(
      content: SizedBox(
        width: 100,
        height: 100,
        child: Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );

    showDialog(context: context, builder: (_) => dialog);
  }

  //------------------------------------------------------------------------
  static showImage(BuildContext context, final String url) {
    final size = MediaQuery.of(context).size;

    showDialog(
        context: context,
        builder: (_) {
          return Stack(
            children: [
              InteractiveViewer(
                boundaryMargin: const EdgeInsets.all(double.infinity),
                child: SizedBox(
                  width: size.width,
                  height: size.height,
                  child: FadeInImage.assetNetwork(
                    placeholder: 'assets/loading.gif',
                    image: url,
                    fit: BoxFit.contain,
                    width: size.width,
                    height: size.height,
                  ),
                ),
              ),
              Positioned(
                top: size.height * 0.1,
                right: size.width * 0.1,
                child: IconButton(
                  icon: const Icon(
                    FontAwesomeIcons.rectangleXmark,
                    color: Colors.white,
                    size: 40,
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ),
            ],
          );
        });
  }

  //------------------------------------------------------------------------
  static downLoadFile(final String url) async {
    if (await canLaunch(url)) {
      await launch(
        url,
        headers: {
          'Content-Type': 'application/pdf',
          'Content-Disposition': 'inline'
        },
      );
    } else {
      throw 'Could not launch $url';
    }
  }
}

import 'package:flutter/material.dart';
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
    AlertDialog dialog = AlertDialog(
      content: SizedBox(
        width: 500,
        height: 500,
        child: FadeInImage.assetNetwork(
          placeholder: 'loader.gif',
          image: url,
          width: 500,
          height: 500,
        ),
      ),
    );

    showDialog(context: context, builder: (_) => dialog);
  }

  //------------------------------------------------------------------------
  static downLoadFile(final String url) async {
    if (await canLaunch(url)) {
      await launch(
        url,
        headers: {
          "Content-Type": "application/pdf",
          "Content-Disposition": "inline"
        },
      );
    } else
      // can't launch url, there is some error
      throw "Could not launch $url";
  }
}

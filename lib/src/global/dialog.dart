import 'package:candles/src/global/global_app_colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DialogCustom {
  // show dialog when login request initialize
  static Future shoDialog(BuildContext context) {
    final dialog = showDialog(
        context: context,
        useSafeArea: false,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
              title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              CircularProgressIndicator(),
              Text("Please wait..",
                  style: GoogleFonts.aBeeZee(color: CandlesAppColor.dark_blue))
            ],
          ));
        });
    return dialog;
  }
}

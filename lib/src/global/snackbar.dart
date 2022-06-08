import 'package:candles/src/global/global_app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class Snackbar {
  // show snackbar to user if error or some important information to show to use in case login not successfull
  // else redirect the user to app home
  static dynamic showsnakbar(
      {required String snakTitle,
      required Color colorr,
      required BuildContext context}) {
    SystemChannels.textInput.invokeListMethod("TextInput.hide");
    final snak = ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      backgroundColor: colorr,
      content: Text(snakTitle,
          style: GoogleFonts.aBeeZee(
              color: CandlesAppColor.system_status_bar_color)),
    ));

    return snak;
  }
}

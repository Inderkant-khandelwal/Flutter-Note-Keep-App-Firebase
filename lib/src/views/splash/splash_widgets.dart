import 'package:candles/src/routes/routes_url.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../global/global_app_colors.dart';

class SplashWidget {
  static Widget socailMediaIcon({required imagename}) {
    final Widget icons = Padding(
        padding: EdgeInsets.only(left: 20.0, top: 5.0),
        child: CircleAvatar(
            backgroundColor: CandlesAppColor.transparent,
            backgroundImage: AssetImage("assets/images/social/$imagename")));
    return icons;
  }

  static Widget rowForTwoButton(
    BuildContext context, {
    required String text,
  }) {
    Widget row = Expanded(
        child: Padding(
      padding: const EdgeInsets.only(left: 5.0),
      child: InkWell(
        borderRadius: BorderRadius.circular(40),
        onTap: () => {
          text == "Login"
              ? Navigator.pushNamed(context, CandlesRoute.login)
              : text == "Sign Up"
                  ? Navigator.pushNamed(context, CandlesRoute.signup)
                  : ""
        },
        child: Ink(
            width: MediaQuery.of(context).size.width / 2,
            height: 60,
            decoration: BoxDecoration(
                border: Border.all(
                    width: 2,
                    color: text != "Login"
                        ? CandlesAppColor.black_color
                        : CandlesAppColor.transparent),
                borderRadius: BorderRadius.circular(40),
                color: text == "Login"
                    ? CandlesAppColor.indigo
                    : CandlesAppColor.system_status_bar_color),
            child: Align(
              alignment: Alignment.center,
              child: Text(text,
                  style: GoogleFonts.lato(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: text == "Login"
                          ? CandlesAppColor.system_status_bar_color
                          : CandlesAppColor.black_color)),
            )),
      ),
    ));
    return row;
  }
}

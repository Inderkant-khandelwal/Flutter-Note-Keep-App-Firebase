import 'package:candles/src/global/global_app_colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class GlobalWidgets {
  static Widget row = Row(
    children: <Widget>[
      Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/images/icon/icon.png")),
            shape: BoxShape.circle),
      ),
      Padding(
        padding: const EdgeInsets.only(left: 10.0),
        child: Text(
          "",
          textDirection: TextDirection.ltr,
          style: GoogleFonts.lato(
              color: CandlesAppColor.black_color, fontWeight: FontWeight.bold),
        ),
      )
    ],
  );
}

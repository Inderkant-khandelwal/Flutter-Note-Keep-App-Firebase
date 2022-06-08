import 'package:candles/src/global/global_app_colors.dart';
import 'splash_widgets.dart';
import "package:flutter/material.dart";
import 'package:google_fonts/google_fonts.dart';

import '../../global/global_widgets.dart';

class SplashFirst extends StatefulWidget {
  const SplashFirst({Key? key}) : super(key: key);

  @override
  State<SplashFirst> createState() => _SplashFirstState();
}

class _SplashFirstState extends State<SplashFirst> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          elevation: 0.0,
          title: GlobalWidgets.row,
          backgroundColor: CandlesAppColor.system_status_bar_color,
        ),
        backgroundColor: CandlesAppColor.system_status_bar_color,

        // body start

        body: ListView(
          children: <Widget>[
            Container(
              child: Column(children: [
                Container(
                  height: MediaQuery.of(context).size.height / 2 * 0.8,
                  width: CandlesAppColor.width(context),
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image:
                              AssetImage("assets/images/splash_screen_top.png"),
                          fit: BoxFit.contain)),
                ),
                Column(
                  children: [
                    // making text just next to container
                    Text("Welcome!",
                        style: GoogleFonts.lato(
                            fontWeight: FontWeight.w900, fontSize: 30)),

                    SizedBox(height: 20),
                    // content just next to welcome
                    Text("Awesome note keep, App for you",
                        style: GoogleFonts.lato(
                            color: CandlesAppColor.light_gray,
                            fontSize: 18,
                            fontWeight: FontWeight.bold)),
                    Text("we are now talk of town",
                        style: GoogleFonts.lato(
                            color: CandlesAppColor.light_gray,
                            fontSize: 18,
                            fontWeight: FontWeight.bold)),

                    SizedBox(height: 50.0),
                    // two button
                    Padding(
                      padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            SplashWidget.rowForTwoButton(context,
                                text: "Login"),
                            SplashWidget.rowForTwoButton(context,
                                text: "Sign Up")
                          ]),
                    ),

                    SizedBox(height: 40.0),
                    //bottom SocialMediaButton
                    Align(
                      alignment: Alignment.center,
                      child: Container(
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 5.0),
                              child: Text("or via social media",
                                  style: GoogleFonts.lato(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: CandlesAppColor.black_color)),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SplashWidget.socailMediaIcon(
                                    imagename: CandleAppImage.facebook),
                                SplashWidget.socailMediaIcon(
                                    imagename: CandleAppImage.google),
                                SplashWidget.socailMediaIcon(
                                    imagename: CandleAppImage.linkedIn),
                              ],
                            )
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ]),
            )
          ],
        ),
      ),
    );
  }
}

// jai shri Ganesh , Har Har Mahadev Jai Gauri Shankar ki , Jai Lakshmi Narayan Bhagwan ki Jai Saraswati Maiya ki

import 'package:candles/firebase_options.dart';
import 'package:candles/src/routes/routes_url.dart';
import './src/views/addnotes/add_note_screen.dart';
import './src/views/changepassword/change_pass_screen.dart';
import './src/views/forgotpassword/forgot_password_screen.dart';
import './src/views/home/home_page.dart';
import './src/views/login/login_page.dart';
import './src/views/signup/sign_up_page.dart';
import './src/views/splash/splash_page_screen.dart';
import './src/views/updatenote/update_note_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import "package:flutter/services.dart";
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import "./src/global/global_app_colors.dart";

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: CandlesAppColor.system_status_bar_color,
      systemNavigationBarColor: CandlesAppColor.system_status_bar_color,
      systemNavigationBarIconBrightness: Brightness.dark,
      statusBarIconBrightness: Brightness.dark));
  runApp(CandelsApp());
}

// ignore: must_be_immutable
class CandelsApp extends StatefulWidget {
  @override
  State<CandelsApp> createState() => _CandelsAppState();
}

class _CandelsAppState extends State<CandelsApp> {
  bool _isUserLoggedInApp = false;

  bool _isUserPreviousLogged = false;

  // initalise storeage package
  final _strorage = new FlutterSecureStorage();

  // check if user is loged in or not
  Future<void> checkIfUserIsLogged() async {
    String? isLoged = await _strorage.read(key: "userIdx");

    if (isLoged == null) {
      _isUserLoggedInApp = false;
      print("inder USER NULL $isLoged - $_isUserLoggedInApp");
    } else {
      _isUserLoggedInApp = true;
      print("inder USER NOT NULL $isLoged - $_isUserLoggedInApp");
    }
  }

  // check if user previous logged
  Future<void> checkIfUserPreviousLogged() async {
    String? isPrevLoged = await _strorage.read(key: "isUser");

    if (isPrevLoged == null) {
      _isUserPreviousLogged = false;
      print("inder PREV NULL $isPrevLoged - $_isUserPreviousLogged");
    } else {
      _isUserPreviousLogged = true;
      print("inder PREV NOT NULL $isPrevLoged - $_isUserPreviousLogged");
    }
  }

  @override
  void initState() {
    checkIfUserIsLogged();
    checkIfUserPreviousLogged();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print("User Widget Logged $_isUserLoggedInApp");
    print("User Widget Prev $_isUserPreviousLogged");
    return FutureBuilder(
        future: checkIfUserIsLogged(),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Container(
              color: Colors.white,
              child: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            initialRoute: _isUserLoggedInApp
                ? CandlesRoute.home_route
                : _isUserPreviousLogged
                    ? CandlesRoute.login
                    : CandlesRoute.splash_screen_first,
            title: "Candles",
            routes: {
              CandlesRoute.home_route: (context) => HomePage(),
              CandlesRoute.splash_screen_first: (context) => SplashFirst(),
              CandlesRoute.create_note: (context) => AddNote(),
              CandlesRoute.edit_note: (context) => UpdateNote(),
              CandlesRoute.login: (context) => Login(),
              CandlesRoute.signup: (context) => SignUp(),
              CandlesRoute.forgotpassword: (context) => ForgotPassword(),
              CandlesRoute.changepassword: (context) => ChangePassword()
            },
          );
        });
  }
}

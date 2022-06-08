import 'package:candles/src/global/global_app_colors.dart';
import 'package:candles/src/routes/routes_url.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import "../../global/dialog.dart";
import "../../global/snackbar.dart";

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  // initalise storeage package
  final _strorage = new FlutterSecureStorage();

// form global key
  final _formLoginKey = GlobalKey<FormState>();

  // filed for add note
  String email_field = "";
  String password_field = "";

  // firebaseAuth instance
  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  // text editinng controllers
  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();

  @override
  void dispose() {
    // clean up the controller when widget is dispose
    email.dispose();
    password.dispose();

    super.dispose();
  }

  // clear form
  clearForm() {
    email.clear();
    password.clear();
  }

// function for user login
  loginNow({required BuildContext context}) async {
    // unfocus the keyboard so that it wont open unnecessary when server send response
    // removing this line will get open the keyboard unnecessary s
    FocusManager.instance.primaryFocus?.unfocus();

    // show loader when user click on login button
    DialogCustom.shoDialog(context);
    try {
      UserCredential _userCredential =
          await _firebaseAuth.signInWithEmailAndPassword(
              email: email_field, password: password_field);

      // set user id in storege for detecting is User loged or nor
      final _userId = _userCredential.user?.uid;
      await _strorage.write(key: "userIdx", value: _userId);
      await _strorage.write(key: "isUser", value: "true");

      // hide loader
      Navigator.pop(context);

      // clear form
      clearForm();

      Navigator.pushNamedAndRemoveUntil(
          context, CandlesRoute.home_route, (route) => false);
    } on FirebaseAuthException catch (e) {
      if (e.code == "user-not-found") {
        // hide loader
        Navigator.pop(context);

        Snackbar.showsnakbar(
            snakTitle: "User Not Found !",
            colorr: CandlesAppColor.red,
            context: context);
      } else if (e.code == "wrong-password") {
        // hide loader
        Navigator.pop(context);

        Snackbar.showsnakbar(
            snakTitle: "Credentials Not Match!",
            colorr: CandlesAppColor.red,
            context: context);
      }
    } catch (e) {
      // hide loader
      Navigator.pop(context);

      Snackbar.showsnakbar(
          snakTitle: "Some Error Occured !",
          colorr: CandlesAppColor.red,
          context: context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CandlesAppColor.system_status_bar_color,
      appBar: AppBar(
        backgroundColor: CandlesAppColor.system_status_bar_color,
        elevation: 0.0,
        title: Text("Login",
            style: GoogleFonts.aBeeZee(
                color: CandlesAppColor.dark_blue,
                fontWeight: FontWeight.bold,
                fontSize: 20)),
      ),

      // ading body to the form
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            // heading start
            // topHeading(text: "Secure! Login "),
            Form(
                key: _formLoginKey,
                child: Column(
                  children: [
                    Container(
                      height: MediaQuery.of(context).size.height / 2 * 0.6,
                      width: CandlesAppColor.width(context),
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage("assets/images/login.png"),
                              fit: BoxFit.cover)),
                    ),
                    SizedBox(height: 10.0),
                    formTextField(
                        id: "email",
                        headingtext: "Email",
                        labeltext: "Enter Your Email",
                        hinttext: "Your Registered Email",
                        icon: Icons.email,
                        textEditingController: email),
                    formTextField(
                        id: "password",
                        headingtext: "Password",
                        labeltext: "Enter Your Password",
                        hinttext: "Your Registered Password",
                        icon: Icons.lock,
                        textEditingController: password),
                    TextButton(
                        style: TextButton.styleFrom(
                            minimumSize: Size(10, 20),
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            padding: EdgeInsets.zero),
                        onPressed: () {
                          Navigator.pushReplacementNamed(
                              context, CandlesRoute.forgotpassword);
                        },
                        child: Text("Forgot Password ?",
                            style: GoogleFonts.aBeeZee(
                                color: CandlesAppColor.dark_blue))),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Don't have Account ?",
                            style: GoogleFonts.aBeeZee(
                                fontWeight: FontWeight.bold,
                                color: CandlesAppColor.dark_blue)),
                        TextButton(
                            onPressed: () {
                              Navigator.pushReplacementNamed(
                                  context, CandlesRoute.signup);
                            },
                            child: Text("Sign Up",
                                style: GoogleFonts.aBeeZee(
                                    color: CandlesAppColor.dark_blue))),
                      ],
                    )
                  ],
                ))
          ],
        ),
      ),

      bottomNavigationBar: addButton(context, _formLoginKey),
    );
  }

  // top heaing
  Widget topHeading({required String text}) {
    final Widget heading = Align(
        alignment: Alignment.topLeft,
        child: Padding(
            padding: EdgeInsets.only(left: 15.0),
            child: Text(text,
                style: GoogleFonts.aBeeZee(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: CandlesAppColor.dark_blue))));

    return heading;
  }

  // add button

  Widget addButton(context, formkey) {
    final Widget container = Padding(
        padding: EdgeInsets.all(12.0),
        child: InkWell(
            borderRadius: BorderRadius.circular(12.0),
            onTap: () {
              if (formkey.currentState!.validate()) {
                setState(() {
                  email_field = email.text;
                  password_field = password.text;
                });

                loginNow(context: context);

                print("form is validate");
              }
            },
            child: Ink(
                width: CandlesAppColor.width(context),
                height: 60,
                decoration: BoxDecoration(
                    color: CandlesAppColor.dark_blue,
                    borderRadius: BorderRadius.circular(12.0)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Login",
                        style: GoogleFonts.aBeeZee(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: CandlesAppColor.system_status_bar_color))
                  ],
                ))));
    return container;
  }

  // form text filed start

  Widget formTextField(
      {required String id,
      required String headingtext,
      required String hinttext,
      required String labeltext,
      required icon,
      required TextEditingController textEditingController}) {
    // making function for input validation
    validateInputs(val, String id) {
      // local variabel for checkig email and password
      bool islocalEmalValid = false;
      bool islocalPasswordValid = false;

      if (islocalEmalValid == true && islocalPasswordValid == true) {
        return null;
      }

      if (id == "email") {
        final bool isEmailValid = RegExp(
                r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
            .hasMatch(val);
        if (isEmailValid) {
          islocalEmalValid = true;
        } else {
          return "Valid Email Required!";
        }
      }

      if (id == "password") {
        if (val.toString().length > 5) {
          islocalPasswordValid = true;
        } else {
          return "Valid password required! More than 5 digit";
        }
      }

      // end of input method
    }

    OutlineInputBorder oulineBorder() {
      final outlineInputBorder = OutlineInputBorder(
          borderSide: BorderSide(width: 2.0, color: CandlesAppColor.dark_blue),
          borderRadius: BorderRadius.circular(5.0));
      return outlineInputBorder;
    }

    OutlineInputBorder outlineErrorborder() {
      final outlineInputBorder = OutlineInputBorder(
          borderSide: BorderSide(width: 2.0, color: CandlesAppColor.red),
          borderRadius: BorderRadius.circular(5.0));
      return outlineInputBorder;
    }

    final Widget textFiled = Padding(
        padding: EdgeInsets.all(12.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 13.0, left: 2.0),
              child: Align(
                alignment: Alignment.topLeft,
                child: Text(headingtext,
                    style: GoogleFonts.aBeeZee(
                        color: CandlesAppColor.dark_blue,
                        fontSize: 15,
                        fontWeight: FontWeight.bold)),
              ),
            ),
            TextFormField(
              obscureText: id == "password" ? true : false,
              controller: textEditingController,
              validator: (value) => validateInputs(value, id),
              cursorColor: CandlesAppColor.dark_blue,
              style: GoogleFonts.aBeeZee(
                decoration: TextDecoration.none,
                decorationColor: CandlesAppColor.dark_blue.withOpacity(0.0),
                decorationThickness: 0.0,
                color: CandlesAppColor.dark_blue,
              ),
              decoration: InputDecoration(
                focusedErrorBorder: outlineErrorborder(),
                errorBorder: outlineErrorborder(),
                // focus border
                focusedBorder: oulineBorder(),
                // enable border
                enabledBorder: oulineBorder(),
                alignLabelWithHint: true,
                hintText: hinttext,
                hintStyle: TextStyle(
                    decoration: TextDecoration.none,
                    color: CandlesAppColor.dark_blue),
                labelText: labeltext,
                labelStyle: TextStyle(
                    decoration: TextDecoration.none,
                    color: CandlesAppColor.dark_blue),
                suffixIcon: Icon(
                  icon,
                  color: CandlesAppColor.dark_blue,
                ),
              ),
            ),
          ],
        ));

    return textFiled;
  }

  // end of the State class
}

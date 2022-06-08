import 'package:candles/src/global/global_app_colors.dart';
import 'package:candles/src/routes/routes_url.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import "../../global/dialog.dart";
import "../../global/snackbar.dart";

class ChangePassword extends StatefulWidget {
  const ChangePassword({Key? key}) : super(key: key);

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  // form global key
  final _formLoginKey = GlobalKey<FormState>();

  // field for change password
  String _new_pass_field = "";

  // firebase Authinstance for current user
  User? _firebaseAuthUser = FirebaseAuth.instance.currentUser;

  // text editinng controllers for password
  final TextEditingController password = TextEditingController();

  @override
  void dispose() {
    // clean up the controller when widget is dispose
    password.dispose();

    super.dispose();
  }

  // clear form
  clearForm() {
    password.clear();
  }

  changeNewPassword({required BuildContext context}) async {
    // unfocus the keyboard so that it wont open unnecessary when server send response
    // removing this line will get open the keyboard unnecessary s
    FocusManager.instance.primaryFocus?.unfocus();

    // show loader when user click on login button
    DialogCustom.shoDialog(context);
    try {
      await _firebaseAuthUser!.updatePassword(_new_pass_field);

      //  clear form filed
      clearForm();

      // hide loader
      Navigator.pop(context);

      // show user a mesage that password is set successfully
      Snackbar.showsnakbar(
          snakTitle: "Password Changed Successfully!",
          colorr: CandlesAppColor.green,
          context: context);

      // Signout user and ask to re-login with new password
      FirebaseAuth.instance.signOut();

      // redirect user to login page
      Navigator.pushNamed(context, CandlesRoute.login);

      // clear the form
      clearForm();
    } catch (e) {
      // hide loader
      Navigator.pop(context);

      // show snack bar if some error occured
      Snackbar.showsnakbar(
          snakTitle: "Some Error Occured !",
          colorr: CandlesAppColor.red,
          context: context);

      print(e);
    }

    // show message to user
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CandlesAppColor.system_status_bar_color,
      appBar: AppBar(
        backgroundColor: CandlesAppColor.system_status_bar_color,
        elevation: 0.0,
        title: Text("Change Password",
            style: GoogleFonts.aBeeZee(
                color: CandlesAppColor.dark_blue,
                fontWeight: FontWeight.bold,
                fontSize: 20)),
        leading: IconButton(
            tooltip: "Go Back",
            color: CandlesAppColor.dark_blue,
            enableFeedback: true,
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.arrow_back)),
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
                              image: AssetImage(
                                  "assets/images/forgot_password.png"),
                              fit: BoxFit.cover)),
                    ),
                    SizedBox(height: 10.0),
                    formTextField(
                        id: "password",
                        headingtext: "New Password",
                        labeltext: "Enter Your New Password",
                        hinttext: "New Password",
                        icon: Icons.lock,
                        textEditingController: password),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Explore the App ?",
                            style: GoogleFonts.aBeeZee(
                                fontWeight: FontWeight.bold,
                                color: CandlesAppColor.dark_blue)),
                        TextButton(
                            onPressed: () {
                              Navigator.pushReplacementNamed(
                                  context, CandlesRoute.home_route);
                            },
                            child: Text("Go to Home",
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
                  _new_pass_field = password.text;
                });
                changeNewPassword(context: context);

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
                    Text("Change Password",
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
      // bool isPasswordValid = false;

      // if (isPasswordValid == true) {
      //   return null;
      // }

      if (id == "password") {
        if (val.toString().length > 5) {
          // isPasswordValid = true;
          return null;
        } else {
          return "Valid Password Required! More than 5 digit";
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
              obscureText: true,
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

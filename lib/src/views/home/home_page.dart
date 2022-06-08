import 'package:candles/src/global/global_app_colors.dart';
import 'package:candles/src/routes/routes_url.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import "package:flutter/material.dart";
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../global/global_widgets.dart';
import "../../global/dialog.dart";
import "../../global/snackbar.dart";

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // initalise storeage package
  final _strorage = new FlutterSecureStorage();

  // firbase instance

  Stream<QuerySnapshot> _collectionStream =
      FirebaseFirestore.instance.collection("Note_Collection").snapshots();

  // firebase instace for user

  User? user = FirebaseAuth.instance.currentUser;

  // firebase Auth instance

  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  // Collection reference

  CollectionReference note_collection =
      FirebaseFirestore.instance.collection("Note_Collection");

  // delete user
  Future<void> deleteNote(id) {
    // show loader
    DialogCustom.shoDialog(context);
    return note_collection
        .doc(id)
        .delete()
        .then((value) => {
              // hide loader
              Navigator.pop(context),
              Snackbar.showsnakbar(
                  snakTitle: "Deleted Successfuly !",
                  colorr: CandlesAppColor.green,
                  context: context)
            })
        .catchError((e) => {
              // hide loader
              Navigator.pop(context),
              Snackbar.showsnakbar(
                  snakTitle: "Deletion Failed !",
                  colorr: CandlesAppColor.red,
                  context: context)
            });
  }

// verify emailfunction
  verifyEmail() async {
    // show loader
    DialogCustom.shoDialog(context);
    try {
      if (user != null && !user!.emailVerified) {
        await user!.sendEmailVerification();
        // hide loader
        Navigator.pop(context);

        // show message to user that email verification link has been sent successfully
        Snackbar.showsnakbar(
            snakTitle: "Verification Link Sent Successfully!",
            colorr: CandlesAppColor.green,
            context: context);

        // sign out user
        signOut();
        //ask user to re login again
        Navigator.pushNamedAndRemoveUntil(
            context, CandlesRoute.login, (context) => false);
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

  // signout

  signOut() async {
    await _firebaseAuth.signOut();
    await _strorage.delete(key: "userIdx");
    Navigator.pushNamedAndRemoveUntil(
        context, CandlesRoute.login, (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: _collectionStream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Container(
                color: CandlesAppColor.system_status_bar_color,
                child: Center(child: Text("Some Erro Occured")));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Container(
                color: CandlesAppColor.system_status_bar_color,
                child: Center(child: CircularProgressIndicator()));
          }

          final List list = [];

          snapshot.data!.docs.map((DocumentSnapshot document) {
            Map datax = document.data() as Map<String, dynamic>;
            list.add(datax);
            datax['id'] = document.id;
          }).toList();

          return Scaffold(
            appBar: AppBar(
              actions: [
                IconButton(
                    onPressed: () {},
                    icon:
                        Icon(Icons.more_vert, color: CandlesAppColor.dark_blue))
              ],
              elevation: 0.3,
              titleSpacing: 0.0,
              title: GlobalWidgets.row,
              iconTheme: IconThemeData(color: CandlesAppColor.black_color),
              backgroundColor: CandlesAppColor.system_status_bar_color,
            ),
            drawer: Drawer(
              child: Column(
                children: [
                  UserAccountsDrawerHeader(
                      otherAccountsPictures: [
                        user!.emailVerified
                            ? IconButton(
                                onPressed: () {},
                                icon: Icon(Icons.verified,
                                    color: CandlesAppColor
                                        .system_status_bar_color))
                            : IconButton(
                                onPressed: () {},
                                icon: Icon(Icons.close,
                                    color: CandlesAppColor.red))
                      ],
                      currentAccountPicture: CircleAvatar(
                        backgroundColor: CandlesAppColor.transparent,
                        backgroundImage:
                            AssetImage("assets/images/user_icon.png"),
                      ),
                      decoration:
                          BoxDecoration(color: CandlesAppColor.dark_blue),
                      accountName: Text("Hi , Welcome",
                          style: GoogleFonts.aBeeZee(
                              color: CandlesAppColor.system_status_bar_color)),
                      accountEmail: Text(user!.email ?? "Your Email",
                          style: GoogleFonts.aBeeZee(
                              color: CandlesAppColor.system_status_bar_color))),
                  user!.emailVerified
                      ? listTileItem(
                          "Email Verified", Icons.check_circle_rounded)
                      : listTileItem(
                          "Verify Your Email", Icons.mark_email_unread),
                  listTileItem("Home", Icons.home),
                  listTileItem("Change Password", Icons.lock_sharp),
                  Divider(),
                  listTileItem("Add Note", Icons.note_add),
                  Spacer(),
                  Expanded(
                    child: Align(
                        alignment: Alignment.bottomCenter,
                        child: listTileItem("Logout", Icons.logout)),
                  )
                ],
              ),
            ),
            backgroundColor: CandlesAppColor.system_status_bar_color,
            floatingActionButton: FloatingActionButton(
                onPressed: () {
                  // print(snapshot.data!.docs.toList()[1].data());
                  // print(list);

                  Navigator.pushNamed(context, CandlesRoute.create_note);
                },
                child: Icon(Icons.edit),
                backgroundColor: CandlesAppColor.dark_blue),
            floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,
            body: ListView.builder(
                physics: AlwaysScrollableScrollPhysics(),
                itemCount: list.length,
                itemBuilder: (BuildContext context, int index) {
                  return Card(
                    elevation: 0.3,
                    child: ExpansionTile(
                      iconColor: CandlesAppColor.dark_blue,
                      leading: Icon(
                        Icons.folder,
                        color: CandlesAppColor.dark_blue,
                      ),
                      initiallyExpanded: false,
                      children: [
                        Container(
                          decoration:
                              BoxDecoration(color: CandlesAppColor.grey_x),
                          child: Column(
                            children: [
                              Align(
                                alignment: Alignment.topRight,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    InkWell(
                                      onTap: () => Navigator.pushNamed(
                                          context, CandlesRoute.edit_note,
                                          arguments: {"id": list[index]['id']}),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: CircleAvatar(
                                            backgroundColor:
                                                CandlesAppColor.green,
                                            radius: 17,
                                            child: Icon(
                                              Icons.edit,
                                              color: CandlesAppColor
                                                  .system_status_bar_color,
                                            )),
                                      ),
                                    ),
                                    InkWell(
                                      splashColor: Colors.red,
                                      onTap: () =>
                                          deleteNote(list[index]['id']),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: CircleAvatar(
                                            backgroundColor:
                                                CandlesAppColor.red,
                                            radius: 17,
                                            child: Icon(
                                              Icons.delete,
                                              color: CandlesAppColor
                                                  .system_status_bar_color,
                                            )),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(15.0),
                                child: Text(list[index]["note_desc"],
                                    style: GoogleFonts.aBeeZee(
                                      color: CandlesAppColor.dark_blue,
                                      letterSpacing: 0.2,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500,
                                    )),
                              ),
                            ],
                          ),
                        )
                      ],
                      title: Text(list[index]['person_name'],
                          style: GoogleFonts.aBeeZee(
                            color: CandlesAppColor.dark_blue,
                            letterSpacing: 0.2,
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          )),
                      subtitle: Text(list[index]['note_title'],
                          style: GoogleFonts.aBeeZee(
                            color: CandlesAppColor.dark_blue,
                          )),
                    ),
                  );
                }),
          );
        });
  }

// drawer list item
  Widget listTileItem(String title, IconData icon) {
    return ListTile(
      minVerticalPadding: 0.0,
      selected: title == "Home" ? true : false,
      dense: true,
      selectedTileColor: Colors.grey[100]!.withOpacity(0.5),
      title: Text(
        title,
        style: GoogleFonts.lato(
            fontWeight: FontWeight.bold,
            color: Colors.grey[800]!.withOpacity(0.8)),
      ),
      leading: Icon(icon,
          color: title == "Verify Your Email"
              ? CandlesAppColor.red
              : title == "Email Verified"
                  ? CandlesAppColor.green
                  : Colors.grey[500]!.withOpacity(0.8)),
      trailing: Icon(
        Icons.arrow_right_sharp,
        color: Colors.grey[500],
      ),
      onTap: () {
        if (title == "Verify Your Email") {
          Navigator.pop(context);
          verifyEmail();
        }
        title == "Home" ? Navigator.pop(context) : "";

        if (title == "Change Password") {
          Navigator.pop(context);
          Navigator.pushNamed(context, CandlesRoute.changepassword);
        }

        if (title == "Add Note") {
          Navigator.pop(context);
          Navigator.pushNamed(context, CandlesRoute.create_note);
        }

        title == "Logout" ? signOut() : "";
      },
    );
  }

  // end of class
}

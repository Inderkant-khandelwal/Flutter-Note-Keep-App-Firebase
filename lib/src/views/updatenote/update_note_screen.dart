import 'package:candles/src/global/global_app_colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import "../../global/dialog.dart";
import "../../global/snackbar.dart";

class UpdateNote extends StatefulWidget {
  const UpdateNote({Key? key}) : super(key: key);

  @override
  State<UpdateNote> createState() => _UpdateNoteState();
}

class _UpdateNoteState extends State<UpdateNote> {
  // access arguments

// form global key
  static final _formKeyId = GlobalKey<FormState>();

  // filed for add note
  late String _person_name;
  late String _note_title;
  late String _note_desc;
  dynamic id = "";

  // firebase instance
  CollectionReference collection =
      FirebaseFirestore.instance.collection("Note_Collection");

  Future<void> updateNote(
      {required BuildContext context,
      required idd,
      required String pname,
      required String ntitle,
      required String ndesc}) {
    // show loader
    DialogCustom.shoDialog(context);
    Map<String, dynamic> note_data = {
      'id': id,
      'person_name': pname,
      'note_title': ntitle,
      'note_desc': ndesc
    };

    return collection
        .doc(idd)
        .update(note_data)
        .then((value) => {
              // hide loader
              Navigator.pop(context),
              // go back
              Navigator.pop(context),
              Snackbar.showsnakbar(
                  snakTitle: "Successfully Updated !",
                  colorr: CandlesAppColor.green,
                  context: context)
            })
        .catchError((e) => {
              // hide loader
              Navigator.pop(context),
              Snackbar.showsnakbar(
                  snakTitle: "Some Error Occured !",
                  colorr: CandlesAppColor.red,
                  context: context)
            });
  }

  @override
  Widget build(BuildContext context) {
    var argX = ModalRoute.of(context)!.settings.arguments as Map;
    id = argX["id"];

    return Scaffold(
      backgroundColor: CandlesAppColor.system_status_bar_color,
      appBar: AppBar(
        backgroundColor: CandlesAppColor.system_status_bar_color,
        elevation: 0.0,
        title: Text("Update Note",
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
            topHeading(text: "Happy ! Journey"),
            Form(
                key: _formKeyId,
                child: FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                    future: FirebaseFirestore.instance
                        .collection('Note_Collection')
                        .doc(argX["id"].toString())
                        .get(),
                    builder: (_, snapshot) {
                      if (snapshot.hasError) {
                        return Container(
                          color: CandlesAppColor.system_status_bar_color,
                          child: Center(child: Text("Some Error Occured")),
                        );
                      }
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      }

                      // taking data out from obj
                      var datay = snapshot.data!.data();
                      String person_data = datay!['person_name'];
                      String note_title_data = datay['note_title'];
                      String note_desc_data = datay['note_desc'];
                      _person_name = person_data;
                      _note_title = note_title_data;
                      _note_desc = note_desc_data;
                      // print(datay);

                      return Column(
                        children: [
                          SizedBox(height: 10.0),
                          formTextField(
                              id: "person",
                              headingtext: "Person Name",
                              labeltext: "Enter Your Name",
                              hinttext: "Enter Person Name",
                              icon: Icons.perm_identity,
                              initValX: person_data),
                          formTextField(
                              id: "notetitle",
                              headingtext: "Note Title",
                              labeltext: "Enter Note Title",
                              hinttext: "Enter Tile Here",
                              icon: Icons.note,
                              initValX: note_title_data),
                          formTextField(
                              id: "notedesc",
                              headingtext: "Note Description",
                              labeltext: "Enter Note Description",
                              hinttext: "Enter Description Here",
                              icon: Icons.description,
                              initValX: note_desc_data)
                        ],
                      );
                    }))
          ],
        ),
      ),

      bottomNavigationBar: addButton(context, _formKeyId),
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
                if (_person_name.length > 2 &&
                    _note_title.length > 2 &&
                    _note_desc.length > 2) {
                  updateNote(
                      context: context,
                      idd: id,
                      pname: _person_name,
                      ntitle: _note_title,
                      ndesc: _note_desc);
                } else {
                  print("Form is not validated");
                }
              }
            },
            child: Ink(
                height: 60,
                decoration: BoxDecoration(
                    color: CandlesAppColor.dark_blue,
                    borderRadius: BorderRadius.circular(12.0)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Update Note",
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
      required String initValX}) {
    // making function for input validation
    validateInputs(val, String id) {
      if (val != null && val.toString().length > 2) {
        return null;
      }

      switch (id) {
        case "person":
          return "Valid Person Name Required";

        case "notetitle":
          return "Valid Note Title Required";

        case "notedesc":
          return "Valid Note Desciption Required";
      }
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

    // text form filed value
    handleValueChange(value, id) {
      switch (id) {
        case "person":
          _person_name = value.toString();

          break;

        case "notetitle":
          _note_title = value.toString();

          break;

        case "notedesc":
          _note_desc = value.toString();

          break;
      }
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
              initialValue: initValX,
              onChanged: (value) => handleValueChange(value, id),
              validator: (value) => validateInputs(value, id),
              maxLines: id == "notedesc" ? 10 : 1,
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

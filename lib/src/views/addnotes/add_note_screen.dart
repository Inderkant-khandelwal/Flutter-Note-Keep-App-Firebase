import 'package:candles/src/global/global_app_colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import "../../global/dialog.dart";
import "../../global/snackbar.dart";

class AddNote extends StatefulWidget {
  const AddNote({Key? key}) : super(key: key);

  @override
  State<AddNote> createState() => _AddNoteState();
}

class _AddNoteState extends State<AddNote> {
// form global key
  final _formKey = GlobalKey<FormState>();

  // filed for add note
  late final String person_name;
  late final String note_title;
  late final String note_desc;

  // firebase instance
  CollectionReference collection =
      FirebaseFirestore.instance.collection("Note_Collection");

  // text editinng controllers
  final TextEditingController person = TextEditingController();
  final TextEditingController noteTitle = TextEditingController();
  final TextEditingController noteDesc = TextEditingController();

  @override
  void dispose() {
    // clean up the controller when widget is dispose
    person.dispose();
    noteTitle.dispose();
    noteDesc.dispose();
    super.dispose();
  }

  // clear form
  clearForm() {
    person.clear();
    noteTitle.clear();
    noteDesc.clear();
  }

  Future<void> addNote({required BuildContext context}) {
    // show loader
    DialogCustom.shoDialog(context);

    Map<String, dynamic> note_data = {
      'person_name': person_name,
      'note_title': note_title,
      'note_desc': note_desc
    };
    return collection
        .add(note_data)
        .then((value) => {
              // hide loader
              Navigator.pop(context),
              // go back
              Navigator.pop(context),
              Snackbar.showsnakbar(
                  snakTitle: "Successfully Created !",
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
    return Scaffold(
      backgroundColor: CandlesAppColor.system_status_bar_color,
      appBar: AppBar(
        backgroundColor: CandlesAppColor.system_status_bar_color,
        elevation: 0.0,
        title: Text("Add Note",
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
            topHeading(text: "Cordial ! Welcome "),
            Form(
                key: _formKey,
                child: Column(
                  children: [
                    SizedBox(height: 10.0),
                    formTextField(
                        id: "person",
                        headingtext: "Person Name",
                        labeltext: "Enter Your Name",
                        hinttext: "Enter Person Name",
                        icon: Icons.perm_identity,
                        textEditingController: person),
                    formTextField(
                        id: "notetitle",
                        headingtext: "Note Title",
                        labeltext: "Enter Note Title",
                        hinttext: "Enter Tile Here",
                        icon: Icons.note,
                        textEditingController: noteTitle),
                    formTextField(
                        id: "notedesc",
                        headingtext: "Note Description",
                        labeltext: "Enter Note Description",
                        hinttext: "Enter Description Here",
                        icon: Icons.description,
                        textEditingController: noteDesc)
                  ],
                ))
          ],
        ),
      ),

      bottomNavigationBar: addButton(context, _formKey),
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
                  person_name = person.text;
                  note_title = noteTitle.text;
                  note_desc = noteDesc.text;
                });
                addNote(context: context);
                clearForm();
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
                    Text("Add Note",
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
              controller: textEditingController,
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

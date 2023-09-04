import 'package:flutter/material.dart';
import 'package:flutter_fab_dialer/flutter_fab_dialer.dart' as j;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'Activities/EditNotes.dart';
import 'package:sqflite/sqflite.dart';
import 'Activities/Todos.dart';
import 'DataBaseMa.dart';
import 'Activities/Voice.dart';

class Dfab extends StatefulWidget {
  Map ThemeColors;
  var category;

  Dfab(this.ThemeColors,[this.category=null]);

  @override
  _DfabState createState() => _DfabState();
}

class _DfabState extends State<Dfab> {
  @override
  Widget build(BuildContext context) {
    var _fabMiniMenuItemList = [
      new j.FabMiniMenuItem.withText(
          new Icon(FontAwesomeIcons.penAlt,
              size: 20, color: widget.ThemeColors["fabIconsColor"]),
          widget.ThemeColors["fabBackGroundColor"],
          10,
          "Button menu", () {
        SaveNote("", "").whenComplete(() => ReadNotes().then((value) {
          AddToCategory(value[value.length - 1]["ID"], widget.category).whenComplete(() {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          EditNotes(false, value[value.length - 1]["ID"])));});
            }));
      }, "Blank note", widget.ThemeColors["fabBackGroundColor"],
          widget.ThemeColors["fabForeGroundColor"], true),
      new j.FabMiniMenuItem.withText(
          new Icon(
            FontAwesomeIcons.book,
            size: 20,
            color: widget.ThemeColors["fabIconsColor"],
          ),
          widget.ThemeColors["fabBackGroundColor"],
          10,
          "Button menu", () {
        SaveNote("", "", "", 1, "[]").whenComplete(() {

          ReadNotes().then((value) {
            AddToCategory(value[value.length - 1]["ID"], widget.category).whenComplete(() {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => TodoManager(value[value.length - 1]["ID"])));

            });

          });
        });


      }, "Todo", widget.ThemeColors["fabBackGroundColor"],
          widget.ThemeColors["fabForeGroundColor"], true),
//      new j.FabMiniMenuItem.withText(
//          new Icon(
//            FontAwesomeIcons.microphoneAlt,
//            size: 20,
//          ),
//          widget.TopColor,
//          10,
//          "Button menu", () {
//        Navigator.push(
//            context, MaterialPageRoute(builder: (context) => Voice()));
//      }, "Voice recorder", widget.TopColor, Colors.white, true),
    ];

    return j.FabDialer(
      _fabMiniMenuItemList,
      widget.ThemeColors["fabBackGroundColor"],
      new Icon(
        Icons.add,
        color: widget.ThemeColors["fabIconsColor"],
      ),
        widget.ThemeColors["fabForeGroundColor"]



    );
  }

  Future ReadNotes() async {
    var path = await getDatabasesPath() + "/NoteDBS.db3";
    var db = await openDatabase(path);

    List<Map> NotesData = await db.query("NoteData");

    db.close();
    return NotesData;
  }
}

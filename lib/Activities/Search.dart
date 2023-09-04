import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'EditNotes.dart';
import '../NotesList.dart' as P;
import '../SearchEngine.dart';
import '../DataBaseMa.dart';

class showSearchActivity extends StatefulWidget {
  Map ThemeColors;
  var categoryName;

  showSearchActivity(this.ThemeColors,[this.categoryName=null]);

  @override
  _showSearchActivityState createState() => _showSearchActivityState();
}

class _showSearchActivityState extends State<showSearchActivity> {
  List SearchFoundedResult = [];
  final _search_controller=TextEditingController();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: SearchBar(),
        body: J(widget.ThemeColors, false, true, SearchFoundedResult, true,widget.categoryName,_search_controller),
      ),
    );
  }

  AppBar SearchBar() {
    return AppBar(
      backgroundColor: widget.ThemeColors["searchBarBackGroundColor"],
      elevation: 0,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            icon: Icon(
              Icons.close,
              color: widget.ThemeColors["searchTextColor"],
            ),
            onPressed: () {
              Navigator.pop(
                context,
                PageRouteBuilder(
                  pageBuilder: (c, a1, a2) => EditNotes(false),
                  transitionsBuilder: (c, anim, a2, child) =>
                      FadeTransition(opacity: anim, child: child),
                  transitionDuration: Duration(milliseconds: 0),
                ),
              );
            },
          ),
          Expanded(
              child: Container(
                  width: double.infinity,
                  height: 50,
                  child: TextField(
                    textInputAction: TextInputAction.search,

                    controller:_search_controller,
                    onChanged: (e) {
                      print(_search_controller.text);
                      List FoundedItem = [];
                      if (e.trim() != "") {
                        ReadNotes().then((value) {
                          value.forEach((element) {

                            if(widget.categoryName!=null){
                              if(element["CategoryName"]==widget.categoryName){

                                if (element["NoteBody"]
                                    .toString()
                                    .toLowerCase()
                                    .trim()
                                    .contains(e.toLowerCase().trim()) ||
                                    element["Title"]
                                        .toString()
                                        .toLowerCase()
                                        .trim()
                                        .contains(e.toLowerCase().trim()) || element["Todos"]
                                    .toString()
                                    .toLowerCase().replaceFirst("[", "").replaceFirst("]", "")
                                    .trim()
                                    .contains(e.toLowerCase().trim())) {
                                  FoundedItem.add(element);
                                }

                              }

                            }

                            else{
                              if (element["NoteBody"]
                                  .toString()
                                  .toLowerCase()
                                  .trim()
                                  .contains(e.toLowerCase().trim()) ||
                                  element["Title"]
                                      .toString()
                                      .toLowerCase()
                                      .trim()
                                      .contains(e.toLowerCase().trim()) || element["Todos"]
                                  .toString()
                                  .toLowerCase().replaceFirst("[", "").replaceFirst("]", "")
                                  .trim()
                                  .contains(e.toLowerCase().trim())) {
                                FoundedItem.add(element);
                              }
                            }


                          });
                        }).whenComplete(() => setState(() {
                              SearchFoundedResult = FoundedItem;
                            }));
                      } else {
                        setState(() {
                          SearchFoundedResult.clear();
                        });
                      }
                    },
                    autofocus: true,
                    cursorHeight: 30,
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText:  widget.categoryName==null?
    "Search...":"Search ${widget.categoryName}...",
                        hintStyle: GoogleFonts.actor(
                            color: widget.ThemeColors["searchTextColor"], fontSize: 18)),
                    style: GoogleFonts.actor(color: widget.ThemeColors["searchTextColor"], fontSize: 18),
                  ) ))
        ],
      ),
    );
  }
}




class J extends P.ShowNotes {
  J(Map ThemeColors, bool NoteList_is_Card, bool isSearchActivity,
      List SearchFoundedResult, bool SearchBar_is_Empty,CategoryName,_search_controller)
      : super(ThemeColors, NoteList_is_Card, true, SearchFoundedResult, true,CategoryName,_search_controller.text);
}

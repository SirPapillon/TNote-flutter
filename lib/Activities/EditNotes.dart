import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:share_plus/share_plus.dart';
import 'package:styled_text/styled_text.dart';
import '../DataBaseMa.dart';

import 'AddToRemindersActivity.dart';

class EditNotes extends StatefulWidget {
  final bool Update;
  var Id;
  var is_search_mode;
  var search_result;

  EditNotes(this.Update,
      [this.Id = null, this.is_search_mode = null, this.search_result]);

  @override
  _EditNotesState createState() => _EditNotesState(Update, Id);
}

class _EditNotesState extends State<EditNotes> {
  final _TitleFieldController = TextEditingController();
  final _target_result_handler_controller = TextEditingController();
  final _scrollController = ScrollController();
  final _search_controller = TextEditingController();
  var _ControllerNoteField = TextEditingController();

  String pageViewTitle="Sheet Color";
  double appBarHeight = 110;
  int NoteMaxLines = 28;
  FontWeight RichInputFontWeight = FontWeight.normal;
  bool isNoteFocused = false;
  bool Update;
  int isFavorite = 0;
  int Id;
  String HashtagCounterField = "";
  bool is_search_mode = false;
  bool canPopActivity = true;
  List indexOffoundedResults = [];
  bool is_results_footer_visible = false;
  late String result_footer;

  var focusNode = FocusNode();
  var searchFocusNode = FocusNode();

  final ValueNotifier<int> _counter = ValueNotifier<int>(0);
  final ValueNotifier<int> _counter2 = ValueNotifier<int>(0);

  int search_cursor_index = 0;
  double _height = 0;
  double _toolHeight = 0;

  void animateMarkedLocationsListContainer(double height) {
    setState(() {
      if (height == 0) {
        isReadOnly = false;
      } else {
        isReadOnly = true;
      }
      _height = height;
    });
  }

  void animateToolsContainer() {
    setState(() {
      isReadOnly = true;
      _toolHeight = 300;
    });
  }

  bool sharedPrefChecked = false;

  double containerHeight1 = 20;
  double containerHeight2 = 12;
  double containerHeight3 = 12;
  double containerHeight4 = 12;

  int currentFontSize = 18;
  double letterSpacing = 0;
  double linesHeight = 1.5;

  int currentFontSize_temp = 18;
  double letterSpacing_temp = 0;
  double linesHeight_temp = 1.5;

  _EditNotesState(this.Update, this.Id);

  int sheetStyle_index = 0;
  int fontColor_index = 0;

  bool textAdded = false;

  Future findSheetColorIndex() async {
    final prefs = await SharedPreferences.getInstance();
    int sheetColor_index = prefs.getInt('sheetColor_index');
    if (sheetColor_index == null) {
      return 0;
    } else {
      return sheetColor_index;
    }
  }

  Future findFontColorIndex() async {
    final prefs = await SharedPreferences.getInstance();

    int fontColor_index = prefs.getInt('fontColor_index');
    if (fontColor_index == null) {
      return 0;
    } else {
      return fontColor_index;
    }
  }

  Future findFontSettings() async {
    final prefs = await SharedPreferences.getInstance();

    String fontSettings = prefs.getString('fontSettings');

    if (fontSettings == null) {
      return null;
    } else {
      return json.decode(fontSettings);
    }
  }

  String cleanNote = "";

  bool isReadOnly = false;

  @override
  Widget build(BuildContext context) {
    List sheetStyles = [
      {
        "backGroundColor": HexColor("FFFAF0"),
        "appBarBackGroundColor": HexColor("FFFAF0"),
        "noteColor": Colors.black,
        "titleColor": Colors.black,
        "iconsColor": Colors.black
      },
      {
        "backGroundColor": Colors.white,
        "appBarBackGroundColor": Colors.white,
        "noteColor": Colors.black,
        "titleColor": Colors.black,
        "iconsColor": Colors.black
      },
      {
        "backGroundColor": HexColor("DCD193"),
        "appBarBackGroundColor": HexColor("DCD193"),
        "noteColor": Colors.black,
        "titleColor": Colors.black,
        "iconsColor": Colors.black
      },
      {
        "backGroundColor": HexColor("DEC36F"),
        "appBarBackGroundColor": HexColor("DEC36F"),
        "noteColor": Colors.black,
        "titleColor": Colors.black,
        "iconsColor": Colors.black
      },
      {
        "backGroundColor": HexColor("F3F3F3"),
        "appBarBackGroundColor": HexColor("F3F3F3"),
        "noteColor": Colors.black,
        "titleColor": Colors.black,
        "iconsColor": Colors.black
      },
      {
        "backGroundColor": HexColor("effbef"),
        "appBarBackGroundColor": HexColor("effbef"),
        "noteColor": Colors.black,
        "titleColor": Colors.black,
        "iconsColor": Colors.black
      },
      {
        "backGroundColor": HexColor("f8efce"),
        "appBarBackGroundColor": HexColor("f8efce"),
        "noteColor": Colors.black,
        "titleColor": Colors.black,
        "iconsColor": Colors.black
      },
      {
        "backGroundColor": HexColor("eff7fa"),
        "appBarBackGroundColor": HexColor("eff7fa"),
        "noteColor": Colors.black,
        "titleColor": Colors.black,
        "iconsColor": Colors.black
      },
      {
        "backGroundColor": HexColor("deeff5"),
        "appBarBackGroundColor": HexColor("deeff5"),
        "noteColor": Colors.black,
        "titleColor": Colors.black,
        "iconsColor": Colors.black
      },
      {
        "backGroundColor": HexColor("1E262E"),
        "appBarBackGroundColor": HexColor("1E262E"),
        "noteColor": HexColor("FFFAF0"),
        "titleColor": HexColor("FFFAF0"),
        "iconsColor": HexColor("FFFAF0")
      },
      {
        "backGroundColor": HexColor("E1D9D1"),
        "appBarBackGroundColor": HexColor("E1D9D1"),
        "noteColor": Colors.black,
        "titleColor": Colors.black,
        "iconsColor": Colors.black
      },
      {
        "backGroundColor": HexColor("232B2B"),
        "appBarBackGroundColor": HexColor("232B2B"),
        "noteColor": HexColor("FFFAF0"),
        "titleColor": HexColor("FFFAF0"),
        "iconsColor": HexColor("FFFAF0")
      },
    ];

    List fontColors = [
      {
        "color": Colors.black,
        "hint_color": Colors.black54,
      },
      {
        "color": HexColor("1E262E"),
        "hint_color": Colors.black54,
      },
      {
        "color": Colors.black54,
        "hint_color": Colors.black54,
      },
      {
        "color": Colors.white70,
        "hint_color": Colors.white30,
      },
      {
        "color": Colors.red,
        "hint_color": Colors.redAccent,
      },
      {
        "color": Colors.purple,
        "hint_color": Colors.purpleAccent,
      },
      {
        "color": Colors.blue,
        "hint_color": Colors.blueGrey,
      },
      {
        "color": Colors.yellow,
        "hint_color": Colors.yellowAccent,
      },
      {
        "color": Colors.green,
        "hint_color": Colors.lightGreen,
      },
    ];

    if (widget.is_search_mode == true) {
      is_search_mode = true;
      canPopActivity = false;
      _search_controller.text = widget.search_result;
    }

//    if (indexOffoundedResults.length > 0) {
//      moveNoteFieldCursorTo(
//        indexOffoundedResults[search_cursor_index],
//      );
//    }

    if (sharedPrefChecked == false) {
      findSheetColorIndex().then((v) {
        findFontColorIndex().then((z) {
          findFontSettings().then((n) {
            sheetStyle_index = v;
            fontColor_index = z;
            if (n != null) {
              currentFontSize = n[0];
              letterSpacing = n[1];
              linesHeight = n[2];
              currentFontSize_temp = currentFontSize;
              letterSpacing_temp = letterSpacing;
              linesHeight_temp = linesHeight;
            }

            sharedPrefChecked = true;
            setState(() {});
          });
        });
      });
    }

    return WillPopScope(
      onWillPop: () async {
        if (canPopActivity == false) {
          disposeSearchSettings();
          return false;
        } else {
          String Note = _ControllerNoteField.text;
          String Title = _TitleFieldController.text;

          SaveChanges(Note, Title, Id, "");

          Navigator.pop(context);
          return true;
        }
      },
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
            resizeToAvoidBottomInset: true,
            backgroundColor: sheetStyles[sheetStyle_index]["backGroundColor"],
            appBar: CBar(sheetStyles, fontColors),
            body: GestureDetector(
              onHorizontalDragUpdate: (details) {
                if (details.delta.dx > 8) {
                  Navigator.pop(context);
                }
              },
              child: Stack(fit: StackFit.expand, children: [
                Stack(children: [
                  SingleChildScrollView(
                      child: CustomTextField(sheetStyles, fontColors)),
                  Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        height: 35,
                        child: find_previous_next_search_result(),
                        decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(12)),
                        margin:
                            EdgeInsets.symmetric(horizontal: 90, vertical: 10),
                      )),
                ]),
                Align(
                    alignment: Alignment.bottomCenter, child: toolContainer()),
                Align(
                    alignment: Alignment.bottomCenter,
                    child: AnimatedContainer(
                      duration: Duration(milliseconds: 400),
                      width: double.infinity,
                      height: _height,
                      decoration: BoxDecoration(
                          color: HexColor("#0e1111"),
                          borderRadius:
                              BorderRadius.vertical(top: Radius.circular(20))),
                      child: Column(children: [
                        Stack(
                          children: [
//                            IconButton(
//                              padding: EdgeInsets.all(0),
//                              onPressed: () {
//
//                              },
//                              icon: Icon(
//                                Icons.clear,
//                                color: Colors.white,
//                              ),
//                            ),
                            Align(
                                heightFactor: 1.4,
                                alignment: Alignment.bottomCenter,
                                child: Text(pageViewTitle,
                                    style: GoogleFonts.lato(
                                        color: Colors.white, fontSize: 18))),
                            Align(
                              alignment: Alignment.topRight,
                              child: IconButton(
                                padding: EdgeInsets.all(0),
                                onPressed: () async {
                                  final prefs =
                                      await SharedPreferences.getInstance();
                                  prefs.setInt(
                                      "sheetColor_index", sheetStyle_index);
                                  prefs.setInt(
                                      "fontColor_index", fontColor_index);

                                  prefs.setString(
                                      "fontSettings",
                                      json.encode([
                                        currentFontSize,
                                        letterSpacing,
                                        linesHeight
                                      ]));

                                  currentFontSize_temp = currentFontSize;
                                  letterSpacing_temp = letterSpacing;
                                  linesHeight_temp = linesHeight_temp;

                                  animateMarkedLocationsListContainer(0);
                                },
                                icon: Icon(
                                  Icons.check,
                                  color: Colors.white,
                                ),
                              ),
                            )
                          ],
                        ),
                        Expanded(
                          child: PageView(
                            onPageChanged: (page_index) {
                              if (page_index == 0) {
                                pageViewTitle="Sheet Color";
                                containerHeight1 = 20;
                                containerHeight2 = 12;
                                containerHeight3 = 12;
                                containerHeight4 = 12;
                              }
                              if (page_index == 1) {
                                pageViewTitle="Font Color";
                                containerHeight2 = 20;
                                containerHeight1 = 12;
                                containerHeight3 = 12;
                                containerHeight4 = 12;
                              }
                              if (page_index == 2) {
                                pageViewTitle="Font Setting";
                                containerHeight3 = 20;
                                containerHeight1 = 12;
                                containerHeight2 = 12;
                                containerHeight4 = 12;
                              }

                              setState(() {});
                            },
                            children: [
                              sheetColorPage(sheetStyles),
                              fontColorPage(fontColors),
                              fontSettingPage(sheetStyles),
                            ],
                          ),
                        ),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                  padding: EdgeInsets.all(5),
                                  child: Text(pageViewTitle,
                                      style: GoogleFonts.lato(
                                          color: Colors.white,
                                          fontSize: containerHeight1)),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      color: Colors.white30)),
                              SizedBox(width: 10),
                              Container(
                                  padding: EdgeInsets.all(5),
                                  child: Text("Font Color",
                                      style: GoogleFonts.lato(
                                          color: Colors.white,
                                          fontSize: containerHeight2)),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      color: Colors.white30)),
                              SizedBox(width: 10),
                              Container(
                                  padding: EdgeInsets.all(5),
                                  child: Text("Font Setting",
                                      style: GoogleFonts.lato(
                                          color: Colors.white,
                                          fontSize: containerHeight3)),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      color: Colors.white30)),
                              SizedBox(width: 10),
                            ])
                      ]),
                    ))
              ]),
            )),
      ),
    );
  }

  Padding fontSettingPage(sheetStyles) {
    final sizeTextFieldController = TextEditingController();

    sizeTextFieldController.text = currentFontSize.toString();

    return Padding(
      padding: const EdgeInsets.only(top: 10, left: 15),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(
          "size",
          style: GoogleFonts.lato(color: Colors.white, fontSize: 20),
        ),
        Row(children: [
          Text(
            currentFontSize.toString(),
            style: GoogleFonts.lato(
              color: Colors.white,
            ),
          ),
          Expanded(
            child: Slider(
              divisions: 18,
              min: 13.0,
              max: 30.0,
              value: currentFontSize.toDouble(),
              activeColor: Colors.red,
              inactiveColor: Colors.blue,
              onChanged: (value) {
                currentFontSize = value.toInt();
                setState(() {});
              },
            ),
          ),
        ]),
        Divider(
          color: Colors.white,
        ),
        Text(
          "letterSpacing",
          style: GoogleFonts.lato(color: Colors.white, fontSize: 20),
        ),
        Row(children: [
          Text(
            letterSpacing.toString(),
            style: GoogleFonts.lato(
              color: Colors.white,
            ),
          ),
          Expanded(
            child: Container(
              child: Slider(
                divisions: 20,
                min: 0,
                max: 5,
                value: letterSpacing.toDouble(),
                activeColor: Colors.red,
                inactiveColor: Colors.blue,
                onChanged: (value) {
                  letterSpacing = value;
                  setState(() {});
                },
              ),
            ),
          ),
        ]),
        Divider(color: Colors.white),
        Text(
          "linesHeight",
          style: GoogleFonts.lato(color: Colors.white, fontSize: 20),
        ),
        Row(children: [
          Text(
            linesHeight.toString(),
            style: GoogleFonts.lato(
              color: Colors.white,
            ),
          ),
          Expanded(
            child: Slider(
              divisions: 20,
              min: 0,
              max: 5,
              value: linesHeight,
              activeColor: Colors.red,
              inactiveColor: Colors.blue,
              onChanged: (value) {
                linesHeight = value;
                setState(() {});
              },
            ),
          ),
        ]),
        Divider(color: Colors.white),
        TextButton(
            child: Text("Reset Settings", style: GoogleFonts.lato()),
            onPressed: () {
              currentFontSize = currentFontSize_temp;
              letterSpacing = letterSpacing_temp;
              linesHeight = linesHeight_temp;
              setState(() {});
            }),
        TextButton(
            child: Text("Reset To Default", style: GoogleFonts.lato()),
            onPressed: () {
              linesHeight = 1.5;
              currentFontSize = 18;
              letterSpacing = 0;
              setState(() {});
            }),
      ]),
    );
  }

  Wrap fontColorPage(fontColors) {
    return Wrap(
        children: List.generate(fontColors.length, (index) {
      return Padding(
        padding: EdgeInsets.all(5),
        child: GestureDetector(
          onTap: () {
            fontColor_index = index;
            setState(() {});
          },
          child: CircleAvatar(
            radius: 16,
            backgroundColor: Colors.white54,
            child: CircleAvatar(
                radius: 15, backgroundColor: fontColors[index]["color"]),
          ),
        ),
      );
    }));
  }

  GridView sheetColorPage(sheetStyles) {
    return GridView.builder(
        itemCount: sheetStyles.length,
        gridDelegate:
            SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 4),
        itemBuilder: (BuildContext context, int index) {
          return GestureDetector(
              onTap: () {
                sheetStyle_index = index;
                setState(() {});
              },
              child: Container(
                decoration: BoxDecoration(
                    color: sheetStyles[index]["backGroundColor"],
                    borderRadius: BorderRadius.circular(3)),
                margin: EdgeInsets.only(right: 4, left: 4, bottom: 8),
              ));
        });
  }

  void disposeSearchSettings() {
    appBarHeight = 110;
    indexOffoundedResults.clear();
    search_cursor_index = 0;
    _search_controller.clear();
    _counter2.value = 0;
    is_search_mode = false;
    widget.is_search_mode = false;
    is_results_footer_visible = false;
    canPopActivity = true;

    setState(() {});
  }

  PreferredSize CBar(
    sheetStyles,
    fontColors,
  ) {
    return PreferredSize(
      preferredSize: Size(250, appBarHeight),
      child: Column(children: [
        Visibility(
          visible: !is_search_mode,
          replacement: AppBar(
              elevation: 0,
              backgroundColor: sheetStyles[sheetStyle_index]
                  ["appBarBackGroundColor"],
              actions: [
                IconButton(
                  icon: Icon(Icons.close,
                      color: sheetStyles[sheetStyle_index]["iconsColor"]),
                  onPressed: () {
                    disposeSearchSettings();
                  },
                  splashRadius: 15,
                ),
                Expanded(
                  child: Padding(
                      padding: EdgeInsets.only(right: 10, top: 10, bottom: 10),
                      child: Container(
                          decoration: BoxDecoration(
                              color: HexColor("FFFFA1"),
                              borderRadius: BorderRadius.circular(10)),
                          child: Padding(
                            padding: const EdgeInsets.only(top: 9.0, left: 3),
                            child: SearchField(sheetStyles),
                          ))),
                )
              ]),
          child: AppBar(
            elevation: 0,
            backgroundColor: sheetStyles[sheetStyle_index]
                ["appBarBackGroundColor"],
            //HexColor("#EEEEEE"),
            actions: [
              Expanded(
                  child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.arrow_back,
                      color: sheetStyles[sheetStyle_index]["iconsColor"],
                    ),
                    onPressed: () {
                      String Note = _ControllerNoteField.text;
                      String Title = _TitleFieldController.text;

                      SaveChanges(Note, Title, Id, "");

                      Navigator.pop(context);
                    },
                  ),
                  Text(widget.Update == true ? "Save Changes" : "Save",
                      style: GoogleFonts.actor(
                          color: sheetStyles[sheetStyle_index]["titleColor"],
                          fontSize: 18,
                          fontWeight: FontWeight.bold)),
                ],
              )),
              IconButton(
                  icon: Image.asset("images/theme.png",
                      fit: BoxFit.cover,
                      height: 25,
                      color: sheetStyles[sheetStyle_index]["iconsColor"]),
                  splashRadius: 15,
                  onPressed: () {
                    animateMarkedLocationsListContainer(500);
                  }),
              IconButton(
                  icon: Icon(Icons.search,
                      color: sheetStyles[sheetStyle_index]["iconsColor"]),
                  splashRadius: 15,
                  onPressed: () {
                    appBarHeight = 75;

                    if (_TitleFieldController.text.length > 0) {
                      String c = _ControllerNoteField.text
                          .replaceAll("<target>", "")
                          .replaceAll("</target>", "")
                          .replaceAll("<title>", "")
                          .replaceAll("</title>", "")
                          .replaceAll("<result>", "")
                          .replaceAll("</result>", "");
                      cleanNote =
                          "${_TitleFieldController.text.replaceAll("<title>", "").replaceAll("</tile>", "")}" +
                              "\n\n" +
                              c;
                    } else {
                      cleanNote = _ControllerNoteField.text;
                    }
                    _counter2.value += 1;
                    searchFocusNode.requestFocus();
                    canPopActivity = false;
                    is_search_mode = true;
                    setState(() {});
                  }),
              PopupMenuButton<int>(
                color: sheetStyles[sheetStyle_index]["backGroundColor"],
                elevation: 4,
                itemBuilder: (context) => [
                  PopupMenuItem<int>(
                      value: 0,
                      child: Row(children: [
                        Icon(
                          Icons.share_outlined,
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Text('Share',
                            style: GoogleFonts.actor(
                                color: sheetStyles[sheetStyle_index]
                                    ["iconsColor"])),
                      ])),
                  PopupMenuItem<int>(
                      value: 1,
                      child: Row(children: [
                        Icon(
                          Icons.alarm_outlined,
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Text('Add to reminder',
                            style: GoogleFonts.actor(
                                color: sheetStyles[sheetStyle_index]
                                    ["iconsColor"])),
                      ])),
                  PopupMenuItem<int>(
                      value: 2,
                      child: Row(children: [
                        Icon(
                          isFavorite == 0
                              ? Icons.favorite_border
                              : Icons.favorite,
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                            isFavorite == 0
                                ? 'Add to Favorite'
                                : 'Remove Favorite',
                            style: GoogleFonts.actor(
                                color: sheetStyles[sheetStyle_index]
                                    ["iconsColor"])),
                      ])),
                  PopupMenuItem<int>(
                      value: 3,
                      child: Row(children: [
                        Icon(
                          Icons.delete_outline,
                        ),
                        SizedBox(width: 5),
                        Text('Delete',
                            style: GoogleFonts.actor(
                                color: sheetStyles[sheetStyle_index]
                                    ["iconsColor"])),
                      ])),
                ],
                onSelected: (value) {
                  switch (value) {
                    case 0:
                      Share.share(_TitleFieldController.text +
                          "\n " +
                          _ControllerNoteField.text);
                      break;
                    case 1:
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AddToReminders(
                                  _TitleFieldController.text, widget.Id)));
                      break;

                    case 2:
                      if (isFavorite == 1) {
                        RemoveFromFavorites(widget.Id);
                        isFavorite = 0;
                      } else {
                        AddToFavorites(widget.Id);
                        isFavorite = 1;
                      }

                      break;

                    case 3:
                      MoveToTrash(widget.Id)
                          .whenComplete(() => Navigator.pop(context));
                      break;
                  }
                },
              ),
            ],
            iconTheme: IconThemeData(
                color: sheetStyles[sheetStyle_index]["iconsColor"]),
            title: Row(children: []),
            //toolbarHeight: 10,
          ),
        ),
        is_search_mode == true ? Text("") : TitleField(fontColors),
      ]),
    );
  }

  void searchPhrase(String search_phrase) {
    if (is_results_footer_visible == false) focusNode.requestFocus();

    is_results_footer_visible = true;

    indexOffoundedResults = search_process(search_phrase);

    if (indexOffoundedResults.length > 0) {
      _target_result_handler_controller.text = "1";
    }
  }

  TextField SearchBar(sheetStyles) {
    return TextField(
      focusNode: searchFocusNode,
      controller: _search_controller,
      onSubmitted: (search_phrase) {
        if (_search_controller.text.trim().length > 0) {
          _counter2.value = 0;

          searchPhrase(search_phrase);
          _counter.value += 1;
          _counter2.value += 1;
        } else {
          disposeSearchSettings();
          is_results_footer_visible = false;
          _counter.value += 1;
          searchFocusNode.requestFocus();
        }
      },
      textInputAction: TextInputAction.search,
      style: GoogleFonts.actor(color: Colors.black, fontSize: 18),
      autofocus: true,
      maxLines: 1,
      cursorHeight: 25,
      decoration: InputDecoration(
          border: InputBorder.none,
          hintText: "Search...",
          hintStyle: GoogleFonts.actor(color: Colors.black54, fontSize: 16)),
    );
  }

  ValueListenableBuilder find_previous_next_search_result() {
    int value = 0;
    return ValueListenableBuilder(
      builder: (context, value, child) {
        return Visibility(
          visible: is_results_footer_visible,
          child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Visibility(
              visible: indexOffoundedResults.length > 0 ? true : false,
              child: IconButton(
                  splashRadius: 15,
                  icon: Icon(Icons.arrow_back, size: 17, color: Colors.white70),
                  onPressed: () {
                    findPreviousSearchResult();
                  }),
            ),
            Text(
                indexOffoundedResults.length > 0
                    ? "${(search_cursor_index + 1).toString()} of ${indexOffoundedResults.length.toString()}"
                    : "no result founded",
                style: GoogleFonts.lato(color: Colors.white70, fontSize: 15)),
            Visibility(
              visible: indexOffoundedResults.length > 0 ? true : false,
              child: IconButton(
                  splashRadius: 15,
                  icon: Icon(Icons.arrow_forward,
                      size: 17, color: Colors.white70),
                  onPressed: () {
                    findNextSearchResult();
                  }),
            )
          ]),
        );
      },
      valueListenable: _counter,
    );
  }

  String taggedString(String note) {
    if (_counter2.value != 0) {
      if (indexOffoundedResults.length == 0) {
        return note;
      } else {
        cleanNote = note.replaceAll(
            "<target>${_search_controller.text}</target>",
            "${_search_controller.text}");

        cleanNote = cleanNote.replaceRange(
            indexOffoundedResults[search_cursor_index]["start"],
            indexOffoundedResults[search_cursor_index]["end"],
            "<target>${_search_controller.text}</target>");

//          cleanNote=cleanNote.replaceRange(0,_TitleFieldController.text.length,"<title>${_TitleFieldController.text}</title>");

        return cleanNote;
      }
    } else {
      cleanNote = note.replaceAll(_search_controller.text,
          "<result>${_search_controller.text}</result>");

      return cleanNote;
    }
  }

  searchModeNote(fontColor, clearNote) {
    return StyledText(
        text: cleanNote,
        tags: {
          "title": StyledTextTag(
              style: GoogleFonts.actor(
                  fontSize: 23,
                  fontWeight: FontWeight.bold,
                  color: fontColor[fontColor_index]["color"])),
          "result": StyledTextTag(
              style: GoogleFonts.actor(
                  color: Colors.yellowAccent,
                  fontSize: currentFontSize.toDouble() + 5,
                  height: linesHeight)),
          "target": StyledTextTag(
              style: GoogleFonts.actor(
                  decoration: TextDecoration.underline,
                  color: Colors.red,
                  fontSize: currentFontSize.toDouble() + 10,
                  height: linesHeight)),
        },
        style: GoogleFonts.actor(
            letterSpacing: letterSpacing.toDouble(),
            color: fontColor[fontColor_index]["color"],
            fontSize: currentFontSize.toDouble(),
            height: linesHeight));
  }

  Row SearchField(sheetStyles) {
    return Row(children: [
      Expanded(child: SearchBar(sheetStyles)),
    ]);
  }

  GestureDetector CustomTextField(sheetStyles, fontColor) {
    if (Update == true) {
      ReadNoteBody(Id).then((value) {
        if (textAdded == false) {
          textAdded = true;
          _ControllerNoteField.text = value[0]['NoteBody'];
          _TitleFieldController.text = value[0]['Title'];
          isFavorite = value[0]["isFavorite"];
        }
      }).whenComplete(() {
        SaveChanges(
                _ControllerNoteField.text, _TitleFieldController.text, Id, "")
            .whenComplete(() {
          if (widget.is_search_mode == true) {
            is_search_mode = true;
            _search_controller.text = widget.search_result;
            cleanNote = _ControllerNoteField.text;
            cleanNote = cleanNote.replaceAll(_search_controller.text,
                "<result>${_search_controller.text}</result>");
            searchPhrase(_search_controller.text);

            _counter2.value += 1;
            widget.is_search_mode = false;
          }
        });
      });
    } else {
      isFavorite = 0;
    }

    return GestureDetector(
      onDoubleTap: () {
        disposeSearchSettings();
        animateToolsContainer();
      },
      onHorizontalDragUpdate: (details) {
        if (details.delta.dx > 18) {
          // Swiping in right direction.
          Navigator.pop(context);
        }
      },
      child: Container(
          decoration: BoxDecoration(
            color: Colors.transparent, //FFFDD0 is good F1E9D2is good
          ),
          child: Stack(children: [
            //OptionsBar(),

            Scrollbar(
              child: Padding(
                padding: const EdgeInsets.only(left: 10.0, right: 5),
                child: Visibility(
                  replacement: Padding(
                      padding: EdgeInsets.only(top: 12.0),
                      child: ValueListenableBuilder(
                          valueListenable: _counter2,
                          builder: (context, value, child) {
                            cleanNote = taggedString(cleanNote);

                            return searchModeNote(fontColor, cleanNote);
                          })),
                  visible: is_search_mode == true ? false : true,
                  child: TextField(
                    onChanged: (d) {
                      String Title = _TitleFieldController.text;
                      SaveChanges(d, Title, Id, "");
                    },
                    maxLines: 30,
                    scrollPhysics: BouncingScrollPhysics(),
                    textInputAction: TextInputAction.newline,
                    readOnly: isReadOnly,
                    decoration: InputDecoration(
                        hintText: "Type...",
                        hintStyle: GoogleFonts.actor(
                            color: fontColor[fontColor_index]["hint_color"],
                            fontSize: 18,
                            height: 1.5),
                        border: InputBorder.none),
                    focusNode: focusNode,
                    cursorColor: Colors.red,
                    controller: _ControllerNoteField,
                    style: GoogleFonts.actor(
                        letterSpacing: letterSpacing.toDouble(),
                        color: fontColor[fontColor_index]["color"],
                        fontSize: currentFontSize.toDouble(),
                        height: linesHeight),
                  ),
                ),
              ),
              radius: Radius.circular(30),
              thickness: 7,
            ),
          ])),
    );
  }

  void findNextSearchResult() {
    if (search_cursor_index == indexOffoundedResults.length - 1)
      search_cursor_index = -1;

    if (search_cursor_index < indexOffoundedResults.length) {
      search_cursor_index++;

      _counter.value += 1;
      _counter2.value += 1;
    }
  }

  void findPreviousSearchResult() {
    if (search_cursor_index > 0 &&
        search_cursor_index <= indexOffoundedResults.length) {
      search_cursor_index--;

      _counter.value += 1;
      _counter2.value += 1;
    }
  }

  void moveNoteFieldCursorTo(int pos) {
    _ControllerNoteField.selection =
        TextSelection.fromPosition(TextPosition(offset: pos));
  }

  List indexOfWords(String str, String targetString) {
    List founded = [];
//    if (_TitleFieldController.text.length>0){
//      str=str.replaceRange(0,_TitleFieldController.text.length,"<title>${_TitleFieldController.text}</title>");
//    }

    str = taggedString(str);
    cleanNote = str;

    for (int x = 0; x < str.length; x++) {
      if (x + 8 + 9 + targetString.length > str.length) {
        break;
      }

      if (str.substring(x, x + 8) == "<result>" &&
          str.substring(x + 8 + targetString.length,
                  x + 8 + 9 + targetString.length) ==
              "</result>") {
        Map resPos = {};

        resPos = {"start": x + 8, "end": x + 8 + targetString.length};

        founded.add(resPos);
      }
    }

    return founded;
  }

  AnimatedContainer toolContainer() {
    if (_toolHeight != 0) {}
    return AnimatedContainer(
        duration: Duration(milliseconds: 400),
        width: double.infinity,
        height: _toolHeight,
        decoration: BoxDecoration(
            boxShadow: [
              _toolHeight != 0
                  ? BoxShadow(
                      color: Colors.black45, blurRadius: 9, spreadRadius: 2)
                  : BoxShadow(
                      color: Colors.black45, blurRadius: 0, spreadRadius: 0)
            ],
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            IconButton(
                padding: EdgeInsets.all(0),
                icon: Icon(Icons.clear, color: Colors.black),
                onPressed: () {
                  _toolHeight = 0;
                  isReadOnly = false;
                  setState(() {});
                })
          ]),
          Padding(
            padding: EdgeInsets.only(left: 20, right: 10, top: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
//                GestureDetector(
//                    onTap: () async{
//
//
//                      int cursorPos=_ControllerNoteField.selection.baseOffset;
//                      Clipboard.getData('text/plain').then((copiedT) {
//String copied=copiedT.text;
//                        String note=_ControllerNoteField.text.substring(0,cursorPos)+copied+_ControllerNoteField.text.substring(cursorPos,_ControllerNoteField.text.length);
//                        print("lkkllk");
//                        _ControllerNoteField.text=note;
//                      });
//
//
//
//                    },
//                    child: Text("Pase Here",
//                        style: GoogleFonts.actor(color: Colors.black, fontSize: 20))),
//
//                Divider(height: 30,),

                GestureDetector(
                    onTap: () {
                      String selectedText = _ControllerNoteField.text.substring(
                          _ControllerNoteField.selection.baseOffset,
                          _ControllerNoteField.selection.extentOffset);
                      Share.share(selectedText);
                    },
                    child: Text("Share Selected Text",
                        style: GoogleFonts.actor(
                            color: Colors.black, fontSize: 20))),

                Divider(
                  height: 30,
                ),

                GestureDetector(
                    onTap: () {
                      _ControllerNoteField.clear();
                    },
                    child: Text("Clear All Text",
                        style: GoogleFonts.actor(
                            color: Colors.black, fontSize: 20))),
              ],
            ),
          ),
        ]));
  }

  List search_process(String search_phrase) {
    search_cursor_index = 0;
    String n;

    if (_TitleFieldController.text.length > 0) {
      String c = _ControllerNoteField.text
          .replaceAll("<target>", "")
          .replaceAll("</target>", "")
          .replaceAll("<title>", "")
          .replaceAll("</title>", "")
          .replaceAll("<result>", "")
          .replaceAll("</result>", "");
      n = "${_TitleFieldController.text.replaceAll("<title>", "").replaceAll("</tile>", "")}" +
          "\n\n" +
          c;
    } else {
      n = _ControllerNoteField.text;
    }

//    if (_TitleFieldController.text.length>0){
//      n="${_TitleFieldController.text}"+"\n\n"+ _ControllerNoteField.text;
//
//    }
//    else{
//      n= _ControllerNoteField.text;
//
//    }

    return indexOfWords(n, search_phrase);
  }

  Container TitleField(fontColors) {
    return Container(
        color: Colors.transparent,
        child: GestureDetector(
          child: TextField(
            readOnly: isReadOnly,
            keyboardType: TextInputType.text,
            onChanged: (d) {
              String Title = _TitleFieldController.text;
              SaveChanges(_ControllerNoteField.text, Title, Id, "");
            },
            controller: _TitleFieldController,
            style: GoogleFonts.actor(
                fontSize: 23,
                fontWeight: FontWeight.bold,
                color: fontColors[fontColor_index]["color"]),
            decoration: InputDecoration(
                prefixText: "- ",
                hintText: "Title",
                border: InputBorder.none,
                hintStyle: GoogleFonts.actor(
                    color: fontColors[fontColor_index]["hint_color"])),
          ),
        ));
  }

//  Future ReadNotes() async {
//    var path = await getDatabasesPath() + "/NoteDBS.db3";
//    var db = await openDatabase(path);
//
//    List<Map> NotesData = await db.query("NoteData");
//
//    db.close();
//    return NotesData;
//  }
}

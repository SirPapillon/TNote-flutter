import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:clever/main.dart';

List themes = [
  {
    "name": "Default",
    "nameStyle": GoogleFonts.actor(
      color: Colors.black,
    ),
    "barColor": Colors.white,
    "titleColor": Colors.black,
    "listModeTitleColor":Colors.black,
    "abbrBackGroundColor": HexColor("FAFAFA"),
    "backGroundColor": HexColor("FAFAFA"),
    "cardBackGroundColor": Colors.white,
    "hamburgerMenuIconColor": Colors.black,
    "fabBackGroundColor": HexColor("0C4FF1"),
    "showModeTileColor": HexColor("0C4FF1"),
    "showModeIconColor": Colors.black54,
    "showModeTextColor": Colors.black,
    "fabForeGroundColor": Colors.white,
    "dialogsBackGroundColor": Colors.white,
    "fabIconsColor": Colors.white,
    "lockedCardBackGroundColor": HexColor("0C4FF1"),
    "lockCardsTextColor": Colors.white,
    "lockDialog-un-LockBackGroundColor": Colors.black,
    "lockDialog-un-LockForeGroundColor": Colors.white,
    "lockedCardForeGroundColor": Colors.white,


    "drawerBackGroundColor": HexColor("FAFAFA"),

    "drawerForeGroundColor": Colors.black87,
    "drawerCategoryNameForeGroundColor": Colors.black,
    "drawerCategoryIconColor": Colors.black54,


    "drawerLightForeGroundColor": Colors.black,
    "dateColor": Colors.black54,
    "favoriteIconFilledColor": Colors.red,
    "favoriteIconUnfilledBorderColor": Colors.black,
    "searchBarBackGroundColor": HexColor("FAFAFA"),
    "searchTextColor": Colors.black54,
    "barIconsColor": Colors.black
  },
  {
    "name": "Classic1",
    "nameStyle": GoogleFonts.inter(
      color: Colors.black,
    ),
    "fabBackGroundColor": Colors.black,
    "fabForeGroundColor": HexColor("FFFFC2"),
    "fabIconsColor": HexColor("FFFFC2"),
    "barColor": HexColor("FFFFC2"),

    "drawerBackGroundColor": HexColor("FFFFC2"),


    "drawerForeGroundColor": Colors.black87,
    "drawerCategoryNameForeGroundColor": Colors.black,
    "drawerCategoryIconColor": Colors.black54,

    "showModeTileColor": Colors.black54,
    "dialogsBackGroundColor": HexColor("FFFFC2"),
    "lockDialogCancelForeGroundColor": HexColor("FFEFBC"),
    "lockedCardBackGroundColor": Colors.black,
    "lockedCardForeGroundColor": HexColor("FFFFC2"),
    "lockDialogCancelBackGroundColor": HexColor("FFEFBC"),
    "lockDialog-un-LockBackGroundColor": Colors.black87,
    "lockDialog-un-LockForeGroundColor": HexColor("FBF8F1"),
    "titleColor": Colors.black,
    "abbrBackGroundColor": HexColor("FFFFC2"),
    "backGroundColor": HexColor("FFFFC2"),
    "cardBackGroundColor": HexColor("FFD801"),
    "searchBarBackGroundColor": HexColor("FFFFC2"),
    "searchTextColor": Colors.black54,
    "behindSearchBarColor": HexColor("FFFFC2"),
  },
//  {
//    "name": "Burned",
//    "nameStyle": TextStyle(color: Colors.black),
//    "barColor": HexColor("DEB887"),
//    "drawerBackGroundColor": HexColor("DEB887"),
//    "fabBackGroundColor": Colors.brown,
//    "fabForeGroundColor": HexColor("DEB887"),
//    "fabIconsColor": HexColor("DEB887"),
//    "drawerCategoryNameForeGroundColor": Colors.brown,
//    "showModeTileColor": Colors.brown,
//    "searchTextColor": Colors.black54,
//
//    "dateColor":Colors.black,
//    "titleColor": HexColor("DEB887"),
//    "lockDialogCancelForeGroundColor": Colors.transparent,
//    "lockedCardBackGroundColor": Colors.orangeAccent,
//    "lockedCardForeGroundColor": Colors.black,
//    "lockDialogCancelBackGroundColor": HexColor("FFEFBC"),
//    "lockDialog-un-LockBackGroundColor": Colors.brown,
//    "lockDialog-un-LockForeGroundColor": HexColor("DEB887"),
//    "abbrBackGroundColor": HexColor("DEB887"),
//    "backGroundColor": HexColor("DEB887"),
//    "cardBackGroundColor": Colors.brown,
//    "searchBarBackGroundColor": HexColor("DEB887"),
//    "behindSearchBarColor": HexColor("DEB887"),
//    "dialogsBackGroundColor": HexColor("DEB887"),
//
//  },
  {
    "name": "Ocean",
    "nameStyle": TextStyle(color: Colors.black54),
    "barColor": Colors.black,
    "titleColor": HexColor("152636"),
    "fabBackGroundColor": HexColor("152636"),
    "fabForeGroundColor": HexColor("caf0f8"),
    "fabIconsColor": HexColor("caf0f8"),
    "showModeTileColor": HexColor("152636"),

    "lockDialogCancelForeGroundColor": Colors.transparent,
    "lockedCardBackGroundColor": HexColor("152636"),
    "lockedCardForeGroundColor": HexColor("caf0f8"),
    "lockDialogCancelBackGroundColor": HexColor("FFEFBC"),
    "lockDialog-un-LockBackGroundColor": Colors.black87,
    "lockDialog-un-LockForeGroundColor": HexColor("FBF8F1"),
    "abbrBackGroundColor": HexColor("caf0f8"),
    "dialogsBackGroundColor": HexColor("caf0f8"),
    "dialogsForeGroundColor": Colors.black,
    "drawerBackGroundColor": HexColor("152636"),

    "drawerForeGroundColor": HexColor("caf0f8"),
    "drawerCategoryNameForeGroundColor": HexColor("8ecae6"),
    "drawerCategoryIconColor": HexColor("8ecae6"),

    "favoriteIconFilledColor": HexColor("152636"),
    "favoriteIconUnfilledBorderColor": HexColor("152636"),

    "backGroundColor": HexColor("219ebc"),
    "cardBackGroundColor": HexColor("8ecae6"),
    "searchBarBackGroundColor": HexColor("219ebc"),
    "behindSearchBarColor": HexColor("219ebc"),
  },
  {
    "name": "Night",
    "nameStyle": TextStyle(color: Colors.black54),
    "barColor": Colors.blue,
    "titleColor": Colors.grey,
    "showModeTileColor": Colors.grey,
    "showModeIconColor": Colors.grey,
    "showModeTextColor": Colors.grey,
    "hamburgerMenuIconColor": Colors.white,
    "fabBackGroundColor": HexColor("152636"),
    "dialogsBackGroundColor": HexColor("152636"),
    "dialogsForeGroundColor": Colors.grey,
    "listModeTitleColor":Colors.grey,

    "fabForeGroundColor": Colors.grey,
    "fabIconsColor": Colors.grey,
    "abbrBackGroundColor": Colors.grey,
    "abbrForeGroundColor": Colors.black,
    "abbrTodosForeGroundColor": Colors.grey,
    "dateColor":Colors.grey,
    "filterColor":Colors.grey,

    "favoriteIconFilledColor": Colors.grey,
    "favoriteIconUnfilledBorderColor": Colors.grey,

    "lockDialogCancelForeGroundColor": Colors.transparent,
    "lockedCardBackGroundColor": Colors.black,
    "lockedCardForeGroundColor": Colors.white,
    "lockDialogCancelBackGroundColor": HexColor("FFEFBC"),
    "lockDialog-un-LockBackGroundColor": Colors.black87,
    "lockDialog-un-LockForeGroundColor": HexColor("FBF8F1"),

    "backGroundColor": HexColor("0e0a14"),
    "drawerBackGroundColor": Colors.black,

    "drawerForeGroundColor": Colors.white,
    "drawerCategoryNameForeGroundColor": Colors.grey,
    "drawerCategoryIconColor":Colors.grey,

    "cardBackGroundColor": HexColor("152636"),
    "searchBarBackGroundColor": HexColor("0e0a14"),
    "behindSearchBarColor": HexColor("0e0a14"),
    "searchTextColor": Colors.white,
    "barIconsColor": Colors.white
  },
//  {
//    "name": "Dark",
//    "nameStyle": TextStyle(color: Colors.black54),
//    "barColor": Colors.white,
//    "titleColor": HexColor("#270082"),
//    "fabBackGroundColor": Colors.deepPurple,
//    "listModeTitleColor":Colors.deepPurple,
//    "drawerBackGroundColor": Colors.deepPurple,
//    "drawerForeGroundColor": HexColor("270082"),
//
//    "showModeTextColor": Colors.deepPurple,
//    "showModeTileColor": Colors.deepPurple,
//    "fabForeGroundColor": Colors.black54,
//    "hamburgerMenuIconColor": Colors.deepPurple,
//    "fabIconsColor": Colors.black54,
//    "abbrBackGroundColor": Colors.white.withOpacity(0.2),
//    "abbrTodosForeGroundColor":Colors.black,
//    "lockDialogCancelForeGroundColor": Colors.transparent,
//    "lockedCardBackGroundColor": Colors.purple,
//    "lockedCardForeGroundColor": Colors.black54,
//    "lockDialogCancelBackGroundColor": HexColor("FFEFBC"),
//    "lockDialog-un-LockBackGroundColor": Colors.black87,
//    "lockDialog-un-LockForeGroundColor": HexColor("FBF8F1"),
//    "backGroundColor": HexColor("#270082"),
//    "filterColor": Colors.deepPurple,
//    "cardBackGroundColor": Colors.deepPurple,
//    "searchBarBackGroundColor": HexColor("270082"),
//    "behindSearchBarColor": HexColor("270082"),
//    "dialogsBackGroundColor": Colors.deepPurple,
//    "dialogsForeGroundColor": HexColor("#270082"),
//    "searchTextColor": Colors.deepPurple,
//    "barIconsColor": Colors.deepPurple,
//    "dateColor":Colors.black,
//    "favoriteIconFilledColor": Colors.blue,
//    "favoriteIconUnfilledBorderColor": HexColor("#270082"),
//  },
  {
    "name": "Light",
    "nameStyle": TextStyle(color: Colors.black54),
    "barColor": Colors.white70,
    "titleColor": Colors.black,
    "fabBackGroundColor": HexColor("54BAB9"),
    "fabForeGroundColor": Colors.black54,
    "hamburgerMenuIconColor": Colors.black54,
    "fabIconsColor": Colors.black54,
    "abbrBackGroundColor": HexColor("FBF8F1"),
    "drawerCategoryNameForeGroundColor": Colors.black45,
    "showModeTileColor": Colors.black45,


    "lockDialogCancelForeGroundColor": Colors.transparent,
    "lockedCardBackGroundColor": HexColor("54BAB9"),
    "lockedCardForeGroundColor": HexColor("F7ECDE"),
    "lockDialogCancelBackGroundColor": HexColor("FFEFBC"),
    "lockDialog-un-LockBackGroundColor": Colors.black87,
    "lockDialog-un-LockForeGroundColor": HexColor("FBF8F1"),

    "backGroundColor": HexColor("E9DAC1"),
    "cardBackGroundColor": HexColor("F7ECDE"),
    "dialogsBackGroundColor": HexColor("F7ECDE"),

    "drawerBackGroundColor": HexColor("F7ECDE"),
    "searchBarBackGroundColor": HexColor("E9DAC1"),
    "behindSearchBarColor": HexColor("E9DAC1"),
    "favoriteIconFilledColor": HexColor("54BAB9"),
    "favoriteIconUnfilledBorderColor": Colors.black54,
    "searchTextColor": Colors.black54,
    "barIconsColor": Colors.black54
  },
  {
    "name": "Jungle",
    "nameStyle": TextStyle(color: Colors.brown),
    "fabBackGroundColor": HexColor("BB6464"),
    "fabForeGroundColor": HexColor("FDFCE5"),
    "hamburgerMenuIconColor": Colors.black54,
    "showModeTileColor": Colors.black54,
    "fabIconsColor":HexColor("FDFCE5"),
    "abbrBackGroundColor": HexColor("FBF8F1"),

    "lockDialogCancelForeGroundColor": Colors.transparent,
    "drawerCategoryNameForeGroundColor": Colors.black54,

    "lockedCardBackGroundColor": HexColor("BB6464"),
    "lockedCardForeGroundColor": HexColor("FDFCE5"),
    "lockDialogCancelBackGroundColor": HexColor("FFEFBC"),
    "lockDialog-un-LockBackGroundColor": Colors.black87,
    "lockDialog-un-LockForeGroundColor": HexColor("FBF8F1"),

    "backGroundColor": HexColor("F9F3DF"),
    "cardBackGroundColor": HexColor("FDFCE5"),
    "drawerBackGroundColor": HexColor("FDFCE5"),
    "dialogsBackGroundColor": HexColor("FDFCE5"),
    "searchBarBackGroundColor": HexColor("F9F3DF"),
    "behindSearchBarColor": HexColor("F9F3DF"),
    "favoriteIconFilledColor": HexColor("BB6464"),
    "favoriteIconUnfilledBorderColor": Colors.black54,
    "searchTextColor": Colors.black54,
    "barIconsColor": Colors.black54
  },
  {
    "name": "Ocean",
    "nameStyle": TextStyle(color: Colors.black54),
    "fabBackGroundColor": HexColor("FFEFBC"),
    "fabForeGroundColor": Colors.black54,
    "hamburgerMenuIconColor": Colors.black54,
    "fabIconsColor": Colors.black54,
    "dialogsBackGroundColor": HexColor("FFEFBC"),
    "lockDialogCancelForeGroundColor": HexColor("FFEFBC"),
    "lockedCardBackGroundColor": HexColor("FFEFBC"),
    "lockedCardForeGroundColor": Colors.black54,
    "lockDialogCancelBackGroundColor": HexColor("FFEFBC"),
    "lockDialog-un-LockBackGroundColor": Colors.black87,
    "lockDialog-un-LockForeGroundColor": HexColor("FBF8F1"),
    "drawerCategoryNameForeGroundColor": Colors.black54,
    "showModeTileColor": Colors.black54,

    "dialogsForeGroundColor": Colors.black54,
    "drawerBackGroundColor":HexColor("FFEFBC"),
    "abbrBackGroundColor": HexColor("FBF8F1"),
    "backGroundColor": HexColor("FFADAD"),
    "cardBackGroundColor": HexColor("FFDAC7"),
    "searchBarBackGroundColor": HexColor("FFADAD"),
    "behindSearchBarColor": HexColor("FFADAD"),
    "favoriteIconFilledColor": Colors.pinkAccent,
    "favoriteIconUnfilledBorderColor": Colors.black54,
    "searchTextColor": Colors.black54,
    "barIconsColor": Colors.black54,


  },
//  {
//    "name": "Wood",
//    "nameStyle": TextStyle(color: Colors.yellow),
//    "fabBackGroundColor": HexColor("204969"),
//    "fabForeGroundColor": Colors.white,
//    "hamburgerMenuIconColor": Colors.black54,
//    "fabIconsColor": Colors.white,
//    "abbrBackGroundColor": Colors.white,
//
//    "lockDialogCancelForeGroundColor": HexColor("FFEFBC"),
//    "lockedCardBackGroundColor":HexColor("54BAB9"),
//    "showModeTileColor":HexColor("54BAB9"),
//    "lockedCardForeGroundColor": HexColor("204969"),
//    "lockDialogCancelBackGroundColor": HexColor("FFEFBC"),
//    "lockDialog-un-LockBackGroundColor": Colors.black87,
//
//    "lockDialog-un-LockForeGroundColor": HexColor("FBF8F1"),
//    "drawerCategoryNameForeGroundColor": Colors.white,
//    "drawerCategoryIconColor": Colors.white,
//    "drawerForeGroundColor": Colors.white,
//    "drawerIconColor": Colors.white,
//    "dialogsBackGroundColor": Colors.white,
//
//    "backGroundColor": Colors.white,
//    "titleColor":Colors.white,
//    "cardBackGroundColor": HexColor("204969"),
//    "searchBarBackGroundColor": Colors.white,
//    "behindSearchBarColor": Colors.white,
//    "favoriteIconFilledColor": HexColor("54BAB9"),
//    "favoriteIconUnfilledBorderColor": HexColor("54BAB9"),
//    "searchTextColor": Colors.black54,
//    "dateColor":Colors.black,
//    "drawerBackGroundColor":HexColor("204969"),
//    "barIconsColor": Colors.black54
//  },
];

class ChooseTheme extends StatefulWidget {
  var currentTheme;

  ChooseTheme([this.currentTheme = null]);

  @override
  _ChooseThemeState createState() => _ChooseThemeState();
}

class _ChooseThemeState extends State<ChooseTheme> {
  var selectedTheme = null;
  var earlyTheme;

  @override
  Widget build(BuildContext context) {
    if (widget.currentTheme != null) {
      selectedTheme = widget.currentTheme;
      earlyTheme = widget.currentTheme;
      widget.currentTheme = null;
    }

    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: WillPopScope(
          onWillPop: () async {
            Future find_theme() async {
              var prefs = await SharedPreferences.getInstance();

              var theme_index = prefs.getInt("theme_index");
              selectedTheme=theme_index;
              if (selectedTheme == null)
                return themes[0];
              else
                return themes[theme_index];
            }

            find_theme().then((replaceAppearance) {

              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MyApp(replaceAppearance),
                  ));
            });
            return false;
          },
          child: Scaffold(
              appBar: AppBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
                actions:[
                  Expanded(
                    child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,children:[
                      IconButton(
                          onPressed: () async {
                            Future find_theme() async {
                              var prefs = await SharedPreferences.getInstance();

                              var theme_index = prefs.getInt("theme_index");
                              selectedTheme=theme_index;

                              if (selectedTheme == null)
                                return themes[0];
                              else
                                return themes[theme_index];
                            }

                            find_theme().then((replaceAppearance) {
                              print("This is it");
                              print(replaceAppearance);

                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => MyApp(replaceAppearance),
                                  ));
                            });
                          },
                          icon: Icon(Icons.arrow_back, color: Colors.black)),
                      Text(
                        "Themes",
                        style: GoogleFonts.lato(color: Colors.black,fontSize:18),
                      ),
                ]),
                  )],
              
              ),
              body: Container(
                color: HexColor("FAFAFA"),
                child: Column(
                  children: [
                    Expanded(
                      child: GridView.builder(
                          itemCount: themes.length,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 4),
                          itemBuilder: (BuildContext context, int index) {
                            return GestureDetector(
                              child: newTheme(index, themes),
                              onTap: () async {
                                selectedTheme = index;
                                setState(() {});
                              },
                            );
                          }),
                    ),
                    Visibility(
                      visible:earlyTheme!=selectedTheme?true:false ,
                      child: Container(
                        width: double.infinity,
                        color: Colors.transparent,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Flexible(
                                  fit: FlexFit.tight,
                                  flex: 1,
                                  child: TextButton(
                                    child: Text(
                                      "Clear changes",
                                      style:
                                          GoogleFonts.lato(color: Colors.black),
                                    ),
                                    style: ButtonStyle(
                                        backgroundColor:
                                            MaterialStateColor.resolveWith(
                                                (states) => Colors.transparent)),
                                    onPressed: () {

                                      selectedTheme=earlyTheme;
                                      saveThemeInShred(selectedTheme);
                                      setState((){});
                                    },
                                  ),
                                ),
                                Flexible(
                                  flex: 1,
                                  fit: FlexFit.tight,
                                  child: TextButton(
                                    child: Text("Apply changes",
                                        style: GoogleFonts.lato(
                                            color: Colors.white)),
                                    style: ButtonStyle(
                                        backgroundColor:
                                            MaterialStateColor.resolveWith(
                                                (states) => Colors.black)),
                                    onPressed: () async {
                                      saveThemeInShred(selectedTheme);
                                    },
                                  ),
                                ),
                              ]),
                        ),
                      ),
                    )
                  ],
                ),
              )),
        ));
  }



  Future saveThemeInShred(int selectedTheme)async{
    final prefs =
        await SharedPreferences.getInstance();
    await prefs.setInt(
        'theme_index', selectedTheme);
  }

  Card newTheme(index_theme, themes) {
    return Card(
        child: ClipRRect(
      borderRadius: BorderRadius.circular(5),
      child: Stack(children: [
        Container(
          child: Column(
            children: [
              Flexible(
                  flex: 2,
                  child: Container(
                    width: double.infinity,
                    color: themes[index_theme]["backGroundColor"],
                  )),
              Flexible(
                  flex: 1,
                  child: Container(
                    width: double.infinity,
                    color: themes[index_theme]["cardBackGroundColor"],
                  )),
              Flexible(
                  flex: themes[index_theme]["cardBackGroundColor"] ==
                          themes[index_theme]["fabBackGroundColor"]
                      ? 0
                      : 1,
                  child: Container(
                    width: double.infinity,
                    color: themes[index_theme]["fabBackGroundColor"],
                  )),
            ],
          ),
        ),
        Visibility(
          visible: index_theme == selectedTheme ? true : false,
          child: Align(
              alignment: Alignment.bottomLeft,
              child: Icon(Icons.check_circle, color: Colors.green, size: 25)),
        ),
      ]),
    ));
  }
}

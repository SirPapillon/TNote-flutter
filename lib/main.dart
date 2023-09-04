// @dart=2.9
import 'package:flutter/material.dart';
import 'CustomFab.dart';
import 'NotesList.dart';
import 'ChangeTheme.dart';
import 'Activities/EditNotes.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:ui';
import 'PageNavigator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'Activities/Search.dart';

import 'dart:async';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'package:clever/Activities/Themes.dart' as theme;
import 'package:clever/Drawer.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

int U;
bool categoryEdited=false;
var catName=null;
Future initializeNotificationManager() async {
  var initializationSettingsAndroid = AndroidInitializationSettings("hashtag");
  var initializationSettings =
      InitializationSettings(android: initializationSettingsAndroid);
  await flutterLocalNotificationsPlugin.initialize(initializationSettings,
      onSelectNotification: (String payload) async {
    if (payload != null) {
      debugPrint("notif payload : " + payload);
    }
  });
}


bool themeChanged=false;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  initializeNotificationManager();

  Map appearance;

  Future find_theme() async {
    final prefs = await SharedPreferences.getInstance();
    int theme_index = prefs.getInt('theme_index');
    if (theme_index == null)
      return theme.themes[0];
    else
      return theme.themes[theme_index];
  }

  find_theme().then((value) async{
    appearance = value;
    runApp(MyApp(appearance));
  });


}

class MyApp extends StatefulWidget {
  Map appearance;
  var categoryName;
  MyApp(this.appearance,[this.categoryName=null]);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  final navigatorKey = GlobalKey<NavigatorState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();


  Color TopColor, MiddleColor, SecondaryColor, TitleColor;
  bool isDescending = false;
  List ThemeColors;

  String ThemeN;



  void onRewardedLoaded(String placementId) {
    print("rewarded ad loaded");
  }

  void onInterstitialLoaded(String placement) {
    print("interstitial loaded");
  }

  void onRewardedClosed(String placement, bool isRewarded) {
    print("ad rewarded: " + isRewarded.toString());
    if (isRewarded) {
      print("hello w");
    }
  }

  void onError(String placement, String error) {
    print("onError" + error);
  }




  @override
  Widget build(BuildContext context) {




    Map appearance = widget.appearance;


    ChangeThemeTo(String ThemeName) async {
      SharedPreferences pref = await SharedPreferences.getInstance();
      pref.setString("theme", ThemeName);
    }

    ThemeN = "default";
    ThemeColors = ChangeTheme(ThemeN);
    TopColor = ThemeColors[0];
    MiddleColor = ThemeColors[1];
    SecondaryColor = ThemeColors[2];
    TitleColor = ThemeColors[6];




    return MaterialApp(
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        onDrawerChanged: (e){
          if(e==false){
            if (catName!=null){
              widget.categoryName=catName;
            }
            else{
              widget.categoryName=null;
            }







              setState(() {});

          }

          else{

            widget.categoryName=catName;
          }


        },
        key: scaffoldKey,
        backgroundColor: appearance["behindSearchBarColor"],
        drawer: Padding(
          padding: const EdgeInsets.only(top:50.0,bottom:20,left:10),
          child: showDrawer(appearance,widget.categoryName),
        ),

          appBar: PreferredSize(
          preferredSize: Size(double.infinity, 50),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: AppBar(
              shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.vertical(bottom: Radius.circular(5))),
              iconTheme:
                  IconThemeData(color: appearance["hamburgerMenuIconColor"]),
              automaticallyImplyLeading: false,
              //
              backgroundColor: appearance["searchBarBackGroundColor"],
              elevation: 2,

              actions: [
                Expanded(
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                      Row(children: [
                        IconButton(
                          onPressed: () async {


                            scaffoldKey.currentState.openDrawer();




//                            main();
//                            _loadInterstitial(); advertisement
                          },
                          icon: Icon(Icons.menu),
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              NavigateTo(showSearchActivity(appearance,widget.categoryName),
                                  context, navigatorKey);
                            });
                          },
                          child: Text(
                            widget.categoryName==null?
                            "Search...":"Search ${handleOverFlow(widget.categoryName,15)}",
                            style: GoogleFonts.actor(
                                color: appearance["searchTextColor"],
                                fontSize: 18),
                          ),
                        ),
                      ]),
                      IconButton(
                          onPressed: () {
                            O() {
                              Future find_theme() async {
                                final prefs =
                                    await SharedPreferences.getInstance();
                                int theme_index = prefs.getInt('theme_index');
                                if (theme_index == null)
                                  return 0;
                                else
                                  return theme_index;
                              }

                              find_theme().then((theme_index) {
                                NavigateToThemes(theme.ChooseTheme(theme_index),
                                    context, navigatorKey);
                              });
                            }

                            O();
                          },
                          icon: Icon(
                            Icons.palette_outlined,
                            color: appearance["barIconsColor"],
                          )),
                    ]))
              ],
            ),
          ),
        ),
        floatingActionButton: GestureDetector(
            onLongPress: () {
              NavigateTo(EditNotes(false), context, navigatorKey);
            },
            child: Dfab(appearance,widget.categoryName)),
        body: GestureDetector(
          onHorizontalDragUpdate: (details) {
//            if (details.delta.dx < 10) {
//              // Swiping in left direction.
//              NavigateTo(EditNotes(false), context, navigatorKey);
//            }
          },
          child: Column(children: [
            Expanded(child: ShowNotes(appearance, false, false, [], false,widget.categoryName)),

            // Stack
          ]),
        ),
      ),
    );
  }





  Future showNotif(id, t) async {
    DateTime now = new DateTime.now();
  }

  Text Title() {
    return Text("Clever",
        style: TextStyle(
            color: TitleColor, fontWeight: FontWeight.bold, fontSize: 25));
  }

  Future ReadThemeFromPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String ThemeName = prefs.getString('theme');

    return ThemeName;
  }

  ChangeThemeFromPrefs() async {}
}

Future h() async {
  return "as";
}





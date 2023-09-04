import 'package:flutter/material.dart';

import 'package:focused_menu/modals.dart';
import 'Activities/EditNotes.dart' as edn;
import 'package:sqflite/sqflite.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:custom_check_box/custom_check_box.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:focused_menu/focused_menu.dart';
import 'package:share_plus/share_plus.dart';
import 'DataBaseMa.dart';
import 'Activities/AddToRemindersActivity.dart';
import 'dart:convert';
import 'package:styled_text/styled_text.dart';
import 'Activities/Todos.dart' as td;
import 'package:clever/AlarmManager.dart';
import 'Drawer.dart' as drawer;

int yu = 0;

String handleOverFlow(String str, int num) {
  if (str.length <= num) return str;

  String final_str = "";
  for (int counter = 0; counter <= num - 1; counter++) {
    final_str = final_str + str[counter];
  }

  return final_str + "...";
}

class ShowNotes extends StatefulWidget {
  Map ThemeColors;
  bool NoteList_is_Card;
  bool isSearchActivity;
  List SearchFoundedResult;
  bool SearchBar_is_Empty;
  var categoryName;
  var search_result;

  ShowNotes(this.ThemeColors, this.NoteList_is_Card, this.isSearchActivity,
      this.SearchFoundedResult, this.SearchBar_is_Empty, this.categoryName,
      [this.search_result = null]);

  @override
  _ShowNotesState createState() =>
      _ShowNotesState(ThemeColors, NoteList_is_Card);
}

class _ShowNotesState extends State<ShowNotes> {
  bool SortMenuVisibility = false;
  Map ThemeColors;
  bool IsChecked = false;
  String filter = "";
  bool filter_alarms = false;

  late List p;

  int ItemLength = 0;
  late List Datas;

  bool isVisible = false;
  Map Ids = {};
  final _PasswordController = TextEditingController();
  final _Re_PasswordController = TextEditingController();
  final _PathFieldController = TextEditingController();
  bool NoteList_is_Card;
  bool isTitleMode = true;

  _ShowNotesState(this.ThemeColors, this.NoteList_is_Card);

  OrderBody(List body) {}
  String DropDefaultItem = "Grid";
  String SortDropDefaultItem = "date";
  bool isSelectable = false;
  bool inCategory = false;

  @override
  Widget build(BuildContext context) {
    if (!widget.isSearchActivity) {
      ReadNotes().whenComplete(() => null).then((value) => setState(() {
            int Counter = 0;
            Ids.clear();
            ItemLength = value.length;

            if (widget.categoryName != null) {
              value = filter_by_category(value, widget.categoryName);
            }
            Datas=filter_by_not_in_trash(value);

            switch (filter) {
              case ("favorites"):
                Datas = filter_by_favorites(Datas);
                break;
              case ("alarms"):
                Datas = filter_by_alarms(Datas);
                break;

              case ("untitle"):
                Datas=filter_by_unTitles(Datas);
                break;
              case ("todos"):
                Datas = filter_by_todos(Datas);
                break;
              case ("title"):
                Datas = filter_by_titles(Datas);
                break;
              case ("notes"):
                Datas = filter_by_notes(Datas);
                break;
              case ("A to Z"):
                Datas = filter_by_alphabet_ascending(Datas);
                break;
              case ("Z to A"):
                Datas = filter_by_alphabet_decending(Datas);
                break;
              default:
                Datas = Datas;
                break;
            }

            Datas.forEach((element) {
              Ids[Counter] = element["ID"];
              Counter += 1;
            });
            var disposeSettings;
            disposeSettings=disposeAlarms(Datas);

            Datas = disposeSettings ;
          }));
    } else {
      setState(() {
        int Counter = 0;
        Ids.clear();
        ItemLength = widget.SearchFoundedResult.length;
        Datas = widget.SearchFoundedResult;
        Datas=filter_by_not_in_trash(Datas);

        Datas.forEach((element) {
          Ids[Counter] = element["ID"];
          Counter += 1;
        });
        var disposeSettings;
        disposeSettings=disposeAlarms(Datas);

        Datas = disposeSettings ;

      });
    }




    return Stack(children: [
      Container(
        color: ThemeColors["backGroundColor"],
        child: Column(children: [
          Visibility(
            visible: !widget.isSearchActivity,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                Expanded(
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [ShowListMode()])),
                ShowListSortMode()
              ]),
            ),
          ),
          Ids.length != 0
              ? NoteList_is_Card == true
                  ? Expanded(child: M1())
                  : Expanded(child: M2())
              : Expanded(
                  child: Container(
                      color: Colors.transparent,
                      width: double.infinity,
                      child: Center(
                          child: Text(
                              widget.isSearchActivity == true
                                  ? widget.SearchFoundedResult == []
                                      ? ""
                                      : "There is nothing to show"
                                  : "",
                              style: GoogleFonts.acme(
                                  color: Colors.black, fontSize: 23)))))
        ]),
      ),
    ]);
  }

  GridView M2() {
    int Counter = 0;
    List D = [];
    Map I = {};
    Datas.forEach((element) {
      if (element["inTrash"] == 0) {
        I[Counter] = element["ID"];
        D.add(element);
        Counter++;
      }
    });
    return GridView.builder(
        physics: BouncingScrollPhysics(),
        itemCount: I.length,
        padding: EdgeInsets.all(0),
        gridDelegate:
            SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
        itemBuilder: (BuildContext context, int index) {
          if (D[index]["inTrash"] == 0) {
            int Id = I[index];
            return GestureDetector(
                onTap: () {
                  if (D[index]['isLocked'] == 1) {
                    _UnlockNotePasswordDialog(context, Id);
                  } else {
                    Scaffold.of(context)
                        .hideCurrentSnackBar();
                    if (D[index]['isTodo'] == 1) {
                      showTodoManagerSetting(index,D);
                    } else {
                      if (widget.isSearchActivity == true) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => edn.EditNotes(
                                    true, Id, true, widget.search_result)));
                      } else {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => edn.EditNotes(true, Id)));
                      }
                    }
                  }
                },
                onLongPress: () {

                },
                child: D[index]['isLocked'] == 0
                    ? FocusedMenuHolder(
                        child: D[index]["isTodo"] == 0
                            ? CrdList(index, D, I)
                            : CrdList_Todos(index, D, I),
                        menuWidth: MediaQuery.of(context).size.width * 0.50,
                        blurSize: 5.0,
                        menuItemExtent: 45,
                        menuBoxDecoration: BoxDecoration(
                            color: ThemeColors["dialogsBackGroundColor"],
                            borderRadius:
                                BorderRadius.all(Radius.circular(20.0))),

                        //duration: Duration(milliseconds: 100),
                        animateMenuItems: false,
                        blurBackgroundColor: Colors.black54,
                        openWithTap: true,
                        // Open Focused-Menu on Tap rather than Long Press
                        menuOffset: 10.0,
                        // Offset value to show menuItem from the selected item
                        bottomOffsetHeight: 80.0,
                        // Offset height to consider, for showing the menu item ( for example bottom navigation bar), so that the popup menu will be shown on top of selected item.
                        menuItems: [
                          // Add Each FocusedMenuItem  for Menu Options
                          FocusedMenuItem(
                              backgroundColor:
                                  ThemeColors["dialogsBackGroundColor"],
                              title: Text(D[index]["isFavorite"] == 0
                                  ? "Add To Favorites"
                                  : "Remove Favorite",style: GoogleFonts.actor(
                                  color:ThemeColors["dialogsForeGroundColor"]
                              )),
                              trailingIcon:D[index]["isFavorite"] == 0? Icon(Icons.favorite_border,color:ThemeColors["favoriteIconUnfilledBorderColor"]):Icon(Icons.favorite,color:ThemeColors["favoriteIconFilledColor"]),
                              onPressed: () {
                                setState(() {
                                  if (D[index]["isFavorite"] == 0)
                                    AddToFavorites(D[index]["ID"]);
                                  else
                                    RemoveFromFavorites(D[index]["ID"]);
                                });
                              }),

                          FocusedMenuItem(
                              backgroundColor:
                                  ThemeColors["dialogsBackGroundColor"],
                              title: Text("Lock",
                                  style: GoogleFonts.actor(
                                    color:ThemeColors["dialogsForeGroundColor"],
                                  )),
                              trailingIcon: Icon(Icons.lock_outline,color:ThemeColors["dialogsForeGroundColor"]),
                              onPressed: () {
                                _LockNotePasswordDialog(
                                  context,
                                  Id,
                                );
                              }),

//                          FocusedMenuItem(
//                              backgroundColor:
//                                  ThemeColors["dialogsBackGroundColor"],
//                              title: Text("Add location",
//                                  style: GoogleFonts.actor(
//                                    color: Colors.black,
//                                  )),
//                              trailingIcon: Icon(Icons.map_outlined),
//                              onPressed: () {
//                                Navigator.push(
//                                    context,
//                                    MaterialPageRoute(
//                                        builder: (context) =>
//                                            showMap(D[index]["ID"])));
//                              }),
                          FocusedMenuItem(

                              backgroundColor:
                                  ThemeColors["dialogsBackGroundColor"],
                              title: Text("Add To Categories",style: GoogleFonts.actor(
                                  color:ThemeColors["dialogsForeGroundColor"]
                              )),
                              trailingIcon: Icon(FontAwesomeIcons.file,color:ThemeColors["dialogsForeGroundColor"]),
                              onPressed: () {
                                AddToCategoryDialog(index);
                              }),


                          FocusedMenuItem(
                            visible: D[index]["isTodo"]==1?false:true,
                              backgroundColor:
                                  ThemeColors["dialogsBackGroundColor"],
                              title: Text("Add To Alarms",
                                  style: GoogleFonts.actor(
                                      color:ThemeColors["dialogsForeGroundColor"]
                                  )),
                              trailingIcon: Icon(Icons.alarm_outlined,color:ThemeColors["dialogsForeGroundColor"]),
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => AddToReminders(
                                            D[index]["Title"], Id)));
                              }),
                          FocusedMenuItem(
                              backgroundColor:
                                  ThemeColors["dialogsBackGroundColor"],
                              title: Text("Share",
                                  style: GoogleFonts.actor(
                                      color:ThemeColors["dialogsForeGroundColor"]
                                  )),
                              trailingIcon: Icon(Icons.share_outlined,color:ThemeColors["dialogsForeGroundColor"]),
                              onPressed: () {
                                String shareContent = "";
                                ReadNotes().then((value) {



                                  if (value[index]["isTodo"]==1){
                                    int todoCounter=1;
                                    if(value[index]["Title"].trim().length!=0){
                                      shareContent+=value[index]["Title"]+'\n';
                                    }
                                    json.decode(value[index]["Todos"]).forEach((todo){
                                      if (todo["Title"].trim().length!=0){
                                        if (todo["Description"].trim().length==0){
                                          shareContent+="$todoCounter- ${todo["Title"]}\n";
                                        }
                                        else{
                                          shareContent+="$todoCounter- ${todo["Title"]} : ${todo["Description"]}\n";
                                        }
                                      }

                                      else if (todo["Description"].trim()!=0){
                                        shareContent+="$todoCounter- ${todo["Description"]}\n";

                                      }

                                      else{
                                        todoCounter--;
                                      }

                                      todoCounter++;
                                    });
                                  }

                                  else{
                                    if (value[index]["Title"].trim().length >=
                                            0 &&
                                        value[index]["NoteBody"].trim().length >=
                                            0) {

                                      shareContent = value[index]["Title"] +
                                          "\n " +
                                          value[index]["NoteBody"];
                                    } else if (value[index]["NoteBody"]
                                            .trim
                                            .length ==
                                        0) {
                                      shareContent = value[index]["Title"];
                                    } else if (shareContent =
                                        value[index]["Title"]) {
                                      shareContent = value[index]["NoteBody"];
                                    } else {}


                                  }
                                  if (shareContent.trim().length > 0) {
                                    Share.share(shareContent.trim());
                                  }
                                });
                              }),

                          FocusedMenuItem(
                              backgroundColor:
                                  ThemeColors["dialogsBackGroundColor"],
                              title: Text(
                                "Delete",
                                style:
                                    GoogleFonts.actor(color: Colors.redAccent),
                              ),
                              trailingIcon: Icon(
                                Icons.delete,
                                color: Colors.redAccent,
                              ),
                              onPressed: () {
                                MoveToTrash(Id)
                                    .whenComplete(() {

                                  Scaffold.of(context)
                                      .hideCurrentSnackBar();
                                      Scaffold.of(context)
                                            .showSnackBar(SnackBar(
                                                content: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                              Text("Moved To Trash"),
                                              GestureDetector(
                                                  child: Text("Redo"),
                                                  onTap: () {
                                                    RemoveFromTrash(Id)
                                                        .whenComplete(() {
                                                      Scaffold.of(context)
                                                          .hideCurrentSnackBar();
                                                      setState(() {});
                                                    });
                                                  })
                                            ])));})
                                    .whenComplete(() => setState(() {}));
                              }),
                        ],
                        onPressed: () {},
                      )
                    : Crd_Locked_List(index));
          } else {
            return Visibility(visible: false, child: Text(''));
          }
        });
  }

  Card Crd_Locked_List(index) {
    return Card(
        color: ThemeColors["lockedCardBackGroundColor"],
        elevation: 0,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10))),
        child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
          Expanded(
              child: Center(
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Icon(
                    Icons.lock_outline,
                    color: ThemeColors["lockedCardForeGroundColor"],
                  ),
                  Text("Locked",
                      style: GoogleFonts.actor(
                          color: ThemeColors["lockedCardForeGroundColor"],
                          fontSize: 25,
                          fontWeight: FontWeight.bold)),
                ]),
                Text("****",
                    style: GoogleFonts.actor(
                        color: ThemeColors["lockedCardForeGroundColor"],
                        fontSize: 25))
              ])))
        ]));
  }

  Card CrdList_Todos(index, D, Ids) {
    List TodosItem = json.decode(D[index]["Todos"]);

    Color AvatarColor = DataBaseColorDetector(Datas[index]["AvatarColor"]);
    return Card(
        color: ThemeColors["cardBackGroundColor"],
        elevation: 0,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10))),
        child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
          Row(children: [
            Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: const EdgeInsets.only(top: 8.0, left: 8.0),
                  child: Visibility(
                      visible: !isSelectable,
                      replacement:
                          Radio(value: true, groupValue: 1, onChanged: (e) {}),
                      child: GestureDetector(
                        onTap: () {
                          PickColorDialog(Ids[index]);
                        },
                        child: CircleAvatar(
                            backgroundColor: AvatarColor, radius: 10),
                      )),
                )),
            Expanded(
                child: Padding(
              padding: const EdgeInsets.only(top: 8.0, right: 8.0),
              child: Align(
                  alignment: Alignment.topRight,
                  child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => AddToReminders(
                                    Datas[index]["Title"],
                                    Datas[index]["Id"],
                                    Datas[index]["AlarmData"])));
                      },
                      child: Visibility(
                        visible: Datas[index]["isAlarmed"] == 1 ? true : false,
                        child: TextButton(
                          child: Text(""),
                          onPressed: () {},
                          style: ButtonStyle(
                              shape: MaterialStateProperty.all(
                                  RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(30)))),
                        ),
                      ))),
            ))
          ]),
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Visibility(
              visible: isTitleMode,
              replacement: TextField(),
              child:
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                Icon(
                  Icons.checklist,
                  color: ThemeColors["titleColor"],
                ),
                Text(D[index]["Title"].trim() != ""?handleOverFlow(
                     D[index]["Title"]
                    , 8):"Untitled todo"
                   ,
                    style: GoogleFonts.actor(
                        color: ThemeColors["titleColor"],
                        fontSize: 23,
                        fontWeight: FontWeight.bold)),
              ]),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Align(
                alignment: Alignment.centerLeft,
                child: Column(
                  children: List.generate(
                      TodosItem.length >= 5 ? 5 : TodosItem.length, (index) {
                    return Row(children: [
                      Container(
                          width: 5,
                          height: 5,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.blue,
                          )),
                      SizedBox(width: 5),
                      StyledText(
                        text:
                            "<title>${handleOverFlow(TodosItem[index]["Title"], 7)}</title>  <description>${handleOverFlow(TodosItem[index]["Description"], 10)}</description>",
                        tags: {
                          'title': StyledTextTag(
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                  color:
                                      ThemeColors["abbrTodosForeGroundColor"])),
                          'description': StyledTextTag(
                              style: TextStyle(
                                  fontSize: 15,
                                  color:
                                      ThemeColors["abbrTodosForeGroundColor"]))
                        },
                      ),
                    ]);
                  }),
                )),
          ),
          Expanded(
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                Align(
                    alignment: Alignment.bottomLeft,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(Datas[index]["Date"],
                          style: TextStyle(
                              fontSize: 12, color: ThemeColors["dateColor"])),
                    )),
                Align(
                  alignment: Alignment.bottomRight,
                  child: IconButton(
                      splashRadius: 15,
                      icon: Datas[index]["isFavorite"] == 0
                          ? Icon(Icons.favorite_border,
                              size: 20,
                              color: ThemeColors[
                                  "favoriteIconUnfilledBorderColor"])
                          : Icon(
                              Icons.favorite,
                              size: 20,
                              color: ThemeColors["favoriteIconFilledColor"],
                            ),
                      onPressed: () {
                        setState(() async {
                          if (Datas[index]["isFavorite"] == 0)
                            AddToFavorites(Datas[index]["ID"]);
                          else
                            RemoveFromFavorites(Datas[index]["ID"]);
                        });
                      }),
                ),
              ]))
        ]));
  }

  Card CrdList(index, Datas, Ids) {
    Color AvatarColor = DataBaseColorDetector(Datas[index]["AvatarColor"]);
    return Card(
        color: ThemeColors["cardBackGroundColor"],
        elevation: 0,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10))),
        child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
          Row(children: [
            Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: const EdgeInsets.only(top: 8.0, left: 8.0),
                  child: Visibility(
                      visible: !isSelectable,
                      replacement:
                          Radio(value: true, groupValue: 1, onChanged: (e) {}),
                      child: GestureDetector(
                        onTap: () {
                          PickColorDialog(Ids[index]);
                        },
                        child: CircleAvatar(
                            backgroundColor: AvatarColor, radius: 10),
                      )),
                )),
            Expanded(
                child: Padding(
              padding: const EdgeInsets.only(top: 8.0, right: 8.0),
              child: Align(
                  alignment: Alignment.topRight,
                  child: GestureDetector(
                      onTap: () {
                        showAlarmsManagerDialog(index, Datas);

                      },
                      child: Visibility(
                        visible: Datas[index]["isAlarmed"] == 1 ? true : false,
                        child: Container(
                          child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Text("Alarmed",
                                style: TextStyle(
                                    color: ThemeColors["fabForeGroundColor"],
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold)),
                          ),
                          decoration: BoxDecoration(
                              color: ThemeColors["fabBackGroundColor"],
                              borderRadius: BorderRadius.circular(20)),
                        ),
                      ))),
            ))
          ]),
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Visibility(
              visible: isTitleMode,
              replacement: TextField(),
              child: Text(handleOverFlow(Datas[index]["Title"].trim() != ""
                  ? Datas[index]["Title"]
                  : "Untitled", 10)
                  ,
                  style: GoogleFonts.actor(
                      fontSize: 23,
                      fontWeight: FontWeight.bold,
                      color: widget.ThemeColors["titleColor"])),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Align(
                alignment: Alignment.centerLeft,
                child: Datas[index]["NoteBody"].trim() != ""
                    ? Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                            color: ThemeColors["abbrBackGroundColor"],
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                        padding: EdgeInsets.all(8.0),
                        child: Text(Datas[index]["NoteBody"] + "\n\n",
                            maxLines: 4,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.actor(
                                fontSize: 14,
                                color: ThemeColors["abbrForeGroundColor"])),
                      )
                    : Text("")),
          ),
          Expanded(
              child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Align(
                  alignment: Alignment.bottomLeft,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(Datas[index]["Date"],
                        style: TextStyle(
                            fontSize: 12, color: ThemeColors["dateColor"])),
                  )),
              Align(
                alignment: Alignment.bottomRight,
                child: IconButton(
                    splashRadius: 15,
                    icon: Datas[index]["isFavorite"] == 0
                        ? Icon(Icons.favorite_border,
                            size: 20,
                            color:
                                ThemeColors["favoriteIconUnfilledBorderColor"])
                        : Icon(
                            Icons.favorite,
                            size: 20,
                            color: ThemeColors["favoriteIconFilledColor"],
                          ),
                    onPressed: () {
                      setState(() async {
                        if (Datas[index]["isFavorite"] == 0)
                          AddToFavorites(Datas[index]["ID"]);
                        else
                          RemoveFromFavorites(Datas[index]["ID"]);
                      });
                    }),
              )
            ],
          ))
        ]));
  }

  DataBaseColorDetector(ColorName) {
    switch (ColorName) {
      case "black87":
        return Colors.black87;
      case "darkblue":
        return HexColor("0C4FF1");
      case "orange":
        return Colors.orange;
      case "yellow":
        return Colors.yellow;
      case "red":
        return Colors.red;
      case "green":
        return Colors.green;
    }
  }

  ListView M1() {
    return ListView.separated(
        physics: BouncingScrollPhysics(),
        separatorBuilder: (BuildContext context, int index) => Divider(
              height: Datas[index]["inTrash"] == 0 ? 1 : 0,
            ),
        padding: const EdgeInsets.only(top: 1),
        itemCount:  Datas.length,
        itemBuilder: (BuildContext context, int index) {
          int Id = Datas[index]["ID"];

          if (Datas[index]['isLocked'] == 0) {
            return FocusedMenuHolder(
                menuWidth: MediaQuery.of(context).size.width * 0.50,
                blurSize: 5.0,
                menuItemExtent: 45,
                menuBoxDecoration: BoxDecoration(
                    color: ThemeColors["dialogsBackGroundColor"],
                    borderRadius: BorderRadius.all(Radius.circular(20.0))),
                //duration: Duration(milliseconds: 100),
                animateMenuItems: false,
                blurBackgroundColor: Colors.black54,
                openWithTap: true,
                // Open Focused-Menu on Tap rather than Long Press
                menuOffset: 10.0,
                // Offset value to show menuItem from the selected item
                bottomOffsetHeight: 80.0,
                onPressed: () {},
                menuItems: [

                  // Add Each FocusedMenuItem  for Menu Options
            FocusedMenuItem(
            backgroundColor:
            ThemeColors["dialogsBackGroundColor"],
                title: Text(Datas[index]["isFavorite"] == 0
                    ? "Add To Favorites"
                    : "Remove Favorite",style: GoogleFonts.actor(
                    color:ThemeColors["dialogsForeGroundColor"]
                )),
                trailingIcon:Datas[index]["isFavorite"] == 0? Icon(Icons.favorite_border,color:ThemeColors["favoriteIconUnfilledBorderColor"]):Icon(Icons.favorite,color:ThemeColors["favoriteIconFilledColor"]),
                onPressed: () {
                  setState(() {
                    if (Datas[index]["isFavorite"] == 0)
                      AddToFavorites(Datas[index]["ID"]);
                    else
                      RemoveFromFavorites(Datas[index]["ID"]);
                  });
                }),

                  FocusedMenuItem(
                      backgroundColor: ThemeColors["dialogsBackGroundColor"],
                      title: Text("Lock",
                          style: GoogleFonts.actor(
                              color:ThemeColors["dialogsForeGroundColor"]
                          )),
                      trailingIcon: Icon(Icons.lock_outline,color:ThemeColors["dialogsForeGroundColor"]),
                      onPressed: () {
                        _LockNotePasswordDialog(
                          context,
                          Id,
                        );
                      }),
//                  FocusedMenuItem(
//                      backgroundColor:
//                      ThemeColors["dialogsBackGroundColor"],
//                      title: Text("Add location",
//                          style: GoogleFonts.actor(
//                            color: Colors.black,
//                          )),
//                      trailingIcon: Icon(Icons.map_outlined),
//                      onPressed: () {
//                        Navigator.push(
//                            context,
//                            MaterialPageRoute(
//                                builder: (context) =>
//                                    showMap(Datas[index]["ID"])));
//                      }),
                  FocusedMenuItem(
                      backgroundColor:
                      ThemeColors["dialogsBackGroundColor"],
                      title: Text("Add To Categories",style: GoogleFonts.actor(
                          color:ThemeColors["dialogsForeGroundColor"]
                      )),
                      trailingIcon: Icon(FontAwesomeIcons.file,color:ThemeColors["dialogsForeGroundColor"]),
                      onPressed: () {
                        AddToCategoryDialog(index);
                      }),
                  FocusedMenuItem(
                      visible: Datas[index]["isTodo"]==1?false:true,

                      backgroundColor: ThemeColors["dialogsBackGroundColor"],
                      title: Text("Add To Alarms",
                          style: GoogleFonts.actor(
                              color:ThemeColors["dialogsForeGroundColor"]
                          )),
                      trailingIcon: Icon(Icons.alarm_outlined,color:ThemeColors["dialogsForeGroundColor"]),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    AddToReminders(Datas[index]["Title"], Id)));
                      }),
                  FocusedMenuItem(
                      backgroundColor: ThemeColors["dialogsBackGroundColor"],
                      title: Text("Share",
                          style: GoogleFonts.actor(
                              color:ThemeColors["dialogsForeGroundColor"]
                          )),
                      trailingIcon: Icon(Icons.share_outlined,color:ThemeColors["dialogsForeGroundColor"]),
                      onPressed: () {
                        String shareContent = "";
                        ReadNotes().then((value) {

    if (value[index]["isTodo"]==1){
      int todoCounter=1;
    if(value[index]["Title"].trim().length!=0){
    shareContent+=value[index]["Title"]+'\n';
    }
    json.decode(value[index]["Todos"]).forEach((todo){
    if (todo["Title"].trim().length!=0){
    if (todo["Description"].trim().length==0){
    shareContent+="$todoCounter- ${todo["Title"]}\n";
    }
    else{
    shareContent+="$todoCounter- ${todo["Title"]} : ${todo["Description"]}\n";
    }
    }

    else
    if (todo["Description"].trim()!=0){
    shareContent+="$todoCounter- ${todo["Description"]}\n";

    }

    else{
    todoCounter--;
    }

    todoCounter++;
    });
    }

else{
    if (value[index]["Title"].trim().length >= 0 &&
    value[index]["NoteBody"].trim().length >= 0) {
    shareContent = value[index]["Title"] +
    "\n " +
    value[index]["NoteBody"];
    } else
    if (value[index]["NoteBody"].trim.length ==
    0) {
    shareContent = value[index]["Title"];
    } else
    if (shareContent = value[index]["Title"]) {
    shareContent = value[index]["NoteBody"];
    } else {}
    }
                          if (shareContent.trim().length > 0) {
                            Share.share(shareContent);
                          }
                        });
                      }),

                  FocusedMenuItem(
                      backgroundColor: ThemeColors["dialogsBackGroundColor"],
                      title: Text(
                        "Delete",
                        style: GoogleFonts.actor(color: Colors.redAccent),
                      ),
                      trailingIcon: Icon(
                        Icons.delete,
                        color: Colors.redAccent,
                      ),
                      onPressed: () {
                        MoveToTrash(Id).whenComplete(() => setState(() {}));
                      }),
                ],
                child: Datas[index]["inTrash"] == 0
                    ? Datas[index]["isTodo"] == 0
                        ? listItem(Id, index)
                        : listItem_todo(Id, index)
                    : Visibility(visible: false, child: Text("")));
          } else {
            return listItem_locked(Id, index);
          }
        });
  }

  Future showAlarmsManagerDialog(int index, Datas) async {
    final ValueNotifier<int> _counter = ValueNotifier<int>(0);
    var alarmData = Datas[index]["AlarmData"];
    var alarms = json.decode(alarmData);

    return showDialog(
        context: context,
        builder: (context) {
          return ValueListenableBuilder(
            valueListenable: _counter,
            builder: (context, value, child) {
              List falarms = alarms;

              return AlertDialog(
                title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Alarms", style: GoogleFonts.lato()),
                      IconButton(
                        icon: Icon(Icons.arrow_forward),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      td.TodoManager(Datas[index]["ID"])));
                        },
                      )
                    ]),
                contentPadding:
                    EdgeInsets.only(bottom: 20, left: 20, right: 20, top: 15),
                titlePadding: EdgeInsets.only(left: 8, top: 8),
                content: SingleChildScrollView(
                  child: Column(
                      children: List.generate(falarms.length, (secondIndex) {
                    return Column(children: [
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            StyledText(
                                text:
                                    "<date>${falarms[secondIndex]["date"].split(" ")[0]}</date>  <time>${falarms[secondIndex]["date"].split(" ")[1].split(".")[0]}</time>",
                                tags: {
                                  "date": StyledTextTag(
                                      style: GoogleFonts.lato(
                                          fontWeight: FontWeight.bold)),
                                  "time":
                                      StyledTextTag(style: GoogleFonts.lato())
                                }),
                            GestureDetector(

                                onTap: () {
                                  cancelAlarmById(
                                          falarms[secondIndex]["alarm_id"])
                                      .whenComplete(() {


                                    falarms.removeAt(secondIndex);

                                    UpdateAlarms(Datas[index]["ID"], falarms)
                                        .whenComplete(() {
                                      alarmData = json.encode(falarms);
                                      if (alarms.length == 0) {
                                        RemoveFromAlarms(Datas[index]["ID"])
                                            .whenComplete(
                                                () => Navigator.pop(context));
                                      }
                                      _counter.value += 1;
                                    });
                                  });
                                },
                                child: Icon(Icons.close)),
                          ]),
                      Divider(
                        height: 20,
                      ),
//        SizedBox(height:20),
                    ]);
                  })),
                ),
              );
            },
          );
        });
  }

  GestureDetector listItem_todo(Id, int index) {
    List TodosItem = json.decode(Datas[index]["Todos"]);

    Color AvatarColor = DataBaseColorDetector(Datas[index]["AvatarColor"]);

    return GestureDetector(
      onTap: () {
        showTodoManagerSetting(index,Datas);
      },
      child: Container(
          child: ListTile(
        subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children:TodosItem.length>0? List.generate(
                TodosItem.length >= 7 ? 7 : TodosItem.length, (secondIndex) {
              return Padding(
                padding: EdgeInsets.only(
                    bottom: secondIndex == TodosItem.length - 1 ? 10.0 : 0),
                child: Row(children: [
                  Container(
                      width: 5,
                      height: 5,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.blue,
                      )),
                  SizedBox(width: 5),
                  StyledText(
                    text:
                        "<title>${handleOverFlow(TodosItem[secondIndex]["Title"], 8)}</title>  <description>${handleOverFlow(TodosItem[secondIndex]["Description"], 13)}</description>",
                    tags: {
                      'title': StyledTextTag(
                          style: TextStyle(
                        color: ThemeColors["abbrTodosForeGroundColor"],
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      )),
                      'description': StyledTextTag(
                          style: TextStyle(
                              fontSize: 15,
                              color: ThemeColors["abbrTodosForeGroundColor"]))
                    },
                  ),
                  Visibility(
                    visible: secondIndex == TodosItem.length - 1 ? true : false,
                    child: Expanded(
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                          Text(
                            Datas[index]['Date'],
                            style: TextStyle(fontSize: 12,color:ThemeColors["dateColor"]),
                          ),
                        ])),
                  )
                ]),
              );
            }):[
              Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      Datas[index]['Date'],
                      style: TextStyle(fontSize: 12,color:ThemeColors["dateColor"]),
                    ),
                  ])

            ]),
        title: Row(children: [
          GestureDetector(
              onTap: () {
                PickColorDialog(Ids[index]);
              },
              child: CircleAvatar(backgroundColor: AvatarColor, radius: 10)),
          SizedBox(width: 5),
          Text(
              Datas[index]['Title'] == ""
                  ? "Untitled todo"
                  : handleOverFlow(Datas[index]['Title'],15),
              style: GoogleFonts.lato(
                  color: ThemeColors["listModeTitleColor"], fontSize: 23)),
          Expanded(
              child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
            Visibility(
              visible: Datas[index]["isAlarmed"] == 1 ? true : false,
              child: GestureDetector(
                onTap:(){
                  print("DFs");
                  showAlarmsManagerDialog(index, Datas);

                },
                child: Container(
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Text("Alarmed",
                        style: TextStyle(
                            color: ThemeColors["fabForeGroundColor"],
                            fontSize: 10,
                            fontWeight: FontWeight.bold)),
                  ),
                  decoration: BoxDecoration(
                      color: ThemeColors["fabBackGroundColor"],
                      borderRadius: BorderRadius.circular(20)),
                ),
              ),
            ),
            Icon(Icons.checklist,color: ThemeColors["titleColor"]),
            IconButton(
              onPressed: () {
                setState(() async {
                  if (Datas[index]["isFavorite"] == 0)
                    AddToFavorites(Datas[index]["ID"]);
                  else
                    RemoveFromFavorites(Datas[index]["ID"]);
                });
              },
              splashRadius: 15,
              icon: Datas[index]["isFavorite"] == 0
                  ? Icon(Icons.favorite_border,
                      size: 20,
                      color: ThemeColors["favoriteIconUnfilledBorderColor"])
                  : Icon(
                      Icons.favorite,
                      size: 20,
                      color: ThemeColors["favoriteIconFilledColor"],
                    ),
            ),
          ]))
        ]),
      )),
    );
  }

  Container listItem_locked(Id, index) {
    return Container(
      color: ThemeColors["lockedCardBackGroundColor"],
      child: ListTile(
        onTap: () {
          _UnlockNotePasswordDialog(context, Id);
        },
        title: Row(children: [
          Text("Locked",
              style: GoogleFonts.actor(
                  color: ThemeColors["lockedCardForeGroundColor"],
                  fontSize: 23)),
          SizedBox(width: 10),
          Icon(Icons.lock_outline,
              color: ThemeColors["lockedCardForeGroundColor"])
        ]),
      ),
    );
  }

  ListTile listItem(Id, index) {
    Color AvatarColor = DataBaseColorDetector(Datas[index]["AvatarColor"]);
    return ListTile(
//              onLongPress: () {
//                Datas[index]['isLocked'] == 1
//                    ? _UnlockNotePasswordDialog(context, Id)
//                    : _showMyDialog(
//                        context,
//                        Id,
//                      );
//              },
      onTap: () {
        Datas[index]['isLocked'] == 1
            ? _UnlockNotePasswordDialog(context, Id)
            : Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => edn.EditNotes(true, Id)));
      },
      tileColor: ThemeColors["fabColor"],
      //shape: RoundedRectangleBorder(borderRadius:BorderRadius.circular(20) ),

      title: Row(children: [
        GestureDetector(
            onTap: () {
              PickColorDialog(Ids[index]);
            },
            child: CircleAvatar(backgroundColor: AvatarColor, radius: 10)),
        SizedBox(width: 5),
        Text(
            Datas[index]['Title'] == ""
                ? "Untitled"
                : handleOverFlow(Datas[index]['Title'], 20),
            style: GoogleFonts.actor(
              fontSize: 23,
              color: widget.ThemeColors["listModeTitleColor"],
            )),
        Expanded(
            child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
          Visibility(
            visible: Datas[index]["isAlarmed"] == 1 ? true : false,
            child: GestureDetector(
              onTap:(){
                showAlarmsManagerDialog(index, Datas);

              },
              child: Container(
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Text("Alarmed",
                      style: TextStyle(
                          color: ThemeColors["fabForeGroundColor"],
                          fontSize: 10,
                          fontWeight: FontWeight.bold)),
                ),
                decoration: BoxDecoration(
                    color: ThemeColors["fabBackGroundColor"],
                    borderRadius: BorderRadius.circular(20)),
              ),
            ),
          ),
          IconButton(
            onPressed: () {
              setState(() async {
                if (Datas[index]["isFavorite"] == 0)
                  AddToFavorites(Datas[index]["ID"]);
                else
                  RemoveFromFavorites(Datas[index]["ID"]);
              });
            },
            splashRadius: 15,
            icon: Datas[index]["isFavorite"] == 0
                ? Icon(Icons.favorite_border,
                    size: 20,
                    color: ThemeColors["favoriteIconUnfilledBorderColor"])
                : Icon(
                    Icons.favorite,
                    size: 20,
                    color: ThemeColors["favoriteIconFilledColor"],
                  ),
          ),
        ]))
      ]),

      subtitle: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
        Container(
            width: 175,
            child: Text(
              handleOverFlow(Datas[index]['NoteBody'].trim(), 50)
              ,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.actor(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: ThemeColors["abbrTodosForeGroundColor"]),
            )),
        Expanded(
            child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
          Text(
            Datas[index]['Date'],
            style: TextStyle(fontSize: 12,color:ThemeColors["dateColor"]),
          ),
        ]))
      ]),
    );
  }

  DropdownButton ShowListSortMode() {
    return DropdownButton(
      dropdownColor: ThemeColors["backGroundColor"],
        isDense: true,
        value: SortDropDefaultItem,
        icon: const Icon(Icons.sort),
        iconSize: 24,
        underline: Container(
          height: 0,
          color: Colors.transparent,
        ),
        items: [
          'A to Z',
          'Z to A',
          'date',
          'favorites',
          'alarms',
          'todos',
          'notes',
          'title',
          'untitle'
        ].map((String value) {
          return DropdownMenuItem(
            value: value,
            child: Text(value,
                style: GoogleFonts.actor(
                  color: ThemeColors["showModeTextColor"],
                )),
            onTap: () {
              SortDropDefaultItem = value;
              setState(() {
                filter = value;
              });
            },
          );
        }).toList(),
        onChanged: (e) {});
  }

  DropdownButton ShowListMode() {
    return DropdownButton(dropdownColor: ThemeColors["backGroundColor"],
        isDense: true,
        value: DropDefaultItem,
        icon:
            Icon(Icons.arrow_downward, color: ThemeColors["showModeIconColor"]),
        iconSize: 24,
        underline: Container(
          height: 2,
          color: ThemeColors["showModeTileColor"],
        ),
        items: ['Grid', 'List'].map((String value) {
          return DropdownMenuItem(
            value: value,
            child: Text(value,
                style: GoogleFonts.actor(
                  color: ThemeColors["showModeTextColor"],
                )),
            onTap: () {
              switch (value) {
                case "List":
                  setState(() {
                    NoteList_is_Card = true;
                    DropDefaultItem = "List";
                  });

                  break;
                case "Grid":
                  setState(() {
                    NoteList_is_Card = false;
                    DropDefaultItem = "Grid";
                  });

                  break;
              }
            },
          );
        }).toList(),
        onChanged: (e) {});
  }

  Future _LockNotePasswordDialog(
    context,
    Id,
  ) async {
    String warning = "";

    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) {
          return StatefulBuilder(builder: (context, StateSetter setState) {
            return AlertDialog(
              backgroundColor: ThemeColors["dialogsBackGroundColor"],
              title: Text("Set password", style: GoogleFonts.lato()),
              titlePadding: EdgeInsets.only(top: 8, left: 8, bottom: 8),
              contentPadding: EdgeInsets.zero,
              content: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8.0),
                        child: Column(children: [
                          TextField(
                            controller: _PasswordController,
                            keyboardType: TextInputType.visiblePassword,
                            obscureText: true,
                            cursorColor: Colors.white,
                            style: GoogleFonts.lato(color: Colors.black),
                            decoration: InputDecoration(hintText: "Password"),
                            textAlign: TextAlign.left,
                          ),
                          TextField(
                            controller: _Re_PasswordController,
                            obscureText: true,
                            keyboardType: TextInputType.visiblePassword,
                            cursorColor: Colors.white,
                            style: GoogleFonts.lato(color: Colors.black),
                            decoration:
                                InputDecoration(hintText: "Re-Password"),
                            textAlign: TextAlign.left,
                          ),
                        ])),
                    SizedBox(height: 15),
                    Visibility(
                        visible: warning.trim().length > 0 ? true : false,
                        child: Center(
                            child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text(warning,
                              style: GoogleFonts.lato(
                                color: Colors.red,
                                fontSize: 11,
                              )),
                        ))),
                    SizedBox(height: 15),
                    Container(
                      width: double.infinity,
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Flexible(
                                fit: FlexFit.tight,
                                flex: 1,
                                child: TextButton(
                                    onPressed: () {},
                                    style: ButtonStyle(
                                        backgroundColor:
                                            MaterialStateColor.resolveWith(
                                                (states) =>
                                                    Colors.transparent)),
                                    child: Text("Cancel",
                                        style: GoogleFonts.lato(
                                            fontSize: 18,
                                            color: Colors.black)))),
                            SizedBox(width: 20),
                            Flexible(
                              flex: 1,
                              fit: FlexFit.tight,
                              child: TextButton(
                                style: ButtonStyle(
                                  backgroundColor: MaterialStateColor
                                      .resolveWith((states) => ThemeColors[
                                          "lockDialog-un-LockBackGroundColor"]),
                                  overlayColor: MaterialStateColor.resolveWith(
                                      (states) => Colors.transparent),
                                ),
                                onPressed: () {
                                  if (_PasswordController.text.length >= 4) {
                                    if (_PasswordController.text.trim() ==
                                        _Re_PasswordController.text.trim()) {
                                      Lock(Id, _PasswordController.text);
                                      Navigator.pop(context);
                                    } else {
                                      warning = "Re-Enter is incorrect";

                                      setState(() {});
                                    }
                                  } else {
                                    warning =
                                        "passwords must contain at least four characters";
                                    setState(() {});
                                  }
                                },
                                child: Text(
                                  "Lock",
                                  style: GoogleFonts.lato(
                                      color: ThemeColors[
                                          "lockDialog-un-LockForeGroundColor"],
                                      fontSize: 18),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
              //actions: [],
            );
          });
        });
  }

  Future _UnlockNotePasswordDialog(context, Id) async {
    _PasswordController.text = '';
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) {
          return AlertDialog(
            backgroundColor: ThemeColors["dialogsBackGroundColor"],
            contentPadding: EdgeInsets.zero,
            content: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: TextField(
                      obscureText: true,
                      controller: _PasswordController,
                      style: GoogleFonts.lato(),
                      decoration: InputDecoration(hintText: "Password"),
                      textAlign: TextAlign.left,
                    ),
                  ),
                  Visibility(
                      visible: isVisible,
                      child: Text("Password is wrong",
                          style: TextStyle(color: Colors.red, fontSize: 15))),
                  SizedBox(height: 15),
                  Container(
                      width: double.infinity,
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10.0),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Flexible(
                                fit: FlexFit.tight,
                                flex: 1,
                                child: TextButton(
                                  style: ButtonStyle(
                                    overlayColor:
                                        MaterialStateColor.resolveWith(
                                            (states) => Colors.transparent),
                                  ),
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: Text(
                                    "Cancel",
                                    style: GoogleFonts.lato(
                                        color: Colors.black, fontSize: 18),
                                  ),
                                ),
                              ),
                              Flexible(
                                fit: FlexFit.tight,
                                flex: 1,
                                child: TextButton(
                                  style: ButtonStyle(
                                    backgroundColor:
                                        MaterialStateColor.resolveWith(
                                            (states) => Colors.black),
                                    overlayColor:
                                        MaterialStateColor.resolveWith(
                                            (states) => Colors.transparent),
                                  ),
                                  onPressed: () {
                                    Unlock(Id, _PasswordController.text)
                                        .then((passIsCorrect) async {
                                      if (passIsCorrect == true) {
                                        var path = await getDatabasesPath() +
                                            "/NoteDBS.db3";
                                        var db = await openDatabase(path);
                                        await db
                                            .rawUpdate(
                                                "UPDATE NoteData SET isLocked=0 WHERE id=$Id")
                                            .whenComplete(
                                                () => Navigator.pop(context));
                                      } else {
                                        // Check if the device can vibrate
                                        Vibration();
                                        isVisible = false;
                                      }
                                    });
                                  },
                                  child: Text(
                                    "Unlock",
                                    style: GoogleFonts.actor(
                                        color: Colors.white, fontSize: 18),
                                  ),
                                ),
                              ),
                            ]),
                      )),
                ],
              ),
            ),
            //actions: [],
          );
        });
  }




  Padding AddColor(Color color, Id) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 3),
      child: GestureDetector(
        onTap: () {
          setAvatarColor(Id, color).whenComplete(() =>           Navigator.pop(context)
          );
        },
        child: CircleAvatar(
          backgroundColor: color,
          radius: 14,
          child: CircleAvatar(
            backgroundColor: Colors.white,
            radius: 13,
            child: CircleAvatar(
              backgroundColor: color,
              radius: 12,
            ),
          ),
        ),
      ),
    );
  }

  showTodoManagerSetting(int index,List Datas) {
    List TodosItem = json.decode(Datas[index]["Todos"]);
    print(TodosItem);

    return showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(
            builder: (context, StateSetter setState) {
              return AlertDialog(
                  contentPadding: EdgeInsets.zero,
                  titlePadding: EdgeInsets.only(
                    top: 8,
                    left: 8,
                  ),
                  title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                            Datas[index]["Title"].trim() == ""
                                ? "Untitled"
                                : handleOverFlow(Datas[index]["Title"].trim(),15),
                            style: GoogleFonts.lato()),
                        IconButton(
                          icon: Icon(Icons.arrow_forward),
                          onPressed: () {
                            Navigator.pop(context);

                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        td.TodoManager(Datas[index]["ID"])));
                          },
                        )
                      ]),
                  content: SingleChildScrollView(
                      physics: BouncingScrollPhysics(),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children:
                              List.generate(TodosItem.length, (indexSecond) {
                            bool isChecked =
                                TodosItem[indexSecond]["isChecked"];

                            return Visibility(
                              visible: TodosItem[indexSecond]["Title"].trim() ==
                                          "" &&
                                      TodosItem[indexSecond]["Description"]
                                              .trim() ==
                                          ""
                                  ? false
                                  : true,
                              child: GestureDetector(
                                child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      CustomCheckBox(
                                        value: isChecked,
                                        shouldShowBorder: true,
                                        checkedIcon: Icons.check,
                                        borderColor: Colors.black54,
                                        checkedFillColor: Colors.black,
                                        borderRadius: 2,
                                        borderWidth: 1,
                                        tooltip: "activity done",
                                        checkBoxSize: 15,
                                        onChanged: (val) {
                                          TodosItem[indexSecond]["isChecked"] =
                                              val;
                                          String tds = json.encode(TodosItem);

                                          SaveChanges("", Datas[index]["Title"],
                                              Datas[index]["ID"], "", tds);

                                          //do your stuff here
                                          setState(() {});
                                        },
                                      ),
                                      TodosItem[indexSecond]["Title"].trim() ==
                                                  "" &&
                                              TodosItem[indexSecond]
                                                          ["Description"]
                                                      .trim() !=
                                                  ""
                                          ? StyledText(
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                  decoration: isChecked
                                                      ? TextDecoration
                                                          .lineThrough
                                                      : TextDecoration.none),
                                              text:
                                                  "<description>${handleOverFlow(TodosItem[indexSecond]["Description"], 15).trim()}</description>",
                                              tags: {
                                                  "description": StyledTextTag(
                                                      style: TextStyle(
                                                    color: ThemeColors[
                                                        "abbrTodosForeGroundColor"],
                                                  )),
                                                })
                                          : StyledText(
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                  decoration: isChecked
                                                      ? TextDecoration
                                                          .lineThrough
                                                      : TextDecoration.none),
                                              text:
                                                  "<title>${handleOverFlow(TodosItem[indexSecond]["Title"], 15).trim()}</title>",
                                              tags: {
                                                  "title": StyledTextTag(
                                                      style: TextStyle(
                                                    color: ThemeColors[
                                                        "abbrTodosForeGroundColor"],
                                                    fontWeight: FontWeight.bold,
                                                  )),
                                                }),
                                    ]),
                              ),
                            );
                          }))));
            },
          );
        });
  }

  PickColorDialog(Id) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
              content: SingleChildScrollView(
                  child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              AddColor(Colors.black87, Id),
              AddColor(HexColor("0C4FF1"), Id),
              AddColor(Colors.green, Id),
              AddColor(Colors.red, Id),
              AddColor(Colors.yellow, Id),
              AddColor(Colors.orange, Id),
            ],
          )));
        });
  }




  Future AddToCategoryDialog(index, [categories]) async {
    categories = [];

    drawer.readCategoriesFromSharedPref().then((value) {
      categories = value;
    }).whenComplete(() => setState(() {}));
    return showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(backgroundColor: ThemeColors["dialogsBackGroundColor"],
                contentPadding:
                    EdgeInsets.only(left: 10, right: 10, top: 20, bottom: 10),
                titlePadding: EdgeInsets.only(
                  top: 8,
                  left: 8,
                ),
                title: Text("Categories", style: GoogleFonts.lato(color:ThemeColors["dialogsForeGroundColor"])),
                content: SingleChildScrollView(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children:
                            List.generate(categories.length, (secondIndex) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  AddToCategory(Datas[index]["ID"],
                                          categories[secondIndex])
                                      .whenComplete(() {
                                    Navigator.pop(context);
                                  });
                                },
                                child: StyledText(
                                    text:
                                        "<categoryName>${categories[secondIndex]}<categoryName/>",
                                    tags: {
                                      "categoryName": StyledTextTag(
                                          style: GoogleFonts.lato(color:ThemeColors["dialogsForeGroundColor"]))
                                    }),
                              ),
                              Divider(color: ThemeColors["dialogsForeGroundColor"],),
                            ],
                          );
                        }))));
          });
        });
  }

  finaAllCategories() {
    List categories = [];
    Datas.forEach((element) {
      if (element["inCategory"] == 1 &&
          !categories.contains(element["CategoryName"])) {
        categories.add(element["CategoryName"]);
      }
    });

    return categories;
  }

  TextButton AddOptionToDialog(icon, text, job,
      [Color color = Colors.black54]) {
    return TextButton.icon(
      icon: Icon(
        icon,
        color: color,
      ),
      label: Text(
        text,
        style: TextStyle(color: Colors.black, fontSize: 18),
      ),
      onPressed: () {
        job();
      },
    );
  }

  Vibration() async {
    bool canVibrate = await Vibrate.canVibrate;
    Vibrate.vibrate();
  }
}



List filter_by_favorites(List datas) {
  List f = [];
  datas.forEach((item) {
    if (item["isFavorite"] == 1) {
      f.add(item);
    }
  });
  return f;
}

List filter_by_category(List datas, String name) {
  List f = [];
  datas.forEach((item) {
    if (item["CategoryName"] == name) {
      f.add(item);
    }
  });
  return f;
}

List filter_by_not_in_trash(List datas){
  List f = [];
  datas.forEach((item) {
    if (item["inTrash"] == 0) {
      f.add(item);
    }
  });
  return f;
}

List filter_by_alarms(List datas) {
  List f = [];
  datas.forEach((item) {
    if (item["isAlarmed"] == 1) {
      f.add(item);
    }
  });
  return f;
}

List filter_by_todos(List datas) {
  List f = [];
  datas.forEach((item) {
    if (item["isTodo"] == 1) {
      f.add(item);
    }
  });
  return f;
}

List filter_by_titles(List datas) {
  List f = [];
  datas.forEach((item) {
    if (item["Title"].length!= 0) {
      f.add(item);
    }
  });
  return f;
}


List filter_by_unTitles(List datas) {
  List f = [];
  datas.forEach((item) {
    if (item["Title"].length== 0) {
      f.add(item);
    }
  });
  return f;
}
List filter_by_notes(List datas) {
  List f = [];
  datas.forEach((item) {
    if (item["isTodo"] == 0) {
      f.add(item);
    }
  });
  return f;
}

List filter_by_alphabet_decending(List datas) {
  List f = [];
  datas.forEach((item) {
    f.add(item);
  });

  f.sort((a, b) => b["Title"].compareTo(a["Title"]));
  return f;
}

List filter_by_alphabet_ascending(List datas) {
  List f = [];
  datas.forEach((item) {
    f.add(item);
  });

  f.sort((a, b) => a["Title"].compareTo(b["Title"]));
  return f;
}

//PdfSettings(pdf) {
//  pdf.addPage(pw.Page(
//      pageFormat: PdfPageFormat.a4,
//      build: (pw.Context context) {
//        return pw.Column(
//            children: [pw.Text("wsd"), pw.Checkbox(name: "as", value: true)]);
//      }));
//}

PermissionsRequest() {
  Permission.storage.request();
  Permission.accessMediaLocation.request();
  Permission.manageExternalStorage.request();
}

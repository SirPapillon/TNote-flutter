import 'dart:convert';

import 'package:clever/NotesList.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:styled_text/styled_text.dart';
import 'Activities/Backup_Restore.dart';
import 'Activities/Trash.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'DataBaseMa.dart';
import 'NotesList.dart' as nl;
import 'main.dart';
import 'Activities/ImportSettings.dart';

class showDrawer extends StatefulWidget {
  var appearance;
  var currentCategoryName;

  showDrawer(this.appearance,[this.currentCategoryName=null]);

  @override
  _showDrawerState createState() => _showDrawerState();
}

class _showDrawerState extends State<showDrawer> {

  List categories = [];

  @override
  Widget build(BuildContext context) {

    catName=widget.currentCategoryName;

    readCategoriesFromSharedPref().then((categ) {
      categories = categ;
      setState(() {});
    });
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Drawer(
        elevation: 10,
        child: Container(
          decoration:BoxDecoration( color: widget.appearance["drawerBackGroundColor"],),


          //color: HexColor("3C4FF1"),
          child: ListView(
            physics: BouncingScrollPhysics()
            ,padding: EdgeInsets.zero,
            children: [Column(children: [
              Row(
                children: [

                ],
              ),
              SizedBox(height: 30),
              GestureDetector(
                onTap: () {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MyApp(widget.appearance),
                      ));
                },
                child: Row(children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.0),
                    child: Icon(Icons.note_outlined,                        color: widget.appearance["drawerForeGroundColor"],
                    ),
                  ),
                  SizedBox(width: 10),
                  Text("All Notes",
                      style: GoogleFonts.lato(
                          color: widget.appearance["drawerForeGroundColor"],
                          fontSize: 18,
                          fontWeight: FontWeight.bold))
                ]),
              ),
              SizedBox(height: 20),
              GestureDetector(
                onTap:(){Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            showBackup_Restore()));},
                child: Row(children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.0),
                    child: Icon(Icons.backup_outlined,                        color: widget.appearance["drawerForeGroundColor"],
                    ),
                  ),
                  SizedBox(width: 10),
                  Text("Create\\Restore Backup",
                      style: GoogleFonts.lato(
                          color: widget.appearance["drawerForeGroundColor"],
                          fontSize: 18,
                          fontWeight: FontWeight.bold))
                ]),
              ),
              SizedBox(height: 20),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              showImportSettingsActivity(widget.appearance)));
                },
                child: Row(children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.0),
                    child: Icon(Icons.import_export_outlined,                        color: widget.appearance["drawerForeGroundColor"],
                    ),
                  ),
                  SizedBox(width: 10),
                  Text("Import\\Export Settings",
                      style: GoogleFonts.lato(
                          color: widget.appearance["drawerForeGroundColor"],
                          fontSize: 18,
                          fontWeight: FontWeight.bold))
                ]),
              ),
              SizedBox(height: 20),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => showTrash(widget.appearance)));
                },
                child: Row(children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.0),
                    child: Icon(Icons.delete_outlined,                        color: widget.appearance["drawerForeGroundColor"],
                    ),
                  ),
                  SizedBox(width: 10),
                  Text("Trash",
                      style: GoogleFonts.lato(
                          color: widget.appearance["drawerForeGroundColor"],
                          fontSize: 18,
                          fontWeight: FontWeight.bold))
                ]),
              ),
              SizedBox(height: 15),
              Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
                Container(color: widget.appearance["drawerCategoryNameForeGroundColor"], height: 1, width: 100),
                Text("Categories",
                    style: GoogleFonts.lato(
                        color: widget.appearance["drawerCategoryNameForeGroundColor"],
                        fontSize: 13,
                        fontWeight: FontWeight.bold)),
                Container(color: widget.appearance["drawerCategoryNameForeGroundColor"], height: 1, width: 100),
              ]),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: List.generate(categories.length, (index) {
                  return Padding(
                    padding:
                        const EdgeInsets.only(left: 8.0, top: 8, bottom: 8),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => MyApp(
                                        widget.appearance, categories[index]),
                                  ));
                            },
                            child: Row(
                              children: [
                                Text(
                                 handleOverFlow(categories[index],15),
                                  style: GoogleFonts.actor(
                                    color:widget.appearance["drawerCategoryNameForeGroundColor"],
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold),
                                ),
                                Expanded(
                                  child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        GestureDetector(
                                            onTap: () {
                                              showCategoryDialog(index);
                                            },
                                            child: Icon(Icons.edit_outlined,
                                                color: widget.appearance["drawerCategoryIconColor"])),
                                        SizedBox(width: 10),
                                        GestureDetector(
                                            onTap: () {

                                              removeCategoryDialog(index);

                                              setState(() {});
                                            },
                                            child: Icon(Icons.clear_outlined,
                                                color:widget.appearance["drawerCategoryIconColor"])),
                                      ]),
                                )
                              ],
                            ),
                          ),
                          Divider(height: 0, color: Colors.black12),
                        ]),
                  );
                }),
              ),
              TextButton(
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.resolveWith(
                          (s) => Colors.black54)),
                  onPressed: () {
                    showCategoryDialog();
                  },
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.add, color: Colors.white),
                        Text("New Category",
                            style: GoogleFonts.lato(
                                color: Colors.white,
                                fontWeight: FontWeight.bold))
                      ]))
            ])],
          ),
        ),
      ),
    );
  }

  showCategoryDialog([index = null]) {
    final categoryFieldController = TextEditingController();
    if (index != null) {
      categoryFieldController.text = categories[index];
    }
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: widget.appearance["dialogsBackGroundColor"],
              titlePadding: EdgeInsets.only(top: 8, left: 8, bottom: 8),
              contentPadding: EdgeInsets.zero,
              title: Text(index == null ? "New Category" : "Edit Category"),
              content: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      TextField(
                        keyboardType: TextInputType.visiblePassword,
                        style: GoogleFonts.actor(color:widget.appearance["dialogsForeGroundColor"]),
                        controller: categoryFieldController,
                        decoration: InputDecoration(

                            hintText: "Enter Category Name...",
                            hintStyle: GoogleFonts.actor(color:widget.appearance["dialogsForeGroundColor"])),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Flexible(
                              fit: FlexFit.tight,
                              flex: 1,
                              child: TextButton(
                                style: ButtonStyle(
                                    backgroundColor:
                                        MaterialStateProperty.resolveWith(
                                            (states) => Colors.transparent)),
                                child: Text("Cancel",
                                    style: GoogleFonts.lato(
                                        fontSize: 18, color: Colors.black)),
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                              ),
                            ),
                            SizedBox(width: 20),
                            Flexible(
                              fit: FlexFit.tight,
                              flex: 1,
                              child: TextButton(
                                style: ButtonStyle(
                                    backgroundColor:
                                        MaterialStateProperty.resolveWith(
                                            (states) => Colors.black)),
                                child: Text(
                                  "Add",
                                  style: GoogleFonts.lato(
                                      fontSize: 18, color: Colors.white),
                                ),
                                onPressed: () {
                                  if (index != null) {
if (categoryFieldController.text.trim().length>0) {
  renameCategory(
      index, categoryFieldController.text)
      .whenComplete(() {
    ChangeCategoriesTo(categories[index],
        categoryFieldController.text);
  }).whenComplete(() {
    if (widget.currentCategoryName != null) {
      if (widget.currentCategoryName == categories[index]) {
        widget.currentCategoryName = categoryFieldController.text;
        catName = widget.currentCategoryName;
      }
    }
  });
}
                                  } else {
          if (categoryFieldController.text.trim().length>0) {
            addCategoryToSharedPref(
                categoryFieldController.text);
          }
                                  }
                                  Navigator.pop(context);
                                  setState(() {});
                                },
                              ),
                            ),
                          ])
                    ],
                  ),
                ),
              ));
        });
  }

  removeCategoryDialog(index) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(

            titlePadding: EdgeInsets.only(top: 8, left: 8, bottom: 8),
            contentPadding: EdgeInsets.only(left:5,right:5,),
            title: Text("Remove Content ?", style: GoogleFonts.lato()),
            content: SingleChildScrollView(
                child: Column(children: [
              SizedBox(height: 10),
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [

                Flexible(
                    flex: 1,
                    fit:FlexFit.tight,
                    child: TextButton(
                        child: Text("Cancel", style: GoogleFonts.lato(color:Colors.black)),
                        onPressed: () {
                          Navigator.pop(context);
                        })),
                Flexible(
                    fit:FlexFit.tight,

                    flex: 1,
                    child: TextButton(

                        child: Text("No", style: GoogleFonts.lato(color:Colors.black)),
                        onPressed: () {
                          Navigator.pop(context);
                          AddToCategoryDialog(index);
                        })),
                Flexible(
                    fit:FlexFit.tight,

                    flex: 1,
                    child: TextButton(
                      style:ButtonStyle(
                        backgroundColor:MaterialStateProperty.resolveWith((s)=>Colors.black)
                      ),
                        child: Text("yes", style: GoogleFonts.lato(color:Colors.white)),
                        onPressed: () {
                          DeleteAcategoryContents(categories[index]).whenComplete(() => removeFromCategories(categories[index])).whenComplete(() {
                            if (widget.currentCategoryName==categories[index]){
                              catName=null;
                            widget.currentCategoryName=catName;
                            }
                            Navigator.pop(context);
                          });
                        })),

              ])
            ])),
          );
        });
  }

  Future  AddToCategoryDialog(index,[categories])async{

String categorySource="";
    readCategoriesFromSharedPref().then((value){

      categories=value;
      categorySource=categories[index];
      categories.removeAt(index);


    }).whenComplete(() => setState((){}));

    return showDialog(
        context:context,
        builder:(context){
          return StatefulBuilder(builder: (BuildContext context, StateSetter setState){
            return AlertDialog(
                contentPadding: EdgeInsets.only(left:10,right:10,top:20,bottom:10),
                titlePadding: EdgeInsets.only(
                  top: 8,
                  left: 8,
                ),
                title:Text("Categories",style:GoogleFonts.lato()),
                content:SingleChildScrollView(
                    child:Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children:List.generate(categories.length,(secondIndex){

                          return Column(                  crossAxisAlignment: CrossAxisAlignment.start,

                            children: [
                              GestureDetector(
                                onTap:(){



                                    AppendCategoryToAnother(categorySource,
                                        categories[secondIndex])
                                        .whenComplete(() =>
                                        removeFromCategories(categorySource)).whenComplete(() {

                                      if (widget.currentCategoryName==categorySource){
                                        catName=null;
                                        widget.currentCategoryName=catName;
                                      }
                                      Navigator.pop(context);
                                    });

                                },
                                child: StyledText(
                                    text:"<categoryName>${categories[secondIndex]}<categoryName/>",
                                    tags:{
                                      "categoryName":StyledTextTag(style:GoogleFonts.lato())
                                    }
                                ),
                              ),
                              Divider(),
                            ],
                          );


                        }

                        ))
                )
            );
          }) ;
        }
    );
  }
}




Future removeFromCategories(catS) async {
  readCategoriesFromSharedPref().then((categories) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    categories.remove(catS);

    prefs.setString("categories", json.encode(categories));
  });
}

Future readCategoriesFromSharedPref() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var categories = prefs.getString("categories");
  if (categories == null) {
    return [];
  } else {
    return json.decode(categories);
  }
}

Future renameCategory(index, name) async {
  readCategoriesFromSharedPref().then((categories) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    categories[index] = name;

    prefs.setString("categories", json.encode(categories));
  });
}

Future addCategoryToSharedPref(String name) async {
  readCategoriesFromSharedPref().then((categories) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (!categories.contains(name)) {
      categories.add(name);
      prefs.setString("categories", json.encode(categories));
    }
  });
}

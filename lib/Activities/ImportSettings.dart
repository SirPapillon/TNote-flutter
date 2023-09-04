import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:filesystem_picker/filesystem_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import "Themes.dart" as tm;
import '../main.dart';

class showImportSettingsActivity extends StatefulWidget {
  var appearance;

  showImportSettingsActivity(this.appearance);

  @override
  _showImportSettingsActivityState createState() =>
      _showImportSettingsActivityState();
}

class _showImportSettingsActivityState
    extends State<showImportSettingsActivity> {
  bool settingsImported = false;
  late int theme_index;
  @override
  Widget build(BuildContext context) {


    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
            appBar: AppBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
                actions: [
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        IconButton(
                          icon: Icon(
                            Icons.arrow_back,
                            color: Colors.black,
                          ),
                          onPressed: () {
                            if (settingsImported) {

                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        MyApp(tm.themes[theme_index]),
                                  ));
                            } else {
                              Navigator.pop(context);
                            }
                          },
                        ),
                        Text("Import/Export Settings",
                            style: GoogleFonts.actor(
                                color: Colors.black,
                                fontSize: 18,
                                fontWeight: FontWeight.bold)),
                      ],
                    ),
                  )
                ]),
            body: Column(children: [
              GestureDetector(
                onTap: () {

                  Permission.storage.request();

                  importSettings().then((path) {
                    readSettings(path).then((allSettings) {
                      applySettings(allSettings)
                          .whenComplete(() {settingsImported = true;});
                    });
                  });
                },
                child: Container(
                    margin: EdgeInsets.only(top: 20, left: 10, right: 10),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Import Settings",
                              style: GoogleFonts.lato(
                                  fontSize: 18, fontWeight: FontWeight.bold)),
                          Padding(
                              padding: EdgeInsets.only(
                                top: 5,
                              ),
                              child: Icon(
                                Icons.arrow_forward,
                              ))
                        ])),
              ),
              Divider(),
              GestureDetector(
                onTap: () {
                  Permission.accessMediaLocation.request();
                  Permission.manageExternalStorage.request();
                  findSettings().then((allSettings) {
                    exportSettings().then((path) {
                      saveFile(allSettings, path);
                    });
                  });
                },
                child: Container(
                    margin: EdgeInsets.only(top: 20, left: 10, right: 10),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Export Settings",
                              style: GoogleFonts.lato(
                                  fontSize: 18, fontWeight: FontWeight.bold)),
                          Padding(
                              padding: EdgeInsets.only(
                                top: 5,
                              ),
                              child: Icon(
                                Icons.arrow_forward,
                              ))
                        ])),
              ),
            ])));
  }



  PermissionsRequest() {
    Permission.storage.request();
    Permission.accessMediaLocation.request();
    Permission.manageExternalStorage.request();
  }

  Future saveFile(content, path) async {
    File file = File(path + "settings.txt"); // 1
    file.writeAsString(content); // 2
  }

  Future readSettings(path) async {
    File file = File(path); // 1
    String settings = await file.readAsString(); //
    return json.decode(settings); // 2
  }

  Future applySettings(allSettings) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    allSettings.forEach((key, value) {
      try {
        if (value != null) {
          if (key =="theme_index"){
            theme_index=value;
          }
          switch (value.runtimeType) {
            case int:
              prefs.setInt(key, value);
              break;
            case String:
              prefs.setString(key, value);
              break;

            default:
              prefs.setString(key, json.encode(value));
              break;
          }
        }
      } catch (e) {}
    });
  }

  Map allSettings = {
    "categories": [],
    "sheetColor_index": 0,
    "fontColor_index": 0,
    "fontSettings": [],
    "theme_index": 0
  };

  Future findSettings() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Map allSettings = {
      "categories": [],
      "sheetColor_index": 0,
      "fontColor_index": 0,
      "fontSettings": [],
      "theme_index": 0
    };

    allSettings.forEach((key, value) {
      try {
        var d = prefs.get(key);

        if (d != null) {
          allSettings[key] = d;
        }
      } catch (e) {}
    });

    return json.encode(allSettings);
  }

  Future importSettings() async {
    Directory rootPath = Directory("/storage/emulated/0/");
    String? path = await FilesystemPicker.open(
      title: 'Select Settings File',
      context: context,
      rootDirectory: rootPath,
      fsType: FilesystemType.file,
      allowedExtensions: [".txt"],
      pickText: 'Select',
      folderIconColor: Colors.teal,
    );
    return path;
  }

  Future exportSettings() async {
    Directory rootPath = Directory("/storage/emulated/0/");
    String? path = await FilesystemPicker.open(
      title: 'Save to folder',
      context: context,
      rootDirectory: rootPath,
      fsType: FilesystemType.folder,
      pickText: 'Save file to this folder',
      folderIconColor: Colors.teal,
    );
    return path;
  }
}

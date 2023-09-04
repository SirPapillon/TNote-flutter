import 'dart:convert';
import 'dart:io';

import 'package:filesystem_picker/filesystem_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_string_encryption/flutter_string_encryption.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:styled_text/styled_text.dart';
import '../DataBaseMa.dart';
import '../NotesList.dart';
import 'ImportSettings.dart';

class showBackup_Restore extends StatefulWidget {
  @override
  _showBackup_RestoreState createState() => _showBackup_RestoreState();
}

class _showBackup_RestoreState extends State<showBackup_Restore> {

  String key="EOkgPZZNli4ek9lX3JD5kw==:IVEeHRmk6JdgS3GGvBmBCsS3YpsRFbGBaeLOiP4SsM0=";

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
                          Navigator.pop(context);
                        },
                      ),
                      Text("Backup/Restore Datas", style: GoogleFonts.actor(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.bold)),
                    ],
                  ),
                )
              ]),
          body: Column(
              children: [
                GestureDetector(
                  onTap: () {
                    Permission.accessMediaLocation.request();
                    Permission.manageExternalStorage.request();
//      PermissionsRequest();
                  ReadNotes().then((datas){
                    createBackupDatas().then((path){
                      datas=removeAlarmsFromBackup(datas);
                      encrypt(json.encode(datas)).then((encryptedContent){
                        saveFile(encryptedContent,path);

                      });
                    });
                  },);},
                  child: Container(
                      margin: EdgeInsets.only(top: 20, left: 10, right: 10),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [

                            Text("Create Backup", style: GoogleFonts.lato(
                                fontSize: 18, fontWeight: FontWeight.bold)),

                            Padding(padding: EdgeInsets.only(top: 5,),
                                child: Icon(Icons.arrow_forward,))

                          ]
                      )
                  ),
                ),

                Divider(),

                GestureDetector(
                  onTap: () {
                    Permission.storage.request();

                    restoreDatas().then((path){
  readDatas(path).then((content){
    decrypt(content).then((decryptedContent){
      var decryptrdContent_list=json.decode(decryptedContent);
    organizeContent(decryptrdContent_list).then((organizedDatas){


        showManageRestoreBackupContent(organizedDatas,decryptrdContent_list);

      });
    });


  });
});
                  },
                  child: Container(
                      margin: EdgeInsets.only(top: 20, left: 10, right: 10),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [

                            Text("Restore Backup", style: GoogleFonts.lato(
                                fontSize: 18, fontWeight: FontWeight.bold)),

                            Padding(padding: EdgeInsets.only(top: 5,),
                                child: Icon(Icons.arrow_forward,))

                          ]
                      )
                  ),
                ),
              ]),
        )
    );
  }


  Future addBackupContent(content)async{

    content.forEach((element){
      SaveNote(element["NoteBody"],element["Title"],element["AlarmData"],element["isTodo"],element["Todos"],element["inTrash"],element["inCategory"],element["CategoryName"]);
    });

  }

  Future organizeContent(List content)async{
    Map counter={"Todos":0,"Notes":0,"Categories":[]};

    content.forEach((data){

      if (data["isTodo"]==1){
        counter["Todos"]+=1;
      }
      else{
        counter["Notes"]+=1;
      }

      if(data["CategoryName"]!=null && data["inCategory"]==1){
        counter["Categories"].add(data["CategoryName"]);
      }

      if(data["CategoryName"]!=null && data["inCategory"]==1){
        counter["Categories"].add(data["CategoryName"]);
      }
    });

    return counter;
  }

  showManageRestoreBackupContent(counter,content){
    List allKeys=["Todos","Notes"];
    print(content);
    print(content.runtimeType);


    return showDialog(
      context: context,
      builder: (context){
        return AlertDialog(
          contentPadding:EdgeInsets.only(left:10,right:10,top:20),
          content:SingleChildScrollView(child: Column(
            children: List.generate(allKeys.length, (index) {
              return Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [

Container(width:5,height:5,decoration: BoxDecoration(color:Colors.blue,borderRadius:BorderRadius.circular(5)),),
                      SizedBox(width:5),
                      StyledText(
                        text:"<counter>${counter[allKeys[index]].toString()}</counter>  <key>${allKeys[index]}</key> <founded>Founded</founded>",
                        tags:{
                          "counter":StyledTextTag(style:GoogleFonts.lato(color:Colors.black,fontSize:17,fontWeight:FontWeight.bold)),
                          "key":StyledTextTag(style:GoogleFonts.lato(color:Colors.black,)),
                          "founded":StyledTextTag(style:GoogleFonts.lato(color:Colors.black,)),
                        }
                      )





                    ],
                  ),
                  index==allKeys.length-1?Padding(
                    padding:  EdgeInsets.only(top:15.0),
                    child: Row(mainAxisAlignment:MainAxisAlignment.center,children: [

                      Flexible(
                          flex:1,
                          fit:FlexFit.tight,
                          child:TextButton(
                              style:ButtonStyle(backgroundColor:MaterialStateProperty.resolveWith((s)=>Colors.white)),
                              onPressed:(){
                                Navigator.pop(context);
                              },
                              child:Text("Cancel",style:GoogleFonts.lato(color: Colors.black))
                          )
                      ),
                      Flexible(
                        flex:1,
                        fit:FlexFit.tight,
                        child:TextButton(
                          style:ButtonStyle(backgroundColor:MaterialStateProperty.resolveWith((s)=>Colors.black)),
                          onPressed:(){

                            addBackupContent(content).whenComplete(() => Navigator.pop(context));

                          },
                          child:Text("Add",style:GoogleFonts.lato(color:Colors.white))
                        )
                      ),


                    ],),
                  ):
                  Divider()
                ],
              );
            }),
          )),
        );
      }
    );
  }


  Future readDatas(path)async{
    File file = File(path); // 1
    String settings = await file.readAsString(); //
    return settings;
  }

  Future saveFile(content,path)async{

    File file = File(path+"backup.txt"); // 1
    file.writeAsString(content); // 2


  }

  Future decrypt(content)async {

    try {
      final cryptor = new PlatformStringCryptor();

      final String decrypted = await cryptor.decrypt(content, key);

      return decrypted;

    } on MacMismatchException {
      return null;
      // unable to decrypt (wrong key or forged data)
    }


  }

    Future encrypt(content)async{
    final cryptor = new PlatformStringCryptor();

    final String encryptedContent = await cryptor.encrypt(content, key);

    return encryptedContent;
  }
  Future restoreDatas()async{
    Directory rootPath=Directory("/storage/emulated/0/");
    String? path = await FilesystemPicker.open(
      title: 'Select Backup',
      context: context,
      rootDirectory: rootPath,
      fsType: FilesystemType.file,
      allowedExtensions: [".txt"],
      pickText: 'Select',
      folderIconColor: Colors.teal,
    );
    return path;
  }


  removeAlarmsFromBackup(List content){
    List c=[];


content.forEach((value){
   final data = Map.of(value);

   data["isAlarmed"]=0;
   data["AlarmData"]="[]";
c.add(data);
    });
return c;
  }
  Future createBackupDatas()async{
    Directory rootPath=Directory("/storage/emulated/0/");
    String? path = await FilesystemPicker.open(
      title: 'Create Backup',
      context: context,
      rootDirectory: rootPath,
      fsType: FilesystemType.folder,
      pickText: 'Create',
      folderIconColor: Colors.teal,
    );
    return path;
  }
}
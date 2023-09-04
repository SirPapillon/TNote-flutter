import 'dart:convert';

import 'package:sqflite/sqflite.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:intl/intl.dart';

Future<List> ReadNotes() async {
  var path = await getDatabasesPath() + "/NoteDBS.db3";
  bool dataBaseExist = await File(path).exists();
  if (dataBaseExist == false) {
    var db = await openDatabase(path);
    db.execute(
        "CREATE TABLE IF NOT EXISTS NoteData(ID INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,NoteBody text,Title char(30),Date char(12),isFavorite int,isLocked int,Password char(20),AvatarColor char(20),AlarmData text,isAlarmed int,isTodo int,Todos text,MapCordinations text,inTrash int,inCategory int,CategoryName text)");
    db.close();
  }


  var db = await openDatabase(path);
  var NotesData = await db.rawQuery("SELECT * FROM NoteData");

  return NotesData;
}

Future SaveNote(String NoteBody, Title, [AlarmData, isTodo = 0, Todos,inTrash=false,inCategory=false,CategoryName]) async {
  // Get a location using getDatabasesPath
  GetDate() {
    DateTime today = new DateTime.now();
    String Month = int.parse(today.month.toString().padLeft(2, '0')).toString();
    late String MonthAbbr;
    switch (Month) {
      case ("1"):
        MonthAbbr = "Jan";
        break;
      case ("2"):
        MonthAbbr = "Feb";
        break;
      case ("3"):
        MonthAbbr = "Mar";
        break;
      case ("4"):
        MonthAbbr = "Apr";
        break;
      case ("5"):
        MonthAbbr = "May";
        break;
      case ("6"):
        MonthAbbr = "Jun";
        break;
      case ("7"):
        MonthAbbr = "Jul";
        break;
      case ("8"):
        MonthAbbr = "Aug";
        break;
      case ("9"):
        MonthAbbr = "Sep";
        break;
      case ("10"):
        MonthAbbr = "Oct";
        break;
      case ("11"):
        MonthAbbr = "Nov";
        break;
      case ("12"):
        MonthAbbr = "Dec";
        break;
      default:
    }
    String dateSlug =
        "$MonthAbbr ${today.day.toString().padLeft(2, '0')},${today.year.toString()}";
    return dateSlug;
  }

  var path = await getDatabasesPath() + "/NoteDBS.db3";

  var db = await openDatabase(path);
  String Date = GetDate();
  await db.insert('NoteData', {
    'isLocked': 0,
    'isFavorite': 0,
    'NoteBody': NoteBody,
    'Title': Title,
    'Date': Date,
    'AvatarColor': "black87",
    'AlarmData': AlarmData,
    'isAlarmed': 0,
    'Todos': Todos,
    'inCategory':inCategory,
    'CategoryName':CategoryName,
    'isTodo': isTodo,
    'inTrash':0
  }).whenComplete(() => db.close());
}

Future setAvatarColor(Id, Color) async {
  if (Color == Colors.red) {
    Color = "red";
  } else if (Color == Colors.yellow) {
    Color = "yellow";
  } else if (Color == Colors.orange) {
    Color = "orange";
  } else if (Color == Colors.green) {
    Color = "green";
  } else if (Color == Colors.black87) {
    Color = "black87";
  }
  var path = await getDatabasesPath() + "/NoteDBS.db3";
  var db = await openDatabase(path);

  await db.rawUpdate("UPDATE NoteData SET AvatarColor='$Color' WHERE ID=$Id");
}

FindNextDate(int week_day_index) {
  DateTime date = DateTime.now();
  var week_today_index = date.weekday;
  int re = week_today_index - week_day_index;

  if (re < 0) {
    date = date.add(Duration(days: 6 + re));
  } else if (re > 0) {
    date = date.add(Duration(days: re + 1));
  }
  else{
    date=date.add(Duration(days:7));
  }

  return date;
}

Future AddAlarmToDataBase(
  Id,
  SoundPath,
  VibrateSetting,
  SnoozeSetting,
  Time,
  Title,
  AlarmPGcolor,
  Dates,
) async {

  List cDates = [];
  List cDates_dateType = [];
  bool isRepeater = false;

  void toDate() {
    DateTime date_now = DateTime.parse(DateTime.now().toString().split(" ")[0]);
    late DateTime target_date;


    Dates.forEach((element) {
      String pick_mode="";
      switch (element) {
        case "ch1":
          target_date = date_now.add(Duration(days: 1));

          break;
        case "ch2":
          target_date = date_now.add(Duration(days: 2));

          break;
        case "ch3":
          target_date = date_now.add(Duration(days: 3));
          break;
        case "ch4":
          target_date = date_now.add(Duration(days: 5));
          break;
        case "ch5":
          target_date = date_now.add(Duration(days: 7));
          break;
        case "ch6":
          target_date = date_now.add(Duration(days: 14));
          break;
        case "ch7":
          target_date = date_now.add(Duration(days: 30));
          break;
        case "ch8":
          target_date = date_now.add(Duration(days: 90));
          break;

        case "ch9":
          target_date = FindNextDate(7);

          break;
        case "ch10":
          target_date = FindNextDate(1);
          break;
        case "ch11":
          target_date = FindNextDate(2);
          break;
        case "ch12":
          target_date = FindNextDate(3);
          break;
        case "ch13":
          target_date = FindNextDate(4);
          break;
        case "ch14":
          target_date = FindNextDate(5);
          break;
        case "ch15":
          target_date = FindNextDate(6);
          break;
        default:

          target_date = element;
          element="calendar";
      }


 pick_mode=element;


      String format_date= target_date.toString().split(" ")[0]+" "+Time;
      DateTime tempDate =
          new DateFormat("yyyy-MM-dd HH:mm:ss").parse(format_date);



if(tempDate.isAfter(DateTime.now())) {
  Map temp = {
    "date": tempDate.toString(),
    "pick_mode": pick_mode,
    "isRepeat": isRepeater,
    "alarm_id": ""
  };
  print(tempDate);
  cDates.add(temp);
}
      cDates_dateType.add(tempDate);
    });
  }

  toDate();



  ReadNotes().then((value) {
var targetData;
    value.forEach((data){
      if (data["ID"]==Id){
        targetData=data;
      }
    });
List allDates=[];
    if(targetData["AlarmData"]!=null) {
       allDates = json.decode(targetData["AlarmData"]);
    }
allDates.forEach((element) {
  cDates.add(element);
});
  }).whenComplete(() async{
   
    var path = await getDatabasesPath() + "/NoteDBS.db3";
    var db = await openDatabase(path);
    await db.rawUpdate(
        "UPDATE NoteData SET AlarmData='${json.encode(cDates)}',isAlarmed=1  WHERE ID=$Id");
  });


return cDates_dateType;

}

Future UpdateAlarms(id,  updateDates,[isAlarmed=1]) async {

  var path = await getDatabasesPath() + "/NoteDBS.db3";
  var db = await openDatabase(path);

  if (updateDates.length==0){
    await db.rawUpdate(
        "UPDATE NoteData SET AlarmData='${json.encode(
            updateDates)}',isAlarmed=0  WHERE ID=$id");
  }
else {
    await db.rawUpdate(
        "UPDATE NoteData SET AlarmData='${json.encode(
            updateDates)}',isAlarmed=$isAlarmed  WHERE ID=$id");
  }
}


Future SaveMarkedLocationsOnMap(int id,String MapCordinations)async{
  var path = await getDatabasesPath() + "/NoteDBS.db3";
  var db = await openDatabase(path);

  await db.rawUpdate(
      "UPDATE NoteData SET mapCordinations='$MapCordinations' WHERE ID=$id");
}

Future SaveChanges(NoteBody, Title, Id, Hashtags, [Todos = ""]) async {
  var path = await getDatabasesPath() + "/NoteDBS.db3";
  var db = await openDatabase(path);

  await db.rawUpdate(
      "UPDATE NoteData SET NoteBody='$NoteBody',Title='$Title',Todos='$Todos' WHERE ID=$Id");
}

Future ReadNoteBody(Id) async {
  var path = await getDatabasesPath() + "/NoteDBS.db3";
  var db = await openDatabase(path);

  List<Map> NotesData =
      await db.rawQuery("SELECT * FROM NoteData WHERE id=$Id");

  db.close();
  return NotesData;
}

Future AddToFavorites(Id) async {
  var path = await getDatabasesPath() + "/NoteDBS.db3";
  var db = await openDatabase(path);
  await db.rawUpdate("UPDATE NoteData SET isFavorite=1 WHERE id=$Id");
}
Future RemoveAcategoryContents(Category)async{

  var path = await getDatabasesPath() + "/NoteDBS.db3";
  var db = await openDatabase(path);
  await db.rawUpdate("UPDATE NoteData SET inCategory=0,CategoryName='' WHERE CategoryName='$Category'");

}

Future DeleteAcategoryContents(Category)async{

  var path = await getDatabasesPath() + "/NoteDBS.db3";
  var db = await openDatabase(path);
  await db.rawUpdate("UPDATE NoteData SET inCategory=0,CategoryName='',inTrash=1 WHERE CategoryName='$Category'");

//  await db.rawDelete("DELETE FROM NoteData WHERE CategoryName='$Category'");


}

Future AppendCategoryToAnother(sourceCategory,targetCategory)async{

  print("fredgth");
  var path = await getDatabasesPath() + "/NoteDBS.db3";
  var db = await openDatabase(path);
  await db.rawUpdate("UPDATE NoteData SET inCategory=1,CategoryName='$targetCategory' WHERE CategoryName='$sourceCategory'");

}


Future AddToCategory(Id,name)async{
  var path = await getDatabasesPath() + "/NoteDBS.db3";
  var db = await openDatabase(path);
  await db.rawUpdate("UPDATE NoteData SET inCategory=1,CategoryName='$name' WHERE id=$Id");
}

Future RemoveFromFavorites(Id) async {
  var path = await getDatabasesPath() + "/NoteDBS.db3";
  var db = await openDatabase(path);

  await db.rawUpdate("UPDATE NoteData SET isFavorite=0 WHERE id=$Id");
}

Future RemoveFromAlarms(Id) async {
  var path = await getDatabasesPath() + "/NoteDBS.db3";
  var db = await openDatabase(path);

  await db.rawUpdate("UPDATE NoteData SET isAlarmed=0 WHERE id=$Id");
}

Future Lock(Id, Password) async {
  var path = await getDatabasesPath() + "/NoteDBS.db3";
  var db = await openDatabase(path);

  await db.rawUpdate(
      "UPDATE NoteData SET isLocked=1,Password='$Password' WHERE id=$Id");
  db.close();
}

Future Unlock(Id, Password) async {
  var path = await getDatabasesPath() + "/NoteDBS.db3";
  var db = await openDatabase(path);
  List p = await db.rawQuery("SELECT Password FROM NoteData WHERE Id=$Id");
  if (Password == p[0]['Password']) {
    return true;
  } else {
    return false;
  }
}


Future MoveToTrash(Id)async{


  UpdateAlarms(Id,[]).whenComplete(() async{
    var path = await getDatabasesPath() + "/NoteDBS.db3";
    var db = await openDatabase(path);


    await db.rawUpdate(
        "UPDATE NoteData SET inTrash=1 WHERE id=$Id");
    db.close();
  });



}


Future RemoveFromTrash(Id)async{
  var path = await getDatabasesPath() + "/NoteDBS.db3";
  var db = await openDatabase(path);


  await db.rawUpdate(
      "UPDATE NoteData SET inTrash=0 WHERE id=$Id");
  db.close();

}


Future DeleteItem(Id) async {
  var path = await getDatabasesPath() + "/NoteDBS.db3";
  var db = await openDatabase(path);

  db.rawDelete("DELETE FROM NoteData WHERE Id=$Id");

}




Future ChangeCategoriesTo(name,changeName)async{
  List datas=[];
  ReadNotes().then((value) {
    value.forEach((element) {datas.add(element);});
  }).whenComplete(() async{

    var path = await getDatabasesPath() + "/NoteDBS.db3";
    var db = await openDatabase(path);
    datas.forEach((element) {
      if(element["CategoryName"]==name) {
        db.rawUpdate(
            "UPDATE NoteData SET CategoryName='$changeName' WHERE Id=${element["ID"]}");
      }
    });
  });






//List datas;
//ReadNotes().then((value) {datas=value;return datas;}).then((datas) async{
//
//
//  datas.forEach((data)async{
//    if (data["CategoryName"]==name){
//      print(name);
//      print(changeName);
//     .whenComplete(() => print("one"));
//
//    }
//  });
//});


}

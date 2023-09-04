import 'dart:async';
import 'dart:convert';

import 'DataBaseMa.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import 'package:intl/intl.dart';

int AlarmID = 0;

Future get_dates() async {
  List final_dates = [];
}

Future DateRepeater() async {}

var androidPlatformChannelSpecifics = AndroidNotificationDetails(
    "alarm notif", "alarm notif", "hello",
    sound: RawResourceAndroidNotificationSound('alarm'),
    playSound: true,
    importance: Importance.max,
    priority: Priority.high,
    icon: "hashtag",
    autoCancel: true,
    largeIcon: DrawableResourceAndroidBitmap("hashtag"));

Future showNotification(int id, title, body, schedule,
    [isRepeat = false]) async {
  tz.initializeTimeZones();

  var notificationDetails =
      NotificationDetails(android: androidPlatformChannelSpecifics);

  int year = int.parse(schedule.toString().split(" ")[0].split("-")[0]);
  int month = int.parse(schedule.toString().split(" ")[0].split("-")[1]);
  int day = int.parse(schedule.toString().split(" ")[0].split("-")[2]);
  int hour = int.parse(schedule.toString().split(" ")[1].split(":")[0]);
  int minute = int.parse(schedule.toString().split(" ")[1].split(":")[1]);

  await flutterLocalNotificationsPlugin.zonedSchedule(
    id,
    title,
    body,
    tz.TZDateTime.from(DateTime(year, month, day, hour, minute), tz.local),
    notificationDetails,
    uiLocalNotificationDateInterpretation:
        UILocalNotificationDateInterpretation.absoluteTime,
    androidAllowWhileIdle: true,
  );
  id = id + 1;

//  await flutterLocalNotificationsPlugin.showWeeklyAtDayAndTime(id, title, body, Day(1), Time(14,25), notificationDetails);
}

void findDates(String str) {
  final startIndex = str.indexOf("[");
  final endIndex = str.indexOf("]", startIndex + str.length);
}

Future cancelAlarms() async {
  await flutterLocalNotificationsPlugin.cancelAll();
}

Future cancelAlarmById(
  int alarm_id,
) async {
  await flutterLocalNotificationsPlugin.cancel(alarm_id);
}

Future mainq() async {
  ReadNotes().then((data) {
    int index = 0;
    data.forEach((element) {
      try {
        var dates_slot = json.decode(element["AlarmData"]);

        dates_slot.forEach((date_slot_str) {
          AlarmID = AlarmID + 1;

          DateTime tempDate = new DateFormat("yyyy-MM-dd hh:mm:ss")
              .parse(date_slot_str["date"].trim());

          date_slot_str["alarm_id"] = AlarmID;

          UpdateAlarms(element["ID"], dates_slot).whenComplete(() {
            showNotification(
                AlarmID, element["Title"], element["NoteBody"], tempDate);
          });
        });
      } catch (e) {}
    });
  });
} //DateTime.now()-> 2022-01-29 21:49:53.235772

String y() {
  return "hjasd";
}

disposeAlarms(List content) {
  List F = [];


  content.forEach((element){
    Map J = {};
    List fDates = [];

    if(element["AlarmData"]!=null && element["isTodo"]==0) {

      List dates = json.decode(element["AlarmData"]);


      dates.forEach((element) {
        DateTime tempDate =
        new DateFormat("yyyy-MM-dd hh:mm:ss").parse(element["date"].trim());

        if (tempDate.isAfter(DateTime.now())) {
          fDates.add(element);
          UpdateAlarms(J["ID"], fDates);

        }
        else{
          cancelAlarmById(element["alarm_id"]);
        }
      });

    }
      element.forEach((key, value) {


        J[key] = value;

      });
if(element["isAlarmed"]==1) {
  if (fDates.length == 0) {
    UpdateAlarms(J["ID"], []).whenComplete(() => RemoveFromAlarms(J["ID"]));
  }
  else if(fDates.length!=json.decode(element["AlarmData"]).length){
    UpdateAlarms(J["ID"], fDates);
  }
}




      J["AlarmData"] = json.encode(fDates);
      F.add(J);

  });

  return F;
}

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

//

//Future initializeNotification() async {
//  int id = 0;
//  var scheduledDate = DateTime.now().add(Duration(seconds: t));
//  var androidPlatformChannelSpecifics = AndroidNotificationDetails(
//      "alarm notif", "alarm notif", "hello",
//      sound: RawResourceAndroidNotificationSound('alarm'),
//      playSound: true,
//      importance: Importance.max,
//      priority: Priority.high,
//      icon: "hashtag",
//      largeIcon: DrawableResourceAndroidBitmap("hashtag"));
//
//  var notificationDetails =
//      NotificationDetails(android: androidPlatformChannelSpecifics);
//  await flutterLocalNotificationsPlugin.schedule(
//      id,
//      "office",
//      "goode mornkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkking",
//      scheduledDate,
//      notificationDetails);
//}

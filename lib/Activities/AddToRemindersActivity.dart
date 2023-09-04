import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter/cupertino.dart';

import 'package:flutter/widgets.dart';
import '../DataBaseMa.dart';
import 'package:clever/AlarmManager.dart';
import 'package:styled_text/styled_text.dart';

class AddToReminders extends StatefulWidget {
  String Name;
  int Id;
  var coniguredData;

  AddToReminders(this.Name, this.Id, [this.coniguredData = false]);

  @override
  _AddToRemindersState createState() => _AddToRemindersState();
}

class _AddToRemindersState extends State<AddToReminders> {
  var Time="0:00:00.000000";
  var candidate_calendar_date = null;

  ConvertToList() {
    RegExp output = new RegExp('[(*?),');
  }

  late Container DayPart = iMoon();

  var Calendar_Dates = [];
  var Dates = [];
  var checkedDates = {};
  Color C = Colors.white;
  Color P = Colors.white;
  Color GradientColor1 = Colors.blueGrey;
  Color GradientColor2 = HexColor("00000d");
  Color mShadowColor = Colors.black;
  String songPath = '', songName = 'Jingle Bells';

  @override
  Widget build(BuildContext context) {
    if (widget.coniguredData != false) {
      songPath = widget.coniguredData[0];

      songName = songPath.split('/').last;
    }

    return MaterialApp(
        color: HexColor("212D3B"),
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          backgroundColor: HexColor("FAFAFA"),
          body: Column(children: [
//            Row(mainAxisAlignment:MainAxisAlignment.center ,children:[Text("hour")]),
//            TimePickerSpinner(
//              is24HourMode: false,
//              isShowSeconds: true,
//              normalTextStyle: GoogleFonts.lato(
//                fontSize: 20,
//              ),
//              highlightedTextStyle: GoogleFonts.lato(
//                fontWeight: FontWeight.bold,
//                fontSize: 24,
//              ),
//              spacing: 50,
//              itemHeight: 80,
//              isForce2Digits: true,
//              onTimeChange: (time) {
//                setState(() {});
//              },
//            ),

            Expanded(
                child: Container(
              child: Column(
                children: [
                  PhysicalModel(
                    color: Colors.transparent,
                    elevation: 4,
                    child: Container(
                      decoration: BoxDecoration(
                          gradient: LinearGradient(
                              colors: [GradientColor1, GradientColor2],
                              begin: Alignment.topLeft)),
                      //color: Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 50.0),
                        child: Stack(children: [
                          CupertinoTimerPicker(



                            onTimerDurationChanged: (e) {

                              Time = e.toString();


                              if ((e.inHours <= 23 && e.inHours >= 18) ||
                                  e.inHours < 6) {
                                if (DayPart != iMoon()) {
                                  setState(() {
                                    DayPart = iMoon();
                                    GradientColor1 = Colors.blueGrey;
                                    GradientColor2 = HexColor("00000d");
                                    mShadowColor = Colors.black;
                                  });
                                }
                              } else {
                                if (DayPart != iSun()) {
                                  setState(() {
                                    DayPart = iSun();
                                    GradientColor1 = Colors.yellow;
                                    GradientColor2 =
                                        Colors.yellow.withOpacity(0.4);
                                    mShadowColor = Colors.yellow;
                                  });
                                }
                              }
                            },

                            initialTimerDuration: Duration(minutes: 5),
                            mode: CupertinoTimerPickerMode.hms,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Align(
                                alignment: Alignment.bottomLeft,
                                child: DayPart),
                          ),
                        ]),
                      ),
                    ),
                  ),
//                  Container(
//                    height: 2,
//                    decoration: BoxDecoration(boxShadow: [
//                      BoxShadow(
//                        color: mShadowColor,
//                        blurRadius: 6,
//                      )
//                    ]),
//                  ),
//
                  Container(
                      color: HexColor("FAFAFA"),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                      color: Colors.black45,
                                      offset: Offset(1, -1))
                                ],
                                color: Colors.white,
                                borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(50),
                                    bottomRight: Radius.circular(10))),
                            width: 110,
                          ),
                          Container(
                              padding: EdgeInsets.only(top: 5, bottom: 5),
                              decoration: BoxDecoration(),
                              child: Column(children: [
                                SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Row(
                                    children: <Widget>[
                                      OvalButtonForDate("   Tomorrow  ", 1),
                                      OvalButtonForDate("2 days later ", 2),
                                      OvalButtonForDate("3 days later ", 3),
                                      OvalButtonForDate("5 days later ", 4),
                                      OvalButtonForDate("A week later ", 5),
                                      OvalButtonForDate("14 days later", 6),
                                      OvalButtonForDate("A month later", 7),
                                      OvalButtonForDate("3 month later", 8),

                                    ],
                                  ),
                                ),
SingleChildScrollView(
  scrollDirection: Axis.horizontal,
  child:Row(
    children:[
      OvalButtonForDate("Next sunday", 9),
      OvalButtonForDate("Next monday", 10),
      OvalButtonForDate("Next tuesday", 11),
      OvalButtonForDate("Next wednsday", 12),
      OvalButtonForDate("Next thursday", 13),
      OvalButtonForDate("Next friday", 14),
      OvalButtonForDate("Next saturday", 15),
    ]
  )
),
//                                SingleChildScrollView(
//                                  scrollDirection: Axis.horizontal,
//                                  child: Row(
//                                    children: <Widget>[
//                                      OvalButtonForDate("On sundays", 13),
//                                      OvalButtonForDate("On mondays", 14),
//                                      OvalButtonForDate("On tuesdays", 15),
//                                      OvalButtonForDate("On wednsdays", 16),
//                                      OvalButtonForDate("On thursdays", 17),
//                                      OvalButtonForDate("On fridays", 18),
//                                      OvalButtonForDate("On saturdays", 19),
//                                    ],
//                                  ),
//                                ),
                              ]))
                        ],
                      )),
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(width: 5),
                        OutlinedButton(
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(HexColor("FAFAFA")),
                            shape: MaterialStateProperty.all(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(80.0))),
                          ),
                          child: Text("calendar",
                              style: GoogleFonts.actor(color: Colors.black)),
                          onPressed: () {
                            showCalendarDialog();
                          },
                        ),
                      ],
                    ),
                  ),
//                  Expanded(
//                      child: ListView(
//                    children: [
//                      GestureDetector(
//                        onTap: () {
////                          selectSong().then((value) {
////                            songPath = value.path;
////                            setState(() {
////                              songName = value.name;
////                            });
////                          });
//                        },
//                        child: DecoratedBox(
//                            decoration: BoxDecoration(
//                                borderRadius: BorderRadius.circular(30),
//                                color: Colors.white),
//                            child: ListTile(
//                              title: Row(children: [
//                                Text("Sound",
//                                    style: GoogleFonts.actor(fontSize: 22)),
//                                Padding(
//                                  padding: const EdgeInsets.only(left: 30.0),
//                                  child: GradientText(songName,
//                                      gradient: LinearGradient(colors: [
//                                        HexColor("0C4FF1"),
//                                        Colors.blue,
//                                      ]),
//                                      style: GoogleFonts.actor(fontSize: 17)),
//                                )
//                              ]),
//                            )),
//                      ),
//                      SizedBox(height: 8),
//                      DecoratedBox(
//                          decoration: BoxDecoration(
//                              borderRadius: BorderRadius.circular(30),
//                              color: Colors.white),
//                          child: ListTile(
//                            title: Row(children: [
//                              Text("Vibrate",
//                                  style: GoogleFonts.actor(fontSize: 22)),
//                              Padding(
//                                padding: const EdgeInsets.only(left: 23.0),
//                                child: GradientText("3 min.",
//                                    gradient: LinearGradient(colors: [
//                                      HexColor("0C4FF1"),
//                                      Colors.blue,
//                                    ]),
//                                    style: GoogleFonts.actor(fontSize: 17)),
//                              )
//                            ]),
//                          )),
//                      SizedBox(height: 8),
//                      DecoratedBox(
//                          decoration: BoxDecoration(
//                              borderRadius: BorderRadius.circular(30),
//                              color: Colors.white),
//                          child: ListTile(
//                            title: Row(children: [
//                              Text("Snooze",
//                                  style: GoogleFonts.actor(fontSize: 22)),
//                              Padding(
//                                padding: const EdgeInsets.only(left: 21.0),
//                                child: GradientText("3 times in 5 minutes",
//                                    gradient: LinearGradient(colors: [
//                                      HexColor("0C4FF1"),
//                                      Colors.blue,
//                                    ]),
//                                    style: GoogleFonts.actor(fontSize: 17)),
//                              )
//                            ]),
//                          )),
//                      SizedBox(height: 8),
//                      DecoratedBox(
//                          decoration: BoxDecoration(
//                              borderRadius: BorderRadius.circular(30),
//                              color: Colors.white),
//                          child: ListTile(
//                            title: Row(children: [
//                              Text("Alarm page",
//                                  style: GoogleFonts.actor(fontSize: 22)),
//                              Padding(
//                                padding: const EdgeInsets.only(left: 15.0),
//                                child: ClipRRect(
//                                  borderRadius: BorderRadius.circular(8),
//                                  child: Container(
//                                    decoration: BoxDecoration(
//                                        gradient: LinearGradient(colors: [
//                                      HexColor("0C4FF1"),
//                                      Colors.blue,
//                                    ])),
//                                    height: 50,
//                                    width: 50,
//                                  ),
//                                ),
//                              ),
//                            ]),
//                          )),
//                    ],
//                  ))
                ],
              ),
            )),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Expanded(
                  child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                    decoration: BoxDecoration(
                        color: HexColor("00000d"),
                        borderRadius: BorderRadius.circular(5)),
                    width: double.infinity,
                    child: TextButton(
                      child: Text("Set as reminder",
                          style: GoogleFonts.actor(color: Colors.white)),
                      onPressed: () {
                        List inValidDates=[];
                        List finalDates = [];
                        checkedDates.forEach((key, value) {
                          if (value == true) finalDates.add(key);
                        });

                        Calendar_Dates.forEach((date) {


                            finalDates.add(date);

                        });


                        AddAlarmToDataBase(widget.Id, songPath.toString(), "vi",
                            'k', Time, widget.Name, 'red', finalDates).then((value) {
                              List reformedDates=[];
                            reformedDates=value;
                              showDatesListDialog(reformedDates,inValidDates).whenComplete(() {
                                mainq().whenComplete(() => Navigator.pop(context));

                              });

                            });


                      },
                    )),
              ))
            ])
          ]),
        ));
  }

  Future showDatesListDialog(List dates,List inValidDates)async{
    return showDialog(
      context:context,
      builder: (context){
        return AlertDialog(
            titlePadding: EdgeInsets.only(top: 8, left: 8, bottom: 8),
            contentPadding: EdgeInsets.only(left:5,right:5,),
          title:Text("Dates",style:GoogleFonts.actor()),
          content:SingleChildScrollView(
            child: Column(
              children:List.generate(dates.length,(index){
                return Column(
                  children: [
                    Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,children:[
                      StyledText(
                          text:
                          "<date>${dates[index].toString().split(" ")[0]}</date>    <time>${dates[index].toString().split(" ")[1].split(".")[0]}</time>",
                          tags: {
                            "date": StyledTextTag(
                                style: GoogleFonts.lato(
                                    fontWeight: FontWeight.bold)),
                            "time":
                            StyledTextTag(style: GoogleFonts.lato())
                          }),

                      dates[index].isBefore(DateTime.now())?Icon(Icons.close,color:Colors.red): Icon(Icons.check,color:Colors.green)



                    ]

                    ),
                  ],
                );
              })
            ),
          )
        );
      }
    );
  }

  Row OvalButtonForCalendarDate(text, id) {
    return Row(
      children: [
        OutlinedButton(
          style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(Colors.white),
              shape: MaterialStateProperty.all(RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30)))),
          child: Row(children: [
            Text(
              text,
              style: GoogleFonts.actor(fontSize: 12, color: Colors.black),
            ),
            SizedBox(width: 20),
            GestureDetector(
                onTap: () {
                  setState(() {
                    Calendar_Dates.removeAt(id);
                  });
                },
                child: Icon(Icons.remove, size: 12, color: Colors.red))
          ]),
          onPressed: () {},
        ),
        SizedBox(
          width: 5,
        )
      ],
    );
  }

  Row OvalButtonForDate(text, id) {
    if (!checkedDates.containsKey("ch$id")) checkedDates["ch$id"] = false;

    bool isChecked = checkedDates["ch$id"];
    if (isChecked) {
      C = Colors.black;
      P = Colors.white;
    } else {
      C = Colors.white;
      P = Colors.black;
    }

    return Row(
      children: [
        OutlinedButton(
          style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(C),
              shape: MaterialStateProperty.all(RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30)))),
          child: Text(
            text,
            style: GoogleFonts.actor(fontSize: 12, color: P),
          ),
          onPressed: () {
            setState(() {
              isChecked == true
                  ? checkedDates["ch$id"] = false
                  : checkedDates["ch$id"] = true;
            });
          },
        ),
        SizedBox(
          width: 5,
        )
      ],
    );
  }

  Container iMoon() {
    return Container(
        decoration: BoxDecoration(boxShadow: [
          BoxShadow(
              spreadRadius: 5,
              blurRadius: 30,
              offset: Offset(2, 5),
              color: Colors.white70)
        ]),
        child: FaIcon(
          FontAwesomeIcons.solidMoon,
          size: 25,
          color: Colors.white,
        ));
  }

  Container iSun() {
    return Container(
        decoration: BoxDecoration(boxShadow: [
          BoxShadow(
              spreadRadius: 5, blurRadius: 30, color: Colors.yellow.shade700)
        ]),
        child: Icon(
          Icons.wb_sunny,
          size: 27,
          color: Colors.yellow.shade800,
        ));
  }

  Future showCalendarDialog() async {
    return showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(
            builder: (context, setState) {
              return Dialog(
                  insetPadding: EdgeInsets.only(left: 20, right: 20),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20))),
                  child: SingleChildScrollView(
                    child: Column(children: [
                      SfDateRangePicker(
                        onSelectionChanged: (e) {
                          setState(() {

                            candidate_calendar_date = e.value;
                          });
                        },
                        showNavigationArrow: true,
                        selectionColor: Colors.red,
                        headerStyle: DateRangePickerHeaderStyle(
                            textStyle: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold)),
                        selectionShape: DateRangePickerSelectionShape.circle,
                        monthCellStyle: DateRangePickerMonthCellStyle(
                            trailingDatesTextStyle: TextStyle(fontSize: 40),
                            weekendTextStyle: TextStyle(color: Colors.red),
                            textStyle: GoogleFonts.lato(
                                color: Colors.black, fontSize: 15)),
                      ),
                      Visibility(
                          visible:
                              candidate_calendar_date != null ? true : false,
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: TextButton(

                              child: StyledText(
                                text:
                                    "Add <bold>${candidate_calendar_date.toString().split(" ")[0]}</bold>",
                                tags: {
                                  'bold': StyledTextTag(
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15,
                                          color: Colors.black))
                                },
                              ),
                              onPressed: () {
                                setState(() {
                                  if (Calendar_Dates.contains(
                                          candidate_calendar_date) ==
                                      false)
                                    Calendar_Dates.add(candidate_calendar_date);
                                });
                              },
                            ),
                          )),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8.0),
                        child: Container(
                            height: 50,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: HexColor("FAFAFA"),
                            ),
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: List.generate(Calendar_Dates.length,
                                    (index) {
                                  if (Calendar_Dates.length == 0) {
                                    return Text("empty",
                                        style: TextStyle(
                                            color: Colors.red, fontSize: 30));
                                  } else {
                                    return Row(
                                      children: [
                                        OutlinedButton(
                                          style: ButtonStyle(
                                              backgroundColor:
                                                  MaterialStateProperty.all(
                                                      Colors.white),
                                              shape: MaterialStateProperty.all(
                                                  RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              30)))),
                                          child: Row(children: [
                                            Text(
                                              Calendar_Dates[index].toString().split(" ")[0],
                                              style: GoogleFonts.actor(
                                                  fontSize: 12,
                                                  color: Colors.black),
                                            ),
                                            SizedBox(width: 10),
                                            GestureDetector(
                                                onTap: () {
                                                  setState(() {
                                                    Calendar_Dates.removeAt(
                                                        index);
                                                  });
                                                },
                                                child: Icon(Icons.remove,
                                                    size: 15,
                                                    color: Colors.red))
                                          ]),
                                          onPressed: () {},
                                        ),
                                        SizedBox(
                                          width: 5,
                                        )
                                      ],
                                    );
                                  }
                                }),
                              ),
                            )),
                      ),
                      TextButton(
                          child: Text("Ok"),
                          onPressed: () {
                            Navigator.pop(context);
                          })
                    ]),
                  ));
            },
          );
        });
  }


}

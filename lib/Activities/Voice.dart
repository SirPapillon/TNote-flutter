//import 'package:flutter/material.dart';
//import 'package:google_fonts/google_fonts.dart';
//import 'package:font_awesome_flutter/font_awesome_flutter.dart';
//import 'package:flutter_sound/flutter_sound.dart';
//import 'package:permission_handler/permission_handler.dart';
//import '../RecordVoice.dart';
//import 'package:hexcolor/hexcolor.dart';
//import '../AudioService.dart';
//
//class Voice extends StatefulWidget {
//  @override
//  _VoiceState createState() => _VoiceState();
//}
//
//class _VoiceState extends State<Voice> {
//  String isRecordingLabel = "Record new voice";
//  bool isRecording = false;
//  var Recorder;
//  List Voices = [];
//
//  @override
//  Widget build(BuildContext context) {
//    return MaterialApp(
//        debugShowCheckedModeBanner: false,
//        home: Scaffold(
//          backgroundColor: Colors.white,
//          appBar: AppBar(elevation: 0,backgroundColor:Colors.white , ),
//          body: Stack(children: [
//            ListView.builder(
//                itemCount: Voices.length,
//                itemBuilder: (BuildContext context, int index) {
//                  return ListTile(onTap: (){PlaySound(Voices[index]);},
//                    leading: Text(
//                      Voices[index],
//                      style:
//                          GoogleFonts.actor(color: Colors.black, fontSize: 20),
//                    ),
//                  );
//                }),
//            Align(alignment: Alignment.bottomCenter, child: _AddB())
//          ]),
////          floatingActionButton: FloatingActionButton.extended(
////            label: Text(isRecordingLabel),
////            icon: Icon(FontAwesomeIcons.microphoneAlt),
////            backgroundColor: Colors.redAccent,
////            onPressed: () {
////
////            },
////          ),
//        ));
//  }
//
//  Expanded _AddB() {
//    return Expanded(
//        child: Padding(
//      padding: const EdgeInsets.all(8.0),
//      child: Container(
//          decoration: BoxDecoration(
//              color: Colors.redAccent, borderRadius: BorderRadius.circular(5)),
//          width: double.infinity,
//          child: TextButton(
//            child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
//              Icon(
//                FontAwesomeIcons.microphoneAlt,
//                color: Colors.white,
//              ),
//              SizedBox(
//                width: 5,
//              ),
//              Text(isRecordingLabel,
//                  style: GoogleFonts.actor(color: Colors.white, fontSize: 18))
//            ]),
//            onPressed: () {
//              String Name = "Untitled-" + (Voices.length + 1).toString();
//              switch (isRecording) {
//                case false:
//                  Recorder = new Recording();
//                  setState(() {
//                    isRecordingLabel = "Stop recording";
//                  });
//                  isRecording = true;
//
//                  Recorder.RecordVoice(Name);
//                  break;
//                case true:
//                  setState(() {
//                    isRecordingLabel = "Record new voice";
//                    Voices.add(Name);
//                  });
//                  isRecording = false;
//                  Recorder.StopRecording();
//                // Recording().StopRecording();
//              }
//            },
//          )),
//    ));
//  }
//}

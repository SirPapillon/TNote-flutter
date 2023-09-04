//import 'package:flutter/material.dart';
//import 'package:google_fonts/google_fonts.dart';
//import 'package:font_awesome_flutter/font_awesome_flutter.dart';
//import 'package:permission_handler/permission_handler.dart';
//import 'package:external_path/external_path.dart';
//import 'dart:io';
//import 'package:sound_recorder/sound_recorder.dart';
//import 'package:file/file.dart';
//
//
//
//class Recording{
//  var recorder;
//
//  PermissionsHandler()async{
//    bool hasPermission = await SoundRecorder.hasPermissions;
//    Permission.storage.request();
//
//    Permission.accessMediaLocation.request();
//    Permission.manageExternalStorage.request();
//    Permission.microphone.request();
//  }
//
//  Future RecordVoice(Name) async {
//    PermissionsHandler();
//
//    var D = await ExternalPath.getExternalStorageDirectories();
//    var T=D[0];
//
//    recorder = SoundRecorder("$T/$Name.mp4"); // .wav .aac .m4a
//    await recorder.initialized;
//    await recorder.start();
//    var recording = await recorder.current(channel: 0);
//
//
//
//
//  }
//
//  Future StopRecording()async{
//    await recorder.stop();
//  }
//
//}

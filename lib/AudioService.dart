//import 'package:soundpool/soundpool.dart';
//import 'package:flutter/services.dart';
//import 'package:external_path/external_path.dart';
//
//
//Future PlaySound(String Name)async{
//  Soundpool pool = Soundpool(streamType: StreamType.notification);
//  var D = await ExternalPath.getExternalStorageDirectories();
//  var T=D[0];
//  int soundId = await rootBundle.load("$T/$Name.mp4").then((ByteData soundData) {
//  return pool.load(soundData);
//  });
//  int streamId = await pool.play(soundId);}
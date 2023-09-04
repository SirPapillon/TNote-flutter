import 'package:flutter/material.dart';

em (){
  print("Done t");
}
Future NavigateToThemes(Activity, context,navigatorKey,[Function callBack=em])async {
  navigatorKey.currentState
      .pushReplacement(PageRouteBuilder(
    pageBuilder: (c, a1, a2) => Activity,
    transitionsBuilder: (c, anim, a2, child) => FadeTransition(opacity: anim, child: child),
    transitionDuration: Duration(milliseconds: 0),
  ),).then((v){callBack();}) ;
}
Future NavigateTo(Activity, context,navigatorKey,[Function callBack=em])async {
  navigatorKey.currentState
      .push(PageRouteBuilder(
    pageBuilder: (c, a1, a2) => Activity,
    transitionsBuilder: (c, anim, a2, child) => FadeTransition(opacity: anim, child: child),
    transitionDuration: Duration(milliseconds: 0),
  ),).then((v){callBack();}) ;
}

NavigateT(Activity,context){
  Navigator.push(context, MaterialPageRoute(builder: Activity) );
}
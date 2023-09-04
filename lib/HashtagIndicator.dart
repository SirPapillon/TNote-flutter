import 'package:flutter/material.dart';

class HashtagIndicator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 70,height: 35,
      child:Text("HJGGJ") ,
      decoration: new BoxDecoration(
        color: Colors.white70,
        border: Border.all(color: Colors.blueGrey, width: 5.0),
        borderRadius: new BorderRadius.all(Radius.elliptical(100, 50)),
      ),
    );
  }
}

import 'package:flutter/material.dart';

class Tabsz extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return TabBar(tabs: [
      Tab(icon: Icon(Icons.directions_car)),
      Tab(icon: Icon(Icons.directions_transit)),
      Tab(icon: Icon(Icons.directions_bike)),
    ]);
  }
}

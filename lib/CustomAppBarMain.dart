import 'package:flutter/material.dart';


class ShowAppBar extends StatelessWidget {
  final Text Title;
  Map ThemeColors;

  ShowAppBar(this.Title, this.ThemeColors);

  @override
  Widget build(BuildContext context) {


    return AppBar(
      backgroundColor: ThemeColors["searchBarBackGroundColor"],
      //FFDBD0
      elevation: 0,
      title: Title,

      actions: [
        Container(
            margin: EdgeInsets.only(top: 7, bottom: 7, right: 5),
            child: Row(children: [

            ]),

        )],
    );
  }
}



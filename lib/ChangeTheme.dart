import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

ChangeTheme(themeName) {
  switch (themeName) {
    case ("default"):
      return default_Theme();
    case ("dark1"):
      return Dark_Theme1();
    case ("light1"):
      return Light_Theme1();
  }
}

default_Theme() {
  Color TopColor = HexColor("0C4FF1");
  Color MiddleColor = Colors.white;
  Color SecondaryColor = HexColor("FAFAFA");
  Color ShadowColor = Colors.black54;
  Color TitleColor = Colors.white;
  Color OptionsBackColor = Colors.white;
  Color OptionsColor = Colors.black;
  Color TileModeColor = HexColor("0C4FF1");
  Color body1 = Colors.black;
  Color body2 = Colors.black54;
  return [
    TopColor,
    MiddleColor,
    SecondaryColor,
    body1,
    body2,
    ShadowColor,
    TitleColor,
    OptionsBackColor,
    OptionsColor,
    TileModeColor
  ];
}

Theme2() {
  Color TopColor = HexColor("#ffcf40");
  Color MiddleColor = HexColor("ffdc73");
  Color SecondaryColor = HexColor("#ffdc73");
  Color ShadowColor = Colors.red;
  Color TitleColor = Colors.black;
  Color OptionsBackColor = Colors.green;
  Color OptionsColor = Colors.orange;
  Color TileModeColor = Colors.black54;
  Color body1 = Colors.black;
  Color body2 = Colors.black54;
  return [
    TopColor,
    MiddleColor,
    SecondaryColor,
    body1,
    body2,
    ShadowColor,
    TitleColor,
    OptionsBackColor,
    OptionsColor,
    TileModeColor
  ];
}

Dark_Theme1() {
  //Dark
  Color TopColor = HexColor("#212129");
  Color MiddleColor = HexColor("#323949");
  Color SecondaryColor = HexColor("#323949");
  Color ShadowColor = Colors.red;
  Color TitleColor = Colors.white70;
  Color OptionsBackColor = HexColor("212129");
  Color OptionsColor = Colors.white70;
  Color TileModeColor = Colors.black54;
  Color body1 = Colors.white70;
  Color body2 = Colors.black54;
  return [
    TopColor,
    MiddleColor,
    SecondaryColor,
    body1,
    body2,
    ShadowColor,
    TitleColor,
    OptionsBackColor,
    OptionsColor,
    TileModeColor
  ];
}

Light_Theme1() {
  Color TopColor = Colors.white;
  Color MiddleColor = Colors.white;
  Color SecondaryColor = Colors.white;
  Color ShadowColor = Colors.red;
  Color TitleColor = Colors.black;
  Color OptionsBackColor = Colors.white;
  Color OptionsColor = Colors.black;
  Color TileModeColor = Colors.black;
  Color body1 = Colors.black;
  Color body2 = Colors.black54;
  return [
    TopColor,
    MiddleColor,
    SecondaryColor,
    body1,
    body2,
    ShadowColor,
    TitleColor,
    OptionsBackColor,
    OptionsColor,
    TileModeColor
  ];
}

Theme5() {
  Color TopColor = HexColor("#97cfBa");
  Color MiddleColor = HexColor("acd1af");
  Color SecondaryColor = HexColor("#acd1af");
  Color ShadowColor = Colors.red;
  Color TitleColor = Colors.black;
  Color OptionsBackColor = HexColor("97cfBa");
  Color OptionsColor = Colors.black;
  Color TileModeColor = Colors.green;
  Color body1 = Colors.black;
  Color body2 = Colors.black54;
  return [
    TopColor,
    MiddleColor,
    SecondaryColor,
    body1,
    body2,
    ShadowColor,
    TitleColor,
    OptionsBackColor,
    OptionsColor,
    TileModeColor
  ];
}

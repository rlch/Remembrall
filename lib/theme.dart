import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  AppTheme._();

  static final ThemeData light = ThemeData();

  static final ThemeData dark = ThemeData(
    scaffoldBackgroundColor: Color(0xff151515),
    cursorColor: Color(0xffC3073F),
    appBarTheme: AppBarTheme(
      color: Color(0xffC3073F),
      textTheme: TextTheme(
        headline6: GoogleFonts.pacifico(
          color: Color(0xff6f2232),
          fontSize: 26,
        ),
      ),
    ),
    cupertinoOverrideTheme: CupertinoThemeData(
      primaryColor: Color(0xffC3073F),
    ),
    inputDecorationTheme: InputDecorationTheme(
        fillColor: Color(0xff1a1a1d),
        hintStyle: GoogleFonts.quicksand(
            textStyle: TextStyle(color: Colors.grey.shade700, fontSize: 20))),
    textTheme: TextTheme(
      subtitle1: GoogleFonts.quicksand(
          textStyle: TextStyle(color: Colors.grey.shade400, fontSize: 20)),
      headline5: GoogleFonts.pacifico(),
    ),
    primaryColor: Color(0xffC3073F),
    highlightColor: Color(0xff6f2232),
    cardColor: Color(0xff604738),
    shadowColor: Colors.black.withOpacity(0.4),
  );
}

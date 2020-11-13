import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme extends ChangeNotifier {
  bool isDark = true;

  ThemeMode currentTheme() => isDark ? ThemeMode.dark : ThemeMode.light;

  void switchTheme() {
    isDark = !isDark;
    notifyListeners();
  }

  AppTheme();

  static final double phoneBoundary = 600;
  static final double tabletBoundary = 1200;
  static final double desktopBoundary = 1600;

  static T determineBreakpoint<T>(
          double width, T phone, T tablet, T desktop, T tv) =>
      width < phoneBoundary
          ? phone
          : width < tabletBoundary
              ? tablet
              : width < desktopBoundary
                  ? desktop
                  : tv;

  static final ThemeData light = ThemeData(
    scaffoldBackgroundColor: Color(0xffF7F4F3),
    appBarTheme: AppBarTheme(
      color: Color(0xffC3073F),
      textTheme: TextTheme(
        headline6: GoogleFonts.pacifico(
          color: Color(0xff6f2232),
          fontSize: 26,
        ),
      ),
    ),
    textTheme: TextTheme(
        bodyText2:
            GoogleFonts.quicksand(color: Colors.grey.shade500, fontSize: 16),
        subtitle1: GoogleFonts.quicksand(
          color: Colors.grey.shade600,
          fontSize: 20,
        ),
        subtitle2: GoogleFonts.quicksand(
          color: Color(0xff604738),
          fontSize: 20,
        ),
        headline1: GoogleFonts.pacifico(
          color: Color(0xffC3073F),
        ),
        headline4: GoogleFonts.quicksand(
          color: Colors.black,
        ),
        headline5: GoogleFonts.pacifico(
          color: Colors.black,
        ),
        button: GoogleFonts.quicksand(
          color: Colors.white,
        )),
    primaryColor: Color(0xffC3073F),
    highlightColor: Color(0xff6f2232),
    accentColor: Color(0xffE7DDDA),
    cardColor: Color(0xff604738),
    shadowColor: Colors.black.withOpacity(0.4),
    cursorColor: Color(0xffC3073F),
    cupertinoOverrideTheme: CupertinoThemeData(
      primaryColor: Color(0xffC3073F),
    ),
    inputDecorationTheme: InputDecorationTheme(
      fillColor: Color(0xffEFE8E6),
      hintStyle: GoogleFonts.quicksand(
        textStyle: TextStyle(color: Colors.grey.shade500, fontSize: 20),
      ),
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: Color(0xffC3073F),
      splashColor: Color(0xff6f2232),
      hoverColor: Color(0xffB1063A),
      focusElevation: 12,
      hoverElevation: 8,
      elevation: 5,
    ),
    bottomAppBarColor: Color(0xff1a1a1d),
  );

  static final ThemeData dark = ThemeData(
    scaffoldBackgroundColor: Color(0xff151515),
    appBarTheme: AppBarTheme(
      color: Color(0xffC3073F),
      textTheme: TextTheme(
        headline6: GoogleFonts.pacifico(
          color: Color(0xff6f2232),
          fontSize: 26,
        ),
      ),
    ),
    textTheme: TextTheme(
        bodyText2:
            GoogleFonts.quicksand(color: Colors.grey.shade500, fontSize: 16),
        subtitle1: GoogleFonts.quicksand(
          color: Colors.grey.shade400,
          fontSize: 20,
        ),
        subtitle2: GoogleFonts.quicksand(
          color: Color(0xff604738),
          fontSize: 20,
        ),
        headline1: GoogleFonts.pacifico(
          color: Color(0xffC3073F),
        ),
        headline4: GoogleFonts.quicksand(
          color: Colors.white,
        ),
        headline5: GoogleFonts.pacifico(
          color: Colors.white,
        ),
        button: GoogleFonts.quicksand(
          color: Colors.white,
        )),
    primaryColor: Color(0xffC3073F),
    highlightColor: Color(0xff6f2232),
    accentColor: Color(0xff604738),
    cardColor: Color(0xff604738),
    shadowColor: Colors.black.withOpacity(0.4),
    cursorColor: Color(0xffC3073F),
    cupertinoOverrideTheme: CupertinoThemeData(
      primaryColor: Color(0xffC3073F),
    ),
    inputDecorationTheme: InputDecorationTheme(
      fillColor: Color(0xff1a1a1d),
      hintStyle: GoogleFonts.quicksand(
        textStyle: TextStyle(color: Colors.grey.shade600, fontSize: 20),
      ),
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: Color(0xffC3073F),
      splashColor: Color(0xff6f2232),
      hoverColor: Color(0xffB1063A),
      focusElevation: 12,
      hoverElevation: 8,
      elevation: 5,
    ),
    bottomAppBarColor: Color(0xff1a1a1d),
  );
}

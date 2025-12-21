import 'package:flutter/material.dart';

class AppThemes{
  static final light =ThemeData(
    primaryColor: Colors.green.shade100,
    scaffoldBackgroundColor: Colors.white,
    brightness: Brightness.light,
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.blue,
      elevation: 0,
      iconTheme: IconThemeData(
        color: Colors.blue
      ),
    ),
    colorScheme: ColorScheme.fromSeed(seedColor: Colors.red,
    primary: const Color(0xff5655),
      brightness: Brightness.light,
      surface: Colors.white,


    ),
    cardColor:  Colors.white,
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: Colors.white,
      selectedItemColor: Colors.black87,
      unselectedItemColor: Colors.grey
    )

  );

//dark
  static final dark =ThemeData(
    primaryColor: Colors.green.shade100,
    scaffoldBackgroundColor: Color(0xff121212),
    brightness: Brightness.dark,
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.blue,
      elevation: 0,
      iconTheme: IconThemeData(
        color: Colors.blue
      ),
    ),
    colorScheme: ColorScheme.fromSeed(seedColor: Colors.red,
    primary: const Color(0x00ff5655),
      brightness: Brightness.dark,
      surface: Color(0xff121212),


    ),
    cardColor:  Color(0xff121212),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: Color(0xff121212),
      selectedItemColor: Colors.white,
      unselectedItemColor: Colors.grey
    )

  );
}

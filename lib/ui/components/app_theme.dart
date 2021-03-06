import 'package:flutter/material.dart';

ThemeData makeAppTheme() {

  final primaryColor = Colors.deepPurple; //Color.fromRGBO(136, 14, 79, 1);
  final primaryColorLight = Colors.deepPurpleAccent; //Color.fromRGBO(188, 71, 123, 1);
  final primaryColorDark = Colors.deepPurple[800]; //Color.fromRGBO(96, 0, 39, 1);
  final secondaryColor = Colors.deepPurple[300];


  return ThemeData(
    primarySwatch: primaryColor,
    primaryColor: primaryColor,
    primaryColorDark: primaryColorDark,
    primaryColorLight: primaryColorLight,
    secondaryHeaderColor: secondaryColor,
    backgroundColor: Colors.white,
    textTheme: TextTheme(
      headline1: TextStyle(
        fontSize: 30,
        fontWeight: FontWeight.bold,
        color: primaryColorDark,
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      focusColor: primaryColor,
      enabledBorder: UnderlineInputBorder(
        borderSide: BorderSide(
          color: primaryColorLight,
        ),
      ),
      focusedBorder: UnderlineInputBorder(
        borderSide: BorderSide(
          color: primaryColor,
        ),
      ),
      alignLabelWithHint: true,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        onPrimary: Colors.white,
        primary: primaryColorLight,
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        primary: primaryColorLight,
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      ),
    ),
  );
}

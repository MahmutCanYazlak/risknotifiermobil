import 'package:flutter/material.dart';
import 'package:risknotifier/config/extensions/context_extension.dart';

class AppTheme {
  const AppTheme._();
  static ThemeData lightTheme(BuildContext context) {
    return ThemeData(
      brightness: Brightness.light,
      primaryColor: const Color.fromRGBO(221, 57, 13, 1),
      scaffoldBackgroundColor: Colors.white,
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
        titleTextStyle: TextStyle(color: Colors.black),
      ),
      textTheme: TextTheme(
        displayLarge: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: context.dynamicHeight(0.037),
        ),
        displayMedium: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: context.dynamicHeight(0.032),
        ),
        displaySmall: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: context.dynamicHeight(0.027),
        ),
        headlineLarge: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: context.dynamicHeight(0.037),
        ),
        headlineSmall: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: context.dynamicHeight(0.027),
        ),
        headlineMedium: TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: context.dynamicHeight(0.022),
        ),
        titleLarge: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: context.dynamicHeight(0.037),
        ),
        titleMedium: TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: context.dynamicHeight(0.027),
        ),
        titleSmall: TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: context.dynamicHeight(0.022),
        ),
        bodyLarge: TextStyle(
          fontWeight: FontWeight.w400,
          fontSize: context.dynamicHeight(0.027),
        ),
        bodyMedium: TextStyle(
          fontWeight: FontWeight.w400,
          fontSize: context.dynamicHeight(0.022),
        ),
        bodySmall: TextStyle(
          fontWeight: FontWeight.w400,
          fontSize: context.dynamicHeight(0.017),
        ),
        labelLarge: TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: context.dynamicHeight(0.027),
        ),
        labelMedium: TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: context.dynamicHeight(0.022),
        ),
        labelSmall: TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: context.dynamicHeight(0.017),
        ),
      ),
      colorScheme: ColorScheme.fromSwatch()
          .copyWith(secondary: const Color.fromRGBO(221, 57, 13, 1)),
    );
  }

  static ThemeData darkTheme(BuildContext context) => ThemeData(
        brightness: Brightness.dark,
        primaryColor: const Color.fromRGBO(221, 57, 13, 1),
        scaffoldBackgroundColor: Colors.black,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.black,
          elevation: 0,
          iconTheme: IconThemeData(color: Colors.white),
          titleTextStyle: TextStyle(color: Colors.white),
        ),
        textTheme: TextTheme(
          displayLarge: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: context.dynamicHeight(0.037),
          ),
          displayMedium: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: context.dynamicHeight(0.032),
          ),
          displaySmall: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: context.dynamicHeight(0.027),
          ),
          headlineLarge: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: context.dynamicHeight(0.037),
          ),
          headlineSmall: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: context.dynamicHeight(0.027),
          ),
          headlineMedium: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: context.dynamicHeight(0.022),
          ),
          titleLarge: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: context.dynamicHeight(0.037),
          ),
          titleMedium: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: context.dynamicHeight(0.027),
          ),
          titleSmall: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: context.dynamicHeight(0.022),
          ),
          bodyLarge: TextStyle(
            fontWeight: FontWeight.w400,
            fontSize: context.dynamicHeight(0.027),
          ),
          bodyMedium: TextStyle(
            fontWeight: FontWeight.w400,
            fontSize: context.dynamicHeight(0.022),
          ),
          bodySmall: TextStyle(
            fontWeight: FontWeight.w400,
            fontSize: context.dynamicHeight(0.017),
          ),
          labelLarge: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: context.dynamicHeight(0.027),
          ),
          labelMedium: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: context.dynamicHeight(0.022),
          ),
          labelSmall: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: context.dynamicHeight(0.017),
          ),
        ),
        colorScheme:
            ColorScheme.fromSwatch().copyWith(secondary: Colors.blueAccent),
      );
}

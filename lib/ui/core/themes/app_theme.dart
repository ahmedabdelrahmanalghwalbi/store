import 'package:flutter/material.dart';

abstract class AppTheme {
  static const Color scaffoldBackgroundColor = Color(0xffFFFFFF);
  static const Color viewBackgroundColor = Color(0xffEEF1F2);
  static const double pagePadding = 12.0;
  static const Color primaryColor = Color(0xff2E9245);
  static const Color inputBorderColor = Color(0xffBDBDBD);
  static const Color inputHintTextColor = Color(0xff9E9E9E);
  static const Color inputLabelColor = Color(0xff000000);
  static const Color inputFillColor = Color(0xFFFFFFFF);
  static const double inputBorderRadius = 8.0;
  static const double inputBorderWidth = 1.0;
  static const double inputFontSize = 14.0;
  static const Color shimmerBaseColor = Color(0xFFD9E2DA);
  static const Color shimmerHighlightColor = Color(0xFFEAF0EC);
  static ThemeData getTheme({
    required bool isDark,
    required BuildContext context,
  }) => ThemeData(
    inputDecorationTheme: InputDecorationTheme(
      errorMaxLines: 4,
      hintStyle: TextStyle(
        color: inputHintTextColor,
        fontWeight: FontWeight.w500,
        fontSize: inputFontSize,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(inputBorderRadius),
        borderSide: BorderSide(
          color: inputBorderColor,
          width: inputBorderWidth,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(inputBorderRadius),
        borderSide: BorderSide(
          color: inputBorderColor,
          width: inputBorderWidth,
        ),
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(inputBorderRadius),
        borderSide: BorderSide(
          color: inputBorderColor,
          width: inputBorderWidth,
        ),
      ),
      labelStyle: TextStyle(
        color: inputLabelColor,
        fontWeight: FontWeight.w500,
        fontSize: inputFontSize,
      ),
      filled: true,
      fillColor: inputFillColor,
      contentPadding: const EdgeInsets.symmetric(
        vertical: 14.0,
        horizontal: 16.0,
      ),
      isDense: true,
    ),
  );
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

const Color bluishClr = Color(0xFF4e5ae8);
const Color orangeClr = Color(0xCFFF8746);
const Color pinkClr = Color(0xFFff4667);
const Color white = Colors.white;
const primaryClr = bluishClr;
const Color darkGreyClr = Color(0xFF121212);
const Color darkHeaderClr = Color(0xFF424242);

class Themes {
  static final light = ThemeData(
    primaryColor: primaryClr,
    brightness: Brightness.light,
  );
  static final dark = ThemeData(
    primaryColor: darkGreyClr,
    brightness: Brightness.dark,
  );
}

TextStyle get headingStyle {
  return GoogleFonts.lato(
      textStyle: TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 24,
    color: Get.isDarkMode ? Colors.white : Colors.black,
  ));
}

TextStyle get subHeadingStyle {
  return GoogleFonts.lato(
      textStyle: TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 20,
    color: Get.isDarkMode ? Colors.white : Colors.black,
  ));
}

TextStyle get titleStyle {
  return GoogleFonts.lato(
      textStyle: TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 18,
    color: Get.isDarkMode ? Colors.white : Colors.black,
  ));
}

TextStyle get subTitleStyle {
  return GoogleFonts.lato(
      textStyle: TextStyle(
    fontWeight: FontWeight.w600,
    fontSize: 16,
    color: Get.isDarkMode ? Colors.white : Colors.black,
  ));
}

TextStyle get bodyStyle {
  return GoogleFonts.lato(
      textStyle: TextStyle(
    fontWeight: FontWeight.w400,
    fontSize: 16,
    color: Get.isDarkMode ? Colors.white : Colors.black,
  ));
}

TextStyle get body2Style {
  return GoogleFonts.lato(
      textStyle: TextStyle(
    fontWeight: FontWeight.w400,
    fontSize: 16,
    color: Get.isDarkMode ? Colors.grey[200] : Colors.black,
  ));
}

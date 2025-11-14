import 'package:flutter/material.dart';

/// Utility class for DataTable colors
/// These are default colors that can be overridden via theme
class DataTableColors {
  static const Color primary = Color(0xFF417afe);
  static const Color white = Color(0XFFFFFFFF);
  static const Color black = Color(0XFF000000);
  
  /// Default header background color
  static const Color headerBackground = Color(0XFFB8B8B8);
  
  /// Helper to check if context is in dark mode
  static bool isDarkMode(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark;
}



import 'package:flutter/material.dart';

/// Utility class for responsive design checks
class Responsive {
  /// Check if the current screen is mobile (< 650px)
  static bool isMobile(BuildContext context) =>
      MediaQuery.of(context).size.width < 650;

  /// Check if the current screen is tablet (650px - 1100px)
  static bool isTablet(BuildContext context) =>
      MediaQuery.of(context).size.width < 1100 &&
      MediaQuery.of(context).size.width >= 650;

  /// Check if the current screen is web (>= 1100px)
  static bool isWeb(BuildContext context) =>
      MediaQuery.of(context).size.width >= 1100;
}



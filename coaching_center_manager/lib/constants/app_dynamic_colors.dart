import 'package:flutter/material.dart';

class AppDynamicColors {
  static Color scaffoldBg(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? const Color(0xFF121212)
        : const Color(0xFFE8F3FB);
  }

  static Color headerBg(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? const Color(0xFF1B3A5C)
        : const Color(0xFF86BFE2);
  }

  static Color cardBg(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? const Color(0xFF1E1E1E)
        : Colors.white;
  }

  static Color primaryText(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? Colors.white
        : const Color(0xFF16305C);
  }

  static Color secondaryText(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? Colors.white70
        : Colors.grey;
  }

  static Color headerText(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? Colors.white
        : Colors.black;
  }

  static Color inputFill(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? const Color(0xFF2A2A2A)
        : Colors.white;
  }
}

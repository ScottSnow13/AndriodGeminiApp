// Import necessary packages and files
import 'package:flutter/material.dart'; // Flutter framework
import 'package:google_fonts/google_fonts.dart'; // For using Google Fonts
import 'package:shared_preferences/shared_preferences.dart'; // For storing theme preferences

const kThemeModeKey = '__theme_mode__'; // Key for storing theme mode in shared preferences
SharedPreferences? _prefs; // Shared preferences instance

// Class for managing theme preferences
abstract class FlutterFlowTheme {
  static Future initialize() async =>
      _prefs = await SharedPreferences.getInstance(); // Initialize shared preferences
  static ThemeMode get themeMode {
    final darkMode = _prefs?.getBool(kThemeModeKey); // Get stored theme mode
    return darkMode == null
        ? ThemeMode.system // If no mode stored, use system default
        : darkMode
            ? ThemeMode.dark // If dark mode stored, use dark mode
            : ThemeMode.light; // If light mode stored, use light mode
  }

  static void saveThemeMode(ThemeMode mode) => mode == ThemeMode.system
      ? _prefs?.remove(kThemeModeKey) // If system mode selected, remove stored mode
      : _prefs?.setBool(kThemeModeKey, mode == ThemeMode.dark); // Otherwise, store selected mode

  static FlutterFlowTheme of(BuildContext context) {
    // Return appropriate theme based on brightness of current theme
    return Theme.of(context).brightness == Brightness.dark
        ? DarkModeTheme()
        : LightModeTheme();
  }

  // Deprecated color getters
  @Deprecated('Use primary instead')
  Color get primaryColor => primary;
  @Deprecated('Use secondary instead')
  Color get secondaryColor => secondary;
  @Deprecated('Use tertiary instead')
  Color get tertiaryColor => tertiary;

  // Color properties
  late Color primary;
  late Color secondary;
  late Color tertiary;
  late Color alternate;
  late Color primaryText;
  late Color secondaryText;
  late Color primaryBackground;
  late Color secondaryBackground;
  late Color accent1;
  late Color accent2;
  late Color accent3;
  late Color accent4;
  late Color success;
  late Color warning;
  late Color error;
  late Color info;

  // Deprecated typography getters
  @Deprecated('Use displaySmallFamily instead')
  String get title1Family => displaySmallFamily;
  @Deprecated('Use displaySmall instead')
  TextStyle get title1 => typography.displaySmall;
  // Many more getters...

  // Typography properties
  String get displayLargeFamily;
  TextStyle get displayLarge;
  String get displayMediumFamily;
  TextStyle get displayMedium;
  String get displaySmallFamily;
  TextStyle get displaySmall;
  // Many more getters...
}

// Light mode theme
class LightModeTheme extends FlutterFlowTheme {
  // Deprecated color getters
  @Deprecated('Use primary instead')
  Color get primaryColor => primary;
  @Deprecated('Use secondary instead')
  Color get secondaryColor => secondary;
  @Deprecated('Use tertiary instead')
  Color get tertiaryColor => tertiary;

  // Color properties
  late Color primary = const Color(0xFF4B986C);
  late Color secondary = const Color(0xFF928163);
  late Color tertiary = const Color(0xFF6D604A);
  late Color alternate = const Color(0xFFC8D7E4);
  late Color primaryText = const Color(0xFF0B191E);
  late Color secondaryText = const Color(0xFF384E58);
  late Color primaryBackground = const Color(0xFFF1F4F8);
  late Color secondaryBackground = const Color(0xFFFFFFFF);
  late Color accent1 = const Color(0x4D4B986C);
  late Color accent2 = const Color(0x4D928163);
  late Color accent3 = const Color(0x4C6D604A);
  late Color accent4 = const Color(0xCDFFFFFF);
  late Color success = const Color(0xFF336A4A);
  late Color warning = const Color(0xFFF3C344);
  late Color error = const Color(0xFFC4454D);
  late Color info = const Color(0xFFFFFFFF);
}

// Typography class
abstract class Typography {
  // Typography properties
  String get displayLargeFamily;
  TextStyle get displayLarge;
  String get displayMediumFamily;
  TextStyle get displayMedium;
  String get displaySmallFamily;
  TextStyle get displaySmall;
  // Many more getters...
}

// Theme typography
class ThemeTypography extends Typography {
  ThemeTypography(this.theme);

  final FlutterFlowTheme theme;

  // Typography properties
  String get displayLargeFamily => 'Urbanist';
  TextStyle get displayLarge => GoogleFonts.getFont(
        'Urbanist',
        color: theme.primaryText,
        fontWeight: FontWeight.normal,
        fontSize: 52.0,
      );
  // Many more getters...
}

// Dark mode theme
class DarkModeTheme extends FlutterFlowTheme {
  // Deprecated color getters
  @Deprecated('Use primary instead')
  Color get primaryColor => primary;
  @Deprecated('Use secondary instead')
  Color get secondaryColor => secondary;
  @Deprecated('Use tertiary instead')
  Color get tertiaryColor => tertiary;

  // Color properties
  late Color primary = const Color(0xFF4B986C);
  late Color secondary = const Color(0xFF928163);
  late Color tertiary = const Color(0xFF6D604A);
  late Color alternate = const Color(0xFF17282E);
  late Color primaryText = const Color(0xFFFFFFFF);
  late Color secondaryText = const Color(0xFF658593);
  late Color primaryBackground = const Color(0xFF0B191E);
  late Color secondaryBackground = const Color(0xFF0D1E23);
  late Color accent1 = const Color(0x4D4B986C);
  late Color accent2 = const Color(0x4D928163);
  late Color accent3 = const Color(0x4C6D604A);
  late Color accent4 = const Color(0xB20B191E);
  late Color success = const Color(0xFF336A4A);
  late Color warning = const Color(0xFFF3C344);
  late Color error = const Color(0xFFC4454D);
  late Color info = const Color(0xFFFFFFFF);
}

// Extension to override TextStyle properties
extension TextStyleHelper on TextStyle {
  TextStyle override({
    String? fontFamily,
    Color? color,
    double? fontSize,
    FontWeight? fontWeight,
    double? letterSpacing,
    FontStyle? fontStyle,
    bool useGoogleFonts = true,
    TextDecoration? decoration,
    double? lineHeight,
  }) =>
      useGoogleFonts
          ? GoogleFonts.getFont(
              fontFamily!,
              color: color ?? this.color,
              fontSize: fontSize ?? this.fontSize,
              letterSpacing: letterSpacing ?? this.letterSpacing,
              fontWeight: fontWeight ?? this.fontWeight,
              fontStyle: fontStyle ?? this.fontStyle,
              decoration: decoration,
              height: lineHeight,
            )
          : copyWith(
              fontFamily: fontFamily,
              color: color,
              fontSize: fontSize,
              letterSpacing: letterSpacing,
              fontWeight: fontWeight,
              fontStyle: fontStyle,
              decoration: decoration,
              height: lineHeight,
            );
}

//This code defines a set of classes and functions for managing and customizing themes in a Flutter app.

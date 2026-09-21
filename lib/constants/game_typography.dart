import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Quản lý tập trung toàn bộ phông chữ Pixel Art 2D của Game
class GameTypography {
  GameTypography._();

  /// Phông chữ chính: Pixelify Sans - phong cách 2D pixel art sắc nét, hiện đại
  static TextStyle pixel({
    TextStyle? textStyle,
    Color? color,
    Color? backgroundColor,
    double? fontSize,
    FontWeight? fontWeight,
    FontStyle? fontStyle,
    double? letterSpacing,
    double? wordSpacing,
    TextBaseline? textBaseline,
    double? height,
    Locale? locale,
    Paint? foreground,
    Paint? background,
    List<Shadow>? shadows,
    List<FontFeature>? fontFeatures,
    TextDecoration? decoration,
    Color? decorationColor,
    TextDecorationStyle? decorationStyle,
    double? decorationThickness,
  }) {
    return GoogleFonts.pixelifySans(
      textStyle: textStyle,
      color: color,
      backgroundColor: backgroundColor,
      fontSize: fontSize,
      fontWeight: fontWeight,
      fontStyle: fontStyle,
      letterSpacing: letterSpacing,
      wordSpacing: wordSpacing,
      textBaseline: textBaseline,
      height: height,
      locale: locale,
      foreground: foreground,
      background: background,
      shadows: shadows,
      fontFeatures: fontFeatures,
      decoration: decoration,
      decorationColor: decorationColor,
      decorationStyle: decorationStyle,
      decorationThickness: decorationThickness,
    );
  }

  /// TextTheme chuẩn cho MaterialApp
  static TextTheme textTheme([TextTheme? base]) {
    return GoogleFonts.pixelifySansTextTheme(base ?? ThemeData.dark().textTheme);
  }
}

import 'package:flutter/material.dart';
import 'tokens.dart';

abstract final class BridgeTheme {
  static ThemeData light() {
    final scheme = ColorScheme.fromSeed(
      seedColor: BridgeColors.primary,
      brightness: Brightness.light,
    ).copyWith(
      primary: BridgeColors.primary,
      surface: BridgeColors.paper,
    );
    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      scaffoldBackgroundColor: BridgeColors.bg,
      fontFamily: 'Inter',
    );
  }

  static ThemeData dark() {
    final scheme = ColorScheme.fromSeed(
      seedColor: BridgeColors.primary,
      brightness: Brightness.dark,
    ).copyWith(primary: BridgeColors.darkPrimary);
    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      scaffoldBackgroundColor: BridgeColors.darkBg,
      fontFamily: 'Inter',
    );
  }
}

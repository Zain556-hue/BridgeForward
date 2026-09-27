import 'package:flutter/material.dart';

// BridgeForward Design System V2 — bright / sharp / high-contrast, not neon.
abstract final class BridgeColors {
  static const primary = Color(0xFF2B4EFF);
  static const primaryDark = Color(0xFF162DA8);
  static const primaryTint = Color(0xFFE8EDFF);
  static const accent = Color(0xFF00C896); // gradients/highlights only
  static const whatsapp = Color(0xFF22C55E); // Share button only
  static const whatsappPressed = Color(0xFF15803C);
  static const whatsappOn = Color(0xFF053B1A);
  static const ink = Color(0xFF0A1628);
  static const muted = Color(0xFF4B5B74);
  static const paper = Color(0xFFFFFFFF);
  static const bg = Color(0xFFF6F8FF);
  static const line = Color(0xFFE2E8F5);
  static const success = Color(0xFF16A34A);
  static const warn = Color(0xFFB45309);
  static const warnBg = Color(0xFFFFF4DE);
  static const danger = Color(0xFFDC2626);
  // Badges
  static const investorBg = Color(0xFFE8EDFF);
  static const investorFg = Color(0xFF162DA8);
  static const collabBg = Color(0xFFD9F8EE);
  static const collabFg = Color(0xFF0A7A64);
  static const buyerBg = Color(0xFFFFE4EF);
  static const buyerFg = Color(0xFFBE185D);
  // Dark mode
  static const darkBg = Color(0xFF0A1628);
  static const darkCard = Color(0xFF111F36);
  static const darkPrimary = Color(0xFF7DA2FF);
}

abstract final class BridgeRadii {
  static const sm = 12.0;
  static const md = 16.0;
  static const lg = 24.0;
}

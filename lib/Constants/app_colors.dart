import 'package:flutter/material.dart';
class AppColors {
  AppColors._();
  // الخلفية
  static const Color background = Color(0xFFF7EFE7);
  static const Color surface = Color(0xFFEDE0D0); // خلفية الكروت الفرعية/الأيقونات
  // اللون الأساسي (الأزرار، العناصر المميزة)
  static const Color primary = Color(0xFFA8434B);
  // النصوص
  static const Color textPrimary = Color(0xFF1A1A1A);
  static const Color textSecondary = Color(0xFF8A8A8A);
  // التقييم / النجوم
  static const Color rating = Color(0xFFD4A24C);
  // كارت ثانوي في شبكة التصنيفات
  static const Color accentPurple = Color(0xFFDCD3E8);
  // ألوان أغلفة الكتب (تنويعات، تستخدم كـ placeholder لو مفيش صورة غلاف)
  static const Color coverBrown = Color(0xFF4A3528);
  static const Color coverRed = Color(0xFF7A1F1F);
  static const Color coverGreen = Color(0xFF1F4A42);
  static const Color coverBlack = Color(0xFF1A1A1A);
  static const List<Color> coverPlaceholders = [
    coverBrown,
    coverRed,
    coverGreen,
    coverBlack,
  ];
}

// ألوان بتتغير حسب الثيم (فاتح / داكن) - استخدمها كده: context.bg, context.card ...
extension AppThemeColors on BuildContext {
  bool get _isDarkTheme => Theme.of(this).brightness == Brightness.dark;

  Color get bg => _isDarkTheme ? const Color(0xFF1C1714) : const Color(0xFFF5EDE4);
  Color get card => _isDarkTheme ? const Color(0xFF2A231F) : Colors.white;
  Color get surface => _isDarkTheme ? const Color(0xFF3B302A) : const Color(0xFFEDE0D0);
  Color get divider => _isDarkTheme ? const Color(0xFF3D322C) : const Color(0xFFE3D3C6);
  Color get subText => _isDarkTheme ? const Color(0xFFC9BDB4) : const Color(0xFF6A6A6A);
  Color get mainText => _isDarkTheme ? const Color(0xFFF2E9E2) : const Color(0xFF2B2B2B);
}

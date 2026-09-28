import 'package:flutter/material.dart';

/// ألوان التطبيق الموحدة — مستخرجة من الديزاين.
/// الفريق كله يستخدم من هنا بس، من غير ما حد يكتب Color(0x...) في مكان تاني.
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
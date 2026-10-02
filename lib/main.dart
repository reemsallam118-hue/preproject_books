import 'package:flutter/material.dart';
import 'package:preproject_books/Constants/app_colors.dart';
import 'package:preproject_books/Constants/books_information.dart';
import 'views/splash_view.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    scaffoldBackgroundColor: const Color(0xFFF5EDE4),
    colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary),
  );

  final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: const Color(0xFF1C1714),
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.primary,
      brightness: Brightness.dark,
    ),
  );

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: isDark,
      builder: (context, dark, _) {
        return ValueListenableBuilder<bool>(
          valueListenable: isArabic,
          builder: (context, arabic, child) {
            return MaterialApp(
              title: 'Bookia',
              debugShowCheckedModeBanner: false,
              theme: lightTheme,
              darkTheme: darkTheme,
              themeMode: dark ? ThemeMode.dark : ThemeMode.light,
              builder: (context, child) {
                // حجم الخط من الإعدادات + اتجاه الشاشة حسب اللغة
                return ValueListenableBuilder<double>(
                  valueListenable: fontScale,
                  builder: (context, scale, _) {
                    return MediaQuery(
                      data: MediaQuery.of(context)
                          .copyWith(textScaler: TextScaler.linear(scale)),
                      child: Directionality(
                        textDirection:
                        arabic ? TextDirection.rtl : TextDirection.ltr,
                        child: child!,
                      ),
                    );
                  },
                );
              },
              home: const SplashView(),
            );
          },
        );
      },
    );
  }
}

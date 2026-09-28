import 'package:flutter/material.dart';
import 'services/books_service.dart';
import 'views/home_view.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: isArabic,
      builder: (context, arabic, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          builder: (context, child) {
            return Directionality(
              textDirection: arabic ? TextDirection.rtl : TextDirection.ltr,
              child: child!,
            );
          },
          home: HomeView(),
        );
      },
    );
  }
}
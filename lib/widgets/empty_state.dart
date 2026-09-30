import 'package:flutter/material.dart';

/// شاشة "مفيش كتب" مشتركة بين الصفحات.
/// حطيه في: lib/widgets/empty_state.dart
class EmptyState extends StatelessWidget {
  final String title;
  final String subtitle;
  final String buttonText;
  final VoidCallback onPressed;

  /// لو عندك صورة لوجو جاهزة في assets، مرريها هنا وهتظهر بدل الأيقونة المرسومة.
  /// مثال: Image.asset('assets/empty_books.png', height: 140)
  final Widget? logo;

  const EmptyState({
    super.key,
    required this.title,
    required this.subtitle,
    required this.buttonText,
    required this.onPressed,
    this.logo,
  });

  static const Color _rose = Color(0xFFA8434B);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            logo ?? _defaultLogo(),
            const SizedBox(height: 24),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2B2B2B),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Color(0xFF8A8A8A), fontSize: 15),
            ),
            const SizedBox(height: 28),
            ElevatedButton(
              onPressed: onPressed,
              style: ElevatedButton.styleFrom(
                backgroundColor: _rose,
                foregroundColor: Colors.white,
                elevation: 0,
                padding:
                const EdgeInsets.symmetric(horizontal: 36, vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              child: Text(buttonText, style: const TextStyle(fontSize: 16)),
            ),
          ],
        ),
      ),
    );
  }

  // كتاب مفتوح + قلب + نجوم، قريبة من اللوجو اللي في الصورة
  Widget _defaultLogo() {
    return SizedBox(
      width: 150,
      height: 130,
      child: Stack(
        alignment: Alignment.center,
        children: [
          const Icon(Icons.menu_book_rounded, size: 120, color: Color(0xFFB9707A)),
          const Positioned(
            top: 22,
            child: Icon(Icons.favorite, size: 44, color: _rose),
          ),
          Positioned(
            top: 0,
            right: 6,
            child: Icon(Icons.auto_awesome,
                size: 20, color: _rose.withOpacity(0.5)),
          ),
          Positioned(
            bottom: 8,
            left: 4,
            child: Icon(Icons.auto_awesome,
                size: 14, color: _rose.withOpacity(0.4)),
          ),
        ],
      ),
    );
  }
}
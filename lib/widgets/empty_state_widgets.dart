import 'package:flutter/material.dart';
import 'package:preproject_books/Constants/app_colors.dart';

class EmptyState extends StatelessWidget {
  final String title;
  final String subtitle;
  final String buttonText;
  final VoidCallback onPressed;
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
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: const Duration(milliseconds: 700),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, 30 * (1 - value)),
            child: child,
          ),
        );
      },
      child: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              logo ?? _defaultLogo(context),
              const SizedBox(height: 32),
              Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  color: context.mainText,
                  height: 1.3,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                subtitle,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Color(0xFF8A8A8A),
                  fontSize: 15,
                  height: 1.6,
                ),
              ),
              const SizedBox(height: 32),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: _rose.withOpacity(0.35),
                      blurRadius: 16,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: ElevatedButton.icon(
                  onPressed: onPressed,
                  icon: const Icon(Icons.search_rounded, size: 20),
                  label: Text(
                    buttonText,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _rose,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 40, vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _defaultLogo(BuildContext context) {
    return SizedBox(
      width: 190,
      height: 170,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: 170,
            height: 170,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  _rose.withOpacity(0.16),
                  _rose.withOpacity(0.04),
                ],
              ),
            ),
          ),
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: context.surface,
            ),
          ),
          const Icon(Icons.menu_book_rounded,
              size: 84, color: Color(0xFFB9707A)),
          Positioned(
            top: 34,
            child: Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: context.bg,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: _rose.withOpacity(0.3),
                    blurRadius: 10,
                  ),
                ],
              ),
              child: const Icon(Icons.favorite, size: 28, color: _rose),
            ),
          ),
          Positioned(
            top: 8,
            right: 14,
            child: Icon(Icons.auto_awesome,
                size: 22, color: _rose.withOpacity(0.55)),
          ),
          Positioned(
            top: 44,
            left: 6,
            child: Icon(Icons.auto_awesome,
                size: 14, color: _rose.withOpacity(0.4)),
          ),
          Positioned(
            bottom: 12,
            right: 26,
            child: Icon(Icons.auto_awesome,
                size: 12, color: _rose.withOpacity(0.35)),
          ),
        ],
      ),
    );
  }
}
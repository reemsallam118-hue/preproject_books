import 'package:flutter/material.dart';
import 'package:preproject_books/Constants/app_colors.dart';
import 'package:preproject_books/Constants/books_information.dart';
import 'home_view.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView>
    with SingleTickerProviderStateMixin {
  static const Color _rose = Color(0xFFA8434B);

  late AnimationController controller;
  late Animation<double> logoScale;
  late Animation<double> logoFade;
  late Animation<double> textFade;
  late Animation<Offset> textSlide;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    );

    logoScale = Tween<double>(begin: 0.6, end: 1.0).animate(
      CurvedAnimation(
        parent: controller,
        curve: const Interval(0.0, 0.55, curve: Curves.easeOutBack),
      ),
    );
    logoFade = CurvedAnimation(
      parent: controller,
      curve: const Interval(0.0, 0.4, curve: Curves.easeOut),
    );

    textFade = CurvedAnimation(
      parent: controller,
      curve: const Interval(0.45, 1.0, curve: Curves.easeOut),
    );
    textSlide = Tween<Offset>(
      begin: const Offset(0, 0.4),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: controller,
        curve: const Interval(0.45, 1.0, curve: Curves.easeOutCubic),
      ),
    );

    controller.forward();

    Future.delayed(const Duration(milliseconds: 2800), () {
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          transitionDuration: const Duration(milliseconds: 600),
          pageBuilder: (context, animation, secondary) => HomeView(),
          transitionsBuilder: (context, animation, secondary, child) {
            return FadeTransition(opacity: animation, child: child);
          },
        ),
      );
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  Widget logo() {
    return Container(
      width: 132,
      height: 132,
      decoration: BoxDecoration(
        color: _rose,
        borderRadius: BorderRadius.circular(38),
        boxShadow: [
          BoxShadow(
            color: _rose.withOpacity(0.35),
            blurRadius: 28,
            offset: const Offset(0, 14),
          ),
        ],
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          const Icon(Icons.auto_stories_rounded, color: Colors.white, size: 68),
          Positioned(
            top: 26,
            right: 26,
            child: Icon(Icons.auto_awesome,
                color: Colors.white.withOpacity(0.85), size: 20),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.bg,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              FadeTransition(
                opacity: logoFade,
                child: ScaleTransition(scale: logoScale, child: logo()),
              ),
              const SizedBox(height: 30),
              FadeTransition(
                opacity: textFade,
                child: SlideTransition(
                  position: textSlide,
                  child: Column(
                    children: [
                      Text(
                        'Bookia',
                        style: TextStyle(
                          fontFamily: 'serif',
                          fontSize: 44,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 1.5,
                          color: context.mainText,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        tr('مكتبتك في جيبك', 'Your library in your pocket'),
                        style: const TextStyle(
                          fontSize: 15,
                          color: Color(0xFF8A8A8A),
                        ),
                      ),
                      const SizedBox(height: 44),
                      const SizedBox(
                        width: 22,
                        height: 22,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.5,
                          color: _rose,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

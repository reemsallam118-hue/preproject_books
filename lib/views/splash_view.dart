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

logoScale = Tween<double>(
begin: 0.6,
end: 1.0,
).animate(
CurvedAnimation(
parent: controller,
curve: const Interval(
0.0,
0.55,
curve: Curves.easeOutBack,
),
),
);

logoFade = CurvedAnimation(
parent: controller,
curve: const Interval(
0.0,
0.4,
curve: Curves.easeOut,
),
);

textFade = CurvedAnimation(
parent: controller,
curve: const Interval(
0.45,
1.0,
curve: Curves.easeOut,
),
);

textSlide = Tween<Offset>(
begin: const Offset(0, 0.4),
end: Offset.zero,
).animate(
CurvedAnimation(
parent: controller,
curve: const Interval(
0.45,
1.0,
curve: Curves.easeOutCubic,
),
),
);

controller.forward();

Future.delayed(const Duration(seconds: 3), () {
if (!mounted) return;

Navigator.pushReplacement(
context,
PageRouteBuilder(
transitionDuration: const Duration(milliseconds: 600),
pageBuilder: (context, animation, secondary) => HomeView(),
transitionsBuilder: (context, animation, secondary, child) {
return FadeTransition(
opacity: animation,
child: child,
);
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
width: 138,
height: 138,
decoration: BoxDecoration(
gradient: const LinearGradient(
begin: Alignment.topLeft,
end: Alignment.bottomRight,
colors: [
Color(0xFFB9525A),
Color(0xFFA8434B),
],
),
borderRadius: BorderRadius.circular(42),
boxShadow: [
BoxShadow(
color: _rose.withOpacity(0.25),
blurRadius: 35,
spreadRadius: 4,
offset: const Offset(0, 16),
),
],
),
child: Stack(
alignment: Alignment.center,
children: [
Container(
width: 104,
height: 104,
decoration: BoxDecoration(
border: Border.all(
color: Colors.white.withOpacity(0.14),
width: 1.5,
),
borderRadius: BorderRadius.circular(32),
),
),
const Icon(
Icons.auto_stories_rounded,
color: Colors.white,
size: 70,
),
Positioned(
top: 25,
right: 25,
child: Icon(
Icons.auto_awesome_rounded,
color: Colors.white.withOpacity(0.9),
size: 21,
),
),
],
),
);
}

Widget backgroundDecoration({
required double size,
required double top,
required double left,
required double opacity,
}) {
return Positioned(
top: top,
left: left,
child: Container(
width: size,
height: size,
decoration: BoxDecoration(
shape: BoxShape.circle,
color: _rose.withOpacity(opacity),
),
),
);
}

@override
Widget build(BuildContext context) {
return Scaffold(
body: Stack(
children: [
// Background
Container(
decoration: BoxDecoration(
gradient: RadialGradient(
center: Alignment.center,
radius: 1.1,
colors: [
context.bg,
context.bg,
],
),
),
),

// Decorative circles
backgroundDecoration(
size: 180,
top: -80,
left: -70,
opacity: 0.055,
),

backgroundDecoration(
size: 220,
top: 120,
left: -150,
opacity: 0.035,
),

backgroundDecoration(
size: 160,
top: 520,
left: 330,
opacity: 0.045,
),

backgroundDecoration(
size: 240,
top: 650,
left: 250,
opacity: 0.035,
),

SafeArea(
child: Center(
child: Column(
mainAxisSize: MainAxisSize.min,
children: [
FadeTransition(
opacity: logoFade,
child: ScaleTransition(
scale: logoScale,
child: logo(),
),
),

const SizedBox(height: 32),

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
fontSize: 46,
fontWeight: FontWeight.w800,
letterSpacing: 1.8,
color: context.mainText,
),
),

const SizedBox(height: 8),

Text(
tr(
'مكتبتك في جيبك',
'Your library in your pocket',
),
style: TextStyle(
fontSize: 20,
fontWeight: FontWeight.w500,
letterSpacing: 0.3,
color: context.mainText.withOpacity(0.55),
),
),

const SizedBox(height: 42),

Container(
width: 42,
height: 42,
padding: const EdgeInsets.all(10),
decoration: BoxDecoration(
color: _rose.withOpacity(0.08),
shape: BoxShape.circle,
),
child: const CircularProgressIndicator(
strokeWidth: 2.2,
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

// Bottom branding
Positioned(
bottom: 28,
left: 0,
right: 0,
child: Text(
'READ • DISCOVER • ENJOY',
textAlign: TextAlign.center,
style: TextStyle(
fontSize: 15,
fontWeight: FontWeight.w600,
letterSpacing: 2.2,
color: context.mainText.withOpacity(0.25),
),
),
),
],
),
);
}
}

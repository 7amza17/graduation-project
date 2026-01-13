import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'welcome_page.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
  late AnimationController _splashController;
  late AnimationController _loaderController;

  // التحكم بالتباعد بين النقاط
  double dotSpacing = 10; // ← عدّل الرقم اللي بدك إياه

  @override
  void initState() {
    super.initState();

    // Splash مدة
    _splashController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..forward();

    _splashController.addStatusListener((status) {
      if (status == AnimationStatus.completed && mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const WelcomePage()),
        );
      }
    });

    // Loader Animation (YouTube-like)
    _loaderController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat();
  }

  @override
  void dispose() {
    _splashController.dispose();
    _loaderController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
          children: [
            // -----------------------------
            //       اللوغو ثابت
            // -----------------------------
            Center(
              child: SizedBox(
                height: 150,
                child: Image.asset(
                  "assets/images/logo1.png",
                  fit: BoxFit.contain,
                ),
              ),
            ),

            // -----------------------------
            //   Loader مثل يوتيوب (3 نقاط)
            // -----------------------------
            Positioned(
              bottom: height * 0.28,
              left: 0,
              right: 0,
              child: SizedBox(
                height: 40,
                child: AnimatedBuilder(
                  animation: _loaderController,
                  builder: (context, child) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildYoutubeDot(_loaderController.value, 0.00,
                            color: const Color(0xFFBDBDBD)),
                        SizedBox(width: dotSpacing),
                       _buildYoutubeDot(
  _loaderController.value,
  0.18,
  color: const Color.fromRGBO(0, 150, 136, 1),
),
                        SizedBox(width: dotSpacing),
                        _buildYoutubeDot(_loaderController.value, 0.36,
                            color: const Color(0xFFBDBDBD)),
                      ],
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // -----------------------------
  //      نقطة Loader مثل يوتيوب
  //  (نبض + طلوع/نزول ناعم)
  // -----------------------------
  Widget _buildYoutubeDot(double t, double shift, {required Color color}) {
    // موجة ناعمة 0..1
    final v = (math.sin((t + shift) * 2 * math.pi) + 1) / 2;

    // نبض الحجم + حركة بسيطة للأعلى
    final double scale = 0.85 + (0.45 * v); // 0.85 .. 1.30
    final double dy = -6 * v; // تطلع لفوق شوي
    final double opacity = 0.55 + (0.45 * v); // 0.55 .. 1.0

    return Transform.translate(
      offset: Offset(0, dy),
      child: Opacity(
        opacity: opacity,
        child: Transform.scale(
          scale: scale,
          child: Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.10),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

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


  double dotSpacing = 10;

  @override
  void initState() {
    super.initState();

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
      
            Center(
              child: SizedBox(
                height: 150,
                child: Image.asset(
                  "assets/images/logo1.png",
                  fit: BoxFit.contain,
                ),
              ),
            ),

 
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


  Widget _buildYoutubeDot(double t, double shift, {required Color color}) {
    final v = (math.sin((t + shift) * 2 * math.pi) + 1) / 2;

    final double scale = 0.85 + (0.45 * v); 
    final double dy = -6 * v; 
    final double opacity = 0.55 + (0.45 * v); 

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

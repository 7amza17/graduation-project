import 'package:flutter/material.dart';
import 'promo_home_page.dart'; // ← اسم الصفحة التي تريد الانتقال إليها

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  void _goToMainMenu(BuildContext context) {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const PromoHomePage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bg = const Color(0xFFF3F7FA);

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: bg,
        body: GestureDetector(
          onTap: () => _goToMainMenu(context), // الانتقال عند الضغط في أي مكان
          behavior: HitTestBehavior.opaque,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16),
            child: Column(
              children: [
                const SizedBox(height: 16),

                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 140,
                        child: Image.asset(
                          "assets/images/logo1.png",
                          fit: BoxFit.contain,
                        ),
                      ),
                      const SizedBox(height: 28),

                      const Text(
                        "مرحباً بك في تطبيق \nSmadi Real Estate",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Color.fromRGBO(0, 150, 136, 1),
                        ),
                      ),

                      const SizedBox(height: 14),

                      const Text(
                        "شكراً لاختيارك تطبيقنا لاستكشاف أفضل العقارات "
                        "للبيع والإيجار بتجربة حديثة وسهلة.",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 15,
                          height: 1.6,
                          color: Colors.black87,
                        ),
                      ),

                      const SizedBox(height: 32),

                      ElevatedButton(
                        onPressed: () => _goToMainMenu(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.teal,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 48,
                            vertical: 14,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(22),
                          ),
                          elevation: 3,
                        ),
                        child: const Text(
                          "ابدأ التصفح",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const Padding(
                  padding: EdgeInsets.only(bottom: 12),
                  child: Text(
                    "يمكنك أيضاً النقر في أي مكان على الشاشة للمتابعة",
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

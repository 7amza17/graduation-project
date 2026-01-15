import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter/services.dart'; 

class DeveloperContactPage extends StatelessWidget {
  const DeveloperContactPage({super.key});

  Future<void> _openUrl(String url) async {
    final uri = Uri.parse(url);
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  Future<void> _callPhone(String phone) async {
    final uri = Uri.parse('tel:$phone');
    await launchUrl(uri);
  }

  Future<void> _sendEmail(String email) async {
    final uri = Uri(
      scheme: 'mailto',
      path: email,
    );
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  // واتساب
  Future<void> _openWhatsApp(String phone) async {
    final uri = Uri.parse('https://wa.me/$phone');
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  @override
  Widget build(BuildContext context) {
    final Color bg = const Color(0xFFF3F7FA);
    final Color teal = Colors.teal;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: bg,
        appBar: AppBar(
          backgroundColor: bg,
          elevation: 0,
          centerTitle: true,
          title: const Text(
            "التواصل مع المطوّر",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.teal,
            ),
          ),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  gradient: const LinearGradient(
                    begin: Alignment.centerRight,
                    end: Alignment.centerLeft,
                    colors: [
                      Color(0xFF006D68),
                      Color(0xFF16A6A0),
                    ],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.18),
                      blurRadius: 18,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          width: 70,
                          height: 70,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white.withOpacity(0.10),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.35),
                              width: 1,
                            ),
                          ),
                          child: ClipOval(
                            child: Image.asset(
                              "assets/images/dev_hamza.png",
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),

                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: const [
                              Text(
                                "حمزة الصمادي",
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  fontSize: 23,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                "مطور تطبيقات",
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Color(0xFFE0F7F7),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 12),

                    const Text(
                      "إذا أعجبك التطبيق أو لديك فكرة تطوير أو تعاون، يسعدني جداً تواصلك معي عبر أي وسيلة من الوسائل التالية.",
                      textAlign: TextAlign.right,
                      style: TextStyle(
                        fontSize: 13.5,
                        color: Color(0xFFEAFDFD),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 26),

              const Text(
                "قنوات رئيسية",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Colors.teal,
                ),
              ),
              const SizedBox(height: 10),

              Row(
                children: [
                  Expanded(
                    child: _buildPrimaryActionButton(
                      title: "البريد الإلكتروني",
                      icon: Icons.email_rounded,
                      color: Colors.redAccent,
                      onTap: () async {
                        final Uri emailUri = Uri(
                          scheme: 'mailto',
                          path: 'smadi4209@gmail.com',
                        );
                        await launchUrl(
                          emailUri,
                          mode: LaunchMode.externalApplication,
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildPrimaryActionButton(
                      title: "LinkedIn",
                      icon: FontAwesomeIcons.linkedin,
                      color: const Color(0xFF0A66C2),
                      onTap: () {
                        _openUrl(
                          "https://www.linkedin.com/in/hamza-alsmadi-4632a6304/",
                        );
                      },
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              _buildFullWidthSocialCentered(
                title: "اتصال هاتفي",
                icon: Icons.phone_in_talk,
                color: Colors.green.shade600,
                onTap: () => _callPhone("+963980395358"),
              ),

              const SizedBox(height: 28),

              const Text(
                "حسابات التواصل الاجتماعي",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Colors.teal,
                ),
              ),
              const SizedBox(height: 12),

              Row(
                children: [
                  Expanded(
                    child: _buildSocialCardFlexible(
                      title: "Facebook",
                      icon: FontAwesomeIcons.facebookF,
                      color: const Color(0xFF1877F2),
                      onTap: () {
                        _openUrl(
                          "https://www.facebook.com/hamza.alsmadi.104?mibextid=ZbWKwL",
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildSocialCardFlexible(
                      title: "WhatsApp",
                      icon: FontAwesomeIcons.whatsapp,
                      color: const Color(0xFF25D366),
                      onTap: () {
                        _openWhatsApp("963980395358");
                      },
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              _buildFullWidthSocialCentered(
                title: "Instagram",
                icon: FontAwesomeIcons.instagram,
                color: const Color(0xFFE1306C),
                onTap: () {
                  _openUrl(
                    "https://www.instagram.com/_7.hs_?igsh=MWp5MWk3a2lxZm85Mw",
                  );
                },
              ),

              const SizedBox(height: 30),

              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: teal.withOpacity(0.12)),
                ),
                child: const Text(
                  "🌟 رسالة صغيرة قد تكون بداية مشروع كبير  🌟",
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    fontSize: 13.5,
                    color: Color.fromARGB(221, 0, 0, 0),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPrimaryActionButton({
    required String title,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return _UxPress(
      borderRadius: 18,
      splashBaseColor: color,
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
          border: Border.all(
            color: color.withOpacity(0.18),
            width: 0.8,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: color.withOpacity(0.10),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: 22,
                color: color,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14.5,
                fontWeight: FontWeight.w600,
                color: Colors.teal.shade800,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSocialCardFlexible({
    required String title,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return _UxPress(
      borderRadius: 18,
      splashBaseColor: color,
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
          border: Border.all(
            color: color.withOpacity(0.18),
            width: 0.8,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: color.withOpacity(0.12),
              ),
              child: Icon(
                icon,
                size: 22,
                color: color,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 13.5,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFullWidthSocialCentered({
    required String title,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return _UxPress(
      borderRadius: 18,
      splashBaseColor: color,
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
          border: Border.all(
            color: color.withOpacity(0.22),
            width: 0.9,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: color.withOpacity(0.12),
              ),
              child: Icon(
                icon,
                size: 22,
                color: color,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14.5,
                fontWeight: FontWeight.w700,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }
}


class _UxPress extends StatefulWidget {
  final Widget child;
  final VoidCallback onTap;
  final double borderRadius;
  final Color splashBaseColor;

  const _UxPress({
    required this.child,
    required this.onTap,
    this.borderRadius = 18,
    this.splashBaseColor = Colors.teal,
  });

  @override
  State<_UxPress> createState() => _UxPressState();
}

class _UxPressState extends State<_UxPress> with SingleTickerProviderStateMixin {
  late final AnimationController _c;
  late final Animation<double> _s;

  @override
  void initState() {
    super.initState();
    _c = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 120),
    );
    _s = Tween<double>(begin: 1.0, end: 0.965).animate(
      CurvedAnimation(parent: _c, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  void _down() {
    HapticFeedback.mediumImpact();
    if (_c.status != AnimationStatus.forward &&
        _c.status != AnimationStatus.completed) {
      _c.forward();
    }
  }

  void _up() {
    if (_c.status != AnimationStatus.reverse &&
        _c.status != AnimationStatus.dismissed) {
      _c.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    final r = BorderRadius.circular(widget.borderRadius);

    return Listener(
      behavior: HitTestBehavior.translucent,
      onPointerDown: (_) => _down(),
      onPointerUp: (_) => _up(),
      onPointerCancel: (_) => _up(),
      child: AnimatedBuilder(
        animation: _s,
        builder: (_, child) => Transform.scale(scale: _s.value, child: child),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: r,
            splashColor: widget.splashBaseColor.withOpacity(0.14),
            highlightColor: widget.splashBaseColor.withOpacity(0.08),
            onTap: () {
              HapticFeedback.heavyImpact();
              widget.onTap();
            },
            child: widget.child,
          ),
        ),
      ),
    );
  }
}

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // للهزّة
import 'package:url_launcher/url_launcher.dart';
import 'property_details_sheet.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart'; // ✅ واتساب

class PropertyCard extends StatefulWidget {
  final String title;
  final String tag;
  final Color tagColor;
  final String price;
  final String area;
  final String location;

  /// وصف مختصر للعقار
  final String description;

  /// رقم الهاتف (يفضّل بصيغة دولية مثل: +9639xxxxxxx)
  final String phone;

  /// صور متعددة للعقار
  final List<String> images;

  const PropertyCard({
    super.key,
    required this.title,
    required this.tag,
    required this.tagColor,
    required this.price,
    required this.area,
    required this.location,
    required this.description,
    required this.phone,
    required this.images,
  });

  @override
  State<PropertyCard> createState() => _PropertyCardState();
}

class _PropertyCardState extends State<PropertyCard>
    with SingleTickerProviderStateMixin {
  late final PageController _pageController;
  late AnimationController _pressController;
  late Animation<double> _scaleAnimation;

  int _currentIndex = 0;
  Timer? _autoTimer;

  // ✅ لمنع فتح التفاصيل عند الضغط على واتساب
  bool _blockCardTap = false;

  @override
  void initState() {
    super.initState();

    _pageController = PageController();
    _startAutoSlide();

    // أنيميشن الضغط
    _pressController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 120),
    );

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.97, // قوة الضغط (0.95 أقوى)
    ).animate(
      CurvedAnimation(
        parent: _pressController,
        curve: Curves.easeOut,
      ),
    );
  }

  void _startAutoSlide() {
    if (widget.images.length <= 1) return;

    _autoTimer?.cancel();
    _autoTimer = Timer.periodic(const Duration(seconds: 4), (_) {
      if (!_pageController.hasClients) return;
      final next = (_currentIndex + 1) % widget.images.length;
      _pageController.animateToPage(
        next,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void dispose() {
    _autoTimer?.cancel();
    _pageController.dispose();
    _pressController.dispose();
    super.dispose();
  }

  void _openDetailsSheet() {
    // 📳 ارتجاج عند فتح الكارد
    HapticFeedback.heavyImpact();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return PropertyDetailsSheet(
          title: widget.title,
          tag: widget.tag,
          tagColor: widget.tagColor,
          price: widget.price,
          area: widget.area,
          location: widget.location,
          phone: widget.phone,
          images: widget.images,
          description: widget.description,
          imagePath: '',
        );
      },
    );
  }

  /// ✅ نفس الواتساب اللي بالداخل: ثابت + رسالة جاهزة مضمونة
  Future<void> _openWhatsApp() async {
    final rawPhone = widget.phone.trim();
    if (rawPhone.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('لا يوجد رقم واتساب مضاف لهذا العقار')),
      );
      return;
    }

    final phone = rawPhone.replaceAll(RegExp(r'[^0-9]'), '');

    final message = '''
السلام عليكم،
أنا زبون في Smadi Real estate 
مُهتم بالعقار التالي:
${widget.title}
الموقع: ${widget.location}
السعر: ${widget.price}

أرجو منك التواصل معي ، شكراً.
''';

    final encodedMessage = Uri.encodeComponent(message);

    final uri = Uri.parse(
      "https://api.whatsapp.com/send?phone=$phone&text=$encodedMessage",
    );

    try {
      final launched = await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );
      if (!launched) throw 'could not launch';
    } catch (_) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('تعذّر فتح واتساب.'),
        ),
      );
    }
  }

  void _pressDown() {
    if (_pressController.status != AnimationStatus.forward &&
        _pressController.status != AnimationStatus.completed) {
      _pressController.forward();
    }
    HapticFeedback.mediumImpact(); // إحساس لمس
  }

  void _pressUp() {
    if (_pressController.status != AnimationStatus.reverse &&
        _pressController.status != AnimationStatus.dismissed) {
      _pressController.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    final cardRadius = BorderRadius.circular(20);

    // ✅ Listener يضمن إن الضغط يشتغل حتى فوق الصورة (PageView كان يبلع GestureDetector)
    return Listener(
      behavior: HitTestBehavior.translucent,
      onPointerDown: (_) => _pressDown(),
      onPointerUp: (_) => _pressUp(),
      onPointerCancel: (_) => _pressUp(),
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: child,
          );
        },
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: cardRadius,
            // تفاعل بصري أوضح
            splashColor: Colors.teal.withOpacity(0.14),
            highlightColor: Colors.teal.withOpacity(0.08),
            onTap: () {
              if (_blockCardTap) return; // ✅ منع فتح التفاصيل عند ضغط واتساب
              _openDetailsSheet();
            },
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: cardRadius,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.06),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // ====== الصور + النقاط ======
                  ClipRRect(
                    borderRadius:
                        const BorderRadius.vertical(top: Radius.circular(20)),
                    child: Stack(
                      children: [
                        AspectRatio(
                          aspectRatio: 16 / 9,
                          child: PageView.builder(
                            controller: _pageController,
                            itemCount: widget.images.length,
                            onPageChanged: (index) {
                              setState(() => _currentIndex = index);
                            },
                            itemBuilder: (context, index) {
                              return Image.asset(
                                widget.images[index],
                                fit: BoxFit.cover,
                              );
                            },
                          ),
                        ),

                        // ✅ طبقة تلتقط Tap فوق الصورة (بدون ما تمنع السحب)
                        Positioned.fill(
                          child: GestureDetector(
                            behavior: HitTestBehavior.translucent,
                            onTapDown: (_) => _pressDown(),
                            onTapCancel: () => _pressUp(),
                            onTapUp: (_) {
                              _pressUp();
                              _openDetailsSheet();
                            },
                          ),
                        ),

                        // التاغ
                        Positioned(
                          top: 10,
                          right: 10,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: widget.tagColor.withOpacity(0.9),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              widget.tag,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),

                        // نقاط الصور (✅ نفس تأثير النقاط اللي برا: كب/صغار + تمدد)
                        Positioned(
                          bottom: 8,
                          left: 0,
                          right: 0,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List.generate(
                              widget.images.length,
                              (i) => AnimatedContainer(
                                duration: const Duration(milliseconds: 300),
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 4),
                                width: _currentIndex == i ? 14 : 8,
                                height: 8,
                                decoration: BoxDecoration(
                                  color: _currentIndex == i
                                      ? Colors.white
                                      : Colors.white.withOpacity(0.45),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // ====== النصوص + الوصف + السعر + الأزرار ======
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(12, 10, 12, 8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          // ✅ العنوان عاليمين 100%
                          Align(
                            alignment: Alignment.centerRight,
                            child: Text(
                              widget.title,
                              textAlign: TextAlign.right,
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                                color: Colors.black87,
                              ),
                            ),
                          ),
                          const SizedBox(height: 4),

                          // ✅ الموقع عاليمين 100%
                          Align(
                            alignment: Alignment.centerRight,
                            child: Text(
                              widget.location,
                              textAlign: TextAlign.right,
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.grey.shade700,
                              ),
                            ),
                          ),

                          const SizedBox(height: 6),

                          // (اختياري لكن أحسن) الوصف عاليمين 100%
                          Align(
                            alignment: Alignment.centerRight,
                            child: Text(
                              widget.description,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.right,
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey.shade800,
                              ),
                            ),
                          ),

                          // ✅ بدل Spacer لتجنب Overflow
                          const SizedBox(height: 12),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              // السعر + المساحة
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    widget.price,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.teal,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    widget.area,
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey.shade700,
                                    ),
                                  ),
                                ],
                              ),

                              // واتساب فوق + التفاصيل تحت
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  // ✅ واتساب فوق (الأيقونة يمين والنص يسار)
                                  InkWell(
                                    onTapDown: (_) =>
                                        setState(() => _blockCardTap = true),
                                    onTapCancel: () =>
                                        setState(() => _blockCardTap = false),
                                    onTapUp: (_) =>
                                        setState(() => _blockCardTap = false),
                                    onTap: _openWhatsApp,
                                    borderRadius: BorderRadius.circular(30),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        textDirection: TextDirection.rtl,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          FaIcon(
                                            FontAwesomeIcons.whatsapp,
                                        color: const Color.fromRGBO(0, 150, 136, 1),
                                            size: 16,
                                          ),
                                          const SizedBox(width: 6),
                                          const Text(
                                            ' التواصل',
                                            style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w700,
                                              color: Colors.teal,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),

                                  const SizedBox(height: 1),

                                  // ✅ التفاصيل تحت
                                  SizedBox(
                                    height: 34,
                                    child: TextButton.icon(
                                      onPressed: _openDetailsSheet,
                                      icon: const Icon(Icons.info_outline,size: 16),
                                      label: const Text(
                                        'التفاصيل',
                                        style: TextStyle(fontSize: 12),
                                      ),
                                      style: TextButton.styleFrom(
                                        foregroundColor: const Color.fromRGBO(0, 150, 136, 1),
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8, vertical: 0),
                                        tapTargetSize:
                                            MaterialTapTargetSize.shrinkWrap,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

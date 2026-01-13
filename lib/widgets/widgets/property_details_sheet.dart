import 'dart:async';
import 'package:SMADI/managers/favorites_manager.dart';
import 'package:SMADI/widgets/vr_tour_page.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

// ✅ أيقونة واتساب
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class PropertyDetailsSheet extends StatefulWidget {
  final String title;
  final String tag;
  final Color tagColor;
  final String price;
  final String area;
  final String location;
  final String phone;
  final List<String> images;

  final String description;

  const PropertyDetailsSheet({
    super.key,
    required this.title,
    required this.tag,
    required this.tagColor,
    required this.price,
    required this.area,
    required this.location,
    required this.phone,
    required this.images,
    required this.description,
    required String imagePath,
  });

  @override
  State<PropertyDetailsSheet> createState() => _PropertyDetailsSheetState();
}

class _PropertyDetailsSheetState extends State<PropertyDetailsSheet> {
  final PageController _pageController = PageController();
  int currentIndex = 0;

  Timer? _autoTimer;
  bool _autoPlayEnabled = true;

  bool isFavorite = false;

  FavoriteProperty get _favoriteModel => FavoriteProperty(
        title: widget.title,
        tag: widget.tag,
        tagColor: widget.tagColor,
        price: widget.price,
        area: widget.area,
        location: widget.location,
        phone: widget.phone,
        description: widget.description,
        images: widget.images,
      );

  @override
  void initState() {
    super.initState();
    isFavorite = FavoritesManager.instance.isFavorite(_favoriteModel);
    _startAutoPlay();
  }

  void _startAutoPlay() {
    if (widget.images.length <= 1) return;

    _autoTimer?.cancel();
    _autoTimer = Timer.periodic(const Duration(seconds: 3), (_) {
      if (!_autoPlayEnabled || !mounted) return;

      final next = (currentIndex + 1) % widget.images.length;

      _pageController.animateToPage(
        next,
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOut,
      );
    });
  }

  void _stopAutoPlay() {
    _autoPlayEnabled = false;
    _autoTimer?.cancel();
  }

  void _toggleFavorite() {
    FavoritesManager.instance.toggleFavorite(_favoriteModel);
    setState(() {
      isFavorite = FavoritesManager.instance.isFavorite(_favoriteModel);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          isFavorite
              ? 'تمت إضافة العقار إلى المفضّلة'
              : 'تمت إزالة العقار من المفضّلة',
        ),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  Future<void> _openWhatsApp() async {
    final rawPhone = widget.phone.trim();
    if (rawPhone.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("رقم الهاتف غير متوفر")),
      );
      return;
    }

    final phone = rawPhone.replaceAll(RegExp(r'[^0-9]'), '');

    final message = '''
مرحباً،
أنا مهتم بالعقار التالي:
${widget.title}
الموقع: ${widget.location}
السعر: ${widget.price}

أرجو التواصل معي، شكراً.
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
          content: Text("تعذّر فتح واتساب. تأكد من تثبيته."),
        ),
      );
    }
  }

  LatLng? _coordsFromLocation(String location) {
    final loc = location.toLowerCase();

    if (loc.contains('دمشق')) return const LatLng(33.5138, 36.2765);
    if (loc.contains('حلب')) return const LatLng(36.2021, 37.1343);
    if (loc.contains('حمص')) return const LatLng(34.7324, 36.7138);
    if (loc.contains('اللاذقية')) return const LatLng(35.5306, 35.7906);
    if (loc.contains('درعا')) return const LatLng(32.6250, 36.1050);

    return null;
  }

  Future<void> _openGoogleMaps(LatLng p) async {
    final uri = Uri.parse(
      "https://www.google.com/maps/search/?api=1&query=${p.latitude},${p.longitude}",
    );
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  @override
  void dispose() {
    _autoTimer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final LatLng? coords = _coordsFromLocation(widget.location);

    return DraggableScrollableSheet(
      initialChildSize: 0.75,
      minChildSize: 0.75,
      maxChildSize: 1,
      expand: false,
      builder: (context, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: Color(0xFFF3F7FA),
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Directionality(
            textDirection: TextDirection.rtl,
            child: Column(
              children: [
                const SizedBox(height: 10),
                Container(
                  width: 50,
                  height: 5,
                  decoration: BoxDecoration(
                    color: Colors.grey[400],
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                const SizedBox(height: 10),

                Expanded(
                  child: ListView(
                    controller: scrollController,
                    padding: const EdgeInsets.all(16),
                    children: [
                      // سلايدر الصور
                      SizedBox(
                        height: 240,
                        child: GestureDetector(
                          onTapDown: (_) => _stopAutoPlay(),
                          onPanDown: (_) => _stopAutoPlay(),
                          child: PageView.builder(
                            controller: _pageController,
                            itemCount: widget.images.length,
                            onPageChanged: (i) {
                              setState(() => currentIndex = i);
                            },
                            itemBuilder: (context, index) {
                              return ClipRRect(
                                borderRadius: BorderRadius.circular(18),
                                child: Image.asset(
                                  widget.images[index],
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                ),
                              );
                            },
                          ),
                        ),
                      ),

                      const SizedBox(height: 12),

                      // ✅ المؤشرات (نفس الكارد)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          widget.images.length,
                          (i) => AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            width: currentIndex == i ? 14 : 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: currentIndex == i
                                  ? Colors.teal
                                  : Colors.teal.withOpacity(0.3),
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 35),

                      // معلومات العقار
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              widget.title,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          GestureDetector(
                            onTap: _toggleFavorite,
                            child: Icon(
                              isFavorite
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                              size: 28,
                              color: isFavorite
                                  ? Colors.red
                                  : Colors.grey[600],
                            ),
                          ),
                          const SizedBox(width: 12),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 6),
                            decoration: BoxDecoration(
                              color: widget.tagColor.withOpacity(0.12),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                  color: widget.tagColor, width: 0.6),
                            ),
                            child: Text(
                              widget.tag,
                              style: TextStyle(
                                fontSize: 13,
                                color: widget.tagColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 12),

                      Row(
                        children: [
                          Icon(Icons.monetization_on_outlined,
                              size: 20, color: Colors.grey[700]),
                          const SizedBox(width: 6),
                          Text(
                            widget.price,
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.teal,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 8),

                      Row(
                        children: [
                          Icon(Icons.square_foot,
                              size: 20, color: Colors.grey[700]),
                          const SizedBox(width: 6),
                          Text(
                            widget.area,
                            style: const TextStyle(
                              fontSize: 14,
                              color: Color.fromARGB(255, 88, 87, 87),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 8),

                      Row(
                        children: [
                          Icon(Icons.location_on_outlined,
                              size: 20, color: Colors.grey[700]),
                          const SizedBox(width: 6),
                          Text(
                            widget.location,
                            style: const TextStyle(
                              fontSize: 14,
                              color: Color.fromARGB(255, 98, 94, 94),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 20),

                      const Text(
                        "تواصل عبر الواتساب",
                        style: TextStyle(
                          color: Colors.teal,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 6),

                      // ✅ الأيقونة صارت واتساب
                      Row(
                        children: [
                          IconButton(
                            onPressed: _openWhatsApp,
                            icon: const FaIcon(
                              FontAwesomeIcons.whatsapp,
                              color: Colors.teal,
                              size: 22,
                            ),
                            tooltip: "واتساب",
                          ),
                          const SizedBox(width: 2),
                          GestureDetector(
                            onTap: _openWhatsApp,
                            child: Directionality(
                              textDirection: TextDirection.ltr,
                              child: Text(
                                widget.phone,
                                style: const TextStyle(
                                  fontSize: 16,
                                  height: 1.5,
                                  color: Colors.teal,
                                  decoration: TextDecoration.underline,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 14),

                      // زر الجولة الافتراضية (Outlined مثل زر الماب)
                      OutlinedButton.icon(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => VRTourPage(
                                title: widget.title,
                                images: widget.images,
                              ),
                            ),
                          );
                        },
                        icon: const Icon(Icons.threesixty_rounded, size: 20),
                        label: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: const [
                            Text(
                              "عرض الجولة الافتراضية ",
                              style: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.w600),
                            ),
                            Text(
                              "360",
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w800,
                                color: Colors.teal,
                              ),
                            ),
                            Text(
                              "°",
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                color: Colors.teal,
                              ),
                            ),
                          ],
                        ),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.teal,
                          side: const BorderSide(
                              color: Colors.teal, width: 1.2),
                          minimumSize: const Size(double.infinity, 48),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      const Text(
                        "وصف مختصر للعقار:",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        widget.description,
                        style: const TextStyle(fontSize: 14, height: 1.5),
                      ),

                      const SizedBox(height: 18),

                      const Text(
                        "الموقع على الخريطة:",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),

                      if (coords == null)
                        Container(
                          height: 200,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                                color: Colors.black.withOpacity(0.06)),
                          ),
                          child: const Text(
                            "لم يتم تحديد إحداثيات لهذا العقار",
                            style: TextStyle(color: Colors.black54),
                          ),
                        )
                      else
                        ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: SizedBox(
                            height: 230,
                            child: FlutterMap(
                              options: MapOptions(
                                initialCenter: coords,
                                initialZoom: 14,
                                interactionOptions: const InteractionOptions(
                                  flags: InteractiveFlag.all,
                                ),
                              ),
                              children: [
                                TileLayer(
                                  urlTemplate:
                                      "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
                                  userAgentPackageName:
                                      "com.smadi.realestate",
                                ),
                                MarkerLayer(
                                  markers: [
                                    Marker(
                                      point: coords,
                                      width: 44,
                                      height: 44,
                                      child: const Icon(
                                        Icons.location_pin,
                                        size: 44,
                                        color: Colors.teal,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),

                      if (coords != null) ...[
                        const SizedBox(height: 10),
                        OutlinedButton.icon(
                          onPressed: () => _openGoogleMaps(coords),
                          icon: const Icon(Icons.map_outlined, size: 18),
                          label: const Text("فتح في خرائط Google"),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.teal,
                            side: const BorderSide(color: Colors.teal),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            minimumSize: const Size(double.infinity, 48),
                          ),
                        ),
                      ],

                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

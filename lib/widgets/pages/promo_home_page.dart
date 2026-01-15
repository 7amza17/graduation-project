import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:SMADI/managers/favorites_page.dart';
import 'main_menu_page.dart';
import 'developer_contact_page.dart';
import 'package:flutter/services.dart';

class PromoHomePage extends StatefulWidget {
  const PromoHomePage({super.key});

  @override
  State<PromoHomePage> createState() => _PromoHomePageState();
}

class _PromoHomePageState extends State<PromoHomePage>
    with SingleTickerProviderStateMixin {
  final PageController _adsController = PageController();
  int _currentIndex = 0;
  Timer? _timer;
  bool _isContactSheetOpen = false;

  late AnimationController _arrowController;
  late Animation<double> _bigArrowMove;
  late Animation<double> _smallArrowMove;

  final List<String> adsImages = [
    "assets/images/ad1.jpg",
    "assets/images/ad2.jpg",
    "assets/images/ad3.jpg",
    "assets/images/ad4.jpg",
    "assets/images/ad5.jpg",
  ];

  @override
  void initState() {
    super.initState();

     _arrowController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat(reverse: true);

    _bigArrowMove = Tween<double>(begin: 0, end: -6).animate(
      CurvedAnimation(parent: _arrowController, curve: Curves.easeInOut),
    );

    _smallArrowMove = Tween<double>(begin: 0, end: -2).animate(
      CurvedAnimation(parent: _arrowController, curve: Curves.easeInOut),
    );

     _timer = Timer.periodic(const Duration(milliseconds: 3500), (_) {
      if (!_adsController.hasClients) return;
      int next = (_currentIndex + 1) % adsImages.length;

      _adsController.animateToPage(
        next,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _adsController.dispose();
    _arrowController.dispose();
    super.dispose();
  }

  void _onSectionSelected(String section) {
    final int initialPage = section == 'rent' ? 1 : 0;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => SaleRentHostPage(initialPage: initialPage),
      ),
    );
  }

   Future<void> _openSearch() async {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => PropertySearchPage(
          allProperties: AppPropertiesData.allProperties,
          logoAsset: "assets/images/logo1.png",
          titleText: "البحث",
        ),
      ),
    );
  }

   Future<void> _openDeveloperContactSheet() async {
    if (_isContactSheetOpen) return;

    setState(() => _isContactSheetOpen = true);
    HapticFeedback.mediumImpact();

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black54,
      builder: (ctx) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: DraggableScrollableSheet(
            initialChildSize: 0.82,
            minChildSize: 0.35,
            maxChildSize: 1.0,
            snap: true,
            snapSizes: const [0.5, 0.82, 1.0],
            expand: false,
            builder: (context, scrollController) {
              return ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(26),
                ),
                child: Material(
                  color: Colors.white,
                  child: Column(
                    children: [
                      const SizedBox(height: 10),
                      Container(
                        width: 44,
                        height: 5,
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.18),
                          borderRadius: BorderRadius.circular(99),
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Divider(height: 1),
                      Expanded(
                        child: PrimaryScrollController(
                          controller: scrollController,
                          child: const DeveloperContactPage(),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );

    if (!mounted) return;
    setState(() => _isContactSheetOpen = false);
  }

  @override
  Widget build(BuildContext context) {
    final bg = const Color(0xFFF3F7FA);

    final homeTitleStyle = GoogleFonts.cairo(
      fontSize: 18,
      fontWeight: FontWeight.w800,
      color: const Color.fromRGBO(0, 150, 136, 1),
    );

    final filledBtnStyle = GoogleFonts.cairo(
      fontSize: 18,
      fontWeight: FontWeight.w700,
      color: Colors.white,
    );

    final outlinedBtnStyle = GoogleFonts.cairo(
      fontSize: 16,
      fontWeight: FontWeight.w700,
      color: const Color.fromRGBO(0, 150, 136, 1),
    );

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: bg,
        drawer: MainSideDrawer(
          currentPage: 'promo',
          onSectionSelected: _onSectionSelected,
        ),
        drawerEnableOpenDragGesture: true,
        drawerEdgeDragWidth: MediaQuery.of(context).size.width * 0.25,

         appBar: AppBar(
          backgroundColor: bg,
          elevation: 0,
          automaticallyImplyLeading: false,
          titleSpacing: 12,
          title: Row(
            children: [
        
              Builder(
                builder: (context) {
                  return IconButton(
                    icon: const Icon(
                      Icons.menu,
                      color: Color.fromRGBO(0, 150, 136, 1),
                    ),
                    onPressed: () {
                      Scaffold.of(context).openDrawer();
                    },
                  );
                },
              ),
 
              IconButton(
                icon: const Icon(
                  Icons.search,
                  color: Color.fromRGBO(0, 150, 136, 1),
                ),
                onPressed: _openSearch,
              ),

       
              const Text(
  "Smadi Real Estate",
  style: TextStyle(
    fontSize: 19,
    fontWeight: FontWeight.w700,
    color: Colors.teal,
    letterSpacing: 0.6,
  ),
),


               
              const Spacer(),

             
              Image.asset(
                'assets/images/logo1.png',
                height: 30,
                fit: BoxFit.contain,
              ),
            ],
          ),
        ),

        body: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onVerticalDragUpdate: (details) {
            if (details.delta.dy < -10) {
              _openDeveloperContactSheet();
            }
          },
          child: Column(
            children: [
              SizedBox(
                height: 240,
                child: PageView.builder(
                  controller: _adsController,
                  itemCount: adsImages.length,
                  onPageChanged: (i) {
                    setState(() => _currentIndex = i);
                  },
                  itemBuilder: (_, i) {
                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 400),
                      margin: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(22),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.08),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(22),
                        child: Image.asset(
                          adsImages[i],
                          fit: BoxFit.cover,
                          width: double.infinity,
                        ),
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 12),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  adsImages.length,
                  (i) => AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: _currentIndex == i ? 14 : 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: _currentIndex == i
                          ? Colors.teal
                          : Colors.teal.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 18),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 22),
                child: Center(child: Text("الرئيسية", style: homeTitleStyle)),
              ),

              const SizedBox(height: 12),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 22),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.06),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      _UxPress(
                        borderRadius: 16,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  const SaleRentHostPage(initialPage: 0),
                            ),
                          );
                        },
                        child: SizedBox(
                          width: double.infinity,
                          height: 56,
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              color: Colors.teal,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                  color: Colors.white.withOpacity(0.18),
                                  width: 1),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.teal.withOpacity(0.22),
                                  blurRadius: 16,
                                  offset: const Offset(0, 8),
                                ),
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.04),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Stack(
                              children: [
                                Positioned.fill(
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(16),
                                    child: Opacity(
                                      opacity: 0.10,
                                      child: DecoratedBox(
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            begin: Alignment.topCenter,
                                            end: Alignment.bottomCenter,
                                            colors: [
                                              Colors.white,
                                              Colors.white.withOpacity(0.0)
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Center(
                                  child: Text("عقارات للبيع",
                                      style: filledBtnStyle),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 12),

                      _UxPress(
                        borderRadius: 16,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  const SaleRentHostPage(initialPage: 1),
                            ),
                          );
                        },
                        child: SizedBox(
                          width: double.infinity,
                          height: 56,
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              color: Colors.teal.shade700,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                  color: Colors.white.withOpacity(0.16),
                                  width: 1),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.teal.shade700.withOpacity(0.20),
                                  blurRadius: 16,
                                  offset: const Offset(0, 8),
                                ),
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.04),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Stack(
                              children: [
                                Positioned.fill(
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(16),
                                    child: Opacity(
                                      opacity: 0.10,
                                      child: DecoratedBox(
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            begin: Alignment.topCenter,
                                            end: Alignment.bottomCenter,
                                            colors: [
                                              Colors.white,
                                              Colors.white.withOpacity(0.0)
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Center(
                                  child: Text("عقارات للإيجار",
                                      style: filledBtnStyle),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 12),

                      _UxPress(
                        borderRadius: 16,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const FavoritesPage(),
                            ),
                          );
                        },
                        child: Container(
                          width: double.infinity,
                          height: 54,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                                color: Colors.teal.withOpacity(0.70),
                                width: 1.4),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.04),
                                blurRadius: 12,
                                offset: const Offset(0, 6),
                              ),
                            ],
                          ),
                          child: Center(
                            child: Text("العقارات المفضلة",
                                style: outlinedBtnStyle),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const Spacer(),

              InkWell(
                onTap: _openDeveloperContactSheet,
                child: AnimatedBuilder(
                  animation: _arrowController,
                  builder: (_, __) {
return Padding(
  padding: const EdgeInsets.only(bottom: 14),
  child: Column(
    mainAxisSize: MainAxisSize.min,
    children: [
       SizedBox(
        height: 20,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Transform.translate(
              offset: Offset(0, _smallArrowMove.value * 0.5),
              child: Opacity(
                opacity: 0.35,
                child: Text(
                  "^^^^^",
                  style: TextStyle(
                    fontSize: 20,
                    letterSpacing: 3,
                    color: Colors.teal.withOpacity(0.7),
                  ),
                ),
              ),
            ),
            Transform.translate(
              offset: Offset(0, _bigArrowMove.value - 4),
              child: Text(
                "^",
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Colors.teal.withOpacity(0.95),
                ),
              ),
            ),
          ],
        ),
      ),

      const SizedBox(height: 2),

       const Text(
        "التواصل مع المطوّر",
        style: TextStyle(
          fontSize: 15,
          color: Colors.teal,
          fontWeight: FontWeight.w600,
        ),
      ),

      const SizedBox(height: 14),
    ],
  ),
);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
 
class _UxPress extends StatefulWidget {
  final Widget child;
  final VoidCallback onTap;
  final double borderRadius;

  const _UxPress({
    required this.child,
    required this.onTap,
    this.borderRadius = 14,
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
            splashColor: Colors.teal.withOpacity(0.14),
            highlightColor: Colors.teal.withOpacity(0.08),
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

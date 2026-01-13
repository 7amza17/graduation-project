import 'package:SMADI/widgets/pages/promo_home_page.dart';
import 'package:flutter/material.dart';
import 'package:SMADI/managers/favorites_page.dart';
import '../widgets/property_card.dart';
import 'developer_contact_page.dart';
import 'package:google_fonts/google_fonts.dart';

class MainSideDrawer extends StatelessWidget {
  final String currentPage;
  final void Function(String) onSectionSelected;

  const MainSideDrawer({
    super.key,
    required this.currentPage,
    required this.onSectionSelected,
  });

  bool get isPromo => currentPage == 'promo';
  bool get isSale => currentPage == 'sale';
  bool get isRent => currentPage == 'rent';

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    final Color bg = const Color(0xFFF3F7FA);
    final Color teal = Colors.teal;

    void _openSearchFromDrawer() {
      Navigator.of(context).pop(); 
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

    return Drawer(
      width: screenSize.width * 0.75,
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: SafeArea(
          child: Container(
            color: bg,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 20, 16, 10),
                  child: Row(
                    children: [
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: const [
                            Text(
                              "Smadi Real Estate",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                                color: Colors.teal,
                                letterSpacing: 0.4,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 4),
                      IconButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        icon: const Icon(
                          Icons.close_rounded,
                          color: Colors.teal,
                          size: 22,
                        ),
                      ),
                    ],
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Divider(
                    height: 20,
                    color: Colors.black.withOpacity(0.06),
                  ),
                ),

                //عناصر القائمة 
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(18),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // الرئيسية
                        _buildMenuItem(
                          context: context,
                          title: "الرئيسية",
                          icon: Icons.home_rounded,
                          iconColor: teal,
                          trailingIcon: isPromo
                              ? Icons.check_circle_rounded
                              : Icons.arrow_back_ios_new_rounded,
                          isActive: isPromo,
                          onTap: () {
                            Navigator.of(context).pop();
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                builder: (_) => const PromoHomePage(),
                              ),
                            );
                          },
                        ),

                        const SizedBox(height: 4),

                        // البحث
                        _buildMenuItem(
                          context: context,
                          title: "بحث",
                          icon: Icons.search_rounded,
                          iconColor: Colors.teal,
                          trailingIcon: Icons.arrow_back_ios_new_rounded,
                          isActive: false,
                          onTap: _openSearchFromDrawer,
                        ),

                        const SizedBox(height: 4),

                        // عقارات للبيع
                        _buildMenuItem(
                          context: context,
                          title: "عقارات للبيع",
                          icon: Icons.apartment_rounded,
                          iconColor: Colors.green.shade600,
                          trailingIcon: isSale
                              ? Icons.check_circle_rounded
                              : Icons.arrow_back_ios_new_rounded,
                          isActive: isSale,
                          onTap: () {
                            Navigator.of(context).pop();
                            if (!isSale) {
                              onSectionSelected('sale');
                            }
                          },
                        ),

                        const SizedBox(height: 4),

                        //  عقارات للإيجار 
                        _buildMenuItem(
                          context: context,
                          title: "عقارات للإيجار",
                          icon: Icons.key_rounded,
                          iconColor: Colors.blue.shade600,
                          trailingIcon: isRent
                              ? Icons.check_circle_rounded
                              : Icons.arrow_back_ios_new_rounded,
                          isActive: isRent,
                          onTap: () {
                            Navigator.of(context).pop();
                            if (!isRent) {
                              onSectionSelected('rent');
                            }
                          },
                        ),

                        const SizedBox(height: 4),

                        //المفضلة
                        _buildMenuItem(
                          context: context,
                          title: "المفضلة",
                          icon: Icons.favorite_rounded,
                          iconColor: Colors.pink.shade400,
                          trailingIcon: Icons.arrow_back_ios_new_rounded,
                          isActive: false,
                          onTap: () {
                            Navigator.of(context).pop();
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const FavoritesPage(),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),

                const Spacer(),

                //  التواصل مع المطور  
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 18),
                  child: SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: () {
                        Navigator.of(context).pop();
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const DeveloperContactPage(),
                          ),
                        );
                      },
                      icon: const Icon(
                        Icons.support_agent_rounded,
                        size: 20,
                      ),
                      label: const Text(
                        "التواصل مع المطوّر",
                        style: TextStyle(
                          fontSize: 14,
                        ),
                      ),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: teal,
                        side: BorderSide(color: teal.withOpacity(0.9)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 10,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMenuItem({
    required BuildContext context,
    required String title,
    required IconData icon,
    required IconData trailingIcon,
    required Color iconColor,
    required bool isActive,
    required VoidCallback onTap,
  }) {
    final Color teal = Colors.teal;

    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: BoxDecoration(
          color: isActive ? teal.withOpacity(0.06) : Colors.transparent,
          borderRadius: BorderRadius.circular(14),
          border: isActive
              ? Border.all(color: teal.withOpacity(0.4), width: 1)
              : null,
        ),
        child: Row(
          children: [
            Icon(
              trailingIcon,
              size: trailingIcon == Icons.check_circle_rounded ? 20 : 16,
              color: trailingIcon == Icons.check_circle_rounded
                  ? teal
                  : Colors.black38,
            ),
            const SizedBox(width: 10),

            Expanded(
              child: Align(
                alignment: Alignment.centerRight,
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
                    color: isActive ? teal : Colors.black87,
                  ),
                ),
              ),
            ),

            const SizedBox(width: 10),

            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: iconColor.withOpacity(0.07),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                icon,
                size: 18,
                color: iconColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

//مكونات البار العلوي
PreferredSizeWidget buildMainAppBar(
  BuildContext context,
  String currentPage,
  void Function(String) onSectionSelected,
) {
  final bg = const Color(0xFFF3F7FA);

  void openSearch() {
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

  return AppBar(
    backgroundColor: bg,
    elevation: 0,
    automaticallyImplyLeading: false,
    titleSpacing: 12,
    title: Row(
      children: [
        Builder(
          builder: (ctx) => IconButton(
            onPressed: () {
              Scaffold.of(ctx).openDrawer();
            },
            icon: const Icon(
              Icons.menu,
              color: Color.fromRGBO(0, 150, 136, 1),
              size: 26,
            ),
            splashRadius: 24,
            tooltip: "القائمة",
          ),
        ),

        IconButton(
          tooltip: "بحث",
          icon: const Icon(
            Icons.search,
            color: Color.fromRGBO(0, 150, 136, 1),
          ),
          onPressed: openSearch,
        ),


        Text(
          "Smadi Real Estate",
          style: GoogleFonts.cairo(
            fontSize: 18,
            fontWeight: FontWeight.w800,
            color: const Color.fromRGBO(0, 150, 136, 1),
          ),
        ),

        const Spacer(),

        Image.asset(
          "assets/images/logo1.png",
          height: 30,
          fit: BoxFit.contain,
        ),
      ],
    ),
  );
}

class SaleRentSwitcher extends StatelessWidget {
  final double position;
  final VoidCallback onSelectSale;
  final VoidCallback onSelectRent;

  const SaleRentSwitcher({
    super.key,
    required this.position,
    required this.onSelectSale,
    required this.onSelectRent,
  });

  bool get isSale => position < 0.5;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragEnd: (details) {
        final velocity = details.primaryVelocity ?? 0;
        if (velocity < 0 && isSale) {
          onSelectRent();
        } else if (velocity > 0 && !isSale) {
          onSelectSale();
        }
      },
      child: Container(
        margin: const EdgeInsets.fromLTRB(16, 8, 16, 16),
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(22),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final totalWidth = constraints.maxWidth - 8;
            final pillWidth = totalWidth / 2;
            final alignmentX = 1 - 2 * position.clamp(0.0, 1.0);

            return Stack(
              children: [
                Align(
                  alignment: Alignment(alignmentX, 0),
                  child: Container(
                    width: pillWidth,
                    height: 36,
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    decoration: BoxDecoration(
                      color: Colors.teal,
                      borderRadius: BorderRadius.circular(18),
                    ),
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: InkWell(
                        borderRadius: BorderRadius.circular(18),
                        onTap: onSelectSale,
                        child: SizedBox(
                          height: 36,
                          child: Center(
                            child: AnimatedDefaultTextStyle(
                              duration: const Duration(milliseconds: 120),
                              curve: Curves.easeInOut,
                              style: TextStyle(
                                color: isSale ? Colors.white : Colors.teal,
                                fontSize: 15,
                                fontWeight:
                                    isSale ? FontWeight.bold : FontWeight.w500,
                              ),
                              child: const Text("بيع"),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: InkWell(
                        borderRadius: BorderRadius.circular(18),
                        onTap: onSelectRent,
                        child: SizedBox(
                          height: 36,
                          child: Center(
                            child: AnimatedDefaultTextStyle(
                              duration: const Duration(milliseconds: 120),
                              curve: Curves.easeInOut,
                              style: TextStyle(
                                color: !isSale ? Colors.white : Colors.teal,
                                fontSize: 15,
                                fontWeight: !isSale
                                    ? FontWeight.bold
                                    : FontWeight.w500,
                              ),
                              child: const Text("إيجار"),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class SaleRentHostPage extends StatefulWidget {
  final int initialPage;
  const SaleRentHostPage({
    super.key,
    this.initialPage = 0,
  });

  @override
  State<SaleRentHostPage> createState() => _SaleRentHostPageState();
}

class _SaleRentHostPageState extends State<SaleRentHostPage> {
  late final PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: widget.initialPage);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _goToSection(String section) {
    final index = section == 'sale' ? 0 : 1;
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 220),
      curve: Curves.easeInOutCubic,
    );
  }

  @override
  Widget build(BuildContext context) {
    final bg = const Color(0xFFF3F7FA);

    return Directionality(
      textDirection: TextDirection.rtl,
      child: AnimatedBuilder(
        animation: _pageController,
        builder: (context, _) {
          double position;

          if (_pageController.hasClients && _pageController.page != null) {
            position = _pageController.page!.clamp(0.0, 1.0);
          } else {
            position = widget.initialPage.toDouble();
          }

          final currentPageName = position < 0.5 ? 'sale' : 'rent';

          return Scaffold(
            backgroundColor: bg,
            drawer: MainSideDrawer(
              currentPage: currentPageName,
              onSectionSelected: _goToSection,
            ),
            drawerEnableOpenDragGesture: currentPageName == 'sale',
            drawerEdgeDragWidth: currentPageName == 'sale'
                ? MediaQuery.of(context).size.width * 0.25
                : 0,
            appBar: buildMainAppBar(
              context,
              currentPageName,
              _goToSection,
            ),
            body: Column(
              children: [
                Expanded(
                  child: PageView(
                    controller: _pageController,
                    physics: const BouncingScrollPhysics(),
                    children: const [
                      SaleTabContent(),
                      RentTabContent(),
                    ],
                  ),
                ),
                SaleRentSwitcher(
                  position: position,
                  onSelectSale: () => _goToSection('sale'),
                  onSelectRent: () => _goToSection('rent'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class SaleTabContent extends StatelessWidget {
  const SaleTabContent({super.key});

  @override
  Widget build(BuildContext context) {
    final saleItems = AppPropertiesData.saleProperties;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Text(
            "قسم البيع",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.teal.shade700,
            ),
            textAlign: TextAlign.right,
          ),
        ),
        Expanded(
          child: GridView.count(
            crossAxisCount: 1,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
            childAspectRatio: 0.85,
            children: saleItems.map((p) {
              return PropertyCard(
                title: p.title,
                tag: p.tag,
                tagColor: p.tagColor,
                price: p.price,
                area: p.area,
                location: p.location,
                description: p.description,
                phone: p.phone,
                images: p.images,
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}

class RentTabContent extends StatelessWidget {
  const RentTabContent({super.key});

  @override
  Widget build(BuildContext context) {
    final rentItems = AppPropertiesData.rentProperties;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Text(
            "قسم الإيجار",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.teal.shade700,
            ),
            textAlign: TextAlign.right,
          ),
        ),
        Expanded(
          child: GridView.count(
            crossAxisCount: 1,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
            childAspectRatio: 0.9,
            children: rentItems.map((p) {
              return PropertyCard(
                title: p.title,
                tag: p.tag,
                tagColor: p.tagColor,
                price: p.price,
                area: p.area,
                location: p.location,
                description: p.description,
                phone: p.phone,
                images: p.images,
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}

class PropertyItem {
  final String title;
  final String tag;
  final Color tagColor;
  final String price;
  final String area;
  final String location;
  final String description;
  final String phone;
  final List<String> images;

  const PropertyItem({
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
}

class AppPropertiesData {
  static final List<PropertyItem> saleProperties = [
    const PropertyItem(
      title: "فيلا فاخرة",
      tag: "بيع",
      tagColor: Colors.green,
      price: "450,000 \$",
      area: "420 م²",
      location: "دمشق - الروضة",
      description: "فيلا فاخرة بتشطيب سوبر ديلوكس وحديقة واسعة وموقف سيارات خاص.",
      phone: "+963 98 039 5358",
      images: [
        
        "assets/vr/property1/bathroom_360.jpg",
        "assets/images/property1.jpg",
        "assets/images/property1_1.jpg",
        "assets/images/property1_2.jpg",
        "assets/images/property1_3.jpg",
      ],
    ),
    const PropertyItem(
      title: "شقة بناية",
      tag: "تم البيع",
      tagColor: Colors.red,
      price: "220,000 \$",
      area: "140 م²",
      location: "حمص - عكرمة",
      description: "شقة فاخرة في بناء حديث مع مصعد ومرآب، تقع في حي هادئ وقريب من الجامعة.",
      phone: "+963 98 039 5358",
      images: [
        "assets/images/1/1.png",
        "assets/images/1/2.png",
        "assets/images/1/3.png",
        "assets/images/1/4.png",
        "assets/images/1/5.png",
        "assets/images/1/6.png",
        "assets/images/1/7.png",
      ],
    ),
    const PropertyItem(
      title: "منزل مع حديقة",
      tag: "بيع",
      tagColor: Colors.green,
      price: "60,000 \$",
      area: "520 م²",
      location: "درعا - بصرى الشام",
      description: "منزل طابق واحد مع حديقة كبيرة، مناسب للعائلات ومحبي الهدوء.",
      phone: "+963 98 039 5358",
      images: [
        "assets/images/property5.jpg",
      ],
    ),
    const PropertyItem(
      title: "شقة حديثة",
      tag: "تفاوض",
      tagColor: Colors.deepPurple,
      price: "300,000 \$",
      area: "180 م²",
      location: "حلب - العزيزية",
      description: "شقة حديثة بتشطيب عصري، 3 غرف وصالون، قريبة من الأسواق والخدمات.",
      phone: "+963 98 039 5358",
      images: [
        "assets/images/property6.jpg",
      ],
    ),
    const PropertyItem(
      title: "شقة ريفية",
      tag: "بيع",
      tagColor: Colors.green,
      price: "300,000 \$",
      area: "180 م²",
      location: "حلب - العزيزية",
      description: "شقة ريفية بإطلالة جميلة على الطبيعة، مناسبة للابتعاد عن ضوضاء المدينة.",
      phone: "+963 98 039 5358",
      images: [
        "assets/images/property6.jpg",
      ],
    ),
  ];

  static final List<PropertyItem> rentProperties = [
    const PropertyItem(
      title: "شقة مطلة على البحر",
      tag: "إيجار",
      tagColor: Colors.blue,
      price: "900 \$ / شهر",
      area: "160 م²",
      location: "اللاذقية - الكورنيش",
      description: "شقة مفروشة بالكامل بإطلالة مباشرة على البحر، مناسبة للعائلات.",
      phone: "+963 98 039 5358",
      images: [
        "assets/images/property2.jpg",
        "assets/images/property2_1.jpg",
        "assets/images/property2_2.jpg",
        "assets/images/property2_3.jpg",
      ],
    ),
    const PropertyItem(
      title: "منزل للطلاب",
      tag: "إيجار",
      tagColor: Colors.orange,
      price: "250 \$ / شهر",
      area: "75 م²",
      location: "دمشق - برامكة",
      description: " منزل للطلاب بالقرب من الجامعات، مفروش بالكامل مع إنترنت.",
      phone: "+963 98 039 5358",
      images: [
       "assets/images/2/1.png",
       "assets/images/2/2.png",
       "assets/images/2/3.png",
       "assets/images/2/4.png",
       "assets/images/2/5.png",
       "assets/images/2/6.png",
      ],
    ),
  ];

  static List<PropertyItem> get allProperties => [
        ...saleProperties,
        ...rentProperties,
      ];
}

/// =======================================================
/// ✅ صفحة البحث الجديدة (قائمة نتائج مثل المفضلة + تفتح تفاصيل العقار عند الضغط)
/// =======================================================
class PropertySearchPage extends StatefulWidget {
  final List<PropertyItem> allProperties;
  final String logoAsset;
  final String titleText;

  const PropertySearchPage({
    super.key,
    required this.allProperties,
    required this.logoAsset,
    required this.titleText,
  });

  @override
  State<PropertySearchPage> createState() => _PropertySearchPageState();
}

class _PropertySearchPageState extends State<PropertySearchPage> {
  final TextEditingController _controller = TextEditingController();
  String _query = "";

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  List<PropertyItem> _filtered() {
    final q = _query.trim();
    if (q.isEmpty) return widget.allProperties;

    return widget.allProperties.where((p) {
      return p.title.contains(q) ||
          p.location.contains(q) ||
          p.price.contains(q) ||
          p.area.contains(q) ||
          p.tag.contains(q);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final bg = const Color(0xFFF3F7FA);
    final results = _filtered();

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: bg,

        // ✅ نفس تنسيق AppBar بالضبط
        appBar: AppBar(
          backgroundColor: bg,
          elevation: 0,
          automaticallyImplyLeading: false,
          titleSpacing: 12,
          title: Row(
            children: [
              // رجوع
              IconButton(
                icon: const Icon(
                  Icons.arrow_back,
                  color: Color.fromRGBO(0, 150, 136, 1),
                ),
                onPressed: () => Navigator.pop(context),
              ),

              // عنوان
              Text(
                widget.titleText,
                style: const TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.w700,
                  color: Colors.teal,
                  letterSpacing: 0.6,
                ),
              ),

              const Spacer(),

              Image.asset(
                widget.logoAsset,
                height: 30,
                fit: BoxFit.contain,
              ),
            ],
          ),
        ),

        body: Column(
          children: [
            // شريط بحث
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 6, 16, 8),
              child: Container(
                height: 48, // ✅ أصغر من قبل
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.06),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                  border: Border.all(
                    color: Colors.teal.withOpacity(0.18),
                    width: 1,
                  ),
                ),
                child: TextField(
                  controller: _controller,
                  onChanged: (v) {
                    setState(() => _query = v);
                  },
                  textDirection: TextDirection.rtl,
                  style: const TextStyle(fontSize: 14), // ✅ أصغر
                  decoration: InputDecoration(
                    hintText: "ابحث عن عقار...",
                    hintStyle: TextStyle(
                      color: Colors.black.withOpacity(0.45),
                      fontSize: 13, // ✅ أصغر
                    ),
                    prefixIcon:
                        const Icon(Icons.search, color: Colors.teal, size: 20),
                    suffixIcon: _controller.text.isEmpty
                        ? null
                        : IconButton(
                            icon: const Icon(Icons.clear,
                                color: Colors.black54, size: 18),
                            onPressed: () {
                              _controller.clear();
                              setState(() => _query = "");
                            },
                          ),
                    border: InputBorder.none,
                    isDense: true, // ✅ يقلل الارتفاع الداخلي
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 12,
                    ),
                  ),
                ),
              ),
            ),

            // نتائج
            Expanded(
              child: results.isEmpty
                  ? const Center(
                      child: Text(
                        "لا يوجد نتائج مطابقة",
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.black54,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    )
                  : GridView.count(
                      crossAxisCount: 1,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                      childAspectRatio: 0.87,
                      children: results.map((p) {
                        // ✅ نفس عرض المفضلة/القائمة: PropertyCard
                        // والضغط على الكارد رح يفتح تفاصيل العقار كما هو عندك داخل PropertyCard
                        return PropertyCard(
                          title: p.title,
                          tag: p.tag,
                          tagColor: p.tagColor,
                          price: p.price,
                          area: p.area,
                          location: p.location,
                          description: p.description,
                          phone: p.phone,
                          images: p.images,
                        );
                      }).toList(),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

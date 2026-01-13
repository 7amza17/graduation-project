import 'package:SMADI/models/property.dart';
import 'package:flutter/material.dart';

import 'property_card.dart';

class PropertiesPage extends StatefulWidget {
  final List<Property> allProperties;
  const PropertiesPage({super.key, required this.allProperties});

  @override
  State<PropertiesPage> createState() => _PropertiesPageState();
}

class _PropertiesPageState extends State<PropertiesPage> {
  final TextEditingController _searchCtrl = TextEditingController();

  // فلاتر
  String _type = 'الكل'; // الكل / بيع / إيجار
  int? _minPrice;
  int? _maxPrice;
  int? _minArea;
  int? _maxArea;

  @override
  void initState() {
    super.initState();
    _searchCtrl.addListener(() {
      setState(() {}); // 🔥 بحث مباشر أثناء الكتابة
    });
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  List<Property> get _filtered {
    final q = _searchCtrl.text.trim().toLowerCase();

    return widget.allProperties.where((p) {
      // 1) فلترة النوع
      if (_type != 'الكل') {
        if (_type == 'بيع' && p.tag != 'بيع') return false;
        if (_type == 'إيجار' && p.tag != 'إيجار') return false;
      }

      // 2) فلترة السعر
      if (_minPrice != null && p.priceValue < _minPrice!) return false;
      if (_maxPrice != null && p.priceValue > _maxPrice!) return false;

      // 3) فلترة المساحة
      if (_minArea != null && p.areaValue < _minArea!) return false;
      if (_maxArea != null && p.areaValue > _maxArea!) return false;

      // 4) البحث النصي
      if (q.isEmpty) return true;

      final hay = (
        '${p.title} ${p.location} ${p.description} ${p.tag}'
      ).toLowerCase();

      return hay.contains(q);
    }).toList();
  }

  void _openFilters() {
    final minPriceCtrl = TextEditingController(text: _minPrice?.toString() ?? '');
    final maxPriceCtrl = TextEditingController(text: _maxPrice?.toString() ?? '');
    final minAreaCtrl  = TextEditingController(text: _minArea?.toString() ?? '');
    final maxAreaCtrl  = TextEditingController(text: _maxArea?.toString() ?? '');

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
      ),
      builder: (ctx) {
        return Padding(
          padding: EdgeInsets.only(
            left: 16,
            right: 16,
            top: 12,
            bottom: MediaQuery.of(ctx).viewInsets.bottom + 16,
          ),
          child: StatefulBuilder(
            builder: (ctx, setLocal) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Expanded(
                        child: Text(
                          'فلترة البحث',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () => Navigator.pop(ctx),
                        icon: const Icon(Icons.close),
                      )
                    ],
                  ),

                  // النوع
                  DropdownButtonFormField<String>(
                    value: _type,
                    decoration: const InputDecoration(labelText: 'النوع'),
                    items: const [
                      DropdownMenuItem(value: 'الكل', child: Text('الكل')),
                      DropdownMenuItem(value: 'بيع', child: Text('بيع')),
                      DropdownMenuItem(value: 'إيجار', child: Text('إيجار')),
                    ],
                    onChanged: (v) => setLocal(() => _type = v ?? 'الكل'),
                  ),

                  const SizedBox(height: 10),

                  // السعر
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: minPriceCtrl,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(labelText: 'السعر من'),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: TextField(
                          controller: maxPriceCtrl,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(labelText: 'السعر إلى'),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 10),

                  // المساحة
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: minAreaCtrl,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            labelText: 'المساحة من (م²)',
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: TextField(
                          controller: maxAreaCtrl,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            labelText: 'المساحة إلى (م²)',
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 14),

                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            setState(() {
                              _type = 'الكل';
                              _minPrice = null;
                              _maxPrice = null;
                              _minArea = null;
                              _maxArea = null;
                            });
                            Navigator.pop(ctx);
                          },
                          child: const Text('إزالة الفلاتر'),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            setState(() {
                              _minPrice = int.tryParse(minPriceCtrl.text.trim());
                              _maxPrice = int.tryParse(maxPriceCtrl.text.trim());
                              _minArea  = int.tryParse(minAreaCtrl.text.trim());
                              _maxArea  = int.tryParse(maxAreaCtrl.text.trim());
                            });
                            Navigator.pop(ctx);
                          },
                          child: const Text('تطبيق'),
                        ),
                      ),
                    ],
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final list = _filtered;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('بحث العقارات'),
          actions: [
            IconButton(
              onPressed: _openFilters,
              icon: const Icon(Icons.tune),
            ),
          ],
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(64),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(12, 0, 12, 10),
              child: TextField(
                controller: _searchCtrl,
                decoration: InputDecoration(
                  hintText: 'ابحث: مدينة، حي، شقة، فيلا...',
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: _searchCtrl.text.isEmpty
                      ? null
                      : IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () => _searchCtrl.clear(),
                        ),
                  filled: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
          ),
        ),
        body: list.isEmpty
            ? const Center(child: Text('ما في نتائج مطابقة.'))
            : ListView.builder(
                padding: const EdgeInsets.all(12),
                itemCount: list.length,
                itemBuilder: (context, i) {
                  final p = list[i];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: PropertyCard(
                      title: p.title,
                      tag: p.tag,
                      tagColor: p.tagColor,
                      price: p.price,
                      area: p.areaText,
                      location: p.location,
                      description: p.description,
                      phone: p.phone,
                      images: p.images,
                    ),
                  );
                },
              ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

class Property {
  final String id;
  final String title;
  final String tag; // بيع / إيجار
  final Color tagColor;
  final String price; // نص مثل "150,000$" أو "200$ شهرياً"
  final int priceValue; // رقم للفلترة
  final int areaValue;  // رقم للفلترة
  final String areaText; // "120 م²"
  final String location;
  final String description;
  final String phone;
  final List<String> images;

  Property({
    required this.id,
    required this.title,
    required this.tag,
    required this.tagColor,
    required this.price,
    required this.priceValue,
    required this.areaValue,
    required this.areaText,
    required this.location,
    required this.description,
    required this.phone,
    required this.images,
  });
}

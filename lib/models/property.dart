import 'package:flutter/material.dart';

class Property {
  final String id;
  final String title;
  final String tag; 
  final Color tagColor;
  final String price; 
  final int priceValue;
  final int areaValue;    
  final String areaText; 
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

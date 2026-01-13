import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FavoriteProperty {
  final String title;
  final String tag;
  final Color tagColor;
  final String price;
  final String area;
  final String location;
  final String phone;        
  final String description;  
  final List<String> images;

  const FavoriteProperty({
    required this.title,
    required this.tag,
    required this.tagColor,
    required this.price,
    required this.area,
    required this.location,
    required this.phone,
    required this.description,
    required this.images,
  });

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'tag': tag,
      'tagColor': tagColor.value,
      'price': price,
      'area': area,
      'location': location,
      'phone': phone,
      'description': description,
      'images': images,
    };
  }

  factory FavoriteProperty.fromJson(Map<String, dynamic> json) {
    return FavoriteProperty(
      title: json['title'],
      tag: json['tag'],
      tagColor: Color(json['tagColor']),
      price: json['price'],
      area: json['area'],
      location: json['location'],
      phone: json['phone'] ?? '',
      description: json['description'] ?? '',
      images: (json['images'] as List).cast<String>(),
    );
  }
}

class FavoritesManager {
  FavoritesManager._() {
    _loadFavoritesFromStorage();
  }

  static final FavoritesManager instance = FavoritesManager._();

  final ValueNotifier<List<FavoriteProperty>> favorites =
      ValueNotifier<List<FavoriteProperty>>([]);

  static const String _storageKey = 'favorite_properties';

  bool isFavorite(FavoriteProperty property) {
    return favorites.value.any((p) =>
        p.title == property.title &&
        p.price == property.price &&
        p.location == property.location);
  }

  Future<void> _loadFavoritesFromStorage() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> storedList =
        prefs.getStringList(_storageKey) ?? <String>[];

    final List<FavoriteProperty> loaded = storedList.map((item) {
      return FavoriteProperty.fromJson(jsonDecode(item));
    }).toList();

    favorites.value = loaded;
  }

  Future<void> _saveFavoritesToStorage() async {
    final prefs = await SharedPreferences.getInstance();

    final List<String> data =
        favorites.value.map((p) => jsonEncode(p.toJson())).toList();

    await prefs.setStringList(_storageKey, data);
  }

  Future<void> toggleFavorite(FavoriteProperty property) async {
    final current = List<FavoriteProperty>.from(favorites.value);

    final index = current.indexWhere((p) =>
        p.title == property.title &&
        p.price == property.price &&
        p.location == property.location);

    if (index >= 0) {
      current.removeAt(index);
    } else {
      current.add(property);
    }

    favorites.value = current;
    await _saveFavoritesToStorage();
  }
}

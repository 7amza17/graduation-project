import 'package:flutter/material.dart';

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

  // نستخدمه للمقارنة بين العقارات
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is FavoriteProperty &&
        other.title == title &&
        other.location == location &&
        other.price == price;
  }

  @override
  int get hashCode => Object.hash(title, location, price);
}

class FavoritesManager {
  FavoritesManager._internal();
  static final FavoritesManager instance = FavoritesManager._internal();

  // قائمة المفضّلة
  final ValueNotifier<List<FavoriteProperty>> favorites =
      ValueNotifier<List<FavoriteProperty>>(<FavoriteProperty>[]);

  bool isFavorite(FavoriteProperty property) {
    return favorites.value.contains(property);
  }

  void toggleFavorite(FavoriteProperty property) {
    final list = List<FavoriteProperty>.from(favorites.value);

    if (list.contains(property)) {
      list.remove(property);
    } else {
      list.add(property);
    }

    favorites.value = list;
  }
}

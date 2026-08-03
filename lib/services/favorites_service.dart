import 'package:flutter/foundation.dart';

class FavoritesService {
  static final FavoritesService _instance = FavoritesService._internal();
  factory FavoritesService() => _instance;
  FavoritesService._internal();

  final ValueNotifier<Set<String>> favoriteIds = ValueNotifier({});

  bool isFavorite(String id) => favoriteIds.value.contains(id);

  void toggleFavorite(String id) {
    final current = Set<String>.from(favoriteIds.value);
    if (current.contains(id)) {
      current.remove(id);
    } else {
      current.add(id);
    }
    favoriteIds.value = current;
  }
}
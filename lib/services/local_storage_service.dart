import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/meal.dart';
import '../models/shopping_item.dart';

class LocalStorageService {
  static const String _favsKey = 'favorites_ids';
  static const String _cachedMealsKey = 'cached_meals';
  static const String _shoppingKey = 'shopping_items';

  Future<Set<String>> getFavoriteIds() async {
    final prefs = await SharedPreferences.getInstance();
    return (prefs.getStringList(_favsKey) ?? []).toSet();
  }

  Future<void> saveFavoriteIds(Set<String> ids) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_favsKey, ids.toList());
  }

  Future<void> cacheMeals(List<Meal> meals) async {
    final prefs = await SharedPreferences.getInstance();
    final rawList = meals.map((m) => jsonEncode(m.toJson())).toList();
    await prefs.setStringList(_cachedMealsKey, rawList);
  }

  Future<List<Meal>> getCachedMeals() async {
    final prefs = await SharedPreferences.getInstance();
    final rawList = prefs.getStringList(_cachedMealsKey) ?? [];
    return rawList.map((str) => Meal.fromJson(jsonDecode(str))).toList();
  }

  Future<List<ShoppingItem>> getShoppingList() async {
    final prefs = await SharedPreferences.getInstance();
    final rawList = prefs.getStringList(_shoppingKey) ?? [];
    return rawList.map((str) => ShoppingItem.fromJson(jsonDecode(str))).toList();
  }

  Future<void> saveShoppingList(List<ShoppingItem> items) async {
    final prefs = await SharedPreferences.getInstance();
    final rawList = items.map((i) => jsonEncode(i.toJson())).toList();
    await prefs.setStringList(_shoppingKey, rawList);
  }
}
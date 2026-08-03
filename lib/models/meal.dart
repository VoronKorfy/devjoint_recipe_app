import 'package:equatable/equatable.dart';

class Meal extends Equatable {
  final String id;
  final String name;
  final String category;
  final String area;
  final String instructions;
  final String thumbnailUrl;
  final List<String> ingredients;

  const Meal({
    required this.id,
    required this.name,
    required this.category,
    required this.area,
    required this.instructions,
    required this.thumbnailUrl,
    required this.ingredients,
  });

  factory Meal.fromJson(Map<String, dynamic> json) {
    final List<String> extractedIngredients = [];

    // 1. Чтение из локального кэша SharedPreferences
    if (json['ingredients'] is List) {
      return Meal(
        id: json['idMeal']?.toString() ?? '',
        name: json['strMeal']?.toString() ?? 'Unknown Recipe',
        category: json['strCategory']?.toString() ?? 'General',
        area: json['strArea']?.toString() ?? 'International',
        instructions: json['strInstructions']?.toString() ?? 'No instructions provided.',
        thumbnailUrl: json['strMealThumb']?.toString() ?? '',
        ingredients: List<String>.from(json['ingredients']),
      );
    }

    // 2. Парсинг сырого ответа от API TheMealDB
    for (int i = 1; i <= 20; i++) {
      final ingredient = json['strIngredient$i'];
      final measure = json['strMeasure$i'];

      if (ingredient != null && ingredient is String && ingredient.trim().isNotEmpty) {
        final measureStr = (measure != null && measure is String && measure.trim().isNotEmpty)
            ? ' (${measure.trim()})'
            : '';
        extractedIngredients.add('${ingredient.trim()}$measureStr');
      }
    }

    return Meal(
      id: json['idMeal']?.toString() ?? '',
      name: json['strMeal']?.toString() ?? 'Unknown Recipe',
      category: json['strCategory']?.toString() ?? 'General',
      area: json['strArea']?.toString() ?? 'International',
      instructions: json['strInstructions']?.toString() ?? 'No instructions provided.',
      thumbnailUrl: json['strMealThumb']?.toString() ?? '',
      ingredients: extractedIngredients,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'idMeal': id,
      'strMeal': name,
      'strCategory': category,
      'strArea': area,
      'strInstructions': instructions,
      'strMealThumb': thumbnailUrl,
      'ingredients': ingredients,
    };
  }

  @override
  List<Object?> get props => [id, name, category, area, instructions, thumbnailUrl, ingredients];
}
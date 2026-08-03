import 'package:equatable/equatable.dart';
import '../../models/meal.dart';

enum MealStatus { initial, loading, success, failure }

class MealState extends Equatable {
  final MealStatus status;
  final List<Meal> meals;
  final Set<String> favoriteIds;
  final String selectedCategory;
  final String searchQuery;
  final bool showFavoritesOnly;
  final bool hasMore;
  final String? errorMessage;

  const MealState({
    this.status = MealStatus.initial,
    this.meals = const [],
    this.favoriteIds = const {},
    this.selectedCategory = 'All',
    this.searchQuery = '',
    this.showFavoritesOnly = false,
    this.hasMore = true,
    this.errorMessage,
  });

  MealState copyWith({
    MealStatus? status,
    List<Meal>? meals,
    Set<String>? favoriteIds,
    String? selectedCategory,
    String? searchQuery,
    bool? showFavoritesOnly,
    bool? hasMore,
    String? errorMessage,
  }) {
    return MealState(
      status: status ?? this.status,
      meals: meals ?? this.meals,
      favoriteIds: favoriteIds ?? this.favoriteIds,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      searchQuery: searchQuery ?? this.searchQuery,
      showFavoritesOnly: showFavoritesOnly ?? this.showFavoritesOnly,
      hasMore: hasMore ?? this.hasMore,
      errorMessage: errorMessage,
    );
  }

  List<String> get categories {
    final set = <String>{'All'};
    for (var m in meals) {
      if (m.category.isNotEmpty) set.add(m.category);
    }
    return set.toList();
  }

  List<Meal> get filteredMeals {
    return meals.where((meal) {
      final matchesSearch = meal.name.toLowerCase().contains(searchQuery.toLowerCase());
      final matchesCategory = selectedCategory == 'All' || meal.category == selectedCategory;
      final matchesFavorite = !showFavoritesOnly || favoriteIds.contains(meal.id);
      return matchesSearch && matchesCategory && matchesFavorite;
    }).toList();
  }

  @override
  List<Object?> get props => [
    status,
    meals,
    favoriteIds,
    selectedCategory,
    searchQuery,
    showFavoritesOnly,
    hasMore,
    errorMessage,
  ];
}
import 'package:equatable/equatable.dart';

abstract class MealEvent extends Equatable {
  const MealEvent();
  @override
  List<Object?> get props => [];
}

class FetchMealsEvent extends MealEvent {}
class LoadNextPageEvent extends MealEvent {}
class SearchMealsEvent extends MealEvent {
  final String query;
  const SearchMealsEvent(this.query);
  @override
  List<Object?> get props => [query];
}
class SelectCategoryEvent extends MealEvent {
  final String category;
  const SelectCategoryEvent(this.category);
  @override
  List<Object?> get props => [category];
}
class ToggleFavoriteEvent extends MealEvent {
  final String mealId;
  const ToggleFavoriteEvent(this.mealId);
  @override
  List<Object?> get props => [mealId];
}
class ToggleFavoritesFilterEvent extends MealEvent {}
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';
import '../../repositories/meal_repository.dart';
import 'meal_event.dart';
import 'meal_state.dart';

class MealBloc extends Bloc<MealEvent, MealState> {
  final MealRepository repository;
  int _currentPage = 1;

  MealBloc({required this.repository}) : super(const MealState()) {
    on<FetchMealsEvent>(_onFetchMeals);
    on<LoadNextPageEvent>(_onLoadNextPage);
    on<SearchMealsEvent>(
      _onSearchMeals,
      transformer: (events, mapper) => events
          .debounceTime(const Duration(milliseconds: 300))
          .switchMap(mapper),
    );
    on<SelectCategoryEvent>(_onSelectCategory);
    on<ToggleFavoriteEvent>(_onToggleFavorite);
    on<ToggleFavoritesFilterEvent>(_onToggleFavoritesFilter);
  }

  Future<void> _onFetchMeals(FetchMealsEvent event, Emitter<MealState> emit) async {
    emit(state.copyWith(status: MealStatus.loading));
    try {
      _currentPage = 1;
      final meals = await repository.getMealsPage(_currentPage);
      final favorites = await repository.getFavorites();
      emit(state.copyWith(
        status: MealStatus.success,
        meals: meals,
        favoriteIds: favorites,
        hasMore: meals.isNotEmpty,
      ));
    } catch (e) {
      emit(state.copyWith(status: MealStatus.failure, errorMessage: e.toString()));
    }
  }

  Future<void> _onLoadNextPage(LoadNextPageEvent event, Emitter<MealState> emit) async {
    if (!state.hasMore || state.searchQuery.isNotEmpty || state.showFavoritesOnly) return;
    try {
      _currentPage++;
      final newMeals = await repository.getMealsPage(_currentPage);
      if (newMeals.isEmpty) {
        emit(state.copyWith(hasMore: false));
      } else {
        emit(state.copyWith(
          meals: [...state.meals, ...newMeals],
          hasMore: true,
        ));
      }
    } catch (_) {}
  }

  Future<void> _onSearchMeals(SearchMealsEvent event, Emitter<MealState> emit) async {
    emit(state.copyWith(searchQuery: event.query));
    if (event.query.isNotEmpty) {
      try {
        final searchResults = await repository.searchMeals(event.query);
        final combined = {...state.meals, ...searchResults}.toList();
        emit(state.copyWith(meals: combined));
      } catch (_) {}
    }
  }

  void _onSelectCategory(SelectCategoryEvent event, Emitter<MealState> emit) {
    emit(state.copyWith(selectedCategory: event.category, showFavoritesOnly: false));
  }

  Future<void> _onToggleFavorite(ToggleFavoriteEvent event, Emitter<MealState> emit) async {
    final currentFavs = Set<String>.from(state.favoriteIds);
    if (currentFavs.contains(event.mealId)) {
      currentFavs.remove(event.mealId);
    } else {
      currentFavs.add(event.mealId);
    }
    await repository.saveFavorites(currentFavs);
    emit(state.copyWith(favoriteIds: currentFavs));
  }

  void _onToggleFavoritesFilter(ToggleFavoritesFilterEvent event, Emitter<MealState> emit) {
    emit(state.copyWith(showFavoritesOnly: !state.showFavoritesOnly));
  }
}
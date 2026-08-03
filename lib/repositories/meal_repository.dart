import '../models/meal.dart';
import '../services/api_service.dart';
import '../services/local_storage_service.dart';

class MealRepository {
  final ApiService _apiService;
  final LocalStorageService _storageService;

  final List<String> _alphabetPages = ['c', 'b', 'a', 'd', 'e', 'f', 'g', 'h', 'i'];

  MealRepository({
    ApiService? apiService,
    LocalStorageService? storageService,
  })  : _apiService = apiService ?? ApiService(),
        _storageService = storageService ?? LocalStorageService();

  Future<List<Meal>> getMealsPage(int page) async {
    if (page < 1 || page > _alphabetPages.length) return [];
    try {
      final letter = _alphabetPages[page - 1];
      final rawList = await _apiService.fetchMealsByLetter(letter);
      final meals = rawList.map((e) => Meal.fromJson(e)).toList();

      // Кэшируем полученные данные
      final existingCache = await _storageService.getCachedMeals();
      final updatedCache = {...existingCache, ...meals}.toList();
      await _storageService.cacheMeals(updatedCache);

      return meals;
    } catch (_) {
      // Если сети нет — отдаём оффлайн-кэш
      return await _storageService.getCachedMeals();
    }
  }

  Future<List<Meal>> searchMeals(String query) async {
    if (query.trim().isEmpty) return [];
    final rawList = await _apiService.searchMealsByName(query);
    return rawList.map((e) => Meal.fromJson(e)).toList();
  }

  Future<Set<String>> getFavorites() => _storageService.getFavoriteIds();
  Future<void> saveFavorites(Set<String> ids) => _storageService.saveFavoriteIds(ids);
}
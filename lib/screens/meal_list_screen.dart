import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../blocs/meal/meal_bloc.dart';
import '../blocs/meal/meal_event.dart';
import '../blocs/meal/meal_state.dart';
import '../widgets/meal/meal_card.dart';
import '../widgets/meal/search_bar_widget.dart';
import '../widgets/meal/category_chips_widget.dart';
import '../widgets/common/shimmer_loading.dart';
import '../widgets/common/error_view.dart';

class MealListScreen extends StatefulWidget {
  const MealListScreen({super.key});

  @override
  State<MealListScreen> createState() => _MealListScreenState();
}

class _MealListScreenState extends State<MealListScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200) {
      context.read<MealBloc>().add(LoadNextPageEvent());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tasty Recipes'),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart_outlined),
            onPressed: () => context.push('/shopping-list'),
          )
        ],
      ),
      body: Column(
        children: [
          SearchBarWidget(
            onChanged: (query) => context.read<MealBloc>().add(SearchMealsEvent(query)),
          ),
          BlocBuilder<MealBloc, MealState>(
            builder: (context, state) => CategoryChipsWidget(
              categories: state.categories,
              selectedCategory: state.selectedCategory,
              showFavoritesOnly: state.showFavoritesOnly,
              onCategorySelected: (cat) => context.read<MealBloc>().add(SelectCategoryEvent(cat)),
              onFavoritesToggled: () => context.read<MealBloc>().add(ToggleFavoritesFilterEvent()),
            ),
          ),
          Expanded(
            child: BlocBuilder<MealBloc, MealState>(
              builder: (context, state) {
                if (state.status == MealStatus.loading) return const ShimmerLoading();
                if (state.status == MealStatus.failure) {
                  return ErrorView(
                    errorMessage: state.errorMessage ?? 'Error',
                    onRetry: () => context.read<MealBloc>().add(FetchMealsEvent()),
                  );
                }

                final meals = state.filteredMeals;
                if (meals.isEmpty) return const Center(child: Text('No recipes found.'));

                return RefreshIndicator(
                  onRefresh: () async => context.read<MealBloc>().add(FetchMealsEvent()),
                  child: ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.all(16),
                    itemCount: meals.length + (state.hasMore ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (index == meals.length) {
                        return const Center(child: Padding(padding: EdgeInsets.all(16), child: CircularProgressIndicator()));
                      }
                      final meal = meals[index];
                      return MealCard(
                        meal: meal,
                        isFavorite: state.favoriteIds.contains(meal.id),
                        onTap: () => context.push('/detail', extra: meal),
                        onFavoriteTap: () => context.read<MealBloc>().add(ToggleFavoriteEvent(meal.id)),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/meal.dart';
import '../blocs/meal/meal_bloc.dart';
import '../blocs/meal/meal_event.dart';
import '../blocs/meal/meal_state.dart';
import '../blocs/shopping_list/shopping_list_bloc.dart';
import '../blocs/shopping_list/shopping_list_event.dart';
import '../widgets/common/favorite_button.dart';
import '../widgets/detail/ingredient_item_tile.dart';

class MealDetailScreen extends StatelessWidget {
  final Meal meal;

  const MealDetailScreen({super.key, required this.meal});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            actions: [
              BlocBuilder<MealBloc, MealState>(
                builder: (context, state) => FavoriteButton(
                  isFavorite: state.favoriteIds.contains(meal.id),
                  color: Colors.white,
                  onTap: () => context.read<MealBloc>().add(ToggleFavoriteEvent(meal.id)),
                ),
              )
            ],
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                meal.name,
                style: const TextStyle(
                  color: Colors.white,
                  shadows: [Shadow(blurRadius: 10, color: Colors.black)],
                ),
              ),
              background: CachedNetworkImage(
                imageUrl: meal.thumbnailUrl,
                fit: BoxFit.cover,
                placeholder: (context, url) => const Center(
                  child: CircularProgressIndicator(),
                ),
                errorWidget: (context, url, error) => Container(
                  color: Colors.grey[850],
                  child: const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.wifi_off, size: 48, color: Colors.white54),
                      SizedBox(height: 8),
                      Text(
                        'Image unavailable offline',
                        style: TextStyle(color: Colors.white54),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                ElevatedButton.icon(
                  icon: const Icon(Icons.add_shopping_cart),
                  label: const Text('Add Ingredients to Shopping List'),
                  onPressed: () {
                    context
                        .read<ShoppingListBloc>()
                        .add(AddIngredientsEvent(meal.name, meal.ingredients));
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Ingredients added to Shopping List!')),
                    );
                  },
                ),
                const SizedBox(height: 20),
                const Text('Ingredients', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                if (meal.ingredients.isEmpty)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 8),
                    child: Text('No ingredients listed.', style: TextStyle(color: Colors.grey)),
                  )
                else
                  ...meal.ingredients.map((ing) => IngredientItemTile(ingredient: ing)),
                const Divider(height: 32),
                const Text('Instructions', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),
                Text(meal.instructions, style: const TextStyle(fontSize: 15, height: 1.5)),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}
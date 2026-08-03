import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../models/meal.dart';
import '../common/favorite_button.dart';

class MealCard extends StatelessWidget {
  final Meal meal;
  final bool isFavorite;
  final VoidCallback onTap;
  final VoidCallback onFavoriteTap;

  const MealCard({
    super.key,
    required this.meal,
    required this.isFavorite,
    required this.onTap,
    required this.onFavoriteTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Row(
          children: [
            SizedBox(
              width: 110,
              height: 110,
              child: CachedNetworkImage(
                imageUrl: meal.thumbnailUrl,
                fit: BoxFit.cover,
                placeholder: (_, __) => const Center(child: CircularProgressIndicator(strokeWidth: 2)),
                errorWidget: (_, __, ___) => const Icon(Icons.fastfood),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(meal.name, maxLines: 2, style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    Chip(label: Text(meal.category, style: const TextStyle(fontSize: 11))),
                  ],
                ),
              ),
            ),
            FavoriteButton(isFavorite: isFavorite, onTap: onFavoriteTap),
          ],
        ),
      ),
    );
  }
}
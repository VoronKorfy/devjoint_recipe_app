import 'package:flutter/material.dart';

class CategoryChipsWidget extends StatelessWidget {
  final List<String> categories;
  final String selectedCategory;
  final bool showFavoritesOnly;
  final ValueChanged<String> onCategorySelected;
  final VoidCallback onFavoritesToggled;

  const CategoryChipsWidget({
    super.key,
    required this.categories,
    required this.selectedCategory,
    required this.showFavoritesOnly,
    required this.onCategorySelected,
    required this.onFavoritesToggled,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        children: [
          FilterChip(
            avatar: Icon(showFavoritesOnly ? Icons.favorite : Icons.favorite_border, size: 16, color: Colors.red),
            label: const Text('Favorites'),
            selected: showFavoritesOnly,
            onSelected: (_) => onFavoritesToggled(),
          ),
          const VerticalDivider(indent: 10, endIndent: 10),
          ...categories.map((cat) => Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: ChoiceChip(
              label: Text(cat),
              selected: selectedCategory == cat && !showFavoritesOnly,
              onSelected: (_) => onCategorySelected(cat),
            ),
          )),
        ],
      ),
    );
  }
}
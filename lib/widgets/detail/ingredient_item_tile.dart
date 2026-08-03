import 'package:flutter/material.dart';

class IngredientItemTile extends StatelessWidget {
  final String ingredient;

  const IngredientItemTile({super.key, required this.ingredient});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          const Icon(Icons.check_circle_outline, size: 18, color: Colors.green),
          const SizedBox(width: 8),
          Expanded(child: Text(ingredient, style: const TextStyle(fontSize: 15))),
        ],
      ),
    );
  }
}
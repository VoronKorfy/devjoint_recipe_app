import 'package:flutter/material.dart';

class FavoriteButton extends StatelessWidget {
  final bool isFavorite;
  final VoidCallback onTap;
  final Color? color;

  const FavoriteButton({
    super.key,
    required this.isFavorite,
    required this.onTap,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        isFavorite ? Icons.favorite : Icons.favorite_border,
        color: isFavorite ? Colors.red : (color ?? Colors.grey),
      ),
      onPressed: onTap,
    );
  }
}
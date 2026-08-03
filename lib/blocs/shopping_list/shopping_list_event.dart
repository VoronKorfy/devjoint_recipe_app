import 'package:equatable/equatable.dart';

abstract class ShoppingListEvent extends Equatable {
  const ShoppingListEvent();
  @override
  List<Object?> get props => [];
}

class LoadShoppingListEvent extends ShoppingListEvent {}

class AddIngredientsEvent extends ShoppingListEvent {
  final String recipeName;
  final List<String> ingredients;
  const AddIngredientsEvent(this.recipeName, this.ingredients);
  @override
  List<Object?> get props => [recipeName, ingredients];
}

class ToggleShoppingItemEvent extends ShoppingListEvent {
  final String itemId;
  const ToggleShoppingItemEvent(this.itemId);
  @override
  List<Object?> get props => [itemId];
}

class ClearBoughtItemsEvent extends ShoppingListEvent {}
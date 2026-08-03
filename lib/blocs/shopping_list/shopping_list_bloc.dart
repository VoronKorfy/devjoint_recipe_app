import 'package:flutter_bloc/flutter_bloc.dart';

import '../../models/shopping_item.dart';
import '../../services/local_storage_service.dart';
import 'shopping_list_event.dart';
import 'shopping_list_state.dart';

class ShoppingListBloc extends Bloc<ShoppingListEvent, ShoppingListState> {
  final LocalStorageService storageService;

  ShoppingListBloc({required this.storageService})
      : super(const ShoppingListState()) {
    on<LoadShoppingListEvent>(_onLoad);
    on<AddIngredientsEvent>(_onAddIngredients);
    on<ToggleShoppingItemEvent>(_onToggleItem);
    on<ClearBoughtItemsEvent>(_onClearBought);
  }

  Future<void> _onLoad(
      LoadShoppingListEvent event, Emitter<ShoppingListState> emit) async {
    final items = await storageService.getShoppingList();
    emit(ShoppingListState(items: items));
  }

  Future<void> _onAddIngredients(
      AddIngredientsEvent event, Emitter<ShoppingListState> emit) async {
    final newItems = event.ingredients
        .map((ing) => ShoppingItem(
      id: DateTime.now().microsecondsSinceEpoch.toString() +
          ing.hashCode.toString(),
      name: ing,
      recipeName: event.recipeName,
    ))
        .toList();

    final updated = [...state.items, ...newItems];
    await storageService.saveShoppingList(updated);
    emit(ShoppingListState(items: updated));
  }

  Future<void> _onToggleItem(
      ToggleShoppingItemEvent event, Emitter<ShoppingListState> emit) async {
    final updated = state.items.map((item) {
      return item.id == event.itemId
          ? item.copyWith(isBought: !item.isBought)
          : item;
    }).toList();

    await storageService.saveShoppingList(updated);
    emit(ShoppingListState(items: updated));
  }

  Future<void> _onClearBought(
      ClearBoughtItemsEvent event, Emitter<ShoppingListState> emit) async {
    final updated = state.items.where((i) => !i.isBought).toList();
    await storageService.saveShoppingList(updated);
    emit(ShoppingListState(items: updated));
  }
}
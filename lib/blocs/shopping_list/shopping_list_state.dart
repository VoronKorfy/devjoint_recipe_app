import 'package:equatable/equatable.dart';
import '../../models/shopping_item.dart';

class ShoppingListState extends Equatable {
  final List<ShoppingItem> items;

  const ShoppingListState({this.items = const []});

  @override
  List<Object?> get props => [items];
}
import 'package:equatable/equatable.dart';

class ShoppingItem extends Equatable {
  final String id;
  final String name;
  final String recipeName;
  final bool isBought;

  const ShoppingItem({
    required this.id,
    required this.name,
    required this.recipeName,
    this.isBought = false,
  });

  ShoppingItem copyWith({bool? isBought}) {
    return ShoppingItem(
      id: id,
      name: name,
      recipeName: recipeName,
      isBought: isBought ?? this.isBought,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'recipeName': recipeName,
    'isBought': isBought,
  };

  factory ShoppingItem.fromJson(Map<String, dynamic> json) => ShoppingItem(
    id: json['id'] ?? '',
    name: json['name'] ?? '',
    recipeName: json['recipeName'] ?? '',
    isBought: json['isBought'] ?? false,
  );

  @override
  List<Object?> get props => [id, name, recipeName, isBought];
}
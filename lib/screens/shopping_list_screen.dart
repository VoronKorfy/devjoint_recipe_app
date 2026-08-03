import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/shopping_list/shopping_list_bloc.dart';
import '../blocs/shopping_list/shopping_list_event.dart';
import '../blocs/shopping_list/shopping_list_state.dart';

class ShoppingListScreen extends StatelessWidget {
  const ShoppingListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Shopping List'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_sweep),
            onPressed: () => context.read<ShoppingListBloc>().add(ClearBoughtItemsEvent()),
          )
        ],
      ),
      body: BlocBuilder<ShoppingListBloc, ShoppingListState>(
        builder: (context, state) {
          if (state.items.isEmpty) {
            return const Center(child: Text('Shopping list is empty!'));
          }

          return ListView.builder(
            itemCount: state.items.length,
            itemBuilder: (context, index) {
              final item = state.items[index];
              return CheckboxListTile(
                title: Text(
                  item.name,
                  style: TextStyle(
                    decoration: item.isBought ? TextDecoration.lineThrough : null,
                  ),
                ),
                subtitle: Text(item.recipeName),
                value: item.isBought,
                onChanged: (_) {
                  context.read<ShoppingListBloc>().add(ToggleShoppingItemEvent(item.id));
                },
              );
            },
          );
        },
      ),
    );
  }
}
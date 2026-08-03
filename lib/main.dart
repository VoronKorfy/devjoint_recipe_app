import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'services/local_storage_service.dart';
import 'repositories/meal_repository.dart';
import 'blocs/meal/meal_bloc.dart';
import 'blocs/meal/meal_event.dart';
import 'blocs/shopping_list/shopping_list_bloc.dart';
import 'blocs/shopping_list/shopping_list_event.dart';
import 'models/meal.dart';
import 'screens/meal_list_screen.dart';
import 'screens/meal_detail_screen.dart';
import 'screens/shopping_list_screen.dart';

void main() {
  runApp(const MyApp());
}

final GoRouter _router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const MealListScreen(),
    ),
    GoRoute(
      path: '/detail',
      builder: (context, state) => MealDetailScreen(meal: state.extra as Meal),
    ),
    GoRoute(
      path: '/shopping-list',
      builder: (context, state) => const ShoppingListScreen(),
    ),
  ],
);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final storageService = LocalStorageService();
    final mealRepository = MealRepository(storageService: storageService);

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => MealBloc(repository: mealRepository)..add(FetchMealsEvent()),
        ),
        BlocProvider(
          create: (context) => ShoppingListBloc(storageService: storageService)..add(LoadShoppingListEvent()),
        ),
      ],
      child: MaterialApp.router(
        title: 'Tasty Recipes Pro',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFFE65100)),
        ),
        darkTheme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFFE65100),
            brightness: Brightness.dark,
          ),
        ),
        themeMode: ThemeMode.system,
        routerConfig: _router,
      ),
    );
  }
}
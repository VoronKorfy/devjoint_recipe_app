# Tasty Recipes App (TheMealDB)

A robust, production-ready Flutter application built for the Week 3 Intern Assignment. The app connects to the open REST API [TheMealDB](https://www.themealdb.com/api.php), featuring state management via BLoC, interactive pagination, search with debounce, offline caching, and a full-featured shopping list.

---

## Features & Key Highlights

* **Clean Architecture & BLoC Pattern**: Complete separation of business logic, state management, and UI layer using `flutter_bloc`.
* **Pagination / Infinite Scroll**: Dynamic recipe fetching using alphabet indexing with protection against duplicate continuous triggers.
* **Pull-to-Refresh**: Seamless data refresh with `RefreshIndicator` that resets pagination and updates local cache.
* **Smart Search with Debounce**: Responsive live search leveraging `RxDart` stream transformers (300ms delay) to prevent spamming API requests.
* **Offline First & Image Caching**: 
  * Disk caching for network images using `cached_network_image` with offline fallback placeholders.
  * Local JSON caching via `SharedPreferences` for full offline availability.
* **Interactive Shopping List**: Add ingredients directly from recipe details to a local persistent checklist.
* **Category Filtering & Favorites**: Filter meals by category or isolate saved favorite recipes instantly.

---

## Tech Stack & Packages Used

* **Framework**: Flutter (Dart)
* **State Management**: `flutter_bloc`, `equatable`
* **Networking**: `dio`
* **Local Persistence**: `shared_preferences`
* **Navigation**: `go_router`
* **Image Caching**: `cached_network_image`
* **UI Utilities**: `shimmer` (skeleton loading), `rxdart` (debounce transformers)

---

## Project Architecture

```text
lib/
├── blocs/               # Business logic components (MealBloc, ShoppingListBloc)
├── models/              # Data models with robust null-safe JSON parsers
├── repositories/        # Repository pattern isolating API and Storage sources
├── services/            # API service (Dio) & Local Storage service (SharedPreferences)
├── screens/             # Top-level screen views
└── widgets/             # Reusable UI components (Cards, Chips, Error views, Shimmers)
```

---

## How to Run

1. **Clone the repository:**
```bash
git clone [https://github.com/VoronKorfy/devjoint_recipe_app.git](https://github.com/VoronKorfy/devjoint_recipe_app.git)
cd devjoint_recipe_app
```


2. **Install dependencies:**
```bash
flutter pub get
```


3. **Run the application:**
```bash
flutter run
```
# ✅ Glassmorphic To-Do List App

A Flutter To-Do List app built for **Week 2** of the DevelopersHub Corporation Flutter Internship.

## Features

- ✅ Add, edit, and delete tasks
- ✅ Mark tasks as complete/incomplete
- ✅ Persistent storage using `SharedPreferences`
- ✅ Filter tasks: All / Pending / Completed
- ✅ Progress bar showing completion percentage
- ✅ Undo delete with Snackbar
- ✅ Swipe left to reveal Edit & Delete actions
- ✅ Animated gradient background
- ✅ Glassmorphism UI throughout
- ✅ Haptic feedback
- ✅ Empty state screens per filter
- ✅ Time-aware greeting (morning/afternoon/evening)

## Setup Instructions

### Prerequisites
- Flutter SDK `>=3.0.0`
- Dart SDK `>=3.0.0`
- Android Studio or VS Code with Flutter plugin

### Steps

```bash
# 1. Clone or copy the project
cd todo_app

# 2. Install dependencies
flutter pub get

# 3. Run the app
flutter run
```

### Dependencies

| Package | Version | Purpose |
|--------|---------|---------|
| `shared_preferences` | ^2.2.2 | Local task persistence |
| `flutter_slidable` | ^3.0.1 | Swipe actions on task tiles |

## Project Structure

```
lib/
├── main.dart                        # App entry point + animated background
├── models/
│   └── task_model.dart              # Task data model with JSON serialization
├── services/
│   └── task_storage_service.dart    # SharedPreferences read/write
├── screens/
│   └── home_screen.dart             # Main screen with list, filters, stats
└── widgets/
    ├── glass_container.dart          # Reusable glassmorphism container
    ├── task_tile.dart                # Individual task row with swipe actions
    ├── add_task_sheet.dart           # Bottom sheet for add/edit
    └── empty_state.dart              # Empty state per filter
```

## SharedPreferences Usage

Tasks are serialized as a `List<String>` of JSON strings and stored under the key `tasks_list`. On every add, edit, toggle, or delete — the full list is re-saved immediately.

```dart
// Save
await prefs.setStringList('tasks_list', tasks.map((t) => t.toJson()).toList());

// Load
final List<String>? encoded = prefs.getStringList('tasks_list');
```

## Screenshots

> Add screenshots of your running app here.

---

Built with 💜 Flutter — DevelopersHub Corporation Internship Week 2

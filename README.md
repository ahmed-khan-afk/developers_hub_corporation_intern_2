<p align="center">
  <img src="https://img.shields.io/badge/Flutter-3.0+-02569B?style=for-the-badge&logo=flutter&logoColor=white"/>
  <img src="https://img.shields.io/badge/Dart-3.0+-0175C2?style=for-the-badge&logo=dart&logoColor=white"/>
  <img src="https://img.shields.io/badge/Platform-Android%20%7C%20iOS%20%7C%20Web-brightgreen?style=for-the-badge"/>
  <img src="https://img.shields.io/badge/Internship-DevelopersHub%20Corp-7C3AED?style=for-the-badge"/>
</p>

<h1 align="center">To-Do List App</h1>
<p align="center">
  A beautiful, fully functional To-Do List app built with Flutter featuring a glassmorphism UI design, persistent local storage via SharedPreferences, and smooth animations — developed as part of <strong>Week 2</strong> of the DevelopersHub Corporation Flutter Internship.
</p>

---

## 📱 Screenshots

> Add screenshots of your running app here.

<img width="720" height="1459" alt="WhatsApp Image 2026-06-18 at 1 04 57 AM" src="https://github.com/user-attachments/assets/2802aadb-ffcd-4359-ac23-18ed52630a35" />
<img width="720" height="1476" alt="WhatsApp Image 2026-06-18 at 1 04 56 AM" src="https://github.com/user-attachments/assets/3bb563bc-0604-465c-8d3d-0eae84696890" />
<img width="720" height="1470" alt="WhatsApp Image 2026-06-18 at 1 04 55 AM" src="https://github.com/user-attachments/assets/8678c20e-189b-48a8-a26c-b1cb862921ab" />
<img width="720" height="1442" alt="WhatsApp Image 2026-06-18 at 1 04 54 AM" src="https://github.com/user-attachments/assets/4ded0cb2-1283-40bc-861b-06e9ad26de03" />
<img width="720" height="1428" alt="WhatsApp Image 2026-06-18 at 1 04 53 AM" src="https://github.com/user-attachments/assets/56f1713f-c88c-42ec-953e-ad01f3ca76f9" />


## ✨ Features

| Feature | Description |
|---|---|
| ➕ Add Tasks | Create new tasks via an animated bottom sheet |
| ✏️ Edit Tasks | Update any existing task inline |
| 🗑️ Delete Tasks | Swipe left to delete with an UNDO option |
| ✅ Toggle Complete | Mark tasks as done with animated checkbox |
| 💾 Persistent Storage | All tasks saved locally using `SharedPreferences` |
| 🔍 Filter Tabs | Switch between All / Pending / Completed views |
| 📊 Progress Bar | Animated completion percentage bar |
| 📈 Stats Chips | Live count of Total, Pending, and Done tasks |
| 🌊 Glassmorphism UI | Frosted glass effects throughout the app |
| 🌈 Animated Background | Slow-shifting purple-indigo gradient |
| 📳 Haptic Feedback | Tactile response on all interactions |
| 🌙 Smart Greeting | Time-aware greeting (morning / afternoon / evening) |
| 🪣 Empty States | Custom empty state per filter tab |

---

## 🗂️ Project Structure

```
lib/
├── main.dart                         # App entry point + animated gradient background
├── models/
│   └── task_model.dart               # Task data model with JSON serialization
├── services/
│   └── task_storage_service.dart     # SharedPreferences read/write service
├── screens/
│   └── home_screen.dart              # Main screen — list, filters, stats, FAB
└── widgets/
    ├── glass_container.dart          # Reusable glassmorphism widget
    ├── task_tile.dart                # Task row with swipe-to-edit/delete
    ├── add_task_sheet.dart           # Animated overlay for add/edit
    └── empty_state.dart              # Per-filter empty state widget
```

---

## 🚀 Getting Started

### Prerequisites

- Flutter SDK `>=3.0.0`
- Dart SDK `>=3.0.0`
- Android Studio **or** VS Code with the Flutter & Dart plugins

### Installation

```bash
# 1. Clone the repository
git clone https://github.com/ahmed-khan-afk/developers_hub_corporation_intern_2.git

# 2. Navigate into the project
cd developers_hub_corporation_intern_2

# 3. Install dependencies
flutter pub get

# 4. Run the app
flutter run
```

To run on a specific platform:

```bash
flutter run -d chrome       # Web
flutter run -d android      # Android
flutter run -d ios          # iOS
```

---

## 📦 Dependencies

| Package | Version | Purpose |
|---|---|---|
| [`shared_preferences`](https://pub.dev/packages/shared_preferences) | ^2.2.2 | Persistent local storage for tasks |
| [`flutter_slidable`](https://pub.dev/packages/flutter_slidable) | ^3.0.1 | Swipe actions (edit & delete) on task tiles |

---

## 💾 SharedPreferences Implementation

Tasks are JSON-serialized and stored as a `List<String>` under the key `tasks_list`. Every add, edit, toggle, or delete operation immediately re-saves the full list.

```dart
// Save all tasks
await prefs.setStringList(
  'tasks_list',
  tasks.map((task) => task.toJson()).toList(),
);

// Load all tasks
final List<String>? encoded = prefs.getStringList('tasks_list');
final tasks = encoded?.map((e) => Task.fromJson(e)).toList() ?? [];
```

---

## 🏗️ Architecture

The app follows a simple, clean architecture suitable for a week-long internship project:

- **Model** — `Task` class with `copyWith`, `toJson`, and `fromJson` methods
- **Service** — `TaskStorageService` abstracts all SharedPreferences logic
- **Screen** — `HomeScreen` manages state with `setState` and calls the service
- **Widgets** — Reusable, self-contained UI components with clear responsibilities

---

## 🎨 Design System

The UI is built around **glassmorphism** — a design trend using frosted glass-like surfaces:

- `BackdropFilter` with `ImageFilter.blur` for the frosted glass effect
- Semi-transparent tinted containers with subtle white borders
- Deep purple/indigo animated gradient background
- All glass containers use `Border.all()` with uniform colors for cross-platform compatibility

---

## 🌐 Platform Compatibility

| Platform | Status |
|---|---|
| Android | ✅ Fully supported |
| iOS | ✅ Fully supported |
| Web | ✅ Supported (with `showDialog` instead of `showModalBottomSheet`) |
| Windows / macOS / Linux | ✅ Desktop scaffold included |

---

## 📚 Internship Context

This project was built for **Week 2** of the [DevelopersHub Corporation](https://developershub.com) Flutter Development Internship.

**Week 2 Task Requirements:**
- Build a To-Do List app in Flutter
- Display tasks in a `ListView`
- Add tasks using `TextFormField` with form validation
- Persist tasks using `SharedPreferences`
- Manage UI state using `setState`

---

## 👨‍💻 Author

**Ahmed Khan**
Flutter Development Intern @ DevelopersHub Corporation
[GitHub](https://github.com/ahmed-khan-afk)

---

<p align="center">Built with 💜 Flutter — DevelopersHub Corporation Internship Week 2</p>

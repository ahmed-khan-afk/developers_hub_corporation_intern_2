import 'package:shared_preferences/shared_preferences.dart';
import '../models/task_model.dart';

class TaskStorageService {
  static const String _tasksKey = 'tasks_list';
  
  Future<bool> saveTasks(List<Task> tasks) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final List<String> encodedTasks =
          tasks.map((task) => task.toJson()).toList();
      return await prefs.setStringList(_tasksKey, encodedTasks);
    } catch (e) {
      return false;
    }
  }

  Future<List<Task>> loadTasks() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final List<String>? encodedTasks = prefs.getStringList(_tasksKey);
      if (encodedTasks == null) return [];
      return encodedTasks
          .map((taskJson) => Task.fromJson(taskJson))
          .toList();
    } catch (e) {
      return [];
    }
  }

  Future<bool> clearAllTasks() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      return await prefs.remove(_tasksKey);
    } catch (e) {
      return false;
    }
  }
}

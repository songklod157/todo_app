import 'dart:convert';
import 'package:flutter_todo_app/data/models/task_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:typed_data';

class TaskRepository {
  static const String _tasksKey = 'tasks';

  Future<List<Task>> getTasks() async {
    final prefs = await SharedPreferences.getInstance();
    final tasksJson = prefs.getStringList(_tasksKey) ?? [];
    return tasksJson
        .map((taskJson) => Task.fromJson(jsonDecode(taskJson)))
        .toList();
  }

  Future<void> saveTask(Task task, Uint8List imageBytes) async {
    final prefs = await SharedPreferences.getInstance();
    final tasksJson = prefs.getStringList(_tasksKey) ?? [];
    final Map<String, dynamic> taskJson = task.toJson();
    taskJson['imageBase64'] = base64Encode(imageBytes);
    tasksJson.add(jsonEncode(task.toJson()));
    prefs.setStringList(_tasksKey, tasksJson);
  }

  Future<void> updateTask(Task updatedTask, Uint8List imageBytes) async {
    final prefs = await SharedPreferences.getInstance();
    final tasksJson = prefs.getStringList(_tasksKey) ?? [];
    final Map<String, dynamic> updatedTaskJson = updatedTask.toJson();
    updatedTaskJson['imageBase64'] = base64Encode(imageBytes);
    final updatedTasksJson = tasksJson.map((taskJson) {
      final task = Task.fromJson(jsonDecode(taskJson));
      return task.id == updatedTask.id
          ? jsonEncode(updatedTask.toJson())
          : taskJson;
    }).toList();
    prefs.setStringList(_tasksKey, updatedTasksJson);
  }

  Future<void> deleteTask(String taskId) async {
    final prefs = await SharedPreferences.getInstance();
    final tasksJson = prefs.getStringList(_tasksKey) ?? [];
    final updatedTasksJson = tasksJson.where((taskJson) {
      final task = Task.fromJson(jsonDecode(taskJson));
      return task.id != taskId;
    }).toList();
    prefs.setStringList(_tasksKey, updatedTasksJson);
  }
}

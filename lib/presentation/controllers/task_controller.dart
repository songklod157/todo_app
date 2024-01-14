import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_todo_app/data/models/task_model.dart';
import 'package:flutter_todo_app/data/repositories/task_repositorie.dart';
import 'package:flutter_todo_app/domain/usecases/create_task_usecase.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class TaskController extends GetxController {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TaskRepository _taskRepository = TaskRepository();
  final CreateTaskUsecase _createTaskUsecase;
  final RxList<Task> tasks = <Task>[].obs;
  final Rx<TaskInput> _taskInput = TaskInput(
    title: '',
    description: '',
    date: DateTime.now(),
    status: 'IN_PROGRESS',
    imageBase64: '',
  ).obs;
  RxList<Task> get filteredTasks => tasks;
  TaskInput get taskInput => _taskInput.value;
  Uint8List? selectedImage;
  TaskController(this._createTaskUsecase) {
    getTasks(); // Load tasks initially
  }
  Future<void> getTasks() async {
    final loadedTasks = await _taskRepository.getTasks();
    tasks.assignAll(loadedTasks);
  }

  Future<void> pickImage() async {
    final pickedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      selectedImage = await pickedImage.readAsBytes();
    } else {
      // ignore: avoid_print
      print('no image selected');
    }
    update();
  }

  void updateTaskInputDate(DateTime date) {
    taskInput.date = date;
    update();
  }

  validateTitle(String? value) {
    if (value == null || value.isEmpty) {
      return 'Title is required';
    } else if (value.length > 100) {
      return 'Title must not exceed 100 characters';
    }
    return null;
  }

  validateDate(String? value) {
    if (value == null || value.isEmpty) {
      return 'Date is required';
    } else {
      try {
        DateTime.parse(value);
      } catch (e) {
        return 'Invalid date format';
      }
    }
    return null;
  }

  void sortByTitle() {
    tasks.sort((a, b) => a.title.compareTo(b.title));
  }

  void sortByDate() {
    tasks.sort((a, b) => a.date.compareTo(b.date));
  }

  void sortByStatus() {
    tasks.sort((a, b) => a.status.compareTo(b.status));
  }

  void createTask() {
    if (formKey.currentState?.validate() ?? false) {
      _createTaskUsecase(_taskInput.value, selectedImage);
      _taskRepository.getTasks().then((tasks) {
        // ignore: avoid_print
        print('All Tasks: $tasks'); // Log tasks for demonstration purposes
      });
      formKey.currentState?.reset();
      getTasks();
      selectedImage = null;
      Get.back();
    }
  }

  void searchTasks(String query) {
    if (query.isEmpty) {
      getTasks();
    } else {
      final filtered = tasks.where((task) =>
          task.title.toLowerCase().contains(query.toLowerCase()) ||
          task.description.toLowerCase().contains(query.toLowerCase()));
      tasks.assignAll(filtered.toList());
    }
  }

  void updateTask({
    required String taskId,
    String? title,
    String? description,
    DateTime? date,
    Uint8List? imageBytes,
    String? status,
  }) async {
    final existingTask = tasks.firstWhere((task) => task.id == taskId,
        orElse: () => Task(
            id: taskId,
            title: '',
            date: DateTime.now(),
            status: '',
            description: '',
            imageBase64: ''));

    final updatedTask = existingTask.copyWith(
      title: title ?? existingTask.title,
      description: description ?? existingTask.description,
      date: date ?? existingTask.date,
      imageBase64: imageBytes != null
          ? base64Encode(imageBytes)
          : existingTask.imageBase64,
      status: status ?? existingTask.status,
    );

    await _taskRepository.updateTask(updatedTask, imageBytes ?? Uint8List(0));
    formKey.currentState?.reset();
    selectedImage = null;
    getTasks();
  }

  void deleteTask(String taskId) {
    _taskRepository.deleteTask(taskId);
    getTasks(); // Refresh the task list after deleting
  }

  void updateTaskStatus(String taskId, bool? isComplete) {
    if (isComplete != null) {
      final updatedTask = tasks.firstWhere((task) => task.id == taskId,
          orElse: () => Task(
              id: taskId,
              title: '',
              date: DateTime.now(),
              status: '',
              description: '',
              imageBase64: ''));

      updatedTask.status = isComplete ? 'COMPLETE' : 'IN_PROGRESS';

      _taskRepository.updateTask(updatedTask, Uint8List(0));
      getTasks(); // Refresh the task list after update
    }
  }
}

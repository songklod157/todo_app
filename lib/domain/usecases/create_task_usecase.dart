import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter_todo_app/data/models/task_model.dart';
import 'package:flutter_todo_app/data/repositories/task_repositorie.dart';
import 'package:uuid/uuid.dart';

class CreateTaskUsecase {
  final TaskRepository _taskRepository;

  CreateTaskUsecase(this._taskRepository);

  void call(TaskInput input, selectedImage) async {
    final newTask = Task(
      id: const Uuid().v4(),
      title: input.title,
      description: input.description,
      date: input.date,
      imageBase64: selectedImage != null
          ? base64Encode(selectedImage!)
          : '', // Convert selected image to Base64
      status: input.status,
    );
    await _taskRepository.saveTask(newTask, selectedImage ?? Uint8List(0));
  }
}

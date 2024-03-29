import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_todo_app/data/models/task_model.dart';
import 'package:flutter_todo_app/presentation/controllers/task_controller.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class TodoFormUpdateWidget extends StatelessWidget {
  TodoFormUpdateWidget({super.key, required this.task});
  final Task task;
  final TaskController taskController = Get.find();
  @override
  Widget build(BuildContext context) {
    bool updateImage = false;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Update Task'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Center(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  GetBuilder<TaskController>(builder: (controller) {
                    return Form(
                      key: taskController.formKey,
                      child: Column(
                        children: [
                          if (taskController.selectedImage == null)
                            Image.memory(
                              base64Decode(task.imageBase64),
                              width: 100,
                              height: 100,
                              fit: BoxFit.cover,
                            ),
                          if (taskController.selectedImage != null)
                            Image.memory(
                              taskController.selectedImage!,
                              width: 100,
                              height: 100,
                              fit: BoxFit.cover,
                            ),
                          const SizedBox(height: 10),
                          ElevatedButton(
                            onPressed: () async {
                              await taskController.pickImage();
                              updateImage = true;
                            },
                            child: const Text('Pick Image'),
                          ),
                          TextFormField(
                            initialValue: task.title,
                            decoration:
                                const InputDecoration(labelText: 'Title'),
                            validator: (value) {
                              return taskController.validateTitle(value);
                            },
                            onChanged: (value) {
                              taskController.taskInput.title = value;
                            },
                          ),
                          const SizedBox(height: 5),
                          TextFormField(
                            initialValue: task.description,
                            decoration:
                                const InputDecoration(labelText: 'Description'),
                            onChanged: (value) {
                              taskController.taskInput.description = value;
                            },
                          ),
                          TextFormField(
                              decoration:
                                  const InputDecoration(labelText: 'Date'),
                              readOnly: true,
                              onTap: () async {
                                final DateTime? pickedDate =
                                    await showDatePicker(
                                  context: context,
                                  initialDate: task.date,
                                  firstDate: DateTime(2000),
                                  lastDate: DateTime(2101),
                                );

                                if (pickedDate != null) {
                                  taskController
                                      .updateTaskInputDate(pickedDate);
                                }
                              },
                              controller: TextEditingController(
                                // ignore: unnecessary_null_comparison
                                text: taskController.taskInput.date != null
                                    ? DateFormat('yyyy-MM-dd')
                                        .format(taskController.taskInput.date)
                                    : '',
                              ),
                              validator: (value) {
                                return taskController.validateDate(value);
                              }),
                          const SizedBox(height: 5),
                          DropdownButtonFormField<String>(
                            value: taskController.taskInput.status,
                            items: ['IN_PROGRESS', 'COMPLETE']
                                .map<DropdownMenuItem<String>>(
                                  (String value) => DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  ),
                                )
                                .toList(),
                            onChanged: (String? value) {
                              taskController.taskInput.status = value ?? '';
                            },
                            decoration:
                                const InputDecoration(labelText: 'Status'),
                          ),
                          const SizedBox(height: 30),
                          SizedBox(
                            width: 300,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                ElevatedButton(
                                    onPressed: () {
                                      taskController.deleteTask(task.id);
                                      Get.back();
                                    },
                                    child: const Text('Delete Task')),
                                ElevatedButton(
                                  onPressed: () {
                                    if (!updateImage) {
                                      taskController.updateTask(
                                        taskId: task.id,
                                        title: taskController.taskInput.title,
                                        description: taskController
                                            .taskInput.description,
                                        date: taskController.taskInput.date,
                                        status: taskController.taskInput.status,
                                      );
                                    } else {
                                      taskController.updateTask(
                                        taskId: task.id,
                                        title: taskController.taskInput.title,
                                        description: taskController
                                            .taskInput.description,
                                        date: taskController.taskInput.date,
                                        imageBytes:
                                            taskController.selectedImage,
                                        status: taskController.taskInput.status,
                                      );
                                    }

                                    Get.back();
                                  },
                                  child: const Text('Update Task'),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                ]),
          ),
        ),
      ),
    );
  }
}

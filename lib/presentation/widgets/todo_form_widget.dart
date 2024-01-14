import 'package:flutter/material.dart';
import 'package:flutter_todo_app/presentation/controllers/task_controller.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class TodoFormWidget extends StatelessWidget {
  TodoFormWidget({super.key});
  final TaskController taskController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Task'),
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
                            Container(
                              width: 100,
                              height: 100,
                              decoration:
                                  const BoxDecoration(color: Colors.grey),
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
                            },
                            child: const Text('Pick Image'),
                          ),
                          TextFormField(
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
                                  initialDate: DateTime.now(),
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
                          const SizedBox(height: 5),
                          const SizedBox(height: 30),
                          ElevatedButton(
                            onPressed: () {
                              taskController.createTask();
                            },
                            child: const Text('Create Task'),
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

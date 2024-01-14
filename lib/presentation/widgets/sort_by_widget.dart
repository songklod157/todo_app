import 'package:flutter/material.dart';
import 'package:flutter_todo_app/data/repositories/task_repositorie.dart';
import 'package:flutter_todo_app/domain/usecases/create_task_usecase.dart';
import 'package:flutter_todo_app/presentation/controllers/task_controller.dart';
import 'package:get/get.dart';

class SortWidget extends StatelessWidget {
  SortWidget({super.key});
  final TaskController taskController =
      Get.put(TaskController(CreateTaskUsecase(TaskRepository())));

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 150,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Center(
            child: Column(
          children: [
            const Text('Sort by'),
            const SizedBox(height: 20),
            SizedBox(
              width: 300,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: () => taskController.sortByTitle(),
                    child: const Text('Title'),
                  ),
                  ElevatedButton(
                    onPressed: () => taskController.sortByDate(),
                    child: const Text('Date'),
                  ),
                  ElevatedButton(
                    onPressed: () => taskController.sortByStatus(),
                    child: const Text('Status'),
                  ),
                ],
              ),
            )
          ],
        )),
      ),
    );
  }
}

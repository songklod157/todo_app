import 'package:flutter/material.dart';
import 'package:flutter_todo_app/data/repositories/task_repositorie.dart';
import 'package:flutter_todo_app/domain/usecases/create_task_usecase.dart';
import 'package:flutter_todo_app/presentation/controllers/task_controller.dart';
import 'package:flutter_todo_app/presentation/widgets/custom_list_item.dart';
import 'package:flutter_todo_app/presentation/widgets/sort_by_widget.dart';
import 'package:flutter_todo_app/presentation/widgets/todo_form_widget.dart';
import 'package:get/get.dart';

class TodoPage extends StatelessWidget {
  TodoPage({super.key});
  final TaskController taskController =
      Get.put(TaskController(CreateTaskUsecase(TaskRepository())));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('TODO APPLICATION')),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 5),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  child: TextField(
                    onChanged: (value) => taskController.searchTasks(value),
                    decoration: const InputDecoration(
                      hintText: 'Search by Title or Description',
                      border: OutlineInputBorder(),
                      labelText: 'Search',
                    ),
                  ),
                ),
                const SizedBox(height: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Todo List'),
                    Row(
                      children: [
                        const Text(
                          'Sort by',
                          style: TextStyle(fontSize: 14),
                        ),
                        IconButton(
                            onPressed: () => showModalBottomSheet(
                                context: context,
                                builder: (context) {
                                  return SortWidget(
                                    key: key,
                                  );
                                }),
                            icon: const Icon(
                              Icons.tune,
                              size: 30,
                            ))
                      ],
                    ),
                  ],
                )
              ],
            ),
            const SizedBox(height: 5),
            Obx(
              () => Expanded(
                child: ListView.builder(
                  itemCount: taskController.filteredTasks.length,
                  itemBuilder: (context, index) {
                    final task = taskController.filteredTasks[index];
                    return Column(
                      children: [
                        CustomListItem(
                          task: task,
                        ),
                        const Divider(
                          height: 5,
                          thickness: 1,
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Get.to(() => TodoFormWidget()),
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}

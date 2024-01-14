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
                        // ListTile(
                        //   title: Text(
                        //       '${task.title}, ${DateFormat('yyyy-MM-dd').format(task.date)}'),
                        //   subtitle: Row(
                        //     children: [
                        //       const Text(
                        //         'Status:',
                        //       ),
                        //       Text(
                        //         task.status == 'IN_PROGRESS'
                        //             ? 'IN PROGRESS'
                        //             : task.status,
                        //         style: const TextStyle(
                        //             fontWeight: FontWeight.w600, fontSize: 12),
                        //       ),
                        //     ],
                        //   ),
                        //   isThreeLine: true,
                        //   leading: task.imageBase64.isNotEmpty
                        //       ? Image.memory(
                        //           base64Decode(task.imageBase64),
                        //           width: 50,
                        //           height: 50,
                        //           fit: BoxFit.cover,
                        //         )
                        //       : null,
                        //   trailing: Checkbox(
                        //     value: task.status == 'COMPLETE',
                        //     onChanged: (value) {
                        //       // Update task status when checkbox is triggered
                        //       taskController.updateTaskStatus(task.id, value);
                        //     },
                        //   ),
                        //   onTap: () {
                        //     // Update task with ID when tapping on a task (replace with your UI logic)
                        //     taskController.updateTask(
                        //       taskId: task.id,
                        //       title: 'Updated Title',
                        //       description: 'Updated Description',
                        //       date: DateTime.now(),
                        //       imageBytes: null,
                        //       status: 'COMPLETE',
                        //     );
                        //   },
                        //   onLongPress: () {
                        //     // Delete task with ID when long-pressing on a task (replace with your UI logic)
                        //     taskController.deleteTask(task.id);
                        //   },
                        // ),
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

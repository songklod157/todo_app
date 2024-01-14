import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_todo_app/data/repositories/task_repositorie.dart';
import 'package:flutter_todo_app/domain/usecases/create_task_usecase.dart';
import 'package:flutter_todo_app/presentation/controllers/task_controller.dart';

void main() {
  group('TaskController Tests', () {
    late TaskController taskController;

    setUp(() {
      taskController = TaskController(CreateTaskUsecase(TaskRepository()));
    });

    test('TaskController initializes correctly', () {
      expect(taskController.tasks, isNotNull);
      expect(taskController.tasks.length, 0);
    });

    test('Creating a task updates the task list', () {
      // Create a task
      taskController.taskInput.title = 'Test Task';
      taskController.taskInput.date = DateTime.now();
      taskController.taskInput.status = 'IN_PROGRESS';

      taskController.createTask();

      // Check if the task list has been updated
      expect(taskController.tasks.length, 1);
      expect(taskController.tasks.first.title, 'Test Task');
    });

    // Add more tests for sorting, searching, and updating tasks as needed
    // ...

    test('Updating a task updates the task list', () {
      // Create a task
      taskController.taskInput.title = 'Original Task';
      taskController.taskInput.date = DateTime.now();
      taskController.taskInput.status = 'IN_PROGRESS';

      taskController.createTask();

      // Update the task
      taskController.updateTask(
        taskId: taskController.tasks.first.id,
        title: 'Updated Task',
      );

      // Check if the task list has been updated
      expect(taskController.tasks.length, 1);
      expect(taskController.tasks.first.title, 'Updated Task');
    });

    test('Sorting tasks by title works correctly', () {
      // Create tasks with different titles
      taskController.taskInput.title = 'Task C';
      taskController.createTask();

      taskController.taskInput.title = 'Task A';
      taskController.createTask();

      taskController.taskInput.title = 'Task B';
      taskController.createTask();

      // Sort tasks by title
      taskController.sortByTitle();

      // Check if tasks are sorted correctly
      expect(taskController.tasks.map((task) => task.title),
          ['Task A', 'Task B', 'Task C']);
    });

    // Add more tests as needed...
  });
}

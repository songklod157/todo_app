import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_todo_app/data/repositories/task_repositorie.dart';
import 'package:flutter_todo_app/domain/usecases/create_task_usecase.dart';
import 'package:flutter_todo_app/presentation/controllers/task_controller.dart';
import 'package:flutter_todo_app/presentation/page/todo_page.dart';
import 'package:get/get.dart';

void main() {
  group('TodoPage Tests', () {
    late TaskController taskController;

    setUp(() {
      taskController = TaskController(CreateTaskUsecase(TaskRepository()));
      Get.put(
          taskController); // Inject the TaskController into the GetX dependency management system
    });

    testWidgets('TodoPage UI test', (WidgetTester tester) async {
      // Build our app and trigger a frame.
      await tester.pumpWidget(MaterialApp(
        home: TodoPage(),
      ));

      // Verify that the title text is present.
      expect(find.text('TODO App'), findsOneWidget);

      // Verify that the form fields are present.
      expect(find.byType(TextFormField), findsNWidgets(5));
      expect(find.byType(DropdownButtonFormField), findsOneWidget);

      // Verify that the create task button is present.
      expect(
          find.widgetWithText(ElevatedButton, 'Create Task'), findsOneWidget);

      // Tap the create task button and trigger a frame.
      await tester.tap(find.widgetWithText(ElevatedButton, 'Create Task'));
      await tester.pump();

      // Verify that tasks list is present.
      expect(find.byType(ListView), findsOneWidget);
    });

    // Add more tests for interactions, like tapping buttons, updating tasks, etc.
    // ...

    testWidgets('Updating task UI test', (WidgetTester tester) async {
      // Build our app and trigger a frame.
      await tester.pumpWidget(MaterialApp(
        home: TodoPage(),
      ));

      // Create a task
      taskController.taskInput.title = 'Test Task';
      taskController.taskInput.date = DateTime.now();
      taskController.taskInput.status = 'IN_PROGRESS';

      await tester.tap(find.widgetWithText(ElevatedButton, 'Create Task'));
      await tester.pump();

      // Tap on the task to update it
      await tester.tap(find.text('Test Task'));
      await tester.pump();

      // Verify that the update task button is present.
      expect(
          find.widgetWithText(ElevatedButton, 'Update Task'), findsOneWidget);

      // Tap the update task button and trigger a frame.
      await tester.tap(find.widgetWithText(ElevatedButton, 'Update Task'));
      await tester.pump();

      // Verify that the tasks list is updated.
      expect(find.text('Updated Task'), findsOneWidget);
    });
  });
}

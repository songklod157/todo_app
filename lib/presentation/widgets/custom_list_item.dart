import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_todo_app/data/models/task_model.dart';
import 'package:flutter_todo_app/presentation/controllers/task_controller.dart';
import 'package:flutter_todo_app/presentation/widgets/todo_form_update_widget.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class CustomListItem extends StatelessWidget {
  const CustomListItem({super.key, required this.task});

  final Task task;

  @override
  Widget build(BuildContext context) {
    final TaskController taskController = Get.find();
    return InkWell(
      onTap: () => Get.to(() => TodoFormUpdateWidget(task: task)),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 5.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            if (task.imageBase64.isEmpty)
              Container(
                width: 50,
                height: 80,
                decoration: const BoxDecoration(color: Colors.grey),
              ),
            if (task.imageBase64.isNotEmpty)
              Expanded(
                  flex: 1,
                  child: Image.memory(
                    base64Decode(task.imageBase64),
                    width: 50,
                    height: 80,
                    fit: BoxFit.cover,
                  )),
            Expanded(
              flex: 3,
              child: _CardDescription(
                title: task.title,
                description: task.description,
                status: task.status,
                date: DateFormat('yyyy-MM-dd').format(task.date),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 15),
              child: Checkbox(
                value: task.status == 'COMPLETE',
                onChanged: (value) {
                  // Update task status when checkbox is triggered
                  taskController.updateTaskStatus(task.id, value);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CardDescription extends StatelessWidget {
  const _CardDescription(
      {required this.title,
      required this.description,
      required this.status,
      required this.date});

  final String title;
  final String description;
  final String status;
  final String date;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(5.0, 0.0, 0.0, 0.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: 18,
            ),
          ),
          const Padding(padding: EdgeInsets.symmetric(vertical: 2.0)),
          Text(
            description,
            style: const TextStyle(fontSize: 12),
          ),
          const Padding(padding: EdgeInsets.symmetric(vertical: 1.0)),
          Row(
            children: [
              const Text('Status: ',
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 12)),
              Text(status == 'IN_PROGRESS' ? 'IN PROGRESS' : status,
                  style: const TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 12,
                      color: Colors.deepPurple)),
            ],
          ),
          Row(
            children: [
              const Text('Date: ',
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 12)),
              Text(date,
                  style: const TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 12,
                      color: Colors.deepPurple)),
            ],
          ),
        ],
      ),
    );
  }
}

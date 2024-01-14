class Task {
  final String id;
  final String title;
  final String description;
  final DateTime date;
  final String imageBase64;
  late String _status;

  Task({
    required this.id,
    required this.title,
    required this.description,
    required this.date,
    required this.imageBase64,
    required String status,
  }) : _status = status;

  // ignore: unnecessary_getters_setters
  String get status => _status;
  set status(String value) {
    _status = value;
  }

  Task copyWith({
    String? id,
    String? title,
    String? description,
    DateTime? date,
    String? imageBase64,
    String? status,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      date: date ?? this.date,
      imageBase64: imageBase64 ?? this.imageBase64,
      status: status ?? this.status,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'date': date.toIso8601String(),
      'imageBase64': imageBase64,
      'status': _status,
    };
  }

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      date: DateTime.parse(json['date']),
      imageBase64: json['imageBase64'],
      status: json['status'],
    );
  }
}

class TaskInput {
  String title;
  String description;
  DateTime date;
  String status;
  String imageBase64;

  TaskInput({
    required this.title,
    required this.description,
    required this.date,
    required this.status,
    required this.imageBase64,
  });

  factory TaskInput.fromTask(Task task) {
    return TaskInput(
      title: task.title,
      description: task.description,
      date: task.date,
      status: task.status,
      imageBase64: task.imageBase64,
    );
  }
}

class TaskInputBuilder {
  String title = '';
  String description = '';
  DateTime date = DateTime.now();
  String status = 'IN_PROGRESS';
  String imageBase64 = '';

  TaskInput build() {
    return TaskInput(
      title: title,
      description: description,
      date: date,
      status: status,
      imageBase64: imageBase64,
    );
  }
}

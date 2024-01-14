class TaskEntity {
  final String id;
  final String title;
  final DateTime date;
  final String status;
  final String imageBase64;

  TaskEntity({
    required this.id,
    required this.title,
    required this.date,
    required this.status,
    required this.imageBase64,
  }) {
    assert(id.isNotEmpty, 'ID must not be empty');
    assert(title.length <= 100, 'Title must not exceed 100 characters');
    assert(status == 'IN_PROGRESS' || status == 'COMPLETE', 'Invalid status');
  }
}

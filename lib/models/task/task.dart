import '../../core/enums.dart';

class Task {
  final String id;
  final String title;
  final String time;
  final String date;
  final TaskStatus status;

  Task({
    required this.id,
    required this.title,
    required this.date,
    required this.time,
    required this.status,
  });
}

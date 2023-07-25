import '../../core/enums.dart';

class Task {
  final String id;
  final String title;
  final String time;
  final String date;
  TaskStatus status;

  Task({
    required this.id,
    required this.title,
    required this.date,
    required this.time,
    required this.status,
  });

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
        id: json['id'].toString(),
        title: json['title'],
        date: json['date'],
        time: json['time'],
        status: getTaskStatusByName(name: json['status']));
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'time': time,
      'date': date,
      'status': status.name,
    };
  }

  static TaskStatus getTaskStatusByName({required String name}) {
    if (name == 'newTask') {
      return TaskStatus.newTask;
    }
    if (name == 'completedTask') {
      return TaskStatus.completedTask;
    }
    return TaskStatus.archivedTask;
  }
}

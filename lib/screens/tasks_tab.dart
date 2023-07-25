import 'package:flutter/material.dart';
import 'package:todo_app/core/enums.dart';

import '../widgets/tasks_list.dart';

class TasksTab extends StatelessWidget {
  const TasksTab({super.key});

  @override
  Widget build(BuildContext context) {
    return const TaskList(status: TaskStatus.newTask);
  }
}

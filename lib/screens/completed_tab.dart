import 'package:flutter/material.dart';
import 'package:todo_app/core/enums.dart';

import '../widgets/tasks_list.dart';

class CompletedTab extends StatelessWidget {
  const CompletedTab({super.key});

  @override
  Widget build(BuildContext context) {
    return const TaskList(status: TaskStatus.completedTask);
  }
}
